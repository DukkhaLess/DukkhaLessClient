module Data.HTTP.Request where

import Data.HTTP.Helpers
import Data.HTTP.Payloads
import Prelude

import Data.Crypto.Types (DocumentId)
import Data.Either (Either)
import Effect.Aff.Class (class MonadAff)
import Model (SessionToken)
import Model.Journal (JournalEntry(..))

login :: forall m. MonadAff m => SubmitLogin -> m (Either String SessionToken)
login payload = do
  response <- request (unsafePostCleartext (ApiPath "/login") payload)
  pure response.body

-- getJournalEntry :: forall m. MonadAff m => DocumentId -> m (Either String JournalEntry)
-- getJournalEntry = do
--   response <- request ()

