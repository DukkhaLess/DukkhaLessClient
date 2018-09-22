module Model.Keyring
  ( generateKeyring
  , runSecretBoxKey
  , runBoxKeyPair
  , encodeKey
  , Keyring(..)
  ) where

import Crypt.NaCl (BoxKeyPair(..), SecretBoxKey, generateBoxKeyPair, generateSecretBoxKey, toUint8Array, fromUint8Array)
import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey)
import Data.Argonaut.Core (Json, caseJsonObject, jsonEmptyObject, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Argonaut.Parser (jsonParser)
import Data.ArrayBuffer.ArrayBuffer (decodeToString, fromString)
import Data.ArrayBuffer.DataView (whole, buffer)
import Data.ArrayBuffer.Typed (asUint8Array, dataView)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Base64 (Base64(..), decodeBase64, encodeBase64, runBase64)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), note)
import Data.String.Read (class Read)
import Effect (Effect)
import Effect.Exception (message)
import Foreign.Object (Object)
import Prelude (pure, bind, ($), (<<<), (>>=), (<#>), class Eq, class Show, (>=>), (>>>))

generateKeyring :: Effect Keyring
generateKeyring = do
  boxKeyPair <- generateBoxKeyPair
  secretBoxKey <- generateSecretBoxKey
  pure $ Keyring { secretBoxKey: secretBoxKey, boxKeyPair: boxKeyPair }


encodeKey :: Uint8Array -> String
encodeKey = runBase64 <<< encodeBase64 <<< buffer <<< dataView

decodeKey :: String -> Either String Uint8Array
decodeKey rawStr = dv <#> asUint8Array where
  decoded = decodeBase64 (Base64 rawStr)
  eithered = note "Could not decode base64 content" decoded
  dv = eithered <#> whole

newtype Keyring = Keyring
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

instance showKeyring :: Show Keyring where
  show = runBase64 <<< encodeBase64 <<< fromString <<< stringify <<< encodeJson

instance readKeyring :: Read Keyring where
  read
    = Base64
    >>> decodeBase64
    >>> note "Base 64 decoding failed"
    >=> (decodeToString >>> (lmap message))
    >=> jsonParser
    >=> decodeJson

derive instance eqKeyring :: Eq Keyring

runSecretBoxKey :: Keyring -> SecretBoxKey
runSecretBoxKey (Keyring keyring) = keyring.secretBoxKey

runBoxKeyPair :: Keyring -> BoxKeyPair
runBoxKeyPair (Keyring keyring) = keyring.boxKeyPair

instance encodeKeyringJson :: EncodeJson Keyring where
  encodeJson ring
    = "secretBoxKey" := (encodeKey $ toUint8Array $ runSecretBoxKey ring)
    ~> "boxKeyPair" := (encodeBoxKeyPair $ runBoxKeyPair ring)
    ~> jsonEmptyObject

encodeBoxKeyPair :: BoxKeyPair -> Json
encodeBoxKeyPair (BoxKeyPair pair)
  = "publicKey" := (encodeKey $ toUint8Array pair.publicKey)
  ~> "secretKey" := (encodeKey $ toUint8Array pair.secretKey)
  ~> jsonEmptyObject

instance decodeKeyringJson :: DecodeJson Keyring where
  decodeJson json =
    caseJsonObject (Left "Keyring input was not a JSON Object") parseRingObj json where
    parseRingObj :: Object Json -> Either String Keyring
    parseRingObj ringObj = do
      sbk <- ringObj .? "secretBoxKey" >>= decodeKey
      bkp <- ringObj .? "boxKeyPair" >>= caseJsonObject (Left "BoxKeyPair field did not contain a json object") decodeBoxKeyPair
      pure $ Keyring { secretBoxKey: fromUint8Array sbk, boxKeyPair: bkp }

decodeBoxKeyPair :: Object Json -> Either String BoxKeyPair
decodeBoxKeyPair boxKeyPairObj = do
  publicKey <- boxKeyPairObj .? "publicKey" >>= decodeKey
  secretKey <- boxKeyPairObj .? "secretKey" >>= decodeKey
  pure $ BoxKeyPair { publicKey: fromUint8Array publicKey, secretKey: fromUint8Array secretKey }
