module Intl.Terms where

import Data.Maybe (Maybe(..))

import Intl.Terms.Introduction as INTRO
import Intl.Terms.Resources as RESOURCE

j :: forall a. a -> Maybe a
j a = Just a

n :: forall a. Maybe a
n = Nothing

data Term
  = MySelfCare
  | Intro INTRO.Introduction
  | Resource RESOURCE.Resources
