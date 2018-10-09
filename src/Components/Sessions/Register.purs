module Components.Sessions.Register where

import Prelude

import AppRouting.Routes as R
import Components.Helpers.Forms as HF
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (class Newtype, wrap)
import Data.Tuple (Tuple(..))
import Data.Validation as V
import Data.Validation.Rules as VR
import Effect.Aff (Aff)
import Effect.Clipboard as EC
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Intl.Terms.Validation as TV
import Model (Session, Username(..))
import Model.Keyring (Keyring, generateKeyring)
import Style.Bulogen (block, button, container, hero, heroBody, input, link, offsetThreeQuarters, primary, pullRight, spaced, subtitle, textarea, title)

data Query a
  = GenerateKeyring a
  | UpdateUsername String a
  | UpdatePassword String a
  | UpdatePasswordConfirmation String a
  | CopyKey (Maybe Keyring) a

data Message
  = SessionCreated Session

newtype Password = Password String
derive instance newtypePassword :: Newtype Password _
derive instance eqPassword :: Eq Password

type State =
  { session :: Maybe Session
  , preparedRing :: Maybe Keyring
  , username :: V.Validation String Username
  , password :: V.Validation String Password
  , passwordConfirmation :: V.Validation (Tuple String String) Password
  }

initialState :: forall a. a -> State
initialState = const
                 { session: Nothing
                 , preparedRing: Nothing
                 , username: V.validation (VR.minimumLength 8 <#> wrap) ""
                 , password: V.validation (VR.minimumLength 10 <#> wrap) ""
                 , passwordConfirmation: V.validation (VR.matchingField TV.Password <#> wrap) (Tuple "" "")
                 }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: forall a. LocaliseFn -> H.Component HH.HTML Query a Message Aff
component t =
  H.lifecycleComponent
    { initialState
    , render
    , eval
    , receiver: const Nothing
    , initializer: Just $ GenerateKeyring unit
    , finalizer: Nothing
    }
  where

  render :: State -> H.ComponentHTML Query
  render state =
    HH.section [HP.classes [hero]]
          [ HH.div [HP.classes [heroBody]]
            [ HH.div [HP.classes [container]]
              [ HH.h1 [ HP.classes [title]] [ HH.text $ t $ Term.Session Sessions.Register ]
              , HF.validated' state.username t (HH.input
                [ HP.classes [input]
                , HP.placeholder $ t $ Term.Session Sessions.Username
                , HE.onValueChange (HE.input UpdateUsername)
                ])
              , HF.validated' state.password t (HH.input
                [ HP.type_ HP.InputPassword
                , HP.classes [input]
                , HP.placeholder $ t (Term.Session Sessions.Password)
                , HE.onValueChange (HE.input UpdatePassword)
                ])
              , HF.validated' state.passwordConfirmation t (HH.input
                [ HP.type_ HP.InputPassword
                , HP.classes [input]
                , HP.placeholder $ t (Term.Session Sessions.ConfirmPassword)
                , HE.onValueChange (HE.input UpdatePasswordConfirmation)
                ])
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
              , HH.a
                [ HP.classes [button, primary, block]
                , HP.href $ R.reverseRoute $ R.Sessions R.Login
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
  eval (GenerateKeyring next) = do
    state <- H.get
    H.liftEffect $ log "Wat"
    nextState <- do
            keyring <- H.liftEffect $ generateKeyring
            pure $ state { preparedRing = Just keyring
                         }
    H.put nextState
    pure next
  eval (CopyKey mkey next) = do
    result <- H.liftEffect $ fromMaybe (pure unit) (mkey <#> (show >>> EC.copyToClipboard))
    pure next
  eval (UpdateUsername username next) = do
    state <- H.get
    let usernameValidation = V.updateValidation state.username username
    H.put state { username = usernameValidation }
    pure next
  eval (UpdatePassword pass next) = do
    state <- H.get
    let passwordValidation = V.updateValidation state.password pass
    H.put state { password = passwordValidation }
    pure next
  eval (UpdatePasswordConfirmation pass next) = do
    state <- H.get
    let firstPass = V.inputValue $ state.password
    let passwordConfValidation = V.updateValidation state.passwordConfirmation (Tuple firstPass pass)
    H.put state { passwordConfirmation = passwordConfValidation }
    pure next
 