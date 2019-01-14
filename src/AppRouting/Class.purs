module AppRouting.Class where

class ReverseRoute a where
  reverseRoute :: a -> String
