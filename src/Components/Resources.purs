module Components.Resources where

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Resources as Resource
import Model (Session)
import Prelude (class Eq, class Ord, type (~>), Unit, const, pure, ($))
import Style.Bulogen (container, hero, heroBody, title)

render :: forall i p. LocaliseFn -> HH.HTML i p
render localiseFn =
  let
    pageTitle = localiseFn $ Term.Resource Resource.Title
  in
    HH.section [HP.classes [hero]]
      [ HH.div [HP.classes [heroBody]]
        [ HH.div [HP.classes [container]]
          [ HH.h1 [ HP.classes [title]] [ HH.text pageTitle ]
          ]
        ]
      ]