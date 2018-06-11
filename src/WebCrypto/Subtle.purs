module WebCrypto.Subtle where

import Prelude          (($), map)
import Data.Show        (class Show, show)
import Data.String.Read (class Read, read)
import Effect.Aff       (Aff)
import Control.Promise  (toAff, Promise)
import Data.Function.Uncurried (Fn3, runFn3)

foreign import data Algorithm :: Type
foreign import data CryptoKey :: Type
foreign import data BufferSource :: Type
foreign import data ArrayBuffer :: Type

foreign import showArrayBufferImpl :: ArrayBuffer -> String

instance showArrayBuffer :: Show ArrayBuffer where
  show = showArrayBufferImpl


foreign import encryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise ArrayBuffer)
foreign import decryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise ArrayBuffer)

encrypt :: Algorithm -> CryptoKey -> BufferSource -> Aff ArrayBuffer
encrypt alg key source = toAff $ runFn3 encryptImpl alg key source

decrypt :: Algorithm -> CryptoKey -> BufferSource -> Aff String
decrypt alg key source = map show $ toAff $ runFn3 decryptImpl alg key source
