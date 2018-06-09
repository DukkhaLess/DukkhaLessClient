module Style.Bulogen.Properties where

import Halogen.HTML (AttrName(..))
import Halogen.HTML.Properties as HP

attr :: forall r i. String -> String -> HP.IProp r i
attr name = HP.attr (AttrName name)

role :: forall r i. String -> HP.IProp r i
role = attr "role"

src :: forall r i. String -> HP.IProp r i
src = attr "src"

ariaLabel :: forall r i. String -> HP.IProp r i
ariaLabel = attr "aria-label"

