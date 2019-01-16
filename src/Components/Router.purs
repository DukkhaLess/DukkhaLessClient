module Components.Router where


import Components.Intro as Intro
import Components.Journals as Journals
import Components.NotFound as NotFound
import Components.Resources as Resources
import Components.Sessions as Sessions
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Model (Model, Session)
import Prelude (type (~>), Unit, Void, const, pure, unit, (<<<), bind, ($), discard, map)
import Routing.Hash (matches)

data Query a
  = Goto R.Routes a
  | UpdateSession Session a

type ChildQuery
  = Intro.Query
  <\/> Resources.Query
  <\/> Sessions.Query
  <\/> NotFound.Query
  <\/> Journals.Query
  <\/> Const Void

type ChildSlot
  = Intro.Slot
  \/ Resources.Slot
  \/ Sessions.Slot
  \/ NotFound.Slot
  \/ Journals.Slot
  \/ Void

type State =
  { localiseFn :: LocaliseFn
  , currentRoute :: R.Routes
  , session :: Maybe Session
  }


nada  :: forall a b. a -> Maybe b
nada = const Nothing

pathToIntro :: ChildPath Intro.Query ChildQuery Intro.Slot ChildSlot
pathToIntro = cpL

pathToResources :: ChildPath Resources.Query ChildQuery Resources.Slot ChildSlot
pathToResources = cpR :> cpL

pathToSessions :: ChildPath Sessions.Query ChildQuery Sessions.Slot ChildSlot
pathToSessions = cpR :> cpR :> cpL

pathToNotFound :: ChildPath NotFound.Query ChildQuery NotFound.Slot ChildSlot
pathToNotFound = cpR :> cpR :> cpR :> cpL

pathToJournals :: ChildPath Journals.Query ChildQuery Journals.Slot ChildSlot
pathToJournals =  cpR :> cpR :> cpR :> cpR :> cpL

component
  :: forall m
  . MonadAff m
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
      navMenu = case state.session of
        Just session -> sessionedMenu session
        Nothing      -> sessionlessMenu


    sessionlessMenu :: H.ParentHTML Query ChildQuery ChildSlot m
    sessionlessMenu =
      HH.nav_
        [ HH.ul_ (map link [R.Intro, R.Resources, R.Sessions RS.Login])
        ]

    sessionedMenu :: Session -> H.ParentHTML Query ChildQuery ChildSlot m
    sessionedMenu session =
      HH.nav_
        [ HH.ul_ (map link [R.Intro, R.Resources, R.Journals $ RJ.Edit Nothing])
        ]

    link r = HH.li_ [ HH.a [ HP.href $ R.reverseRoute r ] [ HH.text $ R.reverseRoute r ] ]

    viewPage :: State -> H.ParentHTML Query ChildQuery ChildSlot m
    viewPage { localiseFn, currentRoute } = case currentRoute of
      R.Intro ->
        HH.slot'
          pathToIntro
          Intro.Slot
          (Intro.component localiseFn)
          unit
          nada
      R.Resources ->
        HH.slot'
          pathToResources
          Resources.Slot
          (Resources.component localiseFn)
          unit
          nada
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
      H.modify_ (_{ session = Just sess })
      pure next

routeSignal :: H.HalogenIO Query Void Aff -> Effect (Effect Unit)
routeSignal driver = matches R.routes hashChanged
  where
    hashChanged _ newRoute = do
      _ <- launchAff $ driver.query <<< H.action <<< Goto $ newRoute
      pure unit

mapSessionMessage :: Sessions.Message -> Maybe (Query Unit)
mapSessionMessage (Sessions.SessionCreated session) = Just (UpdateSession session unit)
