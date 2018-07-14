module Components.Sessions where

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
import Model (Session)

data Query a = Query a

type Message = Unit

type State =
  { session :: Maybe Session
  , registering :: Boolean
  }

initialState :: forall a. Maybe Session -> a -> State
initialState session = const { session: session, registering: false }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: forall m. Maybe Session -> LocaliseFn -> H.Component HH.HTML Query Unit Message m
component initialSession localiseFn =
  H.component
    { initialState: initialState initialSession
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: State -> H.ComponentHTML Query
  render state =
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

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval (Query a)= pure a

