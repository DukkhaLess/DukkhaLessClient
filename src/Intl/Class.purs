module Intl.Class where

import Prelude
import Data.Maybe (Maybe(..))
import Intl.Terms.Sessions as TS
import Intl.Terms as Term
import Intl.Terms.Introduction as TI
import Intl.Terms.Common as TC
import Intl.Terms.Resources as TR
import Intl.Terms.NotFound as TNF
import Intl.Terms.Journals as TJ
import Data.Routing.Routes as Route
import Data.Routing.Routes.Sessions as RS
import Data.Routing.Routes.Journals as RJ


class Describe a where
  describe :: a -> Term.Term

instance describeRoutes :: Describe Route.Routes where
  describe r = case r of
    Route.Intro -> Term.Common TC.ProductName
    Route.Resources -> Term.Resource TR.Title
    Route.NotFound -> Term.NotFound TNF.Title
    Route.Sessions sessions -> describe sessions
    Route.Journals journals -> describe journals

instance describeSessionRoute :: Describe RS.Sessions where
  describe r = case r of
    RS.Login -> Term.Session TS.Login
    RS.Register -> Term.Session TS.Register

instance describeJournalRoute :: Describe RJ.Journals where
  describe r = case r of
    RJ.Edit Nothing -> Term.Journal TJ.Create
    RJ.Edit (Just id) -> Term.Journal $ TJ.EditExisting id
    RJ.List -> Term.Journal TJ.ListEntries
