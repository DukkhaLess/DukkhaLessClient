-- | This module, like the Bulogen one, exists only to provide Halogen compatible ClassName values
-- | Which can be referenced in when building components, so that string based class names can be avoided.

module Style.FontHawesome where


import Halogen.HTML as HH

solid :: HH.ClassName
solid = HH.ClassName "fas"

regular :: HH.ClassName
regular = HH.ClassName "far"

penAlt :: HH.ClassName
penAlt = HH.ClassName "pen-alt"

signInAlt :: HH.ClassName
signInAlt = HH.ClassName "sign-in-alt"

signOutAlt :: HH.ClassName
signOutAlt = HH.ClassName "sign-out-alt"

edit :: HH.ClassName
edit = HH.ClassName "edit"

list :: HH.ClassName
list = HH.ClassName "list"

book :: HH.ClassName
book = HH.ClassName "book"