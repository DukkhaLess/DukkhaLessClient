module Data.HTTP.Payloads where

import Model

import Crypt.NaCl.Class (toUint8Array)
import Crypt.NaCl.Types (BoxPublicKey(..))
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Newtype (class Newtype, unwrap)
import Model.Keyring (encodeKey)

newtype SubmitRegister = SubmitRegister
  { publicKey :: BoxPublicKey
  , username :: Username
  , password :: Password
  , passwordConfirmation :: Password
  }

derive instance newtypeSubmitRegister :: Newtype SubmitRegister _

instance encodeJsonSubmitRegister :: EncodeJson SubmitRegister where
  encodeJson (SubmitRegister r)
    = "publicKey" := encodeKey (toUint8Array r.publicKey)
    ~> "username" := unwrap r.username
    ~> "password" := unwrap r.password
    ~> "passwordConfirmation" := unwrap r.passwordConfirmation
    ~> jsonEmptyObject