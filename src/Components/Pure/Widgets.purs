module Components.Pure.Widgets where

import Halogen.HTML as HH

loading :: forall a b. HH.HTML a b
loading = HH.text "Loading!"
