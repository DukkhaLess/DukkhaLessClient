module Components.Journals.List where

import Prelude

import Control.Monad.Reader.Class (class MonadAsk)
import Data.Crypto.Types (DocumentId)
import Data.Map (Map)
import Data.Maybe (Maybe(..))
import Effect.AVar (AVar)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalMeta(..))

data Query a = NoOp a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Message = MNoMsg

newtype State = State {}

initialState :: forall a. a -> State
initialState = const $ State {}

type RequiredState r =
  ( currentSession :: AVar (Maybe Session)
  , journalMetaCache :: AVar (Map DocumentId JournalMeta)
  | r
  )
component
  :: forall a m r
  . MonadAff m
  => MonadAsk (Record (RequiredState r)) m
  => LocaliseFn
  -> H.Component HH.HTML Query a Message m
component t =
  H.component
    { initialState: initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: State -> H.ComponentHTML Query
  render _ = HH.text "Hi"

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval (NoOp next) = pure next