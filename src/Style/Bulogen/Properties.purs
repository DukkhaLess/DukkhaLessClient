module Style.Bulogen.Properties where

import Halogen.HTML (AttrName(..))
import Halogen.HTML.Properties as HP

attr name = HP.attr (AttrName name)

role = attr "role"

src = attr "src"

ariaLabel = attr "aria-label"

