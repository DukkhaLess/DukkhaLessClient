module AppRouting.Router where

import AppRouting.Routes
import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Model (Model(..))
import Data.Maybe (Maybe(..))

data Input a
  = Goto Routes a

data ChildQuery a = Unit
type ChildSlot = Unit

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
      HH.div_ []

    eval :: Input ~> H.ParentDSL Model Input ChildQuery ChildSlot Void m
    eval (Goto _ next) = do
      pure next
