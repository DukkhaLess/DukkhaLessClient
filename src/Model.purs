module Model where

import AppRouting.Routes as Routes
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Intl (LocaliseFn)
import Model.Keyring (Keyring)

newtype Username = Username String
derive instance newtypeUsername :: Newtype Username _

newtype SessionToken = SessionToken String
derive instance newtypeSessionToken :: Newtype SessionToken _

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
