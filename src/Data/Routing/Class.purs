module Data.Routing.Class where

import Intl.Terms (Term)

class ReverseRoute a where
  reverseRoute :: a -> String

class DescribeRoute a where
  describe :: a -> Term
  iconize :: a -> String