module Intl.Locales.English where

import Intl.Terms (j, n)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.Resources as Resource

import Data.Maybe (Maybe(..))

localise :: Term.Term -> Maybe String
localise Term.MySelfCare = Just "My Selfcare"
localise (Term.Intro intro) = localiseIntro intro
localise (Term.Resource resource) = localiseResource resource

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = j "My Selfcare"
localiseIntro Intro.Explanation = j "A Selfcare application with encryption to help work on your mental health"

localiseResource :: Resource.Resources -> Maybe String
localiseResource Resource.Title = j "Resources"
