module Components.Sessions where

import Prelude

import AppRouting.Routes as R
import Components.Sessions.Login as Login
import Components.Sessions.Register as Register
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Model (Session)

data Query a
  = UpdateRoute R.Sessions a
  | ReceivedSession Session a

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
  = RouteContext R.Sessions

type State =
  { session :: Maybe Session
  , routeContext :: R.Sessions
  }

pathToLogin :: ChildPath Login.Query ChildQuery Login.Slot ChildSlot
pathToLogin = cpL

pathToRegister :: ChildPath Register.Query ChildQuery Register.Slot ChildSlot
pathToRegister = cpR :> cpL

initialState :: Input -> State
initialState (RouteContext landing) =
                 { session: Nothing
                 , routeContext: landing
                 }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

component :: LocaliseFn -> H.Component HH.HTML Query Input Message Aff
component t =
  H.parentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot Aff
      render s = case s.session of
        Nothing -> renderUnAuthed s
        Just session -> HH.text "Authenticated!"
      
      renderUnAuthed :: State -> H.ParentHTML Query ChildQuery ChildSlot Aff
      renderUnAuthed s = case s.routeContext of
        R.Login ->
          HH.slot'
            pathToLogin
            Login.Slot
            (Login.component t)
            unit
            mapLoginMessage
        R.Register ->
          HH.slot'
            pathToRegister
            Register.Slot
            (Register.component t)
            unit
            mapRegisterMessage
      
      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message Aff
      eval (UpdateRoute route next) = do
        H.modify_ (_{ routeContext = route })
        pure next
      eval (ReceivedSession s next) = do
        H.modify_ (_{ session = Just s })
        H.raise $ SessionCreated s
        pure next

      receive :: Input -> Maybe (Query Unit)
      receive (RouteContext route) = Just $ UpdateRoute route unit

mapRegisterMessage :: Register.Message -> Maybe (Query Unit)
mapRegisterMessage (Register.SessionCreated s) = Just (ReceivedSession s unit)

mapLoginMessage :: Login.Message -> Maybe (Query Unit)
mapLoginMessage (Login.SessionCreated s) = Just (ReceivedSession s unit)