module Components.Util where

import Prelude
import Data.Const (Const)
import Halogen as H

type OpaqueSlot
  = H.Slot (Const Void) Void

type MessageSlot
  = H.Slot (Const Void)
