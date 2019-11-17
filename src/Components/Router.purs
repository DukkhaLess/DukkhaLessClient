module Components.Router where

import AppM (AppState)
import Components.Intro as Intro
import Components.Journals as Journals
import Components.Nav as Nav
import Components.NotFound as NotFound
import Components.Resources as Resources
import Components.Sessions as Sessions
import Components.Util (OpaqueSlot, MessageSlot)
import Control.Monad.Reader.Class (class MonadAsk)
import Control.Monad.State (class MonadState)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Halogen (modify_)
import Halogen as H
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Prelude (type (~>), Unit, Void, const, pure, unit, (<<<), bind, ($), discard, map)

data Query a
  = Goto R.Routes a

type State
  = { localiseFn :: LocaliseFn
    , currentRoute :: R.Routes
    }

nada :: forall a b. a -> Maybe b
nada = const Nothing

type ChildSlots
  = ( sessions :: MessageSlot Sessions.Message Unit
    , notFound :: OpaqueSlot Unit
    , journals :: OpaqueSlot Unit
    , nav :: OpaqueSlot Unit
    )

pathToSessions = SProxy :: SProxy "sessions"

pathToNotFound = SProxy :: SProxy "notFound"

pathToJournals = SProxy :: SProxy "journals"

pathToNav = SProxy :: SProxy "nav"

component ::
  forall m.
  MonadAff m =>
  MonadAsk AppState m =>
  LocaliseFn ->
  H.Component HH.HTML Query Unit Void m
component localiseFn =
  H.mkComponent
    { initialState: const { localiseFn, currentRoute: R.Intro }
    , render
    , eval:
      H.mkEval
        ( H.defaultEval
            { handleQuery = handleQuery
            }
        )
    }
  where
  render :: State -> H.ComponentHTML Unit ChildSlots m
  render state = HH.div_ [ navMenu, viewPage state ]
    where
    navMenu =
      HH.slot
        pathToNav
        unit
        (Nav.component localiseFn)
        state.currentRoute
        nada

  viewPage :: State -> H.ComponentHTML Unit ChildSlots m
  viewPage { currentRoute } = case currentRoute of
    R.Intro -> Intro.render localiseFn
    R.Resources -> Resources.render localiseFn
    (R.Sessions r) ->
      HH.slot
        pathToSessions
        unit
        (Sessions.component localiseFn)
        (Sessions.RouteContext r)
        nada
    R.NotFound ->
      HH.slot
        pathToNotFound
        unit
        (NotFound.component localiseFn)
        unit
        nada
    (R.Journals r) ->
      HH.slot
        pathToJournals
        unit
        (Journals.component localiseFn)
        (Journals.JournalsContext { routeContext: r })
        nada

  handleQuery ::
    forall a.
    Query a -> H.HalogenM State Unit ChildSlots Void m (Maybe a)
  handleQuery query = case query of
    (Goto loc a) -> do
      modify_ (_ { currentRoute = loc })
      pure $ Just a
