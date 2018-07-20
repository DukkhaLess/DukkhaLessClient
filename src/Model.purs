module Model where

import AppRouting.Routes as Routes
import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey)
import Data.Maybe (Maybe(..))
import Intl.Terms (Term)

newtype KeyRing = KeyRing
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

type Session =
  { userName :: String
  , keyChains :: KeyRing
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
