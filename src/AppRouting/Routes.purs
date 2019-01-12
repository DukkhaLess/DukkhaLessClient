module AppRouting.Routes where

import Prelude

import Control.Alternative ((<|>))
import Data.Foldable (foldl)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Data.Maybe (Maybe)
import Data.String (toLower, split, Pattern(..))
import Routing.Match (Match, lit, end)

class ReverseRoute a where
  reverseRoute :: a -> String

leader :: String
leader = "#/"

instance showSessions :: Show Sessions where
  show r = toLower $ case r of
    otherwise -> GShow.genericShow otherwise


data Sessions
  = Login
  | Register

derive instance genericSessions :: G.Generic Sessions _

data Journals
  = List
  | Edit (Maybe String)

derive instance genericJournals :: G.Generic Journals _

instance showJournals :: Show Journals where
  show j = toLower $ case j of
    otherwise -> GShow.genericShow otherwise

data Routes
  = Intro
  | Resources
  | Sessions Sessions
  | NotFound
  | Journals Journals

derive instance genericRoutes :: G.Generic Routes _


instance showRoutes :: Show Routes where
  show r = toLower $ case r of
    (Sessions s) -> "sessions/" <> show s
    otherwise -> GShow.genericShow r

instance reverseRouteRoutes :: ReverseRoute Routes where
  reverseRoute route = case route of
    r -> leader <> (show r)

routes :: Match Routes
routes
  = (Intro <$ end)
  <|> route Intro
  <|> route Resources
  <|> route (Sessions Login)
  <|> route (Sessions Register)
  <|> (pure NotFound)

  where
    route :: Routes -> Match Routes
    route r = r <$ (foldl concatRoutes (lit "") $ split (Pattern "/") (show r))
    concatRoutes :: Match Unit -> String -> Match Unit
    concatRoutes ms s = ms *> lit s
