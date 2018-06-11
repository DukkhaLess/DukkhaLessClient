module WebCrypto.Subtle where

import Control.Promise (toAffE, Promise)
import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)

foreign import data Algorithm :: Type
foreign import data CryptoKey :: Type
foreign import data BufferSource :: Type
foreign import data ArrayBuffer :: Type

foreign import encryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise ArrayBuffer)
foreign import decryptImpl :: Fn3 Algorithm CryptoKey BufferSource (Promise String)

encrypt :: Algorithm -> CryptoKey -> BufferSource -> Promise ArrayBuffer
encrypt = runFn3 encryptImpl

decrypt :: Algorithm -> CryptoKey -> BufferSource -> Promise String
decrypt = runFn3 decryptImpl
