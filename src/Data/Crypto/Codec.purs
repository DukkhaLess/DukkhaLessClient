module Data.Crypto.Codec where

import Prelude
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Base64 (Base64(..), decodeBase64, encodeBase64, runBase64)
import Data.ArrayBuffer.DataView (whole, buffer)
import Data.ArrayBuffer.Typed (asUint8Array, dataView)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Core as AC
import Data.Either (Either, note)

encodeBytes :: Uint8Array -> String
encodeBytes = runBase64 <<< encodeBase64 <<< buffer <<< dataView

encodeBytesJson :: Uint8Array -> Json
encodeBytesJson = AC.fromString <<< encodeBytes

decodeBytes :: String -> Either String Uint8Array
decodeBytes rawStr = dv <#> asUint8Array where
  decoded = decodeBase64 (Base64 rawStr)
  eithered = note "Could not decode base64 content" decoded
  dv = eithered <#> whole
