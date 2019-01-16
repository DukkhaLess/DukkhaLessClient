module Data.Routing.Class where

class ReverseRoute a where
  reverseRoute :: a -> String
