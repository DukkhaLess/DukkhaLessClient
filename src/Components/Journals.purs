module Components.Journals where

import Prelude

import AppRouting.Routes.Journals as RJ
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Intl.Terms.Journals as Journals
import Model.Journal as MJ

data Query a = QNoOp a

data Message = MNoOp

newtype State 
  = State
    { routeContext :: RJ.Journals
    , journalsState :: MJ.JournalsState
    }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Input
  = JournalsContext
  { routeContext :: RJ.Journals
  , journalsState :: MJ.JournalsState
  }

type ChildQuery
  = JournalList.Query
  <\/> JournalEntry.Query
  <\/> Const Void

type ChildSlot
  = JournalList.Slot
  \/ JournalEntry.Slot
  \/ Void


pathToList :: ChildPath JournalList.Query ChildQuery JournalList.Slot ChildSlot
pathToList = cpL

pathToEdit :: ChildPath JournalEntry.Query ChildQuery JournalEntry.Slot ChildSlot
pathToEdit = cpR :> cpL


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
      render (State state) = case state.routeContext of
        RJ.Edit id ->
          HH.slot'
            pathToEdit
            JournalEntry.Slot
            (JournalEntry.component t)
            (JournalEntry.Input {alreadyEditing: (unwrap state.journalsState).openForEdit })
            mapEditMessage
        RJ.List ->
          HH.slot'
            pathToList
            JournalList.Slot
            (JournalList.component t)
            unit
            mapListMessage

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message Aff
      eval (QNoOp next) = pure next

      receive :: Input -> Maybe (Query Unit)
      receive _ = Nothing

      initialState :: Input -> State
      initialState (JournalsContext c) = State c
 
mapEditMessage :: JournalEntry.Message -> Maybe (Query Unit)
mapEditMessage _ = Nothing

mapListMessage :: JournalList.Message -> Maybe (Query Unit)
mapListMessage _ = Nothing