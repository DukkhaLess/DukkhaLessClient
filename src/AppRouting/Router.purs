module AppRouting.Router where


import Prelude
  ( type (~>)
  , Unit
  , Void
  , const
  , pure
  , unit
  , (<<<)
  , bind
  , ($)
  , discard
  , map
  , show
  )
import AppRouting.Routes as R
import Components.Intro as Intro
import Components.Resources as Resources
import Components.Sessions as Sessions
import Components.NotFound as NotFound
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Model (Model, Session)
import Routing.Hash (matches)

data Input a
  = Goto R.Routes a
  | UpdateSession Session a

type ChildQuery
  = Intro.Query
  <\/> Resources.Query
  <\/> Sessions.Query
  <\/> NotFound.Query
  <\/> Const Void

type ChildSlot
  = Intro.Slot
  \/ Resources.Slot
  \/ Sessions.Slot
  \/ NotFound.Slot
  \/ Void


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

component :: Model -> H.Component HH.HTML Input Unit Void Aff
component initialModel = H.parentComponent
  { initialState: const initialModel
  , render
  , eval
  , receiver: nada
  }
  where
    render :: Model -> H.ParentHTML Input ChildQuery ChildSlot Aff
    render model =
      HH.div_
        [ HH.ul_ (map link [R.Intro, R.Resources, R.Sessions R.Login])
        , viewPage model model.currentPage
        ]

    link r = HH.li_ [ HH.a [ HP.href $ R.reverseRoute r ] [ HH.text $ show r ] ]

    viewPage :: Model -> R.Routes -> H.ParentHTML Input ChildQuery ChildSlot Aff
    viewPage model R.Intro =
      HH.slot'
        pathToIntro
        Intro.Slot
        (Intro.component model.localiseFn)
        unit
        nada
    viewPage model R.Resources =
      HH.slot'
        pathToResources
        Resources.Slot
        (Resources.component model.localiseFn)
        unit
        nada
    viewPage model (R.Sessions r) =
      HH.slot'
        pathToSessions
        Sessions.Slot
        (Sessions.component model.localiseFn)
        (Sessions.ExistingSession model.session)
        mapSessionMessage
    viewPage model R.NotFound =
      HH.slot'
        pathToNotFound
        NotFound.Slot
        (NotFound.component model.localiseFn)
        unit
        nada

    eval :: Input ~> H.ParentDSL Model Input ChildQuery ChildSlot Void Aff
    eval (Goto loc next) = do
      H.modify_ (_{ currentPage = loc})
      pure next
    eval (UpdateSession sess next) = do
      H.modify_ (_{ session = Just sess })
      pure next

routeSignal :: H.HalogenIO Input Void Aff -> Effect (Effect Unit)
routeSignal driver = matches R.routes hashChanged
  where
    hashChanged _ newRoute = do
      _ <- launchAff $ driver.query <<< H.action <<< Goto $ newRoute
      pure unit

mapSessionMessage :: Sessions.Message -> Maybe (Input Unit)
mapSessionMessage (Sessions.SessionCreated session) = Just (UpdateSession session unit)
