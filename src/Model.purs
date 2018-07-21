module Model where

import AppRouting.Routes as Routes
import Data.Maybe (Maybe(..))
import Intl.Terms (Term)
import Model.Keyring (Keyring)

type Session =
  { userName :: String
  , keyChains :: Keyring
  , sessionToken :: String
  }

type Model =
  { localiseFn :: Term -> String
  , currentPage :: Routes.Routes
  , session :: Maybe Session
  }

initial :: (Term -> String) -> Model
initial f =
  { localiseFn: f
  , currentPage: Routes.Resources
  , session: Nothing
  }
