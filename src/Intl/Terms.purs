module Intl.Terms
  ( j
  , n
  , Term(..)
  ) where

import Data.Maybe (Maybe(..))
import Intl.Terms.Introduction (Introduction)
import Intl.Terms.NotFound (NotFound)
import Intl.Terms.Resources (Resources)
import Intl.Terms.Sessions (Sessions)
import Intl.Terms.Validation (ValidationMsg)
import Intl.Terms.Journals (Journals)
import Intl.Terms.Common (Common)

n :: forall a. Maybe a
n = Nothing

j :: forall a. a -> Maybe a
j = Just

data Term
  = Intro Introduction
  | Resource Resources
  | Session Sessions
  | NotFound NotFound
  | Validation ValidationMsg
  | Journal Journals
  | Common Common
