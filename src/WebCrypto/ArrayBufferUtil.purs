module ArrayBufferUtil
       ( encodeBuffer
       , decodeBuffer
       , base64DecodeImpl
       ) where

import Control.Promise (toAff, Promise)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Effect.Aff (Aff)
import Prelude ((<<<), ($))
import WebCrypto.Base64 (Base64Content(..))


foreign import encodeStringToBuffer :: String -> ArrayBuffer

foreign import decodeBufferToString :: ArrayBuffer -> Promise String

foreign import base64EncodeBuffer :: ArrayBuffer -> String

foreign import base64DecodeImpl :: String -> Promise ArrayBuffer

encodeBuffer :: String -> ArrayBuffer
encodeBuffer = encodeStringToBuffer

decodeBuffer :: ArrayBuffer -> Aff String
decodeBuffer = toAff <<< decodeBufferToString

bufferToBase64 :: ArrayBuffer -> Base64Content
bufferToBase64 = Base64Content <<< base64EncodeBuffer

base64Decode :: Base64Content -> Aff ArrayBuffer
base64Decode (Base64Content content) = toAff $ base64DecodeImpl content
