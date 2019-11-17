module Components.Journals where

import Prelude
import AppM (CurrentSessionRow, JournalMetaCacheRow, EditingJournalEntryRow)
import Components.Helpers.StateAccessors (guardSession)
import Components.Journals.Entry as JournalEntry
import Components.Journals.List as JournalList
import Components.Util (OpaqueSlot)
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

newtype State
  = State
  { routeContext :: RJ.Journals
  }

data Input
  = JournalsContext
    { routeContext :: RJ.Journals
    }

type ChildSlots
  = ( edit :: OpaqueSlot Unit
    , list :: OpaqueSlot Unit
    )

pathToEdit = SProxy :: _ "edit"

pathToList = SProxy :: _ "list"

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
  H.Component HH.HTML (Const Void) Input Void m
component t =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
    }
  where
  render :: State -> H.ComponentHTML Void ChildSlots m
  render (State state) =
    HH.div
      [ HP.classes
          [ SB.container
          ]
      ]
      [ case state.routeContext of
          RJ.Edit id ->
            HH.slot
              pathToEdit
              unit
              (JournalEntry.component t)
              { desiredEntry: id <#> UUID }
              absurd
          RJ.List ->
            HH.slot
              pathToList
              unit
              (JournalList.component t)
              {}
              absurd
      ]

  initialState :: Input -> State
  initialState (JournalsContext c) = State c
