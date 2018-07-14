module AppRouting.Router where

import AppRouting.Routes

import Data.Maybe (Maybe(..))
import Data.String (toLower)
import Data.Tuple (Tuple(..))
import Effect (Effect(..))
import Effect.Aff (Aff, launchAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Halogen.Component.ChildPath (ChildPath, cpL, cpR)
import Halogen.Data.Prism (type (<\/>), type (\/))
import Model (Model)
import Prelude ( type (~>)
               , Unit
               , Void
               , bind
               , const
               , discard
               , map
               , pure
               , show
               , unit
               , ($)
               , (<<<)
               , (<>)
               )
import Routing.Hash (matches)

import Components.Intro as Intro
import Components.Resources as Resources
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

data Input a
  = Goto Routes a

type ChildQuery
  = Intro.Query <\/> Resources.Query

type ChildSlot
  = Intro.Slot \/ Resources.Slot

nada :: forall a b. a -> Maybe b
nada = const Nothing

pathToIntro :: ChildPath Intro.Query ChildQuery Intro.Slot ChildSlot
pathToIntro = cpL

pathToResources :: ChildPath Resources.Query ChildQuery Resources.Slot ChildSlot
pathToResources = cpR

component :: forall m. Model -> H.Component HH.HTML Input Unit Void m
component initialModel = H.parentComponent { initialState: const initialModel
                                           , render
                                           , eval
                                           , receiver: nada
                                           }
    where
    render :: Model -> H.ParentHTML Input ChildQuery ChildSlot m
    render model = HH.div_ [ HH.ul_ (map link [Intro, Resources])
                           , viewPage model model.currentPage
                           ]
    
    link r = HH.li_ [HH.a [HP.href $ reverseRoute r] [HH.text $ show r]]
    
    viewPage :: Model -> Routes -> H.ParentHTML Input ChildQuery ChildSlot m
    viewPage model Intro = HH.slot' pathToIntro Intro.Slot (Intro.component model.localiseFn) unit nada
    
    viewPage model Resources = HH.slot' pathToResources Resources.Slot (Resources.component model.localiseFn) unit nada
    
    eval :: Input ~> H.ParentDSL Model Input ChildQuery ChildSlot Void m
    eval (Goto loc next) = do
        H.modify_ (_ {currentPage = loc})
        pure next
    

routeSignal :: H.HalogenIO Input Void Aff -> Aff (Effect Unit)
routeSignal driver = liftEffect do
    matches routes hashChanged
    where
    hashChanged _ newRoute = do
        _ <- launchAff $ driver.query <<< H.action <<< Goto $ newRoute
        pure unit
    
