module Data.HTTP.Request where

import Prelude
import Data.Either (Either)
import Data.HTTP.Helpers
import Data.HTTP.Payloads
import Effect.Aff.Class (class MonadAff)
import Model (SessionToken)

login :: forall m. MonadAff m => SubmitLogin -> m (Either String SessionToken)
login payload = do
  response <- request (unsafePostCleartext (ApiPath "/login") payload)
  pure response.body

