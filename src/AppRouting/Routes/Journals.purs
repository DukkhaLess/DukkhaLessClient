module AppRouting.Routes.Journals where

import Prelude

import AppRouting.Class (class ReverseRoute)
import Data.Maybe (Maybe(..))

data Journals
  = List
  | Edit (Maybe String)

instance reverseRouteJournals :: ReverseRoute Journals where
  reverseRoute j = case j of
    List -> ""
    Edit Nothing -> "edit"
    Edit (Just id) -> id <> "/" <> "edit"