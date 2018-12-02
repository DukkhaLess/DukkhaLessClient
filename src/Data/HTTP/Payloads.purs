module Data.HTTP.Payloads where

import Model
import Prelude

import Crypt.NaCl.Class (toUint8Array)
import Crypt.NaCl.Types (BoxPublicKey(..))
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype, unwrap)
import Data.Crypto.Codec (encodeBytes)

newtype SubmitRegister = SubmitRegister
  { publicKey :: BoxPublicKey
  , username :: Username
  , password :: Password
  , passwordConfirmation :: Password
  }

derive instance newtypeSubmitRegister :: Newtype SubmitRegister _

instance encodeJsonSubmitRegister :: EncodeJson SubmitRegister where
  encodeJson (SubmitRegister r)
    = "publicKey" := encodeBytes (toUint8Array r.publicKey)
    ~> "username" := unwrap r.username
    ~> "password" := unwrap r.password
    ~> "passwordConfirmation" := unwrap r.passwordConfirmation
    ~> jsonEmptyObject

newtype SubmitLogin = SubmitLogin
  { username :: Username
  , password :: Password
  }

derive instance newtypeSubmitLogin :: Newtype SubmitLogin _
derive instance genericSubmitLogin :: Generic SubmitLogin _
instance showSubmitLogin :: Show SubmitLogin where
  show = genericShow

instance encodeJsonSubmitLogin :: EncodeJson SubmitLogin where
  encodeJson (SubmitLogin l)
    = "username" := unwrap l.username
    ~> "password" := unwrap l.password
    ~> jsonEmptyObject
