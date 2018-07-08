module AppRouting.Routes where

import Prelude
import Control.Alternative ((<|>))
import Data.Foldable (oneOf)
import Routing.Match (Match, lit, int, str, end)

data Routes
  = Intro
  | Resources

instance showRoutes :: Show Routes where
  show Intro = "intro"
  show Resources = "resources"


routes :: Match Routes
routes = oneOf
  [ Intro <$ lit (show Intro)
  , Resources <$ lit (show Resources)
  ]
