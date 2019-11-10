module Data.HTTP.Request where

import Data.HTTP.Helpers
import Prelude
import Affjax (Response)
import Data.Bifunctor (lmap)
import Data.Crypto.Class (decrypt)
import Data.Crypto.Types (Document(..), DocumentId, DecryptionError(..))
import Data.Either (Either)
import Data.Newtype (unwrap)
import Effect.Aff.Class (class MonadAff)
import Model (SessionToken)
import Model.Journal (JournalEntry(..))
import Model.Keyring (Keyring(..))

getJournalEntry ::
  forall m.
  MonadAff m =>
  SessionToken ->
  DocumentId ->
  Keyring ->
  m (Either DecryptionError JournalEntry)
getJournalEntry sessionToken id keyring = do
  response <- request (get (ApiPath ("/journals/" <> unwrap id)) sessionToken) :: m (Response (Either String Document))
  pure $ (lmap Description response.body) >>= decrypt keyring
