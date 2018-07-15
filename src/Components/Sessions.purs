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

data Query a =
  Init (Maybe Session) a

data Message
  = SessionCreated Session

data Input
  = ExistingSession (Maybe Session)

type State =
  { session :: Maybe Session
  , registering :: Boolean
  }

initialState :: forall a. a -> State
initialState = const { session: Nothing, registering: false }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: forall m. LocaliseFn -> H.Component HH.HTML Query Input Message m
component t =
  H.component
    { initialState: initialState
    , render
    , eval
    , receiver: receive
    }
  where

  render :: State -> H.ComponentHTML Query
  render state =
    let
      pageTitle = t $ Term.Resource Resource.Title
    in
      HH.section [HP.classes [hero]]
        [ HH.div [HP.classes [heroBody]]
          [ HH.div [HP.classes [container]]
            [ HH.h1 [ HP.classes [title]] [ HH.text pageTitle ]
            ]
          ]
        ]

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval (Init session next) = do
    H.modify_ (_{ session = session })
    pure next

receive :: Input -> Maybe (Query Unit)
receive (ExistingSession session) = Just $ Init session unit
