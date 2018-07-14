module Intl.Swedish where

import Intl.Terms (j, n)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.Resources as Resource

import Data.Maybe (Maybe(..))

localise :: Term.Term -> Maybe String
localise Term.MySelfCare = n
localise (Term.Intro intro) = localiseIntro intro
localise (Term.Resource resource) = localiseResource resource

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = n
localiseIntro Intro.Explanation = n

localiseResource :: Resource.Resources -> Maybe String
localiseResource Resource.Title = n
