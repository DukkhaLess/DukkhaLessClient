{-
Copyright 2018 James Laver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-}

module Style.Hulma where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Style.Bulogen.TypeDefs (ClassProp)

classify :: String -> HH.ClassName
classify = HH.ClassName

classes :: forall r i. Array HH.ClassName -> ClassProp r i
classes = HP.classes

section :: HH.ClassName
section = classify "section"
sections :: forall r i. ClassProp r i
sections = classes [ section ]
container :: HH.ClassName
container = classify "container"
containers :: forall r i. ClassProp r i
containers = classes [ container ]
card :: HH.ClassName
card = classify "card"
cards :: forall r i. ClassProp r i
cards = classes [ card ]
cardHeader :: HH.ClassName
cardHeader = classify "card-header"
cardHeaders :: forall r i. ClassProp r i
cardHeaders = classes [ cardHeader ]
cardFooter :: HH.ClassName
cardFooter = classify "card-footer"
cardFooters :: forall r i. ClassProp r i
cardFooters = classes [ cardFooter ]
cardFooterItem :: HH.ClassName
cardFooterItem = classify "card-footer-item"
cardFooterItems :: forall r i. ClassProp r i
cardFooterItems = classes [ cardFooterItem ]
cardHeaderTitle :: HH.ClassName
cardHeaderTitle = classify "card-header-title"
cardHeaderTitles :: forall r i. ClassProp r i
cardHeaderTitles = classes [ cardHeaderTitle ]
cardHeaderIcon :: HH.ClassName
cardHeaderIcon = classify "card-header-icon"
cardHeaderIcons :: forall r i. ClassProp r i
cardHeaderIcons = classes [ cardHeaderIcon ]
cardImage :: HH.ClassName
cardImage = classify "card-image"
cardImages :: forall r i. ClassProp r i
cardImages = classes [ cardImage ]
cardContent :: HH.ClassName
cardContent = classify "card-content"
cardContents :: forall r i. ClassProp r i
cardContents = classes [ cardContent ]
media :: HH.ClassName
media = classify "media"
medias :: forall r i. ClassProp r i
medias = classes [ media ]
mediaLeft :: HH.ClassName
mediaLeft = classify "media-left"
mediaLefts :: forall r i. ClassProp r i
mediaLefts = classes [ mediaLeft ]
mediaContent :: HH.ClassName
mediaContent = classify "media-content"
mediaContents :: forall r i. ClassProp r i
mediaContents = classes [ mediaContent ]
title :: HH.ClassName
title = classify "title"
titles :: forall r i. ClassProp r i
titles = classes [ title ]
subtitle :: HH.ClassName
subtitle = classify "subtitle"
subtitles :: forall r i. ClassProp r i
subtitles = classes [ subtitle ]
