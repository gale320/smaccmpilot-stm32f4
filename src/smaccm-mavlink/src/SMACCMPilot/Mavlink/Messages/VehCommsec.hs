{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_ivory.py

module SMACCMPilot.Mavlink.Messages.VehCommsec where

import Ivory.Serialize
import SMACCMPilot.Mavlink.Unpack
import SMACCMPilot.Mavlink.Send

import Ivory.Language
import Ivory.Stdlib

vehCommsecMsgId :: Uint8
vehCommsecMsgId = 185

vehCommsecCrcExtra :: Uint8
vehCommsecCrcExtra = 112

vehCommsecModule :: Module
vehCommsecModule = package "mavlink_veh_commsec_msg" $ do
  depend serializeModule
  depend mavlinkSendModule
  incl mkVehCommsecSender
  incl vehCommsecUnpack
  defStruct (Proxy :: Proxy "veh_commsec_msg")

[ivory|
struct veh_commsec_msg
  { time :: Stored Uint32
  ; good_msgs :: Stored Uint32
  ; bad_msgs :: Stored Uint32
  ; commsec_err :: Stored Uint8
  }
|]

mkVehCommsecSender ::
  Def ('[ ConstRef s0 (Struct "veh_commsec_msg")
        , Ref s1 (Stored Uint8) -- seqNum
        , Ref s1 (Struct "mavlinkPacket") -- tx buffer/length
        ] :-> ())
mkVehCommsecSender =
  proc "mavlink_veh_commsec_msg_send"
  $ \msg seqNum sendStruct -> body
  $ do
  arr <- local (iarray [] :: Init (Array 13 (Stored Uint8)))
  let buf = toCArray arr
  pack buf 0 =<< deref (msg ~> time)
  pack buf 4 =<< deref (msg ~> good_msgs)
  pack buf 8 =<< deref (msg ~> bad_msgs)
  pack buf 12 =<< deref (msg ~> commsec_err)
  -- 6: header len, 2: CRC len
  let usedLen    = 6 + 13 + 2 :: Integer
  let sendArr    = sendStruct ~> mav_array
  let sendArrLen = arrayLen sendArr
  if sendArrLen < usedLen
    then error "vehCommsec payload of length 13 is too large!"
    else do -- Copy, leaving room for the payload
            arrayCopy sendArr arr 6 (arrayLen arr)
            call_ mavlinkSendWithWriter
                    vehCommsecMsgId
                    vehCommsecCrcExtra
                    13
                    seqNum
                    sendStruct

instance MavlinkUnpackableMsg "veh_commsec_msg" where
    unpackMsg = ( vehCommsecUnpack , vehCommsecMsgId )

vehCommsecUnpack :: Def ('[ Ref s1 (Struct "veh_commsec_msg")
                             , ConstRef s2 (CArray (Stored Uint8))
                             ] :-> () )
vehCommsecUnpack = proc "mavlink_veh_commsec_unpack" $ \ msg buf -> body $ do
  store (msg ~> time) =<< unpack buf 0
  store (msg ~> good_msgs) =<< unpack buf 4
  store (msg ~> bad_msgs) =<< unpack buf 8
  store (msg ~> commsec_err) =<< unpack buf 12

