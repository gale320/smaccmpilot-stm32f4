{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_ivory.py

module SMACCMPilot.Mavlink.Messages.SafetyAllowedArea where

import Ivory.Serialize
import SMACCMPilot.Mavlink.Unpack
import SMACCMPilot.Mavlink.Send

import Ivory.Language
import Ivory.Stdlib

safetyAllowedAreaMsgId :: Uint8
safetyAllowedAreaMsgId = 55

safetyAllowedAreaCrcExtra :: Uint8
safetyAllowedAreaCrcExtra = 3

safetyAllowedAreaModule :: Module
safetyAllowedAreaModule = package "mavlink_safety_allowed_area_msg" $ do
  depend serializeModule
  depend mavlinkSendModule
  incl mkSafetyAllowedAreaSender
  incl safetyAllowedAreaUnpack
  defStruct (Proxy :: Proxy "safety_allowed_area_msg")

[ivory|
struct safety_allowed_area_msg
  { p1x :: Stored IFloat
  ; p1y :: Stored IFloat
  ; p1z :: Stored IFloat
  ; p2x :: Stored IFloat
  ; p2y :: Stored IFloat
  ; p2z :: Stored IFloat
  ; frame :: Stored Uint8
  }
|]

mkSafetyAllowedAreaSender ::
  Def ('[ ConstRef s0 (Struct "safety_allowed_area_msg")
        , Ref s1 (Stored Uint8) -- seqNum
        , Ref s1 (Struct "mavlinkPacket") -- tx buffer/length
        ] :-> ())
mkSafetyAllowedAreaSender =
  proc "mavlink_safety_allowed_area_msg_send"
  $ \msg seqNum sendStruct -> body
  $ do
  arr <- local (iarray [] :: Init (Array 25 (Stored Uint8)))
  let buf = toCArray arr
  pack buf 0 =<< deref (msg ~> p1x)
  pack buf 4 =<< deref (msg ~> p1y)
  pack buf 8 =<< deref (msg ~> p1z)
  pack buf 12 =<< deref (msg ~> p2x)
  pack buf 16 =<< deref (msg ~> p2y)
  pack buf 20 =<< deref (msg ~> p2z)
  pack buf 24 =<< deref (msg ~> frame)
  -- 6: header len, 2: CRC len
  let usedLen    = 6 + 25 + 2 :: Integer
  let sendArr    = sendStruct ~> mav_array
  let sendArrLen = arrayLen sendArr
  if sendArrLen < usedLen
    then error "safetyAllowedArea payload of length 25 is too large!"
    else do -- Copy, leaving room for the payload
            arrayCopy sendArr arr 6 (arrayLen arr)
            call_ mavlinkSendWithWriter
                    safetyAllowedAreaMsgId
                    safetyAllowedAreaCrcExtra
                    25
                    seqNum
                    sendStruct

instance MavlinkUnpackableMsg "safety_allowed_area_msg" where
    unpackMsg = ( safetyAllowedAreaUnpack , safetyAllowedAreaMsgId )

safetyAllowedAreaUnpack :: Def ('[ Ref s1 (Struct "safety_allowed_area_msg")
                             , ConstRef s2 (CArray (Stored Uint8))
                             ] :-> () )
safetyAllowedAreaUnpack = proc "mavlink_safety_allowed_area_unpack" $ \ msg buf -> body $ do
  store (msg ~> p1x) =<< unpack buf 0
  store (msg ~> p1y) =<< unpack buf 4
  store (msg ~> p1z) =<< unpack buf 8
  store (msg ~> p2x) =<< unpack buf 12
  store (msg ~> p2y) =<< unpack buf 16
  store (msg ~> p2z) =<< unpack buf 20
  store (msg ~> frame) =<< unpack buf 24

