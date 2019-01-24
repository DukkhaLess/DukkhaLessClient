module Components.Helpers.Widgets where

import Halogen as H
import Halogen.HTML as HH

loading :: forall a b. H.HTML a b
loading = HH.text "Loading!"