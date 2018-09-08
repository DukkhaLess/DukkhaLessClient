module AppRouting.Routes where

import Prelude
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Data.String (toLower)
import Control.Alternative ((<|>))
import Routing.Match (Match, lit, end, root)

data Routes
  = Intro
  | Resources
  | Sessions
  | NotFound


derive instance genericRoutes :: G.Generic Routes _

instance showRoutes :: Show Routes where
  show r = GShow.genericShow r

class ReverseRoute a where
  reverseRoute :: a -> String

leader :: String
leader = "#/"

instance reverseRouteRoutes :: ReverseRoute Routes where
  reverseRoute route = case route of
    r -> leader <> (toLower $ show $ r)

routes :: Match Routes
routes
  = (Intro <$ end)
  <|> route Intro
  <|> route Resources
  <|> route Sessions
  <|> (pure NotFound)

  where
    route r = r <$ (lit "" *> lit (toLower $ show $ r))
