module Components.Sessions.Register where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff (Aff)
import Effect.Clipboard as EC
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
  | CopyKey (Maybe Keyring) a
  | NoOp a

data Message
  = SessionCreated Session

type Input = String

type State =
  { session :: Maybe Session
  , preparedRing :: Maybe Keyring
  }

initialState :: forall a. a -> State
initialState = const
                 { session: Nothing
                 , preparedRing: Nothing
                 }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: LocaliseFn -> H.Component HH.HTML Query Input Message Aff
component t =
  H.component
    { initialState: initialState
    , render
    , eval , receiver: receive}
  where

  render :: State -> H.ComponentHTML Query
  render state =
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
              , secretKeyHeader
              , HH.text $ t $ Term.Session Sessions.KeyRingInstructions
              , HH.a
                [ HP.classes [link, pullRight, spaced]
                , HE.onClick (HE.input_ $ CopyKey state.preparedRing )
                ]
                [ HH.text $ t $ Term.Session Sessions.CopyKey
                ]
              , HH.a
                [ HP.classes [link, pullRight]
                , HP.prop (H.PropName "download") "keyring"
                , HP.href ("data:text/plain;charset=utf-8," <> (fromMaybe "" $ state.preparedRing <#> show))
                ]
                [ HH.text $ t $ Term.Session Sessions.DownloadKey
                ]
              , keyBox state.preparedRing
              , HH.button
                [ HP.classes [button, primary, block]
                , HE.onClick (HE.input_ ToggleRegister)
                ]
                [ HH.text $ t $ Term.Session Sessions.LoginInstead
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
            [ HP.readOnly true
            , HP.value $ fromMaybe "" $ (keyring <#> show)
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
  eval (CopyKey mkey next) = do
    result <- H.liftEffect $ fromMaybe (pure unit) (mkey <#> (show >>> EC.copyToClipboard))
    pure next
  eval (NoOp next) = pure next


receive :: Input -> Maybe (Query Unit)
receive _ = Just $ NoOp unit
