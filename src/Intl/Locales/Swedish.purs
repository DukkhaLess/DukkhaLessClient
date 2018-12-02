module Intl.Locales.Swedish where

import Data.Maybe (Maybe)
import Intl.Terms (j, n)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.Resources as Resource

localise :: Term.Term -> Maybe String
localise term = case term of
  Term.Intro intro -> localiseIntro intro
  Term.Resource resource -> localiseResource resource
  _ -> n

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro intro = case intro of
  Intro.Title -> j "Dukkhaless Självvård"
  _           -> n

localiseResource :: Resource.Resources -> Maybe String
localiseResource title = case title of
  _ -> n
