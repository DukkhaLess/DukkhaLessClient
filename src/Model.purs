module Model where

import Prelude

import Data.Routing.Routes as Routes
import Data.Argonaut ((.?))
import Data.Argonaut.Core (fromString, jsonEmptyObject)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap, wrap)
import Intl (LocaliseFn)
import Model.Keyring (Keyring)

newtype Username = Username String
derive instance newtypeUsername :: Newtype Username _
derive instance genericUsername :: Generic Username _
instance encodeJsonUsername :: EncodeJson Username where
  encodeJson = fromString <<< unwrap
instance showUsername :: Show Username where
  show = genericShow


newtype Password = Password String
derive instance newtypePassword :: Newtype Password _
derive instance eqPassword :: Eq Password
derive instance genericPassword :: Generic Password _
instance showPassword :: Show Password where
  show = genericShow
instance encodeJsonPassword :: EncodeJson Password where
  encodeJson = fromString <<< unwrap

newtype SessionToken = SessionToken String
derive instance newtypeSessionToken :: Newtype SessionToken _
instance encodeJsonSessionToken :: EncodeJson SessionToken where
  encodeJson t = 
    "sessionToken" := fromString (unwrap t)
    ~> jsonEmptyObject

instance decodeJsonSessionToken :: DecodeJson SessionToken where
  decodeJson json = do
    obj <- decodeJson json
    sessionToken <- obj .? "sessionToken"
    pure $ wrap sessionToken

data KeyringUsage
  = None
  | Enabled Keyring

newtype Session = Session
  { username :: Username
  , keyringUsage :: KeyringUsage
  , sessionToken :: SessionToken
  }

derive instance newtypeSession :: Newtype Session _

type Model =
  { localiseFn :: LocaliseFn
  , currentPage :: Routes.Routes
  , session :: Maybe Session
  }

initial :: LocaliseFn -> Model
initial f =
  { localiseFn: f
  , currentPage: Routes.Intro
  , session: Nothing
  }
