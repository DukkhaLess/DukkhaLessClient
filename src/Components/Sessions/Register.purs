module Components.Sessions.Register where

import Prelude

import AppRouting.Routes as R
import Components.Helpers.Forms as HF
import Control.Monad.Error.Class (throwError)
import Crypt.NaCl.Types (BoxKeyPair(..))
import Data.Either (Either, either, note)
import Data.HTTP.Helpers (ApiPath(..), post, request)
import Data.HTTP.Payloads (SubmitRegister)
import Data.Maybe (Maybe(..), fromMaybe, fromJust)
import Data.Newtype (wrap, unwrap)
import Data.Tuple (Tuple(..))
import Data.Validation as V
import Data.Validation.Rules as VR
import Effect.Aff (Aff)
import Effect.Clipboard as EC
import Effect.Exception (error, Error)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions as Sessions
import Intl.Terms.Validation as TV
import Model (Password, SessionToken(..), Username(..), KeyringUsage(Enabled), Session)
import Model.Keyring (Keyring, generateKeyring)
import Partial.Unsafe (unsafePartial)
import Style.Bulogen (block, button, container, hero, heroBody, input, link, primary, pullRight, spaced, subtitle, textarea, title, textCentered)

data Query a
  = GenerateKeyring a
  | UpdateUsername String a
  | UpdatePassword String a
  | UpdatePasswordConfirmation String a
  | AttemptSubmit a
  | CopyKey (Maybe Keyring) a

data Message
  = SessionCreated Session

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
                , HE.onClick (HE.input_ AttemptSubmit)
                ]
                [ HH.text $ t $ Term.Session Sessions.Submit
                ]
              , HH.a
                [ HP.classes [block, textCentered]
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
  eval (AttemptSubmit next) = do
    state <- H.get
    payload <- H.liftAff $ either throwError pure (preparePayload state)
    response <- H.liftAff $ request (post (ApiPath "/register") payload)
    let keyringUsage = Enabled $ unsafePartial $ fromJust state.preparedRing
    let username = Username $ V.inputValue state.username
    sessionToken <- H.liftAff $ either (throwError <<< error) pure (response.body <#> SessionToken)
    let session =
          wrap
          { username
          , keyringUsage
          , sessionToken
          }
    H.raise (SessionCreated session)
    pure next
 
preparePayload :: State -> Either Error SubmitRegister
preparePayload state = note (error "Form results invalid for submission") do
  username <- V.validate_ state.username
  password <- V.validate_ state.password
  passwordConfirmation <- V.validate_ state.passwordConfirmation
  keyring <- map unwrap state.preparedRing
  let publicKey = case keyring.boxKeyPair of BoxKeyPair r -> r.publicKey
  pure $ wrap
    { username
    , password
    , passwordConfirmation
    , publicKey
    }