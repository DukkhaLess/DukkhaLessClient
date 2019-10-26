module Components.Helpers.StateAccessors where

import Prelude

import AppM (CurrentSessionRow')
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (Routes(Intro), reverseRoute)
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
    Nothing ->  logout *> pure Nothing
    Just profile -> pure $ Just profile

logout 
  :: forall m r
  .  MonadEffect m
  => MonadAsk (CurrentSessionRow' r) m
  => m Unit
logout = do
  liftEffect <<< Ref.write Nothing =<< asks _.currentSession
  liftEffect $ setHash $ reverseRoute $ Intro