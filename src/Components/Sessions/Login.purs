module Components.Sessions.Login where

import Prelude

import AppRouting.Routes as R
import Data.ArrayBuffer.ArrayBuffer (decodeToString)
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), note)
import Data.Maybe (Maybe(..))
import Data.String.Read (read)
import Effect.Aff (Aff)
import Effect.Console (log)
import Effect.Exception (message)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Model (Session)
import Model.Keyring (Keyring, generateKeyring)
import Style.Bulogen (block, button, container, hero, heroBody, input, link, offsetThreeQuarters, primary, pullRight, spaced, subtitle, textarea, title)

data Query a
  = ToggleRegister a
  | UpdateKey String a
  | NoOp a

data Message
  = SessionCreated Session

type State =
  {  username :: Maybe String
  , preparedRing :: Maybe Keyring
  }

initialState :: forall a. a -> State
initialState = const
                 { username: Nothing
                 , preparedRing: Nothing
                 }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: forall a. LocaliseFn -> H.Component HH.HTML Query a Message Aff
component t =
  H.component
    { initialState: initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: State -> H.ComponentHTML Query
  render state =
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
                  , keyBox state.preparedRing
                  , HH.a
                    [ HP.classes [button, primary, block]
                    , HP.href $ R.reverseRoute $ R.Sessions R.Register
                    ]
                    [ HH.text $ t $ Term.Session Sessions.RegisterInstead
                    ]
                  ]
                ]
              ]

  secretKeyHeader :: forall p i. HH.HTML p i
  secretKeyHeader =
    HH.h4
      [ HP.classes [subtitle]
      ]
      [ HH.text $ t $ Term.Session Sessions.KeySubtitle
      ]

  keyBox :: forall p. Maybe Keyring -> HH.HTML p (Query Unit)
  keyBox keyring =
    HH.textarea $
      [ HE.onValueChange (HE.input UpdateKey)
      , HP.classes [textarea]
      , HP.placeholder "Your secret keys."
      ]

  eval :: Query ~> H.ComponentDSL State Query Message Aff
  eval (ToggleRegister next) = do
    state <- H.get
    nextState <- do
            keyring <- H.liftEffect $ generateKeyring
            pure $ state { preparedRing = Just keyring
                         }

    H.put nextState
    pure next
  eval (NoOp next) = pure next
  eval (UpdateKey keyStr next) = do
    state <- H.get
    let jsonRaw = Base64 >>> decodeBase64 >>> note "Base64 decoding failed" >=> decodeToString >>> (lmap message) $ keyStr
    H.liftEffect $ log $ show jsonRaw

    nextState <- H.liftEffect $ case read keyStr of
      Left err -> do
        log err
        pure state
      Right keyring -> do
        pure $ state { preparedRing = Just keyring}
    H.put nextState
    pure next