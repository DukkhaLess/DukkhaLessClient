module Components.Journals.Entry where

import Prelude

import Data.Crypto.Types (DocumentId)
import Data.Default (default)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Model.Journal (JournalEntry(..), JournalMeta(..))

data Query a = NoOp a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Message = MNoMsg

newtype State
  = State 
    { entry :: JournalEntry
    }

newtype Input
  = Input
  { alreadyEditing :: Maybe JournalEntry
  , desiredEntry :: Maybe DocumentId
  }

initialState :: Input -> State
initialState (Input input) = State { entry: fromMaybe default input.alreadyEditing }

component :: forall a. LocaliseFn -> H.Component HH.HTML Query Input Message Aff
component t =
  H.component
    { initialState
    , render
    , eval
    , receiver
    }
  where

  render :: State -> H.ComponentHTML Query
  render _ = HH.text "Hi"

  eval :: Query ~> H.ComponentDSL State Query Message Aff
  eval (NoOp next) = pure next

  receiver :: Input -> Maybe (Query Unit)
  receiver _ = Nothing