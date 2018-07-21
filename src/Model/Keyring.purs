module Model.Keyring
  ( generateKeyring
  , runSecretBoxKey
  , runBoxKeyPair
  , encodeKey
  , Keyring(..)
  ) where

import Crypt.NaCl (BoxKeyPair(..), SecretBoxKey, generateBoxKeyPair, generateSecretBoxKey, toUint8Array)
import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey)
import Data.Argonaut.Core (Json, caseJsonObject, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.ArrayBuffer.DataView (whole, buffer)
import Data.ArrayBuffer.Typed (asUint8Array, dataView)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Base64 (encodeBase64, decodeBase64, runBase64)
import Data.Either (Either(..))
import Effect (Effect)
import Foreign.Object (Object)
import Prelude (pure, bind, ($), (<<<))

generateKeyring :: Effect Keyring
generateKeyring = do
  boxKeyPair <- generateBoxKeyPair
  secretBoxKey <- generateSecretBoxKey
  pure $ Keyring { secretBoxKey: secretBoxKey, boxKeyPair: boxKeyPair }

encodeKey :: Uint8Array -> String
encodeKey = runBase64 <<< encodeBase64 <<< buffer <<< dataView

newtype Keyring = Keyring
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

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
      sbk <- ringObj .? "secretBoxKey"
      bkp <- ringObj .? "boxKeyPair"
      pure $ Keyring { secretBoxKey: sbk, boxKeyPair: bkp }
