module AppRouting.Routes where

import Prelude
import Control.Alternative ((<|>))
import Data.Foldable (oneOf)
import Routing.Match (Match, lit, int, str, end)

data Routes
  = Intro
  | Resources

instance showRoutes :: Show Routes where
  show Intro = "Intro"
  show Resources = "Resources"


routes :: Match Routes
routes = oneOf
  [ Intro <$ lit "intro"
  , Resources <$ lit "resources"
  ]
