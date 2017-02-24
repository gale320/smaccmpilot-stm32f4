{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE Rank2Types #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

-- | More-or-less transliterated from Paparazzi:
-- https://github.com/paparazzi/paparazzi/blob/master/sw/airborne/subsystems/ahrs/ahrs_float_mlkf.h
module SMACCMPilot.Flight.Control.Attitude.KalmanFilter (AttState(..), attState, sensorFusion) where

import Control.Applicative
import Control.Monad (forM, forM_)
import Data.Foldable
import qualified Data.Vector as V

import Ivory.Language
import Ivory.Stdlib
import Ivory.Tower

import Linear
import Linear.V
import Numeric.IEEE

import qualified SMACCMPilot.Comm.Ivory.Types.AccelerometerSample as A
import qualified SMACCMPilot.Comm.Ivory.Types.GyroscopeSample as G
import qualified SMACCMPilot.Comm.Ivory.Types.MagnetometerSample as M
import qualified SMACCMPilot.Comm.Ivory.Types.Xyz as XYZ

named :: String -> String
named nm = "att_est_" ++ nm

[ivory|
struct AhrsMlkf {
    -- state
    ltp_to_imu_quat :: Array 4 (Stored IFloat)
  ; gibbs_cor :: Array 4 (Stored IFloat)
  ; gyro_bias :: Array 3 (Stored IFloat)

    -- covariance matrix
  ; p :: Array 6 (Array 6 (Stored IFloat))

    -- secondary filters and bookkeeping
  ; lp_accel :: IFloat
  ; imu_rate :: Array 3 (Stored IFloat)
}
|]

type FloatRates = V3 IFloat

data StateVec = StateVec {
    sv_ltp_to_imu_quat :: Quaternion IFloat
  , sv_gibbs_cor :: Quaternion IFloat
  , sv_gyro_bias :: FloatRates
  }

derefStateVec :: Ref s ('Struct "AhrsMlkf") -> Ivory eff StateVec
derefStateVec ahrs = do
  sv_ltp_to_imu_quat <- derefQuat (ahrs ~> ltp_to_imu_quat)
  sv_gibbs_cor <- derefQuat (ahrs ~> gibbs_cor)
  sv_gyro_bias <- derefV3 (ahrs ~> gyro_bias)
  return StateVec {..}

storeStateVec :: Ref s ('Struct "AhrsMlkf") -> StateVec -> Ivory eff ()
storeStateVec ahrs StateVec {..} = do
  storeQuat (ahrs ~> ltp_to_imu_quat) sv_ltp_to_imu_quat
  storeQuat (ahrs ~> gibbs_cor) sv_gibbs_cor
  storeV3 (ahrs ~> gyro_bias) sv_gyro_bias

derefQuat
  :: (IvoryRef ref,
      IvoryExpr (ref s ('Stored IFloat)),
      IvoryExpr (ref s ('Array 4 ('Stored IFloat))))
  => ref s ('Array 4 ('Stored IFloat)) -> Ivory eff (Quaternion IFloat)
derefQuat ref = do
  [i, x, y, z] <- forM [0, 1, 2, 3] $ \ix -> deref (ref ! ix)
  return (Quaternion i (V3 x y z))

storeQuat
  :: Ref s ('Array 4 ('Stored IFloat)) -> Quaternion IFloat -> Ivory eff ()
storeQuat ref (Quaternion i (V3 x y z)) = do
  store (ref ! 0) i
  store (ref ! 1) x
  store (ref ! 2) y
  store (ref ! 3) z

derefV3
  :: (IvoryRef ref,
      IvoryExpr (ref s ('Stored IFloat)),
      IvoryExpr (ref s ('Array 3 ('Stored IFloat))))
  => ref s ('Array 3 ('Stored IFloat)) -> Ivory eff (V3 IFloat)
derefV3 ref = do
  [x, y, z] <- forM [0, 1, 2] $ \ix -> deref (ref ! ix)
  return (V3 x y z)

derefXyz
  :: (IvoryRef ref,
      IvoryExpr (ref s ('Struct "xyz")),
      IvoryExpr (ref s ('Stored IFloat)))
  => ref s ('Struct "xyz") -> Ivory eff (V3 IFloat)
derefXyz ref = mapM deref $ fmap (ref ~>) (V3 XYZ.x XYZ.y XYZ.z)

storeXyz
  :: Ref s ('Struct "xyz") -> V3 IFloat -> Ivory eff ()
storeXyz ref (V3 x y z) = do
  store (ref ~> XYZ.x) x
  store (ref ~> XYZ.y) y
  store (ref ~> XYZ.z) z

storeV3 :: Ref s ('Array 3 ('Stored IFloat)) -> V3 IFloat -> Ivory eff ()
storeV3 ref (V3 x y z) = do
  store (ref ! 0) x
  store (ref ! 1) y
  store (ref ! 2) z

-- row-major 6x6 matrix
type CovMat = V $(6) (V $(6) IFloat)

derefCovMat
  :: (IvoryRef ref, IvoryExpr (ref s ('Stored IFloat)),
      IvoryExpr (ref s ('Struct "AhrsMlkf")),
      IvoryExpr (ref s ('Array 6 ('Stored IFloat))),
      IvoryExpr (ref s ('Array 6 ('Array 6 ('Stored IFloat)))))
  => ref s ('Struct "AhrsMlkf") -> Ivory eff CovMat
derefCovMat ahrs = do
  rs <- forM [0, 1, 2, 3, 4, 5] $ \r -> do
    forM [0, 1, 2, 3, 4, 5] $ \c ->
      deref (((ahrs ~> p) ! r) ! c)
  return (m66FromList rs)

storeCovMat :: Ref s ('Struct "AhrsMlkf") -> CovMat -> Ivory eff ()
storeCovMat ahrs covMat = do
  forM_ (zip [0, 1, 2, 3, 4, 5] (toList covMat)) $ \(r, rv) ->
    forM_ (zip [0, 1, 2, 3, 4, 5] (toList rv)) $ \(c, cv) ->
      store (((ahrs ~> p) ! r) ! c) cv

--------------------------------------------------------------------------------
-- Constants, to be turned into config values later

ahrs_h_x, ahrs_h_y, ahrs_h_z :: IFloat
ahrs_h_x = 0
ahrs_h_y = 0
ahrs_h_z = 0

ahrs_mag_noise :: V3 IFloat
ahrs_mag_noise = V3 0.2 0.2 0.2

flt_min :: IFloat
flt_min = fromRational (toRational (minNormal :: Float))

{-
extern void ahrs_mlkf_init(void);

// skipping for now because our IMU and body should be aligned
extern void ahrs_mlkf_set_body_to_imu(struct OrientationReps *body_to_imu);
// skipping for now because our IMU and body should be aligned
extern void ahrs_mlkf_set_body_to_imu_quat(struct FloatQuat *q_b2i);

extern bool ahrs_mlkf_align(struct FloatRates *lp_gyro, struct FloatVect3 *lp_accel,
                              struct FloatVect3 *lp_mag);
extern void ahrs_mlkf_propagate(struct FloatRates *gyro, float dt);
extern void ahrs_mlkf_update_accel(struct FloatVect3 *accel);
extern void ahrs_mlkf_update_mag(struct FloatVect3 *mag);
extern void ahrs_mlkf_update_mag_2d(struct FloatVect3 *mag);
extern void ahrs_mlkf_update_mag_full(struct FloatVect3 *mag);
-}

quatRotId :: Quaternion IFloat
quatRotId = Quaternion 1 zero

ahrs_mlkf_init :: Ref s ('Struct "AhrsMlkf") -> Def ('[] ':-> ())
ahrs_mlkf_init ahrs = voidProc (named "init") $ body $ do
  let sv0 = StateVec {
              sv_ltp_to_imu_quat = quatRotId
            , sv_gibbs_cor = quatRotId
            , sv_gyro_bias = zero
            }
  let p0 = scaled (v6FromList [p0_a, p0_a, p0_a, p0_b, p0_b, p0_b])
      p0_a = 1
      p0_b = 1e-4
  storeStateVec ahrs sv0
  storeCovMat ahrs p0
  storeV3 (ahrs ~> imu_rate) zero

-- | Get a roll and pitch quaternion from an accelerometer
-- measurement. If the IMU is directly upside down, we don't want the
-- cross product of the vectors to be zero
ahrs_float_get_quat_from_accel :: V3 IFloat -> Quaternion IFloat
ahrs_float_get_quat_from_accel accel = signorm q
  where
    q = Quaternion qi (V3 qx qy qz)
    (V3 x y z) = signorm accel
    deg180 = abs (z-1) <? 5 * flt_min
    qi = deg180 ? (0, 1 - z)
    qx = deg180 ? (1, (-y))
    qy = deg180 ? (0, x)
    qz = 0

-- | Wrap a quaternion around to the shortest angle
wrapShortest :: Quaternion IFloat -> Quaternion IFloat
wrapShortest (Quaternion i (V3 x y z)) = q'
  where f n = (i <? 0) ? ((-n), n)
        q' = Quaternion (f i) (V3 (f x) (f y) (f z))

quatPlus :: Quaternion IFloat -> Quaternion IFloat -> Quaternion IFloat
quatPlus = liftA2 (+)

-- | Because we don't have a RealFloat instance for IFloat :(
quatMult :: Quaternion IFloat -> Quaternion IFloat -> Quaternion IFloat
quatMult (Quaternion s1 v1) (Quaternion s2 v2) =
  Quaternion (s1*s2 - (v1 `dot` v2)) ((v1 `cross` v2) + s1*^v2 + s2*^v1)

quatConj :: Conjugate a => Quaternion a -> Quaternion a
quatConj (Quaternion e v) = Quaternion (conjugate e) (negate v)

instance Conjugate IFloat
instance TrivialConjugate IFloat

quatRotate :: Quaternion IFloat -> V3 IFloat -> V3 IFloat
quatRotate q v = ijk where
  Quaternion _ ijk = q `quatMult` Quaternion 0 v `quatMult` quatConj q

float_quat_comp_norm_shortest
  :: Quaternion IFloat -> Quaternion IFloat -> Quaternion IFloat
float_quat_comp_norm_shortest a2b b2c =
  signorm (wrapShortest (a2b `quatMult` b2c))

-- | Get an orientation directly from mag and accel
ahrs_float_get_quat_from_accel_mag
  :: V3 IFloat -> V3 IFloat -> Quaternion IFloat
ahrs_float_get_quat_from_accel_mag accel mag =
    float_quat_comp_norm_shortest q_a q_m
  where
    q_a = ahrs_float_get_quat_from_accel accel
    q_m = signorm (Quaternion q_mi (V3 q_mx q_my q_mz))
    (V3 mag_ltp_x mag_ltp_y _) = quatRotate q_a mag
    v1 = V3 mag_ltp_x mag_ltp_y 0
    v2 = V3 ahrs_h_x ahrs_h_y 0
    mag_dot = v1 `dot` v2
    norm2 = norm v1 * norm v2
    deg180 = abs (norm2 + mag_dot) <? 5 * flt_min
    q_mi = deg180 ? (0, norm2 + mag_dot)
    q_mx = 0
    q_my = 0
    q_mz = deg180 ? (1, mag_ltp_x * ahrs_h_y - mag_ltp_y * ahrs_h_x)

-- | Establish initial alignment
ahrs_mlkf_align
  :: Ref s ('Struct "AhrsMlkf")
  -> Def ('[ ConstRef s1 ('Struct "gyroscope_sample")
           , ConstRef s2 ('Struct "accelerometer_sample")
           , ConstRef s3 ('Struct "magnetometer_sample")
           ] ':-> IBool)
ahrs_mlkf_align ahrs =
  proc (named "ahrs_mlkf_align")
    $ \gyro_sample accel_sample mag_sample -> body $ do
      gyroFail <- deref (gyro_sample ~> G.samplefail)
      accelFail <- deref (accel_sample ~> A.samplefail)
      magFail <- deref (mag_sample ~> M.samplefail)

      when (gyroFail .|| accelFail .|| magFail) $ ret false

      gyro <- derefXyz (gyro_sample ~> G.sample)
      accel <- derefXyz (accel_sample ~> A.sample)
      mag <- derefXyz (mag_sample ~> M.sample)
      sv <- derefStateVec ahrs
      let sv' = sv {
              sv_ltp_to_imu_quat = ahrs_float_get_quat_from_accel_mag
                                     accel
                                     mag
            , sv_gyro_bias = gyro
            }
      storeStateVec ahrs sv'
      ret true

-- | Quaternion integration with constant rotational velocity
float_quat_integrate
  :: Quaternion IFloat -> FloatRates -> IFloat -> Quaternion IFloat
float_quat_integrate q@(Quaternion qi (V3 qx qy qz)) omega dt =
    -- identity when norm of the rates is < flt_min
    f <$> q <*> (Quaternion qi' (V3 qx' qy' qz'))
  where
    f n n' = (no >? flt_min) ? (n', n)
    no = norm omega
    a = 0.5 * no * dt
    ca = cos a
    sa_ov_no = sin a / no
    V3 dp dq dr = sa_ov_no *^ omega
    qi' = ca * qi - dp * qx - dq * qy - dr * qz
    qx' = dp * qi + ca * qx + dr * qy - dq * qz
    qy' = dq * qi - dr * qx + ca * qy + dp * qz
    qz' = dr * qi + dq * qx - dp * qy + ca * qz

-- | Propagate gryo input
ahrs_mlkf_propagate
  :: Ref s1 ('Struct "AhrsMlkf")
  -> Def ('[ConstRef s2 ('Struct "gyroscope_sample"), IFloat] ':-> ())
ahrs_mlkf_propagate ahrs =
  voidProc (named "ahrs_mlkf_propagate") $ \gyro_sample dt -> body $ do
    gyro <- derefXyz (gyro_sample ~> G.sample)
    StateVec {..} <- derefStateVec ahrs
    p0 <- derefCovMat ahrs
    let rates = gyro - sv_gyro_bias
        sv_ltp_to_imu_quat' = float_quat_integrate sv_ltp_to_imu_quat rates dt
        V3 dp dq dr = rates ^* dt
        f :: V 6 (V 6 IFloat)
        f = m66FromList [
                [1    , dr   , (-dq), (-dt), 0    , 0    ]
              , [(-dr), 1    , dp   , 0    , (-dt), 0    ]
              , [dq   , (-dp), 1    , 0    , 0    , (-dt)]
              , [0    , 0    , 0    , 1    , 0    , 0    ]
              , [0    , 0    , 0    , 0    , 1    , 0    ]
              , [0    , 0    , 0    , 0    , 0    , 1    ]
              ]
        fpf' = f !*! p0 !*! (transpose f)
        dt2 = dt * dt
        gqg = v6FromList [ dt2 * 10e-3
                         , dt2 * 10e-3
                         , dt2 * 10e-3
                         , dt2 * 9e-6
                         , dt2 * 9e-6
                         , dt2 * 9e-6
                         ]
        p' = fpf' !+! scaled gqg
    storeStateVec ahrs StateVec { sv_ltp_to_imu_quat = sv_ltp_to_imu_quat', .. }
    storeCovMat ahrs p'

v6FromList :: [IFloat] -> V 6 IFloat
v6FromList = V . V.fromList

m66FromList :: [[IFloat]] -> V 6 (V 6 IFloat)
m66FromList = V . V.fromList . map v6FromList

m36FromList :: [[IFloat]] -> V 3 (V 6 IFloat)
m36FromList = V . V.fromList . map v6FromList

-- | Incorporate a 3d vector measurement into the state
update_state
  :: Ref s ('Struct "AhrsMlkf")
  -> V3 IFloat -> V3 IFloat -> V3 IFloat -> Ivory eff ()
update_state ahrs i_expected b_measured noise = do
  StateVec {..} <- derefStateVec ahrs
  p0 <- derefCovMat ahrs
  let b_expected@(V3 b_ex_x b_ex_y b_ex_z) =
        quatRotate sv_ltp_to_imu_quat i_expected
      h = m36FromList [
              [0        , (-b_ex_z), b_ex_y   , 0, 0, 0]
            , [b_ex_z   , 0        , (-b_ex_x), 0, 0, 0]
            , [(-b_ex_y), b_ex_x   , 0        , 0, 0, 0]
            ]
      hph' = h !*! p0 !*! (transpose h)
      s = hph' !+! (scaled (vFromV3 noise))
      sInv = vsFromM33 (inv33 (m33FromVs s))
      k = p0 !*! (transpose h) !*! sInv
      i6 = scaled (V (V.fromList [1, 1, 1, 1, 1, 1]))
      p' = (i6 !-! (k !*! h)) !*! p0
      e = vFromV3 (b_measured ^-^ b_expected)
      [ke0, ke1, ke2, ke3, ke4, ke5] = toList (k !* e)
      gibbs_cor' = sv_gibbs_cor `quatPlus` Quaternion 0 (V3 ke0 ke1 ke2)
      gyro_bias' = sv_gyro_bias ^+^ V3 ke3 ke4 ke5
  storeStateVec ahrs StateVec { sv_gibbs_cor = gibbs_cor'
                              , sv_gyro_bias = gyro_bias'
                              , ..
                              }
  storeCovMat ahrs p'

vsFromM33 :: M33 a -> V 3 (V 3 a)
vsFromM33 = vFromV3 . fmap vFromV3

m33FromVs :: V 3 (V 3 a) -> M33 a
m33FromVs = v3FromV . fmap v3FromV

vFromV3 :: V3 a -> V 3 a
vFromV3 (V3 x y z) = V (V.fromList [x, y, z])

v3FromV :: V 3 a -> V3 a
v3FromV (V v) = V3 x y z
  where
    [x, y, z] = V.toList v

reset_state :: Ref s ('Struct "AhrsMlkf") -> Ivory eff ()
reset_state ahrs = do
  StateVec {..} <- derefStateVec ahrs
  let Quaternion _ gcqv = sv_gibbs_cor
      gibbs_cor' = Quaternion 2 gcqv
      ltp_to_imu_quat' = signorm (sv_ltp_to_imu_quat `quatMult` gibbs_cor')
  storeStateVec ahrs StateVec { sv_gibbs_cor = quatRotId
                              , sv_ltp_to_imu_quat = ltp_to_imu_quat'
                              , ..
                              }

ahrs_mlkf_update_accel
  :: Ref s1 ('Struct "AhrsMlkf")
  -> Def ('[ConstRef s2 ('Struct "accelerometer_sample")] ':-> ())
ahrs_mlkf_update_accel ahrs =
  voidProc (named "ahrs_mlkf_update_accel") $ \accel -> body $ do
    imu_g <- derefXyz (accel ~> A.sample)
    lp_accel0 <- deref (ahrs ~> lp_accel)
    let alpha = 0.92
        lp_accel' = alpha * lp_accel0 + (1 - alpha) * (norm imu_g - 9.81)
        earth_g = V3 0 0 (-9.81)
        dn = 250 * abs lp_accel0
        g_noise = V3 (1 + dn) (1 + dn) (1 + dn)
    store (ahrs ~> lp_accel) lp_accel'
    update_state ahrs earth_g imu_g g_noise
    reset_state ahrs

ahrs_mlkf_update_mag_full
  :: Ref s1 ('Struct "AhrsMlkf")
  -> Def ('[ConstRef s2 ('Struct "magnetometer_sample")] ':-> ())
ahrs_mlkf_update_mag_full ahrs =
  voidProc (named "mag") $ \mag_sample -> body $ do
    mag <- derefXyz (mag_sample ~> M.sample)
    let mag_h = V3 ahrs_h_x ahrs_h_y ahrs_h_z
    update_state ahrs mag_h mag ahrs_mag_noise
    reset_state ahrs

data AttState =
  AttState
    { ahrs_ltp_to_body :: Quaternion IFloat
    , ahrs_body_rates :: FloatRates
    }

attState
  :: (IvoryRef ref, IvoryExpr (ref s ('Stored IFloat)),
      IvoryExpr (ref s ('Struct "AhrsMlkf")),
      IvoryExpr (ref s ('Array 4 ('Stored IFloat))),
      IvoryExpr (ref s ('Array 3 ('Stored IFloat))))
  => ref s ('Struct "AhrsMlkf") -> Ivory eff AttState
attState ahrs = do
  ahrs_ltp_to_body <- derefQuat (ahrs ~> ltp_to_imu_quat)
  ahrs_body_rates <- derefV3 (ahrs ~> imu_rate)
  return AttState {..}

data AttEstimator =
  AttEstimator
    { ahrs_init :: forall eff . Ivory eff ()
    , ahrs_align
        :: forall eff s1 s2 s3
         . ConstRef s1 ('Struct "gyroscope_sample")
        -> ConstRef s2 ('Struct "accelerometer_sample")
        -> ConstRef s3 ('Struct "magnetometer_sample")
        -> Ivory eff IBool
    , ahrs_propagate
        :: forall eff s
         . ConstRef s ('Struct "gyroscope_sample")
        -> IFloat
        -> Ivory eff ()
    , ahrs_update_accel
        :: forall eff s
         . ConstRef s ('Struct "accelerometer_sample")
        -> Ivory eff ()
    , ahrs_update_mag
        :: forall eff s
         . ConstRef s ('Struct "magnetometer_sample")
        -> Ivory eff ()
    , ahrs_state :: Ref 'Global ('Struct "AhrsMlkf")
    -- TODO: debug
    }

monitorAttEstimator :: Monitor e AttEstimator
monitorAttEstimator = do
  ahrs <- state (named "ahrs_state")
  monitorModuleDef $ do
    defStruct (Proxy :: Proxy "AhrsMlkf")
    incl (ahrs_mlkf_init ahrs)
    incl (ahrs_mlkf_align ahrs)
    incl (ahrs_mlkf_propagate ahrs)
    incl (ahrs_mlkf_update_accel ahrs)
    incl (ahrs_mlkf_update_mag_full ahrs)
  return AttEstimator
    { ahrs_init = call_ (ahrs_mlkf_init ahrs)
    , ahrs_align = call (ahrs_mlkf_align ahrs)
    , ahrs_propagate = call_ (ahrs_mlkf_propagate ahrs)
    , ahrs_update_accel = call_ (ahrs_mlkf_update_accel ahrs)
    , ahrs_update_mag = call_ (ahrs_mlkf_update_mag_full ahrs)
    , ahrs_state = ahrs
    }

sensorFusion
  :: ChanOutput ('Struct "accelerometer_sample")
  -> ChanOutput ('Struct "gyroscope_sample")
  -> ChanOutput ('Struct "magnetometer_sample")
  -> ChanOutput ('Stored IBool)
  -> Tower e (ChanOutput ('Struct "AhrsMlkf"))
sensorFusion accel_out gyro_out mag_out motion = do
  (states_in, states_out) <- channel

  monitor (named "sensor_fusion") $ do
    last_gyro_time <- state (named "last_gyro_time")
    -- this gyro sample is in rads/sec rather than deg/sec
    last_gyro_rads <- stateInit (named "last_gyro_rads")
      $ istruct [ G.samplefail .= ival true ]
    last_acc  <- stateInit (named "last_acc")
      $ istruct [ A.samplefail .= ival true ]
    last_mag <- stateInit (named "last_mag")
      $ istruct [ M.samplefail .= ival true ]
    in_motion <- state "in_motion"

    aligned <- stateInit (named "aligned") (ival false)

    ahrs <- monitorAttEstimator

    handler systemInit (named "init") $
      callback $ \_ -> do
        ahrs_init ahrs
        store last_gyro_time =<< getTime

    handler accel_out (named "accel") $ do
      e <- emitter states_in 1
      callback $ \accel -> do
        isFail <- deref (accel ~> A.samplefail)
        unless isFail $ do
          refCopy last_acc accel
          isAligned <- deref aligned
          when isAligned $ do
            ahrs_update_accel ahrs accel
            emit e (constRef (ahrs_state ahrs))

    handler mag_out (named "mag") $ do
      e <- emitter states_in 1
      callback $ \mag -> do
        isFail <- deref (mag ~> M.samplefail)
        unless isFail $ do
          refCopy last_mag mag
          isAligned <- deref aligned
--          when isAligned $ do
          when false $ do
            ahrs_update_mag ahrs mag
            emit e (constRef (ahrs_state ahrs))

    handler gyro_out (named "gyro") $ do
      e <- emitter states_in 1
      callback $ \gyro_sample -> do
        isFail <- deref (gyro_sample ~> G.samplefail)
        isCal <- deref (gyro_sample ~> G.calibrated)
        unless (isFail .|| iNot isCal) $ do
          -- to the conversion deg -> rads here
          gyro_deg <- derefXyz (gyro_sample ~> G.sample)
          let gyro_rads = gyro_deg ^* (pi / 180)
          refCopy last_gyro_rads gyro_sample
          storeXyz (last_gyro_rads ~> G.sample) gyro_rads

          isAligned <- deref aligned
          ifte_ isAligned
            (do t0 <- deref last_gyro_time
                t <- getTime
                store last_gyro_time t
                let -- We need to cast to a smaller integer type to be able to
                    -- safely convert to a float. toIMilliseconds gives sint64
                    -- but really we are using very few of those bits of
                    -- precision
                    dt_ms :: Sint16
                    dt_ms = castWith 0 (toIMilliseconds (t - t0))
                    dt = safeCast dt_ms / 1000.0
                ahrs_propagate ahrs (constRef last_gyro_rads) dt
                emit e (constRef (ahrs_state ahrs)))
            (do wasMoving <- deref in_motion
                unless wasMoving $ do
                  done <- ahrs_align ahrs
                            (constRef last_gyro_rads)
                            (constRef last_acc)
                            (constRef last_mag)
                  when done $ store aligned true)

    handler motion (named "motion") $ callback $ refCopy in_motion

  return states_out
