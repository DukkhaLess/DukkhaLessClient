module Data.Routing.Class where

import Intl.Terms (Term)

class ReverseRoute a where
  reverseRoute :: a -> String
