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
import AppRouting.Routes
import Components.Intro as Intro
import Components.Resources as Resources
import Components.Sessions as Sessions
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Model (Model, Session)
import Routing.Hash (matches)

data Input a
  = Goto Routes a
  | UpdateSession Session a

type ChildQuery
  = Intro.Query
  <\/> Resources.Query
  <\/> Sessions.Query
  <\/> Const Void

type ChildSlot
  = Intro.Slot
  \/ Resources.Slot
  \/ Sessions.Slot
  \/ Void


nada  :: forall a b. a -> Maybe b
nada = const Nothing

pathToIntro :: ChildPath Intro.Query ChildQuery Intro.Slot ChildSlot
pathToIntro = cpL

pathToResources :: ChildPath Resources.Query ChildQuery Resources.Slot ChildSlot
pathToResources = cpR :> cpL

pathToSessions :: ChildPath Sessions.Query ChildQuery Sessions.Slot ChildSlot
pathToSessions = cpR :> cpR :> cpL

component :: forall m. Model -> H.Component HH.HTML Input Unit Void m
component initialModel = H.parentComponent
  { initialState: const initialModel
  , render
  , eval
  , receiver: nada
  }
  where
    render :: Model -> H.ParentHTML Input ChildQuery ChildSlot m
    render model =
      HH.div_
        [ HH.ul_ (map link [Intro, Resources, Sessions])
        , viewPage model model.currentPage
        ]

    link r = HH.li_ [ HH.a [ HP.href $ reverseRoute r ] [ HH.text $ show r ] ]

    viewPage :: Model -> Routes -> H.ParentHTML Input ChildQuery ChildSlot m
    viewPage model Intro =
      HH.slot'
        pathToIntro
        Intro.Slot
        (Intro.component model.localiseFn)
        unit
        nada
    viewPage model Resources =
      HH.slot'
        pathToResources
        Resources.Slot
        (Resources.component model.localiseFn)
        unit
        nada
    viewPage model Sessions =
      HH.slot'
        pathToSessions
        Sessions.Slot
        (Sessions.component model.localiseFn)
        (Sessions.ExistingSession model.session)
        mapSessionMessage

    eval :: Input ~> H.ParentDSL Model Input ChildQuery ChildSlot Void m
    eval (Goto loc next) = do
      H.modify_ (_{ currentPage = loc})
      pure next
    eval (UpdateSession sess next) = do
      H.modify_ (_{ session = Just sess })
      pure next

routeSignal :: H.HalogenIO Input Void Aff -> Aff (Effect Unit)
routeSignal driver = liftEffect do
  matches routes hashChanged
  where
    hashChanged _ newRoute = do
      _ <- launchAff $ driver.query <<< H.action <<< Goto $ newRoute
      pure unit

mapSessionMessage :: Sessions.Message -> Maybe (Input Unit)
mapSessionMessage (Sessions.SessionCreated session) = Just (UpdateSession session unit)
