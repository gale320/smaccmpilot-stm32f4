{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_ivory.py

module SMACCMPilot.Mavlink.Messages.Data16 where

import Ivory.Serialize
import SMACCMPilot.Mavlink.Unpack
import SMACCMPilot.Mavlink.Send

import Ivory.Language
import Ivory.Stdlib

data16MsgId :: Uint8
data16MsgId = 169

data16CrcExtra :: Uint8
data16CrcExtra = 46

data16Module :: Module
data16Module = package "mavlink_data16_msg" $ do
  depend serializeModule
  depend mavlinkSendModule
  incl mkData16Sender
  incl data16Unpack
  defStruct (Proxy :: Proxy "data16_msg")

[ivory|
struct data16_msg
  { data16_type :: Stored Uint8
  ; len :: Stored Uint8
  ; data16 :: Array 16 (Stored Uint8)
  }
|]

mkData16Sender ::
  Def ('[ ConstRef s0 (Struct "data16_msg")
        , Ref s1 (Stored Uint8) -- seqNum
        , Ref s1 (Struct "mavlinkPacket") -- tx buffer/length
        ] :-> ())
mkData16Sender =
  proc "mavlink_data16_msg_send"
  $ \msg seqNum sendStruct -> body
  $ do
  arr <- local (iarray [] :: Init (Array 18 (Stored Uint8)))
  let buf = toCArray arr
  pack buf 0 =<< deref (msg ~> data16_type)
  pack buf 1 =<< deref (msg ~> len)
  arrayPack buf 2 (msg ~> data16)
  -- 6: header len, 2: CRC len
  let usedLen    = 6 + 18 + 2 :: Integer
  let sendArr    = sendStruct ~> mav_array
  let sendArrLen = arrayLen sendArr
  if sendArrLen < usedLen
    then error "data16 payload of length 18 is too large!"
    else do -- Copy, leaving room for the payload
            arrayCopy sendArr arr 6 (arrayLen arr)
            call_ mavlinkSendWithWriter
                    data16MsgId
                    data16CrcExtra
                    18
                    seqNum
                    sendStruct

instance MavlinkUnpackableMsg "data16_msg" where
    unpackMsg = ( data16Unpack , data16MsgId )

data16Unpack :: Def ('[ Ref s1 (Struct "data16_msg")
                             , ConstRef s2 (CArray (Stored Uint8))
                             ] :-> () )
data16Unpack = proc "mavlink_data16_unpack" $ \ msg buf -> body $ do
  store (msg ~> data16_type) =<< unpack buf 0
  store (msg ~> len) =<< unpack buf 1
  arrayUnpack buf 2 (msg ~> data16)

