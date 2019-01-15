module Components.Journals where

import Prelude

import AppRouting.Routes.Journals as RJ
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Intl.Terms.Journals as Journals
import Model.Journal (JournalsState(..))

data Query a = QNoOp a

data Message = MNoOp

newtype State 
  = State
    { routeContext :: RJ.Journals
    , journalsState :: JournalsState
    }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Input
  = JournalsContext
  { routeContext :: RJ.Journals
  , journalsState :: JournalsState
  }

type ChildQuery
  = JournalList.Query
  <\/> JournalEntry.Query
  <\/> Const Void

type ChildSlot
  = JournalList.Slot
  \/ JournalEntry.Slot
  \/ Void


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
      receive _ = Nothing

      initialState :: Input -> State
      initialState (JournalsContext c) = State c
 