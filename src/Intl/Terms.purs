module Intl.Terms where

import Intl.Terms.Introduction as INTRO
import Intl.Terms.Resources as RESOURCE

import Data.Maybe (Maybe(..))

j :: forall a. a -> Maybe a
j a = Just a

n :: forall a.  Maybe a
n = Nothing

data Term
  = MySelfCare
  | Intro INTRO.Introduction
  | Resource RESOURCE.Resources
