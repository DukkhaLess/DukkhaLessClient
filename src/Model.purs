module Model where

import AppRouting.Routes as Routes
import Data.Maybe (Maybe(..))
import Intl (LocaliseFn)
import Model.Keyring (Keyring)

data KeyringUsage
  = None
  | Enabled Keyring

type Session =
  { userName :: String
  , accountForm :: KeyringUsage
  , sessionToken :: String
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
