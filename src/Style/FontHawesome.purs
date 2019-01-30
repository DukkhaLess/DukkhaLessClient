-- | This module, like the Bulogen one, exists only to provide Halogen compatible ClassName values
-- | Which can be referenced in when building components, so that string based class names can be avoided.

module Style.FontHawesome where


import Halogen.HTML as HH

solid :: HH.ClassName
solid = HH.ClassName "fas"

regular :: HH.ClassName
regular = HH.ClassName "far"

penAlt :: HH.ClassName
penAlt = HH.ClassName "fa-pen-alt"

signInAlt :: HH.ClassName
signInAlt = HH.ClassName "fa-sign-in-alt"

signOutAlt :: HH.ClassName
signOutAlt = HH.ClassName "fa-sign-out-alt"

edit :: HH.ClassName
edit = HH.ClassName "fa-edit"

list :: HH.ClassName
list = HH.ClassName "fa-list"

book :: HH.ClassName
book = HH.ClassName "fa-book"

userPlus :: HH.ClassName
userPlus = HH.ClassName "fa-user-plus"

penSquare :: HH.ClassName
penSquare = HH.ClassName "fa-pen-square"