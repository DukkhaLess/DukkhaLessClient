module Components.Sessions.Login where

import Prelude

import AppRouting.Routes as R
import AppRouting.Routes.Sessions as RS
import Components.Helpers.Forms as HF
import Control.Monad.Error.Class (throwError)
import Data.Either (Either(..), note, either)
import Data.HTTP.Helpers (ApiPath(..), unsafePostCleartext, request)
import Data.HTTP.Payloads (SubmitLogin(SubmitLogin))
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.Tuple (Tuple(..), fst, snd)
import Data.Validation as V
import Data.Validation.Rules as VR
import Effect.Aff (Aff)
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
import Style.Bulogen (block, button, container, hero, heroBody, input, primary, subtitle, textCentered, textarea, title)

data Query a
  = UpdateKey String a
  | UpdateUsername String a
  | UpdatePassword String a
  | Submit a

data Message
  = SessionCreated Session

type State =
  { username :: Username
  , password :: Password
  , keyring :: V.Validation String Keyring
  }

initialState :: forall a. a -> State
initialState = const
                 { username: (wrap "")
                 , password: (wrap "")
                 , keyring: V.validation (VR.parsableKeyring) ""
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
                    , HE.onValueChange (HE.input UpdateUsername)
                    ]
                  , HH.input
                    [ HP.type_ HP.InputPassword
                    , HP.classes [input]
                    , HP.placeholder $ t (Term.Session Sessions.Password)
                    , HE.onValueChange (HE.input UpdatePassword)
                    ]
                  , HF.validated' state.keyring t $ HH.textarea
                        [ HE.onValueChange (HE.input UpdateKey)
                        , HP.classes [textarea]
                        , HP.placeholder "Your secret keys."
                        ]
                  , HH.a
                    [ HP.classes [button, primary, block]
                    , HE.onClick (HE.input_ Submit)
                    ]
                    [ HH.text $ t $ Term.Session Sessions.Submit
                    ]
                  , HH.a
                    [ HP.classes [block, textCentered]
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
      [ HP.classes [subtitle]
      ]
      [ HH.text $ t $ Term.Session Sessions.KeySubtitle
      ]


  eval :: Query ~> H.ComponentDSL State Query Message Aff
  eval (UpdateUsername username next) = do
    state <- H.get
    H.put state { username = wrap username }
    pure next
  eval (UpdatePassword password next) = do
    state <- H.get
    H.put state { password = wrap password }
    pure next
  eval (UpdateKey keyStr next) = do
    state <- H.get
    let keyringValidation = V.updateValidation state.keyring keyStr
    H.put state { keyring = keyringValidation }
    pure next
  eval (Submit next) = do
    state <- H.get
    H.modify_ (_{ keyring = V.touch state.keyring })
    payloadAndKeyring <- H.liftAff $ either throwError pure (prepareLoginPayload state)
    let payload = fst payloadAndKeyring
    let keyring = snd payloadAndKeyring
    response <- H.liftAff $ request (unsafePostCleartext (ApiPath "/login") payload)
    case response.body of
      Right token -> do
        H.raise $ SessionCreated $ wrap { username: state.username, keyringUsage: Enabled keyring, sessionToken: token }
        pure next
      Left _ -> do
        pure next

  prepareLoginPayload :: State -> Either Error (Tuple SubmitLogin Keyring)
  prepareLoginPayload state = note (error "Validation failed for login payload") result where
    keyring :: Maybe Keyring
    keyring = V.validate_ state.keyring
    payload :: SubmitLogin
    payload = SubmitLogin { username: state.username, password: state.password }
    result = map (Tuple payload) keyring
    