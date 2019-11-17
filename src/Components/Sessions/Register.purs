module Components.Sessions.Register where

import Prelude
import Components.Helpers.Forms as HF
import Control.Monad.Error.Class (throwError)
import Control.Monad.State (class MonadState)
import Crypt.NaCl.Types (BoxKeyPair(..))
import Data.Argonaut (encodeJson, stringify)
import Data.Const (Const(..))
import Data.Either (Either, either, note)
import Data.HTTP.Helpers (ApiPath(..), plaintextPost, request)
import Data.HTTP.Payloads (SubmitRegister)
import Data.Maybe (Maybe(..), fromMaybe, fromJust)
import Data.Newtype (wrap, unwrap)
import Data.Routing.Routes as R
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..))
import Data.Validation as V
import Data.Validation.Rules as VR
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect)
import Effect.Clipboard as EC
import Effect.Exception (error, Error)
import Halogen (get, liftEffect, modify_, put)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Intl.Terms.Validation as TV
import Model (KeyringUsage(Enabled), Password, Session, Username(..))
import Model.Keyring (Keyring, generateKeyring)
import Partial.Unsafe (unsafePartial)
import Style.Bulogen (block, button, container, hero, heroBody, input, link, primary, pullRight, spaced, subtitle, textarea, title, textCentered, success)
import Web.HTML.Event.EventTypes (offline)

data Action
  = GenerateKeyring
  | UpdateUsername String
  | UpdatePassword String
  | UpdatePasswordConfirmation String
  | AttemptSubmit
  | CopyKey (Maybe Keyring)

data Message
  = SessionCreated Session

type State
  = { session :: Maybe Session
    , preparedRing :: Maybe Keyring
    , username :: V.Validation String Username
    , password :: V.Validation String Password
    , passwordConfirmation :: V.Validation (Tuple String String) Password
    }

initialState :: forall a. a -> State
initialState =
  const
    { session: Nothing
    , preparedRing: Nothing
    , username: V.validation (VR.minimumLength 8 <#> wrap) ""
    , password: V.validation (VR.minimumLength 10 <#> wrap) ""
    , passwordConfirmation: V.validation (VR.matchingField TV.Password <#> wrap) (Tuple "" "")
    }

component ::
  forall a m.
  MonadAff m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) a Message m
component t =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ ( H.defaultEval
              { handleAction = handleAction H.raise
              , initialize = Just GenerateKeyring
              }
          )
    }
  where
  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.section [ HP.classes [ hero ] ]
      [ HH.div [ HP.classes [ heroBody ] ]
          [ HH.div [ HP.classes [ container ] ]
              [ HH.h1 [ HP.classes [ title ] ] [ HH.text $ t $ Term.Session Sessions.Register ]
              , HF.validated' state.username t
                  ( HH.input
                      [ HP.classes [ input ]
                      , HP.placeholder $ t $ Term.Session Sessions.Username
                      , HE.onValueChange (UpdateUsername >>> Just)
                      ]
                  )
              , HF.validated' state.password t
                  ( HH.input
                      [ HP.type_ HP.InputPassword
                      , HP.classes [ input ]
                      , HP.placeholder $ t (Term.Session Sessions.Password)
                      , HE.onValueChange (UpdatePassword >>> Just)
                      ]
                  )
              , HF.validated' state.passwordConfirmation t
                  ( HH.input
                      [ HP.type_ HP.InputPassword
                      , HP.classes [ input ]
                      , HP.placeholder $ t (Term.Session Sessions.ConfirmPassword)
                      , HE.onValueChange (UpdatePasswordConfirmation >>> Just)
                      ]
                  )
              , secretKeyHeader
              , HH.text $ t $ Term.Session Sessions.KeyRingInstructions
              , HH.a
                  [ HP.classes [ link, pullRight, spaced ]
                  , HE.onClick (const $ Just $ CopyKey state.preparedRing)
                  ]
                  [ HH.text $ t $ Term.Session Sessions.CopyKey
                  ]
              , HH.a
                  [ HP.classes [ link, pullRight ]
                  , HP.prop (H.PropName "download") "keyring"
                  , HP.href ("data:text/plain;charset=utf-8," <> (fromMaybe "" $ state.preparedRing <#> encodeJson <#> stringify))
                  ]
                  [ HH.text $ t $ Term.Session Sessions.DownloadKey
                  ]
              , keyBox state.preparedRing
              , HH.a
                  [ HP.classes [ button, success, block ]
                  , HE.onClick (const $ Just AttemptSubmit)
                  ]
                  [ HH.text $ t $ Term.Session Sessions.Submit
                  ]
              , HH.a
                  [ HP.classes [ block, textCentered ]
                  , HP.href $ R.reverseRoute $ R.Sessions RS.Login
                  ]
                  [ HH.text $ t $ Term.Session Sessions.LoginInstead
                  ]
              ]
          ]
      ]

  secretKeyHeader :: forall p i. HH.HTML p i
  secretKeyHeader =
    HH.h4
      [ HP.classes [ subtitle ]
      ]
      [ HH.text $ t $ Term.Session Sessions.KeySubtitle
      ]

  keyBox :: forall w i. Maybe Keyring -> HH.HTML w i
  keyBox keyring =
    HH.textarea
      $ [ HP.readOnly true
        , HP.value $ fromMaybe "" $ (keyring <#> encodeJson <#> stringify)
        , HP.classes [ textarea ]
        , HP.placeholder "Your secret keys."
        ]

handleAction ::
  forall t.
  MonadState State t =>
  MonadEffect t =>
  MonadAff t =>
  (Message -> t Unit) ->
  Action -> t Unit
handleAction raise action = case action of
  GenerateKeyring -> do
    state <- get
    nextState <- do
      keyring <- liftEffect $ generateKeyring
      pure
        $ state
            { preparedRing = Just keyring
            }
    put nextState
  (CopyKey mkey) -> do
    liftEffect $ fromMaybe (pure unit) (mkey <#> (encodeJson >>> stringify >>> EC.copyToClipboard))
  (UpdateUsername username) -> do
    state <- get
    let
      usernameValidation = V.updateValidation state.username username
    put state { username = usernameValidation }
  (UpdatePassword pass) -> do
    state <- get
    let
      passwordValidation = V.updateValidation state.password pass
    put state { password = passwordValidation }
  (UpdatePasswordConfirmation pass) -> do
    state <- get
    let
      firstPass = V.inputValue $ state.password
    let
      passwordConfValidation = V.updateValidation state.passwordConfirmation (Tuple firstPass pass)
    put state { passwordConfirmation = passwordConfValidation }
  AttemptSubmit -> do
    state <- get
    modify_
      ( _
          { username = V.touch state.username
          , password = V.touch state.password
          , passwordConfirmation = V.touch state.passwordConfirmation
          }
      )
    payload <- H.liftAff $ either throwError pure (preparePayload state)
    response <- H.liftAff $ request (plaintextPost (ApiPath "/register") payload)
    let
      keyringUsage = Enabled $ unsafePartial $ fromJust state.preparedRing
    let
      username = Username $ V.inputValue state.username
    sessionToken <- liftAff $ either (throwError <<< error) pure response.body
    let
      session =
        wrap
          { username
          , keyringUsage
          , sessionToken
          }
    raise (SessionCreated session)

preparePayload :: State -> Either Error SubmitRegister
preparePayload state =
  note (error "Form results invalid for submission") do
    username <- V.validate_ state.username
    password <- V.validate_ state.password
    passwordConfirmation <- V.validate_ state.passwordConfirmation
    keyring <- map unwrap state.preparedRing
    let
      publicKey = case keyring.boxKeyPair of BoxKeyPair r -> r.publicKey
    pure
      $ wrap
          { username
          , password
          , passwordConfirmation
          , publicKey
          }
