module Data.Crypto.Codec where

import Prelude
import Effect.Unsafe (unsafePerformEffect)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Base64 (decodeBase64, encodeBase64, runBase64, fromString)
import Data.ArrayBuffer.Typed (whole, buffer)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Core as AC
import Data.Either (Either, note)

encodeBytes :: Uint8Array -> String
encodeBytes = runBase64 <<< encodeBase64 <<< buffer

encodeBytesJson :: Uint8Array -> Json
encodeBytesJson = AC.fromString <<< encodeBytes

-- The call to unsafePerformEffect is allowable only because an ArrayBuffer can ALWAYS
-- be represented as ArrayView Uint8, due to that being the smallest indexing size allowed
decodeBytes :: String -> Either String Uint8Array
decodeBytes rawStr = eithered <#> (unsafePerformEffect <<< whole)
  where
  decoded = fromString rawStr <#> decodeBase64

  eithered = note "Could not decode base64 content" decoded
