module Components.Resources where

import Prelude
import Style.Bulogen

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Resources as Resource

data Query a = Query a

type Message = Unit

component :: forall m. LocaliseFn -> H.Component HH.HTML Query Unit Message m
component localiseFn =
  H.component
    { initialState: const localiseFn
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: LocaliseFn -> H.ComponentHTML Query
  render state =
    let
      pageTitle = state $ Term.Resource Resource.Title
    in
      HH.section [HP.classes [hero]]
        [ HH.div [HP.classes [heroBody]]
          [ HH.div [HP.classes [container]]
            [ HH.h1 [ HP.classes [title]] [ HH.text pageTitle ]
            ]
          ]
        ]

  eval :: Query ~> H.ComponentDSL LocaliseFn Query Message m
  eval (Query a)= pure a
