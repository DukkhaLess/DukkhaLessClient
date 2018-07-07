module Intl.English where

import Intl.Terms

import Data.Maybe (Maybe(..))

localise :: Term -> Maybe String
localise MySelfCare = Just "My Selfcare"
localise (Intro intro) = localiseIntro intro
localise _    = Nothing

localiseIntro :: Introduction -> Maybe String
localiseIntro Title = Just "My Selfcare"
localiseIntro Explanation = Just "A Selfcare application with encryption to help work on your mental health"
