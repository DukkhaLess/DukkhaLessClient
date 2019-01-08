module Components.Journals where

import Prelude
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Intl (LocaliseFn)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl.Terms.Journals as Journals
import Components.Journals.List as JournalList
import Components.Journals.Entry as JournalEntry

data Query a = QNoOp a

newtype State = State {}

type ChildQuery
  = JournalList.Query
  <\/> JournalEntry.Query
  <\/> Const Void

type ChildSlot
  = JournalList.Slot
  \/ JournalEntry.Slot
  \/ Void


component :: LocaliseFn -> H.Component HH.HTML Query Unit Unit Aff
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

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Unit Aff
      eval (QNoOp next) = pure next

      receive :: Unit -> Maybe (Query Unit)
      receive _ = Nothing

      initialState :: Unit -> State
      initialState _ = State {}
 