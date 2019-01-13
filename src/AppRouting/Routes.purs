module AppRouting.Routes where

import Prelude

import Control.Alternative ((<|>))
import Data.Array (tail)
import Data.Foldable (foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (toLower, split, Pattern(..))
import Routing.Match (Match, lit, end)

class ReverseRoute a where
  reverseRoute :: a -> String

leader :: String
leader = "#/"

data Sessions
  = Login
  | Register

instance reverseRouteSessions :: ReverseRoute Sessions where
  reverseRoute r = case r of
    Login -> "login"
    Register -> "register"


data Journals
  = List
  | Edit (Maybe String)

instance reverseRouteJournals :: ReverseRoute Journals where
  reverseRoute j = case j of
    List -> ""
    Edit Nothing -> "edit"
    Edit (Just id) -> id <> "/" <> "edit"

data Routes
  = Intro
  | Resources
  | Sessions Sessions
  | NotFound
  | Journals Journals

instance reverseRouteRoutes :: ReverseRoute Routes where
  reverseRoute r = leader <> toLower case r of
    Intro -> "into"
    Resources -> "resources"
    NotFound -> "notfound"
    (Sessions s) -> "sessions/" <> reverseRoute s
    (Journals j) -> "journals/" <> reverseRoute j

routes :: Match Routes
routes
  = (Intro <$ end)
  <|> routeSimple Intro
  <|> routeSimple Resources
  <|> routeSimple (Sessions Login)
  <|> routeSimple (Sessions Register)
  <|> routeSimple (Journals List)
  <|> (pure NotFound)

  where
    routeSimple :: Routes -> Match Routes
    routeSimple r = r <$ (foldl concatRoutes (lit "") $ fromMaybe [] $ tail $ split (Pattern "/") (reverseRoute r))
    concatRoutes :: Match Unit -> String -> Match Unit
    concatRoutes ms s = ms *> lit s
