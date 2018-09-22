module Effect.Clipboard
  (copyToClipboard) where

import Effect (Effect)
import Prelude (Unit)

foreign import _copyToClipboard :: String -> Effect Unit

copyToClipboard :: String -> Effect Unit
copyToClipboard = _copyToClipboard
