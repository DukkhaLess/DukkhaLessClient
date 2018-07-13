module AppRouting.Router where

import AppRouting.Routes
import Prelude (type (~>), Unit, Void, const, pure, unit)
import Halogen as H
import Halogen.HTML as HH
import Model (Model)
import Data.Maybe (Maybe(..))
import Halogen.Component.ChildPath (ChildPath, cpR, cpL)
import Halogen.Data.Prism (type (<\/>), type (\/))
import Components.Intro as Intro
import Components.Resources as Resources

data Input a
  = Goto Routes a

type ChildQuery
  = Intro.Query
  <\/> Resources.Query

type ChildSlot
  = Intro.Slot
  \/ Resources.Slot


nada  :: forall a b. a -> Maybe b
nada = const Nothing

pathToIntro :: ChildPath Intro.Query ChildQuery Intro.Slot ChildSlot
pathToIntro = cpL

pathToResources :: ChildPath Resources.Query ChildQuery Resources.Slot ChildSlot
pathToResources = cpR

component :: forall m. Model -> H.Component HH.HTML Input Unit Void m
component model = H.parentComponent
  { initialState: const model
  , render
  , eval
  , receiver: const Nothing
  }
  where
    render :: Model -> H.ParentHTML Input ChildQuery ChildSlot m
    render mdl =
      HH.div_
        [ viewPage model.currentPage
        ]

    viewPage :: Routes -> H.ParentHTML Input ChildQuery ChildSlot m
    viewPage Intro =
      HH.slot' pathToIntro Intro.Slot (Intro.component model.localiseFn) unit nada
    viewPage Resources =
      HH.slot' pathToResources Resources.Slot (Resources.component model.localiseFn) unit nada

    eval :: Input ~> H.ParentDSL Model Input ChildQuery ChildSlot Void m
    eval (Goto _ next) = do
      pure next
