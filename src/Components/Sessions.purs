module Components.Sessions where

import Prelude

import Components.Sessions.Login as Login
import Components.Sessions.Register as Register
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (reverseRoute)
import Data.Routing.Routes as R
import Data.Routing.Routes.Sessions as RS
import Effect.Aff.Class (class MonadAff)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.Sessions (Sessions(..))
import Model (Session)
import Routing.Hash (setHash)

data Query a
  = UpdateRoute RS.Sessions a
  | ReceivedSession Session a
  | Initialise a

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
  :: forall m
  . MonadAff m
  => LocaliseFn
  -> H.Component HH.HTML Query Input Message m
component t =
  H.lifecycleParentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    , initializer: Just (Initialise unit)
    , finalizer: Nothing
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
        RS.Logout -> HH.text $ t $ Term.Session Logout
      
      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message m
      eval (UpdateRoute route next) = do
        mapRouteOrLogout route
        pure next
      eval (ReceivedSession s next) = do
        H.modify_ (_{ session = Just s })
        H.raise $ SessionCreated s
        pure next
      eval (Initialise next) = do
        currentRoute <- H.gets _.routeContext
        mapRouteOrLogout currentRoute
        pure next


      mapRouteOrLogout :: RS.Sessions -> H.ParentDSL State Query ChildQuery ChildSlot Message m Unit
      mapRouteOrLogout route =
        case route of
          RS.Logout -> do
            H.raise $ SessionErased
            liftEffect $ setHash $ reverseRoute $ R.Intro
          r -> do
            H.modify_ (_{ routeContext = route })
      
      

      receive :: Input -> Maybe (Query Unit)
      receive (RouteContext route) = Just $ UpdateRoute route unit

mapRegisterMessage :: Register.Message -> Maybe (Query Unit)
mapRegisterMessage (Register.SessionCreated s) = Just (ReceivedSession s unit)

mapLoginMessage :: Login.Message -> Maybe (Query Unit)
mapLoginMessage (Login.SessionCreated s) = Just (ReceivedSession s unit)