module Components.Helpers.StateAccessors where

import Prelude

import AppM (CurrentSessionRow')
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (Routes(Sessions), reverseRoute)
import Data.Routing.Routes.Sessions (Sessions(Logout))
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Model (Session)
import Routing.Hash (setHash)

guardSession
  :: forall m r
  .  MonadEffect m
  => MonadAsk (CurrentSessionRow' r) m
  => m (Maybe Session)
guardSession = do
  asks _.currentSession >>= (Ref.read >>> liftEffect) >>= case _ of
    Nothing -> (liftEffect $ setHash $ reverseRoute $ Sessions Logout) *> pure Nothing
    Just profile -> pure $ Just profile