module Components.Sessions where

import Prelude

import AppM (CurrentSessionRow')
import Components.Sessions.Login as Login
import Components.Sessions.Register as Register
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (Routes(..), reverseRoute)
import Data.Routing.Routes as R
import Data.Routing.Routes.Sessions as RS
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Effect.Ref as Ref
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions (Sessions(..))
import Model (Session)
import Routing.Hash (setHash)

data Query a
  = UpdateRoute RS.Sessions a
  | ReceivedSession Session a

data Message
  = SessionCreated Session
  | SessionErased

type ChildQuery
  = Login.Query
  <\/> Register.Query
  <\/> Const Void

type ChildSlot
  = Login.Slot
  \/ Register.Slot
  \/ Void

data Input
  = RouteContext RS.Sessions

type State =
  { session :: Maybe Session
  , routeContext :: RS.Sessions
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

component
  :: forall m r
  .  MonadAff m
  => MonadEffect m
  => MonadAsk (CurrentSessionRow' r) m
  => LocaliseFn
  -> H.Component HH.HTML Query Input Message m
component t =
  H.parentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
      render s = case s.session of
        Nothing -> renderUnAuthed s
        Just session -> HH.text "Authenticated!"
      
      renderUnAuthed :: State -> H.ParentHTML Query ChildQuery ChildSlot m
      renderUnAuthed s = case s.routeContext of
        RS.Login ->
          HH.slot'
            pathToLogin
            Login.Slot
            (Login.component t)
            unit
            mapLoginMessage
        RS.Register ->
          HH.slot'
            pathToRegister
            Register.Slot
            (Register.component t)
            unit
            mapRegisterMessage
      
      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message m
      eval (UpdateRoute route next) = do
        H.modify_ (_{ routeContext = route })
        pure next
      eval (ReceivedSession s next) = do
        H.modify_ (_{ session = Just s })
        asks _.currentSession >>= Ref.write (Just s) >>> liftEffect
        H.raise $ SessionCreated s
        liftEffect $ setHash $ reverseRoute $ Intro
        pure next

      receive :: Input -> Maybe (Query Unit)
      receive (RouteContext route) = Just $ UpdateRoute route unit

mapRegisterMessage :: Register.Message -> Maybe (Query Unit)
mapRegisterMessage (Register.SessionCreated s) = Just (ReceivedSession s unit)

mapLoginMessage :: Login.Message -> Maybe (Query Unit)
mapLoginMessage (Login.SessionCreated s) = Just (ReceivedSession s unit)