module WebCrypto.Subtle where

import Prelude         (($))
import Effect.Aff      (Aff)
import Control.Promise (toAff, Promise)
import Data.Function.Uncurried (Fn3, runFn3)

foreign import data Algorithm :: Type
foreign import data CryptoKey :: Type
foreign import data BufferSource :: Type
foreign import data ArrayBuffer :: Type

foreign import encryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise ArrayBuffer)
foreign import decryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise String)

encrypt :: Algorithm -> CryptoKey -> BufferSource -> Aff ArrayBuffer
encrypt alg key source = toAff $ runFn3 encryptImpl alg key source

decrypt :: Algorithm -> CryptoKey -> BufferSource -> Aff String
decrypt alg key source = toAff $ runFn3 decryptImpl alg key source
