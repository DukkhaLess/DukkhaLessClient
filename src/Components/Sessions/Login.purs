module Components.Sessions.Login where

import Prelude

import AppRouting.Routes as R
import Data.ArrayBuffer.ArrayBuffer (decodeToString)
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), note)
import Data.HTTP.Helpers (ApiPath(..), post, request)
import Data.HTTP.Payloads (SubmitLogin(SubmitLogin))
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.String.Read (read)
import Data.Tuple (Tuple(..))
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
import Model (Session, Username, Password, SessionToken(SessionToken), KeyringUsage(Enabled))
import Model.Keyring (Keyring)
import Style.Bulogen (block, button, container, hero, heroBody, input, link, offsetThreeQuarters, primary, pullRight, spaced, subtitle, textCentered, textarea, title)

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
  , keyring :: Maybe Keyring
  }

initialState :: forall a. a -> State
initialState = const
                 { username: (wrap "")
                 , password: (wrap "")
                 , keyring: Nothing
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
                  , keyBox state.keyring
                  , HH.a
                    [ HP.classes [button, primary, block]
                    , HE.onClick (HE.input_ Submit)
                    ]
                    [ HH.text $ t $ Term.Session Sessions.Submit
                    ]
                  , HH.a
                    [ HP.classes [block, textCentered]
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
    let jsonRaw = Base64 >>> decodeBase64 >>> note "Base64 decoding failed" >=> decodeToString >>> (lmap message) $ keyStr
    nextState <- H.liftEffect $ case read keyStr of
      Left err -> do
        log err
        pure state
      Right keyring -> do
        pure $ state { keyring = Just keyring}
    H.put nextState
    pure next
  eval (Submit next) = do
    state <- H.get
    let payload = SubmitLogin { username: state.username, password: state.password }
    response <- H.liftAff $ request (post (ApiPath "/login") payload)
    case Tuple (response.body <#> SessionToken) (state.keyring) of
      Tuple (Right t) (Just keyring) -> do
        H.raise $ SessionCreated $ wrap { username: state.username, keyringUsage: Enabled keyring, sessionToken: t }
        pure next
      _    -> pure next