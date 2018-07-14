module Model where

import Prelude (show)
import Intl.Terms (Term)
import AppRouting.Routes as Routes

type Model =
  { localiseFn :: Term -> String
  , currentPage :: Routes.Routes
  }

initial :: (Term -> String) -> Model
initial f =
  { localiseFn: f
  , currentPage: Routes.Resources
  }
