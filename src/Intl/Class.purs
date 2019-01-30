module Intl.Class where

import Intl.Terms.Sessions as TS
import Intl.Terms as Term
import Intl.Terms.Introduction as TI
import Intl.Terms.Common as TC
import Intl.Terms.Resources as TR
import Intl.Terms.NotFound as TNF
import Data.Routing.Routes as Route
import Data.Routing.Routes.Sessions as RS


class Describe a where
  describe :: a -> Term.Term

instance describeSessions :: Describe RS.Sessions where
  describe r = case r of
    RS.Login -> Term.Session TS.Login
    RS.Register -> Term.Session TS.Register

instance describeRoutes :: Describe Route.Routes where
  describe r = case r of
    Route.Intro -> Term.Common TC.ProductName
    Route.Resources -> Term.Resource TR.Title
    Route.NotFound -> Term.Common TNF.Title
    Route.Sessions sessions -> describe sessions
    Route.Journals journals -> describe journals

