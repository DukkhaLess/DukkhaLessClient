module WebCrypto.Subtle where

import Prelude          (($), map, (<<<))
import Data.Show        (class Show, show)
import Effect.Aff       (Aff)
import Control.Promise  (toAff, Promise)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.ArrayBuffer.Types  (ArrayBuffer)

foreign import data Algorithm :: Type
foreign import data CryptoKey :: Type

type CipherText = ArrayBuffer

data PlainText = PlainText ArrayBuffer

foreign import showArrayBufferImpl :: ArrayBuffer -> String

instance showPlainText :: Show PlainText where
  show (PlainText buffer) = showArrayBufferImpl buffer

foreign import encryptImpl :: Fn3 Algorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)
foreign import decryptImpl :: Fn3 Algorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

encrypt :: Algorithm -> CryptoKey -> PlainText -> Aff CipherText
encrypt alg key (PlainText source) = toAff $ runFn3 encryptImpl alg key source

decrypt :: Algorithm -> CryptoKey -> CipherText -> Aff String
decrypt alg key source = map (show <<< PlainText) $ toAff $ runFn3 decryptImpl alg key source
