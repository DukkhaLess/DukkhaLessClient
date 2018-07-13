module AppRouting.Router where

import AppRouting.Routes
import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Model (Model(..))
import Data.Maybe (Maybe(..))
import Data.Functor.Coproduct (Coproduct)
import Halogen.Component.ChildPath (ChildPath, cpR, cpL)
import Components.Intro as Intro
import Data.Either (Either(..))
import Components.Resources as Resources

data Input a
  = Goto Routes a

type ChildQuery = Coproduct Intro.Query Resources.Query
type ChildSlot = Either Intro.Slot Resources.Slot


nada  :: forall f o. o -> Maybe (f Unit)
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
