module Intl.Terms
  ( j
  , n
  , Term(..)
  ) where

import Intl.Terms.Introduction (Introduction)
import Intl.Terms.Resources (Resources)
import Intl.Terms.Sessions (Sessions)

import Data.Maybe (Maybe(..))

n :: forall a. Maybe a
n = Nothing

j :: forall a. a -> Maybe a
j = Just

data Term
  = Intro Introduction
  | Resource Resources
  | Session Sessions
