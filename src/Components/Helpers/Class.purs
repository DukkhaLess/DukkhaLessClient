module Components.Helpers.Class where

import Prelude
import Data.Array (snoc)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as Route
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Data.Routing.Routes.Sessions as RS
import Data.Routing.Routes.Journals as RJ
import Style.FontHawesome as FA

makeIcon
  :: forall a b c
  .  Iconise a
  => a
  -> Maybe (H.HTML b c)
makeIcon a = makeElement <$> iconise a where
  makeElement classes =
    HH.i 
      [ HP.classes
        classes
      ]
      []

class Iconise a where
  iconise :: a -> Maybe (Array (HH.ClassName))

instance describeRoutes :: Iconise Route.Routes where
  iconise r = case r of
    Route.Intro -> Nothing
    Route.Resources -> Nothing
    Route.NotFound -> Nothing
    Route.Sessions sessions -> iconise sessions
    Route.Journals journals -> iconise journals

instance describeSessionRoute :: Iconise RS.Sessions where
  iconise r = case r of
    RS.Login -> Just $ [FA.solid, FA.signInAlt]
    RS.Register -> Just $ [FA.solid, FA.userPlus]

instance describeJournalRoute :: Iconise RJ.Journals where
  iconise r = Just $ snoc [FA.solid] $ case r of
    RJ.Edit Nothing -> FA.penSquare
    RJ.Edit (Just _) -> FA.edit
    RJ.List -> FA.list
