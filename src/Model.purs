module Model where

import Intl.Terms (Term)

type Model =
  { localiseFn :: Term -> String
  }

initial :: (Term -> String) -> Model
initial f = { localiseFn: f }
