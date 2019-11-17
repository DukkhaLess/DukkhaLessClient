module Model.Keyring
  ( generateKeyring
  , runSecretBoxKey
  , runBoxKeyPair
  , Keyring(..)
  , boxPrivateKey
  , boxPublicKey
  , secretBoxKey
  ) where

import Prelude
import Crypt.NaCl (BoxKeyPair(..), fromUint8Array, generateBoxKeyPair, generateSecretBoxKey, toUint8Array)
import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey, BoxSecretKey, BoxPublicKey)
import Data.Argonaut.Core (Json, caseJsonObject, jsonEmptyObject, stringify)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Combinators ((.:))
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Base64 (decodeBase64, encodeBase64, runBase64)
import Data.Crypto.Codec (decodeBytes, encodeBytes)
import Data.Either (Either(..))
import Data.Newtype (class Newtype)
import Effect (Effect)
import Foreign.Object (Object)

generateKeyring :: Effect Keyring
generateKeyring = do
  boxKeyPair <- generateBoxKeyPair
  sbKey <- generateSecretBoxKey
  pure $ Keyring { secretBoxKey: sbKey, boxKeyPair: boxKeyPair }

newtype Keyring
  = Keyring
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

derive instance newtypeKeyring :: Newtype Keyring _

boxPrivateKey :: Keyring -> BoxSecretKey
boxPrivateKey (Keyring keyring) = privKey keyring.boxKeyPair
  where
  privKey (BoxKeyPair pair) = pair.secretKey

boxPublicKey :: Keyring -> BoxPublicKey
boxPublicKey (Keyring keyring) = pubKey keyring.boxKeyPair
  where
  pubKey (BoxKeyPair pair) = pair.publicKey

secretBoxKey :: Keyring -> SecretBoxKey
secretBoxKey (Keyring keyring) = keyring.secretBoxKey

runSecretBoxKey :: Keyring -> SecretBoxKey
runSecretBoxKey (Keyring keyring) = keyring.secretBoxKey

runBoxKeyPair :: Keyring -> BoxKeyPair
runBoxKeyPair (Keyring keyring) = keyring.boxKeyPair

instance encodeKeyringJson :: EncodeJson Keyring where
  encodeJson ring =
    "secretBoxKey" := (encodeBytes $ toUint8Array $ runSecretBoxKey ring)
      ~> "boxKeyPair"
      := (encodeBoxKeyPair $ runBoxKeyPair ring)
      ~> jsonEmptyObject

encodeBoxKeyPair :: BoxKeyPair -> Json
encodeBoxKeyPair (BoxKeyPair pair) =
  "publicKey" := (encodeBytes $ toUint8Array pair.publicKey)
    ~> "secretKey"
    := (encodeBytes $ toUint8Array pair.secretKey)
    ~> jsonEmptyObject

instance decodeKeyringJson :: DecodeJson Keyring where
  decodeJson json = caseJsonObject (Left "Keyring input was not a JSON Object") parseRingObj json
    where
    parseRingObj :: Object Json -> Either String Keyring
    parseRingObj ringObj = do
      sbk <- ringObj .: "secretBoxKey" >>= decodeBytes
      bkp <- ringObj .: "boxKeyPair" >>= caseJsonObject (Left "BoxKeyPair field did not contain a json object") decodeBoxKeyPair
      pure $ Keyring { secretBoxKey: fromUint8Array sbk, boxKeyPair: bkp }

decodeBoxKeyPair :: Object Json -> Either String BoxKeyPair
decodeBoxKeyPair boxKeyPairObj = do
  publicKey <- boxKeyPairObj .: "publicKey" >>= decodeBytes
  secretKey <- boxKeyPairObj .: "secretKey" >>= decodeBytes
  pure $ BoxKeyPair { publicKey: fromUint8Array publicKey, secretKey: fromUint8Array secretKey }
