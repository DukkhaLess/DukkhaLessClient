module WebCrypto.Subtle where

import Control.Promise (toAff, Promise)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Show (class Show, show)
import Effect.Aff (Aff)
import Prelude (($), map, (<<<))

foreign import data Algorithm :: Type
foreign import data CryptoKey :: Type

data CipherText = CipherText ArrayBuffer

data PlainText = PlainText ArrayBuffer

foreign import encryptImpl :: Fn3 Algorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)
foreign import decryptImpl :: Fn3 Algorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

encrypt :: Algorithm -> CryptoKey -> PlainText -> Aff CipherText
encrypt alg key (PlainText source) = map CipherText $ toAff $ runFn3 encryptImpl alg key source

decrypt :: Algorithm -> CryptoKey -> CipherText -> Aff String
decrypt alg key (CipherText source) = map (show <<< PlainText) $ toAff $ runFn3 decryptImpl alg key source
