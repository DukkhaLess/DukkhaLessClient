module AppM where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Maybe (Maybe(..))
import Effect.AVar (AVar)
import Effect.Aff (Aff)
import Effect.Aff.AVar (new)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Intl (LocaliseFn)
import Model (Session(..))
import Type.Equality (class TypeEquals, from)


type Env =
  { currentSession :: AVar (Maybe Session)
  , localiseFn :: AVar LocaliseFn
  }


makeEnv :: LocaliseFn -> Aff Env
makeEnv l = do
  localiseFn <- new l
  currentSession <- new Nothing
  pure $
    { localiseFn
    , currentSession
    }
    

newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from