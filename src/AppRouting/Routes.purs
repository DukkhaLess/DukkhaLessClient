module AppRouting.Routes where

import Prelude

import Control.Alternative ((<|>))
import Data.String (toLower)
import Routing.Match (Match, lit)

import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow

data Routes
  = Intro
  | Resources

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
routes = route Intro <|> route Resources
    where
    route r = r <$ (lit "" *> lit (toLower $ show $ r))
    
