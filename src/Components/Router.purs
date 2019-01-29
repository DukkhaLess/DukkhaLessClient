module Components.Router where


import AppM (AppState)
import Components.Intro as Intro
import Components.Journals as Journals
import Components.Nav as Nav
import Components.NotFound as NotFound
import Components.Resources as Resources
import Components.Sessions (Message(..))
import Components.Sessions as Sessions
import Control.Monad.Reader.Class (class MonadAsk)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Model (Model, Session)
import Prelude (type (~>), Unit, Void, const, pure, unit, (<<<), bind, ($), discard, map)
import Routing.Hash (matches)

data Query a
  = Goto R.Routes a
  | UpdateSession (Maybe Session) a

type ChildQuery
  =    Sessions.Query
  <\/> NotFound.Query
  <\/> Journals.Query
  <\/> Nav.Query
  <\/> Const Void

type ChildSlot
  =  Sessions.Slot
  \/ NotFound.Slot
  \/ Journals.Slot
  \/ Nav.Slot
  \/ Void

type State =
  { localiseFn :: LocaliseFn
  , currentRoute :: R.Routes
  , session :: Maybe Session
  }


nada  :: forall a b. a -> Maybe b
nada = const Nothing

pathToSessions :: ChildPath Sessions.Query ChildQuery Sessions.Slot ChildSlot
pathToSessions = cpL

pathToNotFound :: ChildPath NotFound.Query ChildQuery NotFound.Slot ChildSlot
pathToNotFound = cpR :> cpL

pathToJournals :: ChildPath Journals.Query ChildQuery Journals.Slot ChildSlot
pathToJournals = cpR :> cpR :> cpL

pathToNav :: ChildPath Nav.Query ChildQuery Nav.Slot ChildSlot
pathToNav = cpR :> cpR :> cpR :> cpL

component
  :: forall m
  . MonadAff m
  => MonadAsk AppState m
  => LocaliseFn
  -> H.Component HH.HTML Query Unit Void m
component localiseFn = H.parentComponent
  { initialState: const { localiseFn, session: Nothing, currentRoute: R.Intro }
  , render
  , eval
  , receiver: const Nothing
  }
  where
    render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
    render state = HH.div_ [navMenu, viewPage state] where
      navMenu =
        HH.slot'
          pathToNav
          Nav.Slot
          (Nav.component localiseFn)
          state.session
          nada

    viewPage :: State -> H.ParentHTML Query ChildQuery ChildSlot m
    viewPage { currentRoute } = case currentRoute of
      R.Intro -> Intro.render localiseFn
      R.Resources ->Resources.render localiseFn
      (R.Sessions r) ->
        HH.slot'
          pathToSessions
          Sessions.Slot
          (Sessions.component localiseFn)
          (Sessions.RouteContext r)
          mapSessionMessage
      R.NotFound ->
        HH.slot'
          pathToNotFound
          NotFound.Slot
          (NotFound.component localiseFn)
          unit
          nada
      (R.Journals r) ->
        HH.slot'
          pathToJournals
          Journals.Slot
          (Journals.component localiseFn)
          (Journals.JournalsContext { routeContext: r })
          nada

    eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Void m
    eval (Goto loc next) = do
      H.modify_ (_{ currentRoute = loc})
      pure next
    eval (UpdateSession sess next) = do
      H.modify_ (_{ session = sess })
      pure next

routeSignal :: H.HalogenIO Query Void Aff -> Effect (Effect Unit)
routeSignal driver = matches R.routes hashChanged
  where
    hashChanged _ newRoute = do
      _ <- launchAff $ driver.query <<< H.action <<< Goto $ newRoute
      pure unit

mapSessionMessage :: Sessions.Message -> Maybe (Query Unit)
mapSessionMessage message = case message of 
  Sessions.SessionCreated session -> Just (UpdateSession (Just session) unit)
  SessionErased -> Just $ UpdateSession Nothing unit
