module Components.Sessions.Register where

import Prelude

import AppRouting.Routes as R
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Either (Either(..), hush)
import Data.Newtype (class Newtype, unwrap)
import Data.Tuple (Tuple(..))
import Data.Validation
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
  , username :: Validation String Username
  , password :: Validation String Password
  , passwordConfirmation :: Validation (Tuple (Maybe String) String) Password
  }

validateUsername :: String -> Either String Username
validateUsername un = Left "Hi"

validatePassword :: String -> Either String Password
validatePassword p = Left "Hi"

validatePasswordConfirmation :: Tuple (Maybe String) String -> Either String Password
validatePasswordConfirmation p = Left "Hi"

initialState :: forall a. a -> State
initialState = const
                 { session: Nothing
                 , preparedRing: Nothing
                 , username: validation (validator validateUsername) ""
                 , password: validation (validator validatePassword) ""
                 , passwordConfirmation:validation (validator validatePasswordConfirmation) (Tuple Nothing "")
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
              , HH.input
                [ HP.classes [input]
                , HP.placeholder $ t $ Term.Session Sessions.Username
                , HE.onValueChange (HE.input UpdateUsername)
                ]
              , HH.input
                [ HP.type_ HP.InputPassword
                , HP.classes [input]
                , HP.placeholder $ t (Term.Session Sessions.Password)
                , HE.onValueChange (HE.input UpdatePassword)
                ]
              , HH.input
                [ HP.type_ HP.InputPassword
                , HP.classes [input]
                , HP.placeholder $ t (Term.Session Sessions.ConfirmPassword)
                , HE.onValueChange (HE.input UpdatePasswordConfirmation)
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
    let usernameValidation = updateValidation state.username username
    H.put state { username = usernameValidation }
    pure next
  eval (UpdatePassword pass next) = do
    state <- H.get
    let passwordValidation = updateValidation state.password pass
    H.put state { password = passwordValidation }
    pure next
  eval (UpdatePasswordConfirmation pass next) = do
    state <- H.get
    let passState = hush $ validate state.password
    let firstPass = map unwrap passState
    let passwordConfValidation = updateValidation state.passwordConfirmation (Tuple firstPass pass)
    H.put state { passwordConfirmation = passwordConfValidation }
    pure next
 



