module Data.Routing.Routes
  ( module ARC
  , Routes(..)
  , routes
  ) where

import Data.Routing.Literals
import Prelude

import Control.Alternative ((<|>))
import Data.Array (tail)
import Data.Foldable (foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Routing.Class (class ReverseRoute, reverseRoute)
import Data.Routing.Class (class ReverseRoute, reverseRoute) as ARC
import Data.Routing.Routes.Journals (Journals)
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions (Sessions)
import Data.Routing.Routes.Sessions as RS
import Data.String (toLower, split, Pattern(..))
import Routing.Match (Match, lit, end, str)

data Routes
  = Intro
  | Resources
  | Sessions Sessions
  | NotFound
  | Journals Journals

instance reverseRouteRoutes :: ReverseRoute Routes where
  reverseRoute r = leader <> toLower case r of
    Intro -> "intro"
    Resources -> "resources"
    NotFound -> "notfound"
    (Sessions s) -> sessionsName <> "/" <> reverseRoute s
    (Journals j) -> journalsName <> "/" <> reverseRoute j

routes :: Match Routes
routes
  = (Intro <$ end)
  <|> routeSimple Intro
  <|> routeSimple Resources
  <|> routeSimple (Sessions RS.Login)
  <|> routeSimple (Sessions RS.Register)
  <|> routeSimple (Journals $ RJ.Edit Nothing)
  <|> ((lit journalsName *> str <* lit edit) <#> Just <#> RJ.Edit <#> Journals)
  <|> routeSimple (Journals RJ.List)
  <|> (pure NotFound)

  where
    routeSimple :: Routes -> Match Routes
    routeSimple r = r <$ (foldl concatRoutes (lit "") $ fromMaybe [] $ tail $ split (Pattern "/") (reverseRoute r))
    concatRoutes :: Match Unit -> String -> Match Unit
    concatRoutes ms s = ms *> lit s
