module Intl.English where

import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.Resources as Resource

import Data.Maybe (Maybe(..))

localise :: Term.Term -> Maybe String
localise Term.MySelfCare = Just "My Selfcare"
localise (Term.Intro intro) = localiseIntro intro
localise _    = Nothing

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = Just "My Selfcare"
localiseIntro Intro.Explanation = Just "A Selfcare application with encryption to help work on your mental health"
