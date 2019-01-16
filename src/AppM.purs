module AppM where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Crypto.Types (DocumentId)
import Data.Map (empty, Map)
import Data.Maybe (Maybe(..))
import Effect.AVar (AVar)
import Effect.Aff (Aff)
import Effect.Aff.AVar (new)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..))
import Type.Equality (class TypeEquals, from)
import Type.Row (type (+))

type CurrentSessionRow r =
  ( currentSession :: AVar (Maybe Session)
  | r
  )
type CurrentSessionRow' r = Record (CurrentSessionRow r)

type LocaliseFnRow r =
  ( localiseFn :: AVar LocaliseFn
  | r
  )

type LocaliseFnRow' r = Record (LocaliseFnRow r)

type JournalMetaCacheRow r =
  ( journalMetaCache :: AVar (Map DocumentId JournalMeta)
  | r
  )

type JournalMetaCacheRow' r = Record (JournalMetaCacheRow r)

type EditingJournalEntryRow r =
  ( editingJournalEntry :: AVar (Maybe JournalEntry)
  | r
  )

type EditingJournalEntryRow' r = Record (EditingJournalEntryRow r)

type AppState =
    Record
      ( CurrentSessionRow
      + LocaliseFnRow
      + EditingJournalEntryRow
      + JournalMetaCacheRow
      + ()
      )

makeAppState :: LocaliseFn -> Aff AppState
makeAppState l = do
  localiseFn <- new l
  currentSession <- new Nothing
  journalMetaCache <- new empty
  editingJournalEntry <- new Nothing
  pure $
    { localiseFn
    , currentSession
    , journalMetaCache
    , editingJournalEntry
    }
    

newtype AppM a = AppM (ReaderT AppState Aff a)

runAppM :: AppState -> AppM ~> Aff
runAppM appState (AppM m) = runReaderT m appState

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance monadAskAppM :: TypeEquals e AppState => MonadAsk e AppM where
  ask = AppM $ asks from