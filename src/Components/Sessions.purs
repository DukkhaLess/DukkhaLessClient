module Components.Sessions where

import Prelude
import AppM (CurrentSessionRow')
import Components.Sessions.Login as Login
import Components.Sessions.Register as Register
import Components.Util (MessageSlot)
import Control.Monad.Reader (class MonadAsk, asks)
import Control.Monad.State (class MonadState, modify_)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (Routes(..), reverseRoute)
import Data.Routing.Routes as R
import Data.Routing.Routes.Sessions as RS
import Data.Symbol (SProxy(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Halogen as H
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions (Sessions(..))
import Model (Session)
import Routing.Hash (setHash)
import Web.HTML.Event.EventTypes (offline)

data Action
  = UpdateRoute RS.Sessions
  | ReceivedSession Session

data Message
  = SessionCreated Session
  | SessionErased

data Input
  = RouteContext RS.Sessions

type State
  = { session :: Maybe Session
    , routeContext :: RS.Sessions
    }

type ChildSlots
  = ( login :: MessageSlot Login.Message Unit
    , register :: MessageSlot Register.Message Unit
    )

pathToLogin = SProxy :: SProxy "login"

pathToRegister = SProxy :: SProxy "register"

initialState :: Input -> State
initialState (RouteContext landing) =
  { session: Nothing
  , routeContext: landing
  }

component ::
  forall m r.
  MonadAff m =>
  MonadEffect m =>
  MonadAsk (CurrentSessionRow' r) m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) Input Message m
component t =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ (H.defaultEval { handleAction = handleAction H.raise })
    }
  where
  render :: State -> H.ComponentHTML Action ChildSlots m
  render s = case s.session of
    Nothing -> renderUnAuthed s
    Just session -> HH.text "Authenticated!"

  renderUnAuthed :: State -> H.ComponentHTML Action ChildSlots m
  renderUnAuthed s = case s.routeContext of
    RS.Login ->
      HH.slot
        pathToLogin
        unit
        (Login.component t)
        unit
        mapLoginMessage
    RS.Register ->
      HH.slot
        pathToRegister
        unit
        (Register.component t)
        unit
        mapRegisterMessage

receive :: Input -> Maybe Action
receive input = case input of
  (RouteContext route) -> Just $ UpdateRoute route

mapRegisterMessage :: Register.Message -> Maybe Action
mapRegisterMessage (Register.SessionCreated s) = Just (ReceivedSession s)

mapLoginMessage :: Login.Message -> Maybe Action
mapLoginMessage (Login.SessionCreated s) = Just (ReceivedSession s)

handleAction ::
  forall t r.
  MonadState State t =>
  MonadAsk (CurrentSessionRow' r) t =>
  MonadEffect t =>
  (Message -> t Unit) ->
  Action -> t Unit
handleAction raise action = case action of
  (UpdateRoute route) -> do
    modify_ (_ { routeContext = route })
  (ReceivedSession s) -> do
    modify_ (_ { session = Just s })
    asks _.currentSession >>= Ref.write (Just s) >>> liftEffect
    raise (SessionCreated s)
    liftEffect $ setHash $ reverseRoute $ Intro
