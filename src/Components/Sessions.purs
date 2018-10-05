module Components.Sessions where

import Prelude

import AppRouting.Routes as R
import Components.Sessions.Login as Login
import Components.Sessions.Register as Register
import Data.ArrayBuffer.ArrayBuffer (decodeToString)
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Const (Const)
import Data.Either (Either(..), note)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.Read (read)
import Effect.Aff (Aff)
import Effect.Clipboard as EC
import Effect.Console (log)
import Effect.Exception (message)
import Flags (EditLevel(..))
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
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
  = NoOp a

data Message
  = SessionCreated Session

type ChildQuery
  = Login.Query
  <\/> Register.Query
  <\/> Const Void

type ChildSlot
  = Login.Slot
  \/ Register.Slot
  \/ Void

data Input
  = ExistingSession (Maybe Session)

type State =
  { session :: Maybe Session
  , preparedRing :: Maybe Keyring
  }

pathToLogin :: ChildPath Login.Query ChildQuery Login.Slot ChildSlot
pathToLogin = cpL

pathToRegister :: ChildPath Register.Query ChildQuery Register.Slot ChildSlot
pathToRegister = cpR :> cpL

initialState :: forall a. a -> State
initialState = const
                 { session: Nothing
                 , preparedRing: Nothing
                 }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: LocaliseFn -> R.Sessions -> H.Component HH.HTML Query Input Message Aff
component t sessionContext =
  H.parentComponent
    { initialState: initialState
    , render
    , eval
    , receiver: receive
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot Aff
      render s =
        HH.div_[]

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message Aff
      eval (NoOp next) = pure next

      receive :: Input -> Maybe (Query Unit)
      receive _ = Just $ NoOp unit
