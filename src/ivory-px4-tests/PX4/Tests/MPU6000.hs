{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}

module PX4.Tests.MPU6000 (sensorProvider, testApp) where

import Control.Monad (void)

import Ivory.Language
import Ivory.Stdlib

import Ivory.Tower
import Ivory.Tower.StateMachine

import Ivory.BSP.STM32.Driver.SPI

import SMACCMPilot.Hardware.MPU6000

import PX4.Tests.Platforms

testApp :: (TestPlatform p) => Tower p ()
testApp = do
  boardInitializer
  void sensorProvider

sensorProvider :: forall p . (TestPlatform p)
                => Tower p (ChannelSink (Struct "mpu6000_raw_sensor"))
sensorProvider = do
  towerModule  rawSensorTypeModule
  towerDepends rawSensorTypeModule

  raw_sensor <- channel

  (req, res) <- spiTower [mpu6000Device platform]
  mpu6kCtl req res (src raw_sensor) (SPIDeviceHandle 0)
  return (snk raw_sensor)
  where
  platform = Proxy :: Proxy p

mpu6kCtl :: ChannelSource (Struct "spi_transaction_request")
         -> ChannelSink   (Struct "spi_transaction_result")
         -> ChannelSource (Struct "mpu6000_raw_sensor")
         -> SPIDeviceHandle
         -> Tower p ()
mpu6kCtl toDriver fromDriver sensorSource dh = task "mpu6kCtl" $ do
  spiRequest <- withChannelEmitter toDriver "toDriver"
  spiResult <- withChannelEvent fromDriver "fromDriver"
  sensorEmitter <- withChannelEmitter sensorSource "sensorOutput"

  (initMachine, initError) <- initializerMachine dh spiRequest spiResult

  taskStackSize 2048

  taskInit $ do
    begin initMachine

  p <- withPeriodicEvent (Milliseconds 5) -- 200hz
  handle p "period" $ \_ -> do
    initializing <- active initMachine
    unless initializing $ do
      e <- deref initError
      ifte_ e
        (invalidSensor >>= emit_ sensorEmitter)
        (getSensorsReq dh >>= emit_ spiRequest)

  handle spiResult "spiResult" $ \res -> do
    initializing <- active initMachine
    unless initializing $ do
      t <- getTime
      r <- rawSensorFromResponse res t
      emit_ sensorEmitter r

  where
  invalidSensor :: (GetAlloc eff ~ Scope s)
                => Ivory eff (ConstRef (Stack s) (Struct "mpu6000_raw_sensor"))
  invalidSensor = do
    t <- getTime
    fmap constRef $ local $ istruct
      [ valid .= ival false, time .= ival t ]

