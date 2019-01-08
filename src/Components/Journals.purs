module Components.Journals where

import Prelude
import Intl (LocaliseFn)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl.Terms.Journals as Journals

data Query a = QNoOp a
data Input = INoOp

newtype State = State {}

component :: LocaliseFn -> H.Component HH.HTML Query Input Message Aff
component t =
  H.parentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot Aff
      render state = HH.text "hi"

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message Aff
      eval (QNoOp next) = pure next

      receive :: Input -> Maybe (Query Unit)
      receive INoOp = Nothing
 