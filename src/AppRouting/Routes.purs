module AppRouting.Routes where

import Prelude
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Control.Alternative ((<|>))
import Routing.Match (Match, lit)

data Routes
  = Intro
  | Resources


derive instance genericRoutes :: G.Generic Routes _

instance showRoutes :: Show Routes where
  show r = GShow.genericShow r

class ReverseRoutable a where
  reverseRoute :: a -> String

routes :: Match Routes
routes
  = intro
  <|> resources

  where
    intro = Intro <$ route (show Intro)
    resources = Resources <$ route (show Resources)


    route str = lit "" *> lit str
