module Style.Hulma where

import Prelude
import Halogen.HTML as HH
import Halogen.HTML.Elements as HE
import Halogen.HTML.Properties as HP

-- card :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
-- card = HH.div []

type Classy r i = HP.IProp ( "class" :: String | r  ) i

classify :: String -> HH.ClassName
classify = HH.ClassName

classes :: forall r i. Array HH.ClassName -> Classy r i
classes = HP.classes

section :: HH.ClassName
section = classify "section"
sections :: forall r i. Classy r i
sections = classes [ section ]
container :: HH.ClassName
container = classify "container"
containers :: forall r i. Classy r i
containers = classes [ container ]
card :: HH.ClassName
card = classify "card"
cards :: forall r i. Classy r i
cards = classes [ card ]
cardHeader :: HH.ClassName
cardHeader = classify "card-header"
cardHeaders :: forall r i. Classy r i
cardHeaders = classes [ cardHeader ]
cardFooter :: HH.ClassName
cardFooter = classify "card-footer"
cardFooters :: forall r i. Classy r i
cardFooters = classes [ cardFooter ]
cardFooterItem :: HH.ClassName
cardFooterItem = classify "card-footer-item"
cardFooterItems :: forall r i. Classy r i
cardFooterItems = classes [ cardFooterItem ]
cardHeaderTitle :: HH.ClassName
cardHeaderTitle = classify "card-header-title"
cardHeaderTitles :: forall r i. Classy r i
cardHeaderTitles = classes [ cardHeaderTitle ]
cardHeaderIcon :: HH.ClassName
cardHeaderIcon = classify "card-header-icon"
cardHeaderIcons :: forall r i. Classy r i
cardHeaderIcons = classes [ cardHeaderIcon ]
cardImage :: HH.ClassName
cardImage = classify "card-image"
cardImages :: forall r i. Classy r i
cardImages = classes [ cardImage ]
cardContent :: HH.ClassName
cardContent = classify "card-content"
cardContents :: forall r i. Classy r i
cardContents = classes [ cardContent ]
media :: HH.ClassName
media = classify "media"
medias :: forall r i. Classy r i
medias = classes [ media ]
mediaLeft :: HH.ClassName
mediaLeft = classify "media-left"
mediaLefts :: forall r i. Classy r i
mediaLefts = classes [ mediaLeft ]
mediaContent :: HH.ClassName
mediaContent = classify "media-content"
mediaContents :: forall r i. Classy r i
mediaContents = classes [ mediaContent ]
title :: HH.ClassName
title = classify "title"
titles :: forall r i. Classy r i
titles = classes [ title ]
subtitle :: HH.ClassName
subtitle = classify "subtitle"
subtitles :: forall r i. Classy r i
subtitles = classes [ subtitle ]
--  :: HH.ClassName
--  = classify ""
--  :: forall r i. Classy r i
-- s = classes [ Class ]
