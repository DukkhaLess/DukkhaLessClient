module Components.Journals where

import Prelude

import AppM (CurrentSessionRow, JournalMetaCacheRow, EditingJournalEntryRow)
import Components.Helpers.StateAccessors (guardSession)
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Control.Monad.Reader.Class (class MonadAsk)
import Data.Const (Const)
import Data.Crypto.Types (DocumentId(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Routing.Routes.Journals as RJ
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..))
import Model.Journal as MJ
import Style.Bulogen as SB
import Type.Row (type (+))

data Query a = Initialise a

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
  H.lifecycleParentComponent
    { initialState
    , render
    , eval
    , receiver: receive
    , initializer: Just (Initialise unit)
    , finalizer: Nothing
    }
    where
      render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
      render (State state) = 
        HH.div
          [ HP.classes
            [ SB.container
            ]
          ]
          [
            case state.routeContext of
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
          ]

      eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message m
      eval (Initialise next) = do
        -- _ <- guardSession
        pure next

      receive :: Input -> Maybe (Query Unit)
      receive _ = Nothing

      initialState :: Input -> State
      initialState (JournalsContext c) = State c