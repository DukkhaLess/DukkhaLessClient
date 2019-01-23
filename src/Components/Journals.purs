module Components.Journals where

import Prelude

import AppM (CurrentSessionRow, JournalMetaCacheRow, EditingJournalEntryRow)
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Control.Monad.Reader.Class (class MonadAsk)
import Data.Const (Const)
import Data.Crypto.Types (DocumentId(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Routing.Routes.Journals as RJ
import Effect.AVar (AVar)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..))
import Model.Journal as MJ
import Type.Row (type (+))

data Query a = QNoOp a

data Message = MNoOp

newtype State 
  = State
    { routeContext :: RJ.Journals
    }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Input
  = JournalsContext
  { routeContext :: RJ.Journals
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

type RequiredState r =
  ( CurrentSessionRow
  + JournalMetaCacheRow
  + EditingJournalEntryRow
  + r
  )

component
  :: forall m r
  . MonadAff m 
  => MonadAsk (Record (RequiredState r)) m
  => LocaliseFn
  -> H.Component HH.HTML Query Input Message m
component t =
  H.parentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
      render (State state) = case state.routeContext of
        RJ.Edit id ->
          HH.slot'
            pathToEdit
            JournalEntry.Slot
            (JournalEntry.component t)
            (JournalEntry.Input
              { desiredEntry: id <#> UUID }
            )
            (const Nothing)
        RJ.List ->
          HH.slot'
            pathToList
            JournalList.Slot
            (JournalList.component t)
            unit
            (const Nothing)

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message m
      eval (QNoOp next) = pure next

      receive :: Input -> Maybe (Query Unit)
      receive _ = Nothing

      initialState :: Input -> State
      initialState (JournalsContext c) = State c