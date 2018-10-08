module Components.Helpers.Forms where

import Data.Validation

import Halogen.HTML as HH
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Properties (IProp)
import Intl (LocaliseFn)

validated' :: forall a e r p i. ValidationG a e r -> LocaliseFn -> HTML p i -> HTML p i
validated' v t f = validated v t f []

validated :: forall a e r r2 p i. ValidationG a e r -> LocaliseFn -> HTML p i -> Array (IProp r2 i) -> HTML p i
validated v t field ps = elem where
  elem = HH.div
    [
    ]
    [ field
    ]