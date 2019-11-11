module Components.Journals where

import Prelude
import Components.Helpers.StateAccessors (guardSession)
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Control.Monad.Reader.Class (class MonadAsk)
import Data.Const (Const)
import Data.Crypto.Types (DocumentId(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Routing.Routes.Journals as RJ
import Data.Symbol (SProxy(..))
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

data Query a
  = Initialise a

data Message
  = MNoOp

newtype State
  = State
  { routeContext :: RJ.Journals
  }

data Slot
  = Slot

derive instance eqSlot :: Eq Slot

derive instance ordSlot :: Ord Slot

data Input
  = JournalsContext
    { routeContext :: RJ.Journals
    }

type ChildSlots
  = ( edit :: H.Slot JournalEntry.Slot Void Unit
    , list :: H.Slot JournalList.Slot Void Unit
    )

pathToEdit = SProxy :: SProxy "edit"

pathToList = SProxy :: SProxy "list"

type RequiredState r
  = ( CurrentSessionRow
        + JournalMetaCacheRow
        + EditingJournalEntryRow
        + r
    )

component ::
  forall m r.
  MonadAff m =>
  MonadAsk (Record (RequiredState r)) m =>
  LocaliseFn ->
  H.Component HH.HTML Query Input Message m
component t =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
    }
  where
  render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
  render (State state) =
    HH.div
      [ HP.classes
          [ SB.container
          ]
      ]
      [ case state.routeContext of
          RJ.Edit id ->
            HH.slot'
              pathToEdit
              JournalEntry.Slot
              (JournalEntry.component t)
              ( JournalEntry.Input
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

  initialState :: Input -> State
  initialState (JournalsContext c) = State c
