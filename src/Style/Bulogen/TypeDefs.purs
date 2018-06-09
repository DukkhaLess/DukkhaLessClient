module Style.Bulogen.TypeDefs where

import Halogen.HTML.Properties as HP

type IPropArray r i = Array (HP.IProp ( "class" :: String | r) i)
