module Data.HTTP.Request where

import Data.HTTP.Helpers
import Data.HTTP.Payloads
import Prelude

import Data.Crypto.Class (decrypt)
import Data.Crypto.Types (DocumentId)
import Data.Either (Either)
import Data.Newtype (unwrap)
import Effect.Aff.Class (class MonadAff)
import Model (SessionToken)
import Model.Journal (JournalEntry(..))
import Model.Keyring (Keyring(..))

login :: forall m. MonadAff m => SubmitLogin -> m (Either String SessionToken)
login payload = do
  response <- request (unsafePostCleartext (ApiPath "/login") payload)
  pure response.body

getJournalEntry
  :: forall m
  . MonadAff m
  => SessionToken
  -> DocumentId
  -> Keyring
  -> m (Either String JournalEntry)
getJournalEntry sessionToken id keyring = do
  response <- request (get (ApiPath "/journals/" <> unwrap id) sessionToken)
  result <- response.body <#> decrypt keyring
  pure result

