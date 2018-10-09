module Model where

import AppRouting.Routes as Routes
import Data.Argonaut.Core (fromString, toString)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Either (note)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap, wrap)
import Intl (LocaliseFn)
import Model.Keyring (Keyring)
import Prelude ((<<<), ($), map, class Eq)

newtype Username = Username String
derive instance newtypeUsername :: Newtype Username _
instance encodeJsonUsername :: EncodeJson Username where
  encodeJson = fromString <<< unwrap

newtype Password = Password String
derive instance newtypePassword :: Newtype Password _
derive instance eqPassword :: Eq Password
instance encodeJsonPassword :: EncodeJson Password where
  encodeJson = fromString <<< unwrap

newtype SessionToken = SessionToken String
derive instance newtypeSessionToken :: Newtype SessionToken _
instance encodeJsonSessionToken :: EncodeJson SessionToken where
  encodeJson = fromString <<< unwrap
instance decodeJsonSessionToken :: DecodeJson SessionToken where
  decodeJson json = map wrap $ note "SessionToken string could not be decoded" $ toString json

data KeyringUsage
  = None
  | Enabled Keyring

type Session =
  { userName :: Username
  , accountForm :: KeyringUsage
  , sessionToken :: SessionToken
  }

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
