module Components.Sessions where

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Events as HE
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Model (Session)
import Model.Keyring (Keyring(..))
import Prelude (type (~>), Unit, bind, const, discard, pure, unit, not, ($), class Ord, class Eq)
import Style.Bulogen (container, hero, heroBody, input, textarea, title, primary, button)

data Query a
  = ToggleRegister a
  | Init (Maybe Session) a

data Message
  = SessionCreated Session

data Input
  = ExistingSession (Maybe Session)

type State =
  { session :: Maybe Session
  , registering :: Boolean
  , preparedRing :: Maybe Keyring
  }

initialState :: forall a. a -> State
initialState = const { session: Nothing, registering: false, preparedRing: Nothing }

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
      case state.session of
        Just session -> HH.text "Logout"
        Nothing -> if state.registering then registerForm state else loginForm state

  loginForm :: State -> H.ComponentHTML Query
  loginForm state =
    HH.section [HP.classes [hero]]
        [ HH.div [HP.classes [heroBody]]
          [ HH.div [HP.classes [container]]
            [ HH.h1 [ HP.classes [title]] [ HH.text $ t $ Term.Session Sessions.Login ]
            , HH.input
              [ HP.classes [input]
              , HP.placeholder $ t $ Term.Session Sessions.Username
              ]
            , HH.input
              [ HP.type_ HP.InputPassword
              , HP.classes [input]
              , HP.placeholder $ t (Term.Session Sessions.Password)
              ]
            , HH.textarea [HP.classes [textarea]]
            , HH.text $ t $ Term.Session Sessions.KeyRingInstructions
            , HH.button
              [ HP.classes [button, primary]
              , HE.onClick (HE.input_ ToggleRegister)
              ]
              [ HH.text $ t $ Term.Session Sessions.RegisterInstead
              ]
            ]
          ]
        ]



  registerForm :: State -> H.ComponentHTML Query
  registerForm state =
    HH.section [HP.classes [hero]]
        [ HH.div [HP.classes [heroBody]]
          [ HH.div [HP.classes [container]]
            [ HH.h1 [ HP.classes [title]] [ HH.text $ t $ Term.Session Sessions.Register ]
            , HH.input
              [ HP.classes [input]
              , HP.placeholder $ t $ Term.Session Sessions.Username
              ]
            , HH.input
              [ HP.type_ HP.InputPassword
              , HP.classes [input]
              , HP.placeholder $ t (Term.Session Sessions.Password)
              ]
            , HH.input
              [ HP.type_ HP.InputPassword
              , HP.classes [input]
              , HP.placeholder $ t (Term.Session Sessions.ConfirmPassword)
              ]
            , HH.textarea [HP.classes [textarea]]
            , HH.text $ t $ Term.Session Sessions.KeyRingInstructions
            , HH.button
              [ HP.classes [button, primary]
              , HE.onClick (HE.input_ ToggleRegister)
              ]
              [ HH.text $ t $ Term.Session Sessions.LoginInstead
              ]
            ]
          ]
        ]


  eval :: Query ~> H.ComponentDSL State Query Message m
  eval (Init session next) = do
    H.modify_ (_{ session = session })
    pure next
  eval (ToggleRegister next) = do
    state <- H.get
    let nextState = state { registering = not state.registering }
    H.put nextState
    pure next

receive :: Input -> Maybe (Query Unit)
receive (ExistingSession session) = Just $ Init session unit
