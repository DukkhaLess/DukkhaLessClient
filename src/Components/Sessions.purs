module Components.Sessions where

import Prelude

import Effect.Exception (message)
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), note)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.ArrayBuffer.ArrayBuffer (decodeToString)
import Data.String.Read (read)
import Effect.Aff (Aff)
import Effect.Clipboard as EC
import Effect.Console (log)
import Flags (EditLevel(..))
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
  | Init (Maybe Session) a
  | CopyKey (Maybe Keyring) a
  | UpdateKey String a

data Message
  = SessionCreated Session

data Input
  = ExistingSession (Maybe Session)

data SessionCreationMode
  = Login
  | Register

type State = { session :: Maybe Session
  , sessionCreationMode :: SessionCreationMode
  , preparedRing :: Maybe Keyring
  }

initialState :: forall a. a -> State
initialState = const
                 { session: Nothing
                 , sessionCreationMode: Login
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
    , eval
    , receiver: receive
    }
  where

  render :: State -> H.ComponentHTML Query
  render state =
      case state.session of
        Just session -> HH.text "Logout"
        Nothing -> case state.sessionCreationMode of
          Register -> registerForm
          Login    -> loginForm
      where

        loginForm :: H.ComponentHTML Query
        loginForm =
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
                  , keyBox ReadWrite state.preparedRing
                  , HH.button
                    [ HP.classes [button, primary, block]
                    , HE.onClick (HE.input_ ToggleRegister)
                    ]
                    [ HH.text $ t $ Term.Session Sessions.RegisterInstead
                    ]
                  ]
                ]
              ]



        registerForm :: H.ComponentHTML Query
        registerForm =
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
                  , keyBox ReadOnly state.preparedRing
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

  keyBox :: forall p. EditLevel -> Maybe Keyring -> HH.HTML p (Query Unit)
  keyBox editLevel keyring =
    case editLevel of
          ReadOnly ->
            HH.textarea $
            [ HP.readOnly true
            , HP.value $ fromMaybe "" $ (keyring <#> show)
            , HP.classes [textarea]
            , HP.placeholder "Your secret keys."
            ]
          ReadWrite ->
            HH.textarea $
            [ HE.onValueChange (HE.input UpdateKey)
            , HP.classes [textarea]
            , HP.placeholder "Your secret keys."
            ]

  eval :: Query ~> H.ComponentDSL State Query Message Aff
  eval (Init session next) = do
    H.modify_ (_{ session = session })
    pure next
  eval (ToggleRegister next) = do
    state <- H.get
    nextState <- case state.sessionCreationMode of
          Login -> do
            keyring <- H.liftEffect $ generateKeyring
            pure $ state { sessionCreationMode = Register
                         , preparedRing = Just keyring
                         }
          Register -> pure $ state { sessionCreationMode = Login
                                   , preparedRing = Nothing
                                   }
    H.put nextState
    pure next
  eval (CopyKey mkey next) = do
    result <- H.liftEffect $ fromMaybe (pure unit) (mkey <#> (show >>> EC.copyToClipboard))
    pure next
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


receive :: Input -> Maybe (Query Unit)
receive (ExistingSession session) = Just $ Init session unit
