module AppM where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Crypto.Types (DocumentId)
import Data.Maybe (Maybe(..))
import Data.Map (empty, Map)
import Effect.AVar (AVar)
import Effect.Aff (Aff)
import Effect.Aff.AVar (new)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..))
import Type.Equality (class TypeEquals, from)

type AppState =
  { currentSession :: AVar (Maybe Session)
  , localiseFn :: AVar LocaliseFn
  , journalMetaCache :: AVar (Map DocumentId JournalMeta)
  , editingJournalEntry :: AVar (Maybe JournalEntry)
  }


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