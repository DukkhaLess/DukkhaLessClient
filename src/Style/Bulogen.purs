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


-- | This module provides simple classname wrappers for Bulma Classnames
-- | The intent is to allow compile time checks of spelling, and nothing more
module Style.Bulogen where

import Halogen.HTML as HH

-- Colours
white :: HH.ClassName
white = HH.ClassName "is-white"
black :: HH.ClassName
black = HH.ClassName "is-black"
light :: HH.ClassName
light = HH.ClassName "is-light"
dark :: HH.ClassName
dark = HH.ClassName "is-dark"
primary :: HH.ClassName
primary = HH.ClassName "is-primary"
link :: HH.ClassName
link = HH.ClassName "is-link"
info :: HH.ClassName
info = HH.ClassName "is-info"
success :: HH.ClassName
success = HH.ClassName "is-success"
warning :: HH.ClassName
warning = HH.ClassName "is-warning"
danger :: HH.ClassName
danger = HH.ClassName "is-danger"

-- States

loading :: HH.ClassName
loading = HH.ClassName "is-loading"
normal :: HH.ClassName
normal = HH.ClassName "is-normal"
hovered :: HH.ClassName
hovered = HH.ClassName "is-hovered"
focused :: HH.ClassName
focused = HH.ClassName "is-focused"

-- Sizes

small :: HH.ClassName
small = HH.ClassName "is-small"
medium :: HH.ClassName
medium = HH.ClassName "is-medium"
large :: HH.ClassName
large = HH.ClassName "is-large"

-- Text sizes

size1 :: HH.ClassName
size1 = HH.ClassName "is-size-1"
size1Mobile :: HH.ClassName
size1Mobile = HH.ClassName "is-size-1-mobile"
size1Tablet :: HH.ClassName
size1Tablet = HH.ClassName "is-size-1-tablet"
size1Touch :: HH.ClassName
size1Touch = HH.ClassName "is-size-1-touch"
size1Desktop :: HH.ClassName
size1Desktop = HH.ClassName "is-size-1-desktop"
size1Widescreen :: HH.ClassName
size1Widescreen = HH.ClassName "is-size-1-widescreen"
size1FullHd :: HH.ClassName
size1FullHd = HH.ClassName "is-size-1-fullhd"
size2 :: HH.ClassName
size2 = HH.ClassName "is-size-2"
size2Mobile :: HH.ClassName
size2Mobile = HH.ClassName "is-size-2-mobile"
size2Tablet :: HH.ClassName
size2Tablet = HH.ClassName "is-size-2-tablet"
size2Touch :: HH.ClassName
size2Touch = HH.ClassName "is-size-2-touch"
size2Desktop :: HH.ClassName
size2Desktop = HH.ClassName "is-size-2-desktop"
size2Widescreen :: HH.ClassName
size2Widescreen = HH.ClassName "is-size-2-widescreen"
size2FullHd :: HH.ClassName
size2FullHd = HH.ClassName "is-size-2-fullhd"
size3 :: HH.ClassName
size3 = HH.ClassName "is-size-3"
size3Mobile :: HH.ClassName
size3Mobile = HH.ClassName "is-size-3-mobile"
size3Tablet :: HH.ClassName
size3Tablet = HH.ClassName "is-size-3-tablet"
size3Touch :: HH.ClassName
size3Touch = HH.ClassName "is-size-3-touch"
size3Desktop :: HH.ClassName
size3Desktop = HH.ClassName "is-size-3-desktop"
size3Widescreen :: HH.ClassName
size3Widescreen = HH.ClassName "is-size-3-widescreen"
size3FullHd :: HH.ClassName
size3FullHd = HH.ClassName "is-size-3-fullhd"
size4 :: HH.ClassName
size4 = HH.ClassName "is-size-4"
size4Mobile :: HH.ClassName
size4Mobile = HH.ClassName "is-size-4-mobile"
size4Tablet :: HH.ClassName
size4Tablet = HH.ClassName "is-size-4-tablet"
size4Touch :: HH.ClassName
size4Touch = HH.ClassName "is-size-4-touch"
size4Desktop :: HH.ClassName
size4Desktop = HH.ClassName "is-size-4-desktop"
size4Widescreen :: HH.ClassName
size4Widescreen = HH.ClassName "is-size-4-widescreen"
size4FullHd :: HH.ClassName
size4FullHd = HH.ClassName "is-size-4-fullhd"
size5 :: HH.ClassName
size5 = HH.ClassName "is-size-5"
size5Mobile :: HH.ClassName
size5Mobile = HH.ClassName "is-size-5-mobile"
size5Tablet :: HH.ClassName
size5Tablet = HH.ClassName "is-size-5-tablet"
size5Touch :: HH.ClassName
size5Touch = HH.ClassName "is-size-5-touch"
size5Desktop :: HH.ClassName
size5Desktop = HH.ClassName "is-size-5-desktop"
size5Widescreen :: HH.ClassName
size5Widescreen = HH.ClassName "is-size-5-widescreen"
size5FullHd :: HH.ClassName
size5FullHd = HH.ClassName "is-size-5-fullhd"
size6 :: HH.ClassName
size6 = HH.ClassName "is-size-6"
size6Mobile :: HH.ClassName
size6Mobile = HH.ClassName "is-size-6-mobile"
size6Tablet :: HH.ClassName
size6Tablet = HH.ClassName "is-size-6-tablet"
size6Touch :: HH.ClassName
size6Touch = HH.ClassName "is-size-6-touch"
size6Desktop :: HH.ClassName
size6Desktop = HH.ClassName "is-size-6-desktop"
size6Widescreen :: HH.ClassName
size6Widescreen = HH.ClassName "is-size-6-widescreen"
size6FullHd :: HH.ClassName
size6FullHd = HH.ClassName "is-size-6-fullhd"

active :: HH.ClassName
active = HH.ClassName "is-active"

outlined :: HH.ClassName
outlined = HH.ClassName "is-outlined"
inverted :: HH.ClassName
inverted = HH.ClassName "is-inverted"

-- Text properties

textLight :: HH.ClassName
textLight = HH.ClassName "has-text-light"
textDark :: HH.ClassName
textDark = HH.ClassName "has-text-dark"
textPrimary :: HH.ClassName
textPrimary = HH.ClassName "has-text-primary"
textInfo :: HH.ClassName
textInfo = HH.ClassName "has-text-info"
textSuccess :: HH.ClassName
textSuccess = HH.ClassName "has-text-success"
textWarning :: HH.ClassName
textWarning = HH.ClassName "has-text-warning"
textDanger :: HH.ClassName
textDanger = HH.ClassName "has-text-danger"

textWhite :: HH.ClassName
textWhite = HH.ClassName "has-text-white"
textWhiteBis :: HH.ClassName
textWhiteBis = HH.ClassName "has-text-white-bis"
textWhiteTer :: HH.ClassName
textWhiteTer = HH.ClassName "has-text-white-ter-"

textBlack :: HH.ClassName
textBlack = HH.ClassName "has-text-black"
textBlackBis :: HH.ClassName
textBlackBis = HH.ClassName "has-text-black-bis"
textBlackTer :: HH.ClassName
textBlackTer = HH.ClassName "has-text-black-ter"

textGrey :: HH.ClassName
textGrey = HH.ClassName "has-text-grey"
textGreyDarker :: HH.ClassName
textGreyDarker = HH.ClassName "has-text-grey-darker"
textGreyDark :: HH.ClassName
textGreyDark = HH.ClassName "has-text-grey-dark"
textGreyLight :: HH.ClassName
textGreyLight = HH.ClassName "has-text-grey-light"
textGreyLighter :: HH.ClassName
textGreyLighter = HH.ClassName "has-text-grey-lighter"

textCentered :: HH.ClassName
textCentered = HH.ClassName "has-text-centered"
textCenteredMobile :: HH.ClassName
textCenteredMobile = HH.ClassName "has-text-centered-mobile"
textCenteredTablet :: HH.ClassName
textCenteredTablet = HH.ClassName "has-text-centered-tablet"
textCenteredTabletOnly :: HH.ClassName
textCenteredTabletOnly = HH.ClassName "has-text-centered-tablet-only"
textCenteredTouch :: HH.ClassName
textCenteredTouch = HH.ClassName "has-text-centered-touch"
textCenteredDesktop :: HH.ClassName
textCenteredDesktop = HH.ClassName "has-text-centered-desktop"
textCenteredDesktopOnly :: HH.ClassName
textCenteredDesktopOnly = HH.ClassName "has-text-centered-desktop-only"
textCenteredWidescreen :: HH.ClassName
textCenteredWidescreen = HH.ClassName "has-text-centered-widescreen"
textCenteredWidescreenOnly :: HH.ClassName
textCenteredWidescreenOnly = HH.ClassName "has-text-centered-widescreen-only"
textCenteredFullHd :: HH.ClassName
textCenteredFullHd = HH.ClassName "has-text-centered-fullhd"
textJustified :: HH.ClassName
textJustified = HH.ClassName "has-text-justified"
textJustifiedMobile :: HH.ClassName
textJustifiedMobile = HH.ClassName "has-text-justified-mobile"
textJustifiedTablet :: HH.ClassName
textJustifiedTablet = HH.ClassName "has-text-justified-tablet"
textJustifiedTabletOnly :: HH.ClassName
textJustifiedTabletOnly = HH.ClassName "has-text-justified-tablet-only"
textJustifiedTouch :: HH.ClassName
textJustifiedTouch = HH.ClassName "has-text-justified-touch"
textJustifiedDesktop :: HH.ClassName
textJustifiedDesktop = HH.ClassName "has-text-justified-desktop"
textJustifiedDesktopOnly :: HH.ClassName
textJustifiedDesktopOnly = HH.ClassName "has-text-justified-desktop-only"
textJustifiedWidescreen :: HH.ClassName
textJustifiedWidescreen = HH.ClassName "has-text-justified-widescreen"
textJustifiedWidescreenOnly :: HH.ClassName
textJustifiedWidescreenOnly = HH.ClassName "has-text-justified-widescreen-only"
textJustifiedFullHd :: HH.ClassName
textJustifiedFullHd = HH.ClassName "has-text-justified-fullhd"
textLeft :: HH.ClassName
textLeft = HH.ClassName "has-text-left"
textLeftMobile :: HH.ClassName
textLeftMobile = HH.ClassName "has-text-left-mobile"
textLeftTablet :: HH.ClassName
textLeftTablet = HH.ClassName "has-text-left-tablet"
textLeftTabletOnly :: HH.ClassName
textLeftTabletOnly = HH.ClassName "has-text-left-tablet-only"
textLeftTouch :: HH.ClassName
textLeftTouch = HH.ClassName "has-text-left-touch"
textLeftDesktop :: HH.ClassName
textLeftDesktop = HH.ClassName "has-text-left-desktop"
textLeftDesktopOnly :: HH.ClassName
textLeftDesktopOnly = HH.ClassName "has-text-left-desktop-only"
textLeftWidescreen :: HH.ClassName
textLeftWidescreen = HH.ClassName "has-text-left-widescreen"
textLeftWidescreenOnly :: HH.ClassName
textLeftWidescreenOnly = HH.ClassName "has-text-left-widescreen-only"
textLeftFullHd :: HH.ClassName
textLeftFullHd = HH.ClassName "has-text-left-fullhd"
textRight :: HH.ClassName
textRight = HH.ClassName "has-text-right"
textRightMobile :: HH.ClassName
textRightMobile = HH.ClassName "has-text-right-mobile"
textRightTablet :: HH.ClassName
textRightTablet = HH.ClassName "has-text-right-tablet"
textRightTabletOnly :: HH.ClassName
textRightTabletOnly = HH.ClassName "has-text-right-tablet-only"
textRightTouch :: HH.ClassName
textRightTouch = HH.ClassName "has-text-right-touch"
textRightDesktop :: HH.ClassName
textRightDesktop = HH.ClassName "has-text-right-desktop"
textRightDesktopOnly :: HH.ClassName
textRightDesktopOnly = HH.ClassName "has-text-right-desktop-only"
textRightWidescreen :: HH.ClassName
textRightWidescreen = HH.ClassName "has-text-right-widescreen"
textRightWidescreenOnly :: HH.ClassName
textRightWidescreenOnly = HH.ClassName "has-text-right-widescreen-only"
textRightFullHd :: HH.ClassName
textRightFullHd = HH.ClassName "has-text-right-fullhd"

textWeightLight :: HH.ClassName
textWeightLight = HH.ClassName "has-text-weight-light"
textWeightNormal :: HH.ClassName
textWeightNormal = HH.ClassName "has-text-weight-normal"
textWeightSemibold :: HH.ClassName
textWeightSemibold = HH.ClassName "has-text-weight-semibold"
textWeightBold :: HH.ClassName
textWeightBold = HH.ClassName "has-text-weight-bold"

capitalize :: HH.ClassName
capitalize = HH.ClassName "is-capitalized"
lowercase :: HH.ClassName
lowercase = HH.ClassName "is-lowercase"
uppercase :: HH.ClassName
uppercase = HH.ClassName "is-uppercase"
italic :: HH.ClassName
italic = HH.ClassName "is-italic"


clearfix :: HH.ClassName
clearfix = HH.ClassName "is-clearfix"
pullLeft :: HH.ClassName
pullLeft = HH.ClassName "is-pulled-left"
pullRight :: HH.ClassName
pullRight = HH.ClassName "is-pulled-right"
cliped :: HH.ClassName
cliped = HH.ClassName "is-clipped"
overlay :: HH.ClassName
overlay = HH.ClassName "is-overlay"

transparent :: HH.ClassName
transparent = HH.ClassName "is-transparent"
invisible :: HH.ClassName
invisible = HH.ClassName "is-invisible"
marginless :: HH.ClassName
marginless = HH.ClassName "is-marginless"
paddingless :: HH.ClassName
paddingless = HH.ClassName "is-paddingless"
radiusless :: HH.ClassName
radiusless = HH.ClassName "is-radiusless"
shadowless :: HH.ClassName
shadowless = HH.ClassName "is-shadowless"
unselectable :: HH.ClassName
unselectable = HH.ClassName "is-unselectable"

mobile :: HH.ClassName
mobile = HH.ClassName "mobile"
tablet :: HH.ClassName
tablet = HH.ClassName "tablet"
tabletOnly :: HH.ClassName
tabletOnly = HH.ClassName "tablet-only"
touch :: HH.ClassName
touch = HH.ClassName "touch"
desktop :: HH.ClassName
desktop = HH.ClassName "desktop"
desktopOnly :: HH.ClassName
desktopOnly = HH.ClassName "desktopOnly"
widescreen :: HH.ClassName
widescreen = HH.ClassName "widescreen"
widescreenOnly :: HH.ClassName
widescreenOnly = HH.ClassName "widescreenOnly"
fullhd :: HH.ClassName
fullhd = HH.ClassName "fullhd"

block :: HH.ClassName
block = HH.ClassName "is-block"
blockMobile :: HH.ClassName
blockMobile = HH.ClassName "is-block-mobile"
blockTablet :: HH.ClassName
blockTablet = HH.ClassName "is-block-tablet"
blockTabletOnly :: HH.ClassName
blockTabletOnly = HH.ClassName "is-block-tablet-only"
blockDesktop :: HH.ClassName
blockDesktop = HH.ClassName "is-block-desktop"
blockDesktopOnly :: HH.ClassName
blockDesktopOnly = HH.ClassName "is-block-desktop-only"
blockWidescreen :: HH.ClassName
blockWidescreen = HH.ClassName "is-block-widescreen"
blockWidescreenOnly :: HH.ClassName
blockWidescreenOnly = HH.ClassName "is-block-widescreen-only"
blockFullHd :: HH.ClassName
blockFullHd = HH.ClassName "is-block-fullhd"

flex :: HH.ClassName
flex = HH.ClassName "is-flex"
flexMobile :: HH.ClassName
flexMobile = HH.ClassName "is-flex-mobile"
flexTablet :: HH.ClassName
flexTablet = HH.ClassName "is-flex-tablet"
flexTabletOnly :: HH.ClassName
flexTabletOnly = HH.ClassName "is-flex-tablet-only"
flexDesktop :: HH.ClassName
flexDesktop = HH.ClassName "is-flex-desktop"
flexDesktopOnly :: HH.ClassName
flexDesktopOnly = HH.ClassName "is-flex-desktop-only"
flexWidescreen :: HH.ClassName
flexWidescreen = HH.ClassName "is-flex-widescreen"
flexWidescreenOnly :: HH.ClassName
flexWidescreenOnly = HH.ClassName "is-flex-widescreen-only"
flexFullHd :: HH.ClassName
flexFullHd = HH.ClassName "is-flex-fullhd"

inline :: HH.ClassName
inline = HH.ClassName "is-inline"
inlineMobile :: HH.ClassName
inlineMobile = HH.ClassName "is-inline-mobile"
inlineTablet :: HH.ClassName
inlineTablet = HH.ClassName "is-inline-tablet"
inlineTabletOnly :: HH.ClassName
inlineTabletOnly = HH.ClassName "is-inline-tablet-only"
inlineDesktop :: HH.ClassName
inlineDesktop = HH.ClassName "is-inline-desktop"
inlineDesktopOnly :: HH.ClassName
inlineDesktopOnly = HH.ClassName "is-inline-desktop-only"
inlineWidescreen :: HH.ClassName
inlineWidescreen = HH.ClassName "is-inline-widescreen"
inlineWidescreenOnly :: HH.ClassName
inlineWidescreenOnly = HH.ClassName "is-inline-widescreen-only"
inlineFullHd :: HH.ClassName
inlineFullHd = HH.ClassName "is-inline-fullhd"

inlineBlock :: HH.ClassName
inlineBlock = HH.ClassName "is-inline-block"
inlineBlockMobile :: HH.ClassName
inlineBlockMobile = HH.ClassName "is-inline-block-mobile"
inlineBlockTablet :: HH.ClassName
inlineBlockTablet = HH.ClassName "is-inline-block-tablet"
inlineBlockTabletOnly :: HH.ClassName
inlineBlockTabletOnly = HH.ClassName "is-inline-block-tablet-only"
inlineBlockDesktop :: HH.ClassName
inlineBlockDesktop = HH.ClassName "is-inline-block-desktop"
inlineBlockDesktopOnly :: HH.ClassName
inlineBlockDesktopOnly = HH.ClassName "is-inline-block-desktop-only"
inlineBlockWidescreen :: HH.ClassName
inlineBlockWidescreen = HH.ClassName "is-inline-block-widescreen"
inlineBlockWidescreenOnly :: HH.ClassName
inlineBlockWidescreenOnly = HH.ClassName "is-inline-block-widescreen-only"
inlineBlockFullHd :: HH.ClassName
inlineBlockFullHd = HH.ClassName "is-inline-block-fullhd"

inlineFlex :: HH.ClassName
inlineFlex = HH.ClassName "is-inline-flex"
inlineFlexMobile :: HH.ClassName
inlineFlexMobile = HH.ClassName "is-inline-flex-mobile"
inlineFlexTablet :: HH.ClassName
inlineFlexTablet = HH.ClassName "is-inline-flex-tablet"
inlineFlexTabletOnly :: HH.ClassName
inlineFlexTabletOnly = HH.ClassName "is-inline-flex-tablet-only"
inlineFlexDesktop :: HH.ClassName
inlineFlexDesktop = HH.ClassName "is-inline-flex-desktop"
inlineFlexDesktopOnly :: HH.ClassName
inlineFlexDesktopOnly = HH.ClassName "is-inline-flex-desktop-only"
inlineFlexWidescreen :: HH.ClassName
inlineFlexWidescreen = HH.ClassName "is-inline-flex-widescreen"
inlineFlexWidescreenOnly :: HH.ClassName
inlineFlexWidescreenOnly = HH.ClassName "is-inline-flex-widescreen-only"
inlineFlexFullHd :: HH.ClassName
inlineFlexFullHd = HH.ClassName "is-inline-flex-fullhd"

hidden :: HH.ClassName
hidden = HH.ClassName "is-hidden"
hiddenMobile :: HH.ClassName
hiddenMobile = HH.ClassName "is-hidden-mobile"
hiddenTablet :: HH.ClassName
hiddenTablet = HH.ClassName "is-hidden-tablet"
hiddenTabletOnly :: HH.ClassName
hiddenTabletOnly = HH.ClassName "is-hidden-tablet-only"
hiddenDesktop :: HH.ClassName
hiddenDesktop = HH.ClassName "is-hidden-desktop"
hiddenDesktopOnly :: HH.ClassName
hiddenDesktopOnly = HH.ClassName "is-hidden-desktop-only"
hiddenWidescreen :: HH.ClassName
hiddenWidescreen = HH.ClassName "is-hidden-widescreen"
hiddenWidescreenOnly :: HH.ClassName
hiddenWidescreenOnly = HH.ClassName "is-hidden-widescreen-only"
hiddenFullHd :: HH.ClassName
hiddenFullHd = HH.ClassName "is-hidden-fullhd"

table :: HH.ClassName
table = HH.ClassName "table"
bordered :: HH.ClassName
bordered = HH.ClassName "is-bordered"
striped :: HH.ClassName
striped = HH.ClassName "is-striped"
hoverable :: HH.ClassName
hoverable = HH.ClassName "is-hoverable"

tag :: HH.ClassName
tag = HH.ClassName "tag"
tags :: HH.ClassName
tags = HH.ClassName "tags"

spaced :: HH.ClassName
spaced = HH.ClassName "is-spaced"

container :: HH.ClassName
container = HH.ClassName "container"


columns :: HH.ClassName
columns = HH.ClassName "columns"
column :: HH.ClassName
column = HH.ClassName "column"

fluid :: HH.ClassName
fluid = HH.ClassName "is-fluid"
narrow :: HH.ClassName
narrow = HH.ClassName "is-narrow"
gapless :: HH.ClassName
gapless = HH.ClassName "is-gapless"
multiline :: HH.ClassName
multiline = HH.ClassName "is-multiline"

content :: HH.ClassName
content = HH.ClassName "content"

hero :: HH.ClassName
hero = HH.ClassName "hero"
heroBody :: HH.ClassName
heroBody = HH.ClassName "hero-body"

media :: HH.ClassName
media = HH.ClassName "media"
mediaLeft :: HH.ClassName
mediaLeft = HH.ClassName "media-left"
mediaRight :: HH.ClassName
mediaRight = HH.ClassName "media-right"
mediaContent :: HH.ClassName
mediaContent = HH.ClassName "media-content"

level :: HH.ClassName
level = HH.ClassName "level"
levelLeft :: HH.ClassName
levelLeft = HH.ClassName "level-left"
levelRight :: HH.ClassName
levelRight = HH.ClassName "level-right"
levelItem :: HH.ClassName
levelItem = HH.ClassName "level-item"

fullwidth :: HH.ClassName
fullwidth = HH.ClassName "is-full-width"
threeQuarters :: HH.ClassName
threeQuarters = HH.ClassName "is-three-quarters"
twoThirds :: HH.ClassName
twoThirds = HH.ClassName "is-two-thirds"
half :: HH.ClassName
half = HH.ClassName "is-half"
oneThird :: HH.ClassName
oneThird = HH.ClassName "is-one-third"
oneQuarter :: HH.ClassName
oneQuarter = HH.ClassName "is-one-quarter"
fourFifths :: HH.ClassName
fourFifths = HH.ClassName "is-four-fifths"
threeFifths :: HH.ClassName
threeFifths = HH.ClassName "is-three-fifths"
twoFifths :: HH.ClassName
twoFifths = HH.ClassName "is-two-fifths"
oneFifth :: HH.ClassName
oneFifth = HH.ClassName "is-one-fifth"

offsetThreeQuarters :: HH.ClassName
offsetThreeQuarters = HH.ClassName "is-offset-three-quarters"
offsetTwoThirds :: HH.ClassName
offsetTwoThirds = HH.ClassName "is-offset-two-thirds"
offsetHalf :: HH.ClassName
offsetHalf = HH.ClassName "is-offset-half"
offsetOneThird :: HH.ClassName
offsetOneThird = HH.ClassName "is-offset-one-third"
offsetOneQuarter :: HH.ClassName
offsetOneQuarter = HH.ClassName "is-offset-one-quarter"
offsetFourFifths :: HH.ClassName
offsetFourFifths = HH.ClassName "is-offset-four-fifths"
offsetThreeFifths :: HH.ClassName
offsetThreeFifths = HH.ClassName "is-offset-three-fifths"
offsetTwoFifths :: HH.ClassName
offsetTwoFifths = HH.ClassName "is-offset-two-fifths"
offsetOneFifth :: HH.ClassName
offsetOneFifth = HH.ClassName "is-offset-one-fifth"

cols2 :: HH.ClassName
cols2 = HH.ClassName "is-2"
cols3 :: HH.ClassName
cols3 = HH.ClassName "is-3"
cols4 :: HH.ClassName
cols4 = HH.ClassName "is-4"
cols5 :: HH.ClassName
cols5 = HH.ClassName "is-5"
cols6 :: HH.ClassName
cols6 = HH.ClassName "is-6"
cols7 :: HH.ClassName
cols7 = HH.ClassName "is-7"
cols8 :: HH.ClassName
cols8 = HH.ClassName "is-8"
cols9 :: HH.ClassName
cols9 = HH.ClassName "is-9"
cols10 :: HH.ClassName
cols10 = HH.ClassName "is-10"
cols11 :: HH.ClassName
cols11 = HH.ClassName "is-11"

offset2 :: HH.ClassName
offset2 = HH.ClassName "is-offset-2"
offset3 :: HH.ClassName
offset3 = HH.ClassName "is-offset-3"
offset4 :: HH.ClassName
offset4 = HH.ClassName "is-offset-4"
offset5 :: HH.ClassName
offset5 = HH.ClassName "is-offset-5"
offset6 :: HH.ClassName
offset6 = HH.ClassName "is-offset-6"
offset7 :: HH.ClassName
offset7 = HH.ClassName "is-offset-7"
offset8 :: HH.ClassName
offset8 = HH.ClassName "is-offset-8"
offset9 :: HH.ClassName
offset9 = HH.ClassName "is-offset-9"
offset10 :: HH.ClassName
offset10 = HH.ClassName "is-offset-10"
offset11 :: HH.ClassName
offset11 = HH.ClassName "is-offset-11"

section :: HH.ClassName
section = HH.ClassName "section"

title :: HH.ClassName
title = HH.ClassName "title"
subtitle :: HH.ClassName
subtitle = HH.ClassName "subtitle"

header :: HH.ClassName
header = HH.ClassName "footer"
footer :: HH.ClassName
footer = HH.ClassName "footer"

tile :: HH.ClassName
tile = HH.ClassName "tile"

delete :: HH.ClassName
delete = HH.ClassName "delete"

image :: HH.ClassName
image = HH.ClassName "image"
square :: HH.ClassName
square = HH.ClassName "is-square"
square16 :: HH.ClassName
square16 = HH.ClassName "is-16x16"
square24 :: HH.ClassName
square24 = HH.ClassName "is-24x24"
square32 :: HH.ClassName
square32 = HH.ClassName "is-32x32"
square48 :: HH.ClassName
square48 = HH.ClassName "is-48x48"
square64 :: HH.ClassName
square64 = HH.ClassName "is-64x64"
square96 :: HH.ClassName
square96 = HH.ClassName "is-96x96"
square128 :: HH.ClassName
square128 = HH.ClassName "is-128x128"

ratio1by1 :: HH.ClassName
ratio1by1 = HH.ClassName "is-1by1"
ratio4by3 :: HH.ClassName
ratio4by3 = HH.ClassName "is-4by3"
ratio3by2 :: HH.ClassName
ratio3by2 = HH.ClassName "is-3by2"
ratio16by9 :: HH.ClassName
ratio16by9 = HH.ClassName "is-16by9"
ratio2by1 :: HH.ClassName
ratio2by1 = HH.ClassName "is-2by1"


notification :: HH.ClassName
notification = HH.ClassName "notification"
progress :: HH.ClassName
progress = HH.ClassName "progress"


control :: HH.ClassName
control = HH.ClassName "control"

box :: HH.ClassName
box = HH.ClassName "box"


selected :: HH.ClassName
selected = HH.ClassName "is-selected"


label :: HH.ClassName
label = HH.ClassName "label"
input :: HH.ClassName
input = HH.ClassName "input"
textarea :: HH.ClassName
textarea = HH.ClassName "textarea"
select :: HH.ClassName
select = HH.ClassName "select"
checkbox :: HH.ClassName
checkbox = HH.ClassName "checkbox"
radio :: HH.ClassName
radio = HH.ClassName "radio"
button :: HH.ClassName
button = HH.ClassName "button"

fixedSize :: HH.ClassName
fixedSize = HH.ClassName "has-fixed-size"
file :: HH.ClassName
file = HH.ClassName "file"
fileLabel :: HH.ClassName
fileLabel = HH.ClassName "file-label"
fileInput :: HH.ClassName
fileInput = HH.ClassName "file-input"
fileCta :: HH.ClassName
fileCta = HH.ClassName "file-cta"
fileIcon :: HH.ClassName
fileIcon = HH.ClassName "file-icon"
fileName :: HH.ClassName
fileName = HH.ClassName "file-name"

help :: HH.ClassName
help = HH.ClassName "help"


field :: HH.ClassName
field = HH.ClassName "field"
fieldLabel :: HH.ClassName
fieldLabel = HH.ClassName "field-label"
fieldBody :: HH.ClassName
fieldBody = HH.ClassName "field-body"

name :: HH.ClassName
name = HH.ClassName "has-name"

addons :: HH.ClassName
addons = HH.ClassName "has-addons"
addonsCentered :: HH.ClassName
addonsCentered = HH.ClassName "has-addons-centered"
addonsRight :: HH.ClassName
addonsRight = HH.ClassName "has-addons-right"

grouped :: HH.ClassName
grouped = HH.ClassName "is-grouped"
groupedCentered :: HH.ClassName
groupedCentered = HH.ClassName "is-grouped-centered"
groupedRight :: HH.ClassName
groupedRight = HH.ClassName "is-grouped-right"
groupedMultiline :: HH.ClassName
groupedMultiline = HH.ClassName "is-grouped-multiline"

rounded :: HH.ClassName
rounded = HH.ClassName "is-rounded"

horizontal :: HH.ClassName
horizontal = HH.ClassName "is-horizontal"

expanded :: HH.ClassName
expanded = HH.ClassName "is-expanded"

static :: HH.ClassName
static = HH.ClassName "is-static"

boxed :: HH.ClassName
boxed = HH.ClassName "is-boxed"

-- Fontawesome

icon :: HH.ClassName
icon = HH.ClassName "icon"
iconsLeft :: HH.ClassName
iconsLeft = HH.ClassName "has-icons-left"
iconsRight :: HH.ClassName
iconsRight = HH.ClassName "has-icons-right"

-- Components

-- Breadcrumb

breadcrumb :: HH.ClassName
breadcrumb = HH.ClassName "breadcrumb"
arrowSeperator :: HH.ClassName
arrowSeperator = HH.ClassName "has-arrow-separator"
bulletSeparator :: HH.ClassName
bulletSeparator = HH.ClassName "has-bullet-separator"
dotSeparator :: HH.ClassName
dotSeparator = HH.ClassName "has-dot-separator"
succeedsSeparator :: HH.ClassName
succeedsSeparator = HH.ClassName "has-succeeds-separator"

-- Card

card :: HH.ClassName
card = HH.ClassName "card"
cardHeader :: HH.ClassName
cardHeader = HH.ClassName "card-header"
cardHeaderTitle :: HH.ClassName
cardHeaderTitle = HH.ClassName "card-header-title"
cardHeaderIcon :: HH.ClassName
cardHeaderIcon = HH.ClassName "card-header-icon"
cardImage :: HH.ClassName
cardImage = HH.ClassName "card-image"
cardContent :: HH.ClassName
cardContent = HH.ClassName "card-content"
cardFooter :: HH.ClassName
cardFooter = HH.ClassName "card-footer"
cardFooterItem :: HH.ClassName
cardFooterItem = HH.ClassName "card-footer-item"

-- Dropdown

dropdown :: HH.ClassName
dropdown = HH.ClassName "dropdown"
dropdownTrigger :: HH.ClassName
dropdownTrigger = HH.ClassName "dropdown-trigger"
dropdownMenu :: HH.ClassName
dropdownMenu = HH.ClassName "dropdown-menu"
dropdownContent :: HH.ClassName
dropdownContent = HH.ClassName "dropdown-content"
dropdownItem :: HH.ClassName
dropdownItem = HH.ClassName "dropdown-item"
dropdownDivider :: HH.ClassName
dropdownDivider = HH.ClassName "dropdown-divider"

-- Menu

menu :: HH.ClassName
menu = HH.ClassName "menu"
menuLabel :: HH.ClassName
menuLabel = HH.ClassName "menu-label"
menuList :: HH.ClassName
menuList = HH.ClassName "menu-list"

-- Message

message :: HH.ClassName
message = HH.ClassName "message"
messageHeader :: HH.ClassName
messageHeader = HH.ClassName "message-header"
messageBody :: HH.ClassName
messageBody = HH.ClassName "message-body"

-- Modal

modal :: HH.ClassName
modal = HH.ClassName "modal"
modalBackground :: HH.ClassName
modalBackground = HH.ClassName "modal-background"
modalContent :: HH.ClassName
modalContent = HH.ClassName "modal-content"
modalClose :: HH.ClassName
modalClose = HH.ClassName "modal-close"

-- Navbar

navbar :: HH.ClassName
navbar = HH.ClassName "navbar"
navbarBrand :: HH.ClassName
navbarBrand = HH.ClassName "navbar-brand"
navbarBurger :: HH.ClassName
navbarBurger = HH.ClassName "navbar-burger"
burger :: HH.ClassName
burger = HH.ClassName "burger"
navbarMenu :: HH.ClassName
navbarMenu = HH.ClassName "navbar-menu"
navbarStart :: HH.ClassName
navbarStart = HH.ClassName "navbar-start"
navbarEnd :: HH.ClassName
navbarEnd = HH.ClassName "navbar-end"
navbarItem :: HH.ClassName
navbarItem = HH.ClassName "navbar-item"
navbarLink :: HH.ClassName
navbarLink = HH.ClassName "navbar-link"
navbarDropdown :: HH.ClassName
navbarDropdown = HH.ClassName "navbar-dropdown"
navbarDivider :: HH.ClassName
navbarDivider = HH.ClassName "navbar-divider"

-- for html tag
navbarFixedTop :: HH.ClassName
navbarFixedTop = HH.ClassName "has-navbar-fixed-top"
navbarFixedBottom :: HH.ClassName
navbarFixedBottom = HH.ClassName "has-navbar-fixed-bottom"
-- for navbar (ewww has)
hasDropdown :: HH.ClassName
hasDropdown = HH.ClassName "has-dropdown"
hasDropup :: HH.ClassName
hasDropup = HH.ClassName "has-dropdown-up"
fixedTop :: HH.ClassName
fixedTop = HH.ClassName "is-fixed-top"
fixedBottom :: HH.ClassName
fixedBottom = HH.ClassName "is-fixed-bottom"

-- Pagination

paginationPrevious :: HH.ClassName
paginationPrevious = HH.ClassName "pagination-previous"
paginationNext :: HH.ClassName
paginationNext = HH.ClassName "pagination-next"
paginationList :: HH.ClassName
paginationList = HH.ClassName "pagination-list"
paginationLink :: HH.ClassName
paginationLink = HH.ClassName "pagination-link"
paginationEllipsis :: HH.ClassName
paginationEllipsis = HH.ClassName "pagination-ellipsis"

-- Panel

panel :: HH.ClassName
panel = HH.ClassName "panel"
panelHeading :: HH.ClassName
panelHeading = HH.ClassName "panel-heading"
panelTabs :: HH.ClassName
panelTabs = HH.ClassName "panel-tabs"
panelBlock :: HH.ClassName
panelBlock = HH.ClassName "panel-block"

-- Tabs

tabs :: HH.ClassName
tabs = HH.ClassName "tabs"
