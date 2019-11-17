module Components.Sessions.Login where

import Prelude
import Components.Helpers.Forms as HF
import Control.Monad.Error.Class (throwError)
import Control.Monad.State (class MonadState, get, put, modify_)
import Data.Const (Const(..))
import Data.Either (Either(..), note, either)
import Data.HTTP.Helpers (ApiPath(..), plaintextPost, request)
import Data.HTTP.Payloads (SubmitLogin(SubmitLogin))
import Data.List.Lazy (Step(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.Routing.Routes as R
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..), fst, snd)
import Data.Validation as V
import Data.Validation.Rules as VR
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Exception (error, Error)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Model (KeyringUsage(Enabled), Password, Session, Username)
import Model.Keyring (Keyring)
import Style.Bulogen (block, button, container, hero, heroBody, input, primary, subtitle, textCentered, textarea, title, success)
import Web.File.FileList (FileList)
import Web.HTML.Event.DataTransfer (files)
import Web.HTML.Event.DataTransfer as HA
import Web.HTML.Event.DragEvent (dataTransfer)

data Action
  = UpdateKey String
  | UpdateUsername String
  | UpdatePassword String
  | DropFiles (Maybe FileList)
  | Submit

data Message
  = SessionCreated Session

type State
  = { username :: Username
    , password :: Password
    , keyring :: V.Validation String Keyring
    }

initialState :: forall a. a -> State
initialState =
  const
    { username: (wrap "")
    , password: (wrap "")
    , keyring: V.validation (VR.parsableKeyring) ""
    }

component ::
  forall m.
  MonadAff m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) Void Message m
component t =
  H.mkComponent
    { initialState: initialState
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction = handleAction H.raise
            }
    }
  where
  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.section [ HP.classes [ hero ] ]
      [ HH.div [ HP.classes [ heroBody ] ]
          [ HH.div [ HP.classes [ container ] ]
              [ HH.h1 [ HP.classes [ title ] ] [ HH.text $ t $ Term.Session Sessions.Login ]
              , HH.input
                  [ HP.classes [ input ]
                  , HP.placeholder $ t $ Term.Session Sessions.Username
                  , HE.onValueChange (Just <<< UpdateUsername)
                  ]
              , HH.input
                  [ HP.type_ HP.InputPassword
                  , HP.classes [ input ]
                  , HP.placeholder $ t (Term.Session Sessions.Password)
                  , HE.onValueChange (Just <<< UpdatePassword)
                  ]
              , HF.validated' state.keyring t
                  $ HH.textarea
                      [ HE.onValueChange (Just <<< UpdateKey)
                      , HP.classes [ textarea ]
                      , HP.placeholder "Your secret keys."
                      , HE.onDrop (dataTransfer >>> files >>> DropFiles >>> Just)
                      ]
              , HH.a
                  [ HP.classes [ button, success, block ]
                  , HE.onClick (const $ Just Submit)
                  ]
                  [ HH.text $ t $ Term.Session Sessions.Submit
                  ]
              , HH.a
                  [ HP.classes [ block, textCentered ]
                  , HP.href $ R.reverseRoute $ R.Sessions RS.Register
                  ]
                  [ HH.text $ t $ Term.Session Sessions.RegisterInstead
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

  handleAction ::
    forall t.
    MonadState State t =>
    MonadAff t =>
    (Message -> t Unit) ->
    Action -> t Unit
  handleAction raise action = case action of
    (UpdateUsername username) -> do
      state <- get
      put state { username = wrap username }
    (UpdatePassword password) -> do
      state <- get
      put state { password = wrap password }
    (UpdateKey keyStr) -> do
      state <- get
      let
        keyringValidation = V.updateValidation state.keyring keyStr
      put state { keyring = keyringValidation }
    Submit -> do
      state <- get
      modify_ (_ { keyring = V.touch state.keyring })
      payloadAndKeyring <- liftAff $ either throwError pure (prepareLoginPayload state)
      let
        payload = fst payloadAndKeyring
      let
        keyring = snd payloadAndKeyring
      response <- liftAff $ request (plaintextPost (ApiPath "/login") payload)
      case response.body of
        Right token -> do
          raise $ SessionCreated $ wrap { username: state.username, keyringUsage: Enabled keyring, sessionToken: token }
        Left _ -> pure unit
    (DropFiles files) -> pure unit

  prepareLoginPayload :: State -> Either Error (Tuple SubmitLogin Keyring)
  prepareLoginPayload state = note (error "Validation failed for login payload") result
    where
    keyring :: Maybe Keyring
    keyring = V.validate_ state.keyring

    payload :: SubmitLogin
    payload = SubmitLogin { username: state.username, password: state.password }

    result = map (Tuple payload) keyring
