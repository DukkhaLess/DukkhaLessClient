module ArrayBufferUtil
       ( encodeBuffer
       , decodeBuffer
       ) where

import Effect.Aff (Aff)
import Control.Promise (toAff, Promise)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Prelude ((<<<))


foreign import encodeStringToBuffer :: String -> ArrayBuffer

foreign import decodeBufferToString :: ArrayBuffer -> Promise String

encodeBuffer :: String -> ArrayBuffer
encodeBuffer = encodeStringToBuffer

decodeBuffer :: ArrayBuffer -> Aff String
decodeBuffer = toAff <<< decodeBufferToString
