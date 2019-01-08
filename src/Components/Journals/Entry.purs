module Components.Journals.Entry where

import Prelude

data Query a = NoOp a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot