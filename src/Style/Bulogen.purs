module Style.Bulogen where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type Class r i = HP.IProp ( "class" :: String | r ) i

classify :: String -> HH.ClassName
classify = HH.ClassName

-- classes :: forall r i. Array HH.ClassName -> Class r i
-- classes = HP.classes

-- Colours

white = classify "is-white"
black = classify "is-black"
light = classify "is-light"
dark = classify "is-dark"
primary = classify "is-primary"
link = classify "is-link"
info = classify "is-info"
success = classify "is-success"
warning = classify "is-warning"
danger = classify "is-danger"

-- States

loading = classify "is-loading"
normal = classify "is-normal"
hovered = classify "is-hovered"
focused = classify "is-focused"

-- Sizes

small = classify "is-small"
medium = classify "is-medium"
large = classify "is-large"

-- Text sizes

size1 = classify "is-size-1"
size1Mobile = classify "is-size-1-mobile"
size1Tablet = classify "is-size-1-tablet"
size1Touch = classify "is-size-1-touch"
size1Desktop = classify "is-size-1-desktop"
size1Widescreen = classify "is-size-1-widescreen"
size1Fullhd = classify "is-size-1-fullhd"
size2 = classify "is-size-2"
size2Mobile = classify "is-size-2-mobile"
size2Tablet = classify "is-size-2-tablet"
size2Touch = classify "is-size-2-touch"
size2Desktop = classify "is-size-2-desktop"
size2Widescreen = classify "is-size-2-widescreen"
size2Fullhd = classify "is-size-2-fullhd"
size3 = classify "is-size-3"
size3Mobile = classify "is-size-3-mobile"
size3Tablet = classify "is-size-3-tablet"
size3Touch = classify "is-size-3-touch"
size3Desktop = classify "is-size-3-desktop"
size3Widescreen = classify "is-size-3-widescreen"
size3Fullhd = classify "is-size-3-fullhd"
size4 = classify "is-size-4"
size4Mobile = classify "is-size-4-mobile"
size4Tablet = classify "is-size-4-tablet"
size4Touch = classify "is-size-4-touch"
size4Desktop = classify "is-size-4-desktop"
size4Widescreen = classify "is-size-4-widescreen"
size4Fullhd = classify "is-size-4-fullhd"
size5 = classify "is-size-5"
size5Mobile = classify "is-size-5-mobile"
size5Tablet = classify "is-size-5-tablet"
size5Touch = classify "is-size-5-touch"
size5Desktop = classify "is-size-5-desktop"
size5Widescreen = classify "is-size-5-widescreen"
size5Fullhd = classify "is-size-5-fullhd"
size6 = classify "is-size-6"
size6Mobile = classify "is-size-6-mobile"
size6Tablet = classify "is-size-6-tablet"
size6Touch = classify "is-size-6-touch"
size6Desktop = classify "is-size-6-desktop"
size6Widescreen = classify "is-size-6-widescreen"
size6Fullhd = classify "is-size-6-fullhd"

active = classify "is-active"

outlined = classify "is-outlined"
inverted = classify "is-inverted"

-- Text properties

textLight = classify "has-text-light"
textDark = classify "has-text-dark"
textPrimary = classify "has-text-primary"
textInfo = classify "has-text-info"
textSuccess = classify "has-text-success"
textWarning = classify "has-text-warning"
textDanger = classify "has-text-danger"

textWhite = classify "has-text-white"
textWhiteBis = classify "has-text-white-bis"
textWhiteTer = classify "has-text-white-ter-"

textBlack = classify "has-text-black"
textBlackBis = classify "has-text-black-bis"
textBlackTer = classify "has-text-black-ter"

textGrey = classify "has-text-grey"
textGreyDarker = classify "has-text-grey-darker"
textGreyDark = classify "has-text-grey-dark"
textGreyLight = classify "has-text-grey-light"
textGreyLighter = classify "has-text-grey-lighter"

textCentered = classify "has-text-centered"
textCenteredMobile = classify "has-text-centered-mobile"
textCenteredTablet = classify "has-text-centered-tablet"
textCenteredTabletOnly = classify "has-text-centered-tablet-only"
textCenteredTouch = classify "has-text-centered-touch"
textCenteredDesktop = classify "has-text-centered-desktop"
textCenteredDesktopOnly = classify "has-text-centered-desktop-only"
textCenteredWidescreen = classify "has-text-centered-widescreen"
textCenteredWidescreenOnly = classify "has-text-centered-widescreen-only"
textCenteredFullhd = classify "has-text-centered-fullhd"
textJustified = classify "has-text-justified"
textJustifiedMobile = classify "has-text-justified-mobile"
textJustifiedTablet = classify "has-text-justified-tablet"
textJustifiedTabletOnly = classify "has-text-justified-tablet-only"
textJustifiedTouch = classify "has-text-justified-touch"
textJustifiedDesktop = classify "has-text-justified-desktop"
textJustifiedDesktopOnly = classify "has-text-justified-desktop-only"
textJustifiedWidescreen = classify "has-text-justified-widescreen"
textJustifiedWidescreenOnly = classify "has-text-justified-widescreen-only"
textJustifiedFullhd = classify "has-text-justified-fullhd"
textLeft = classify "has-text-left"
textLeftMobile = classify "has-text-left-mobile"
textLeftTablet = classify "has-text-left-tablet"
textLeftTabletOnly = classify "has-text-left-tablet-only"
textLeftTouch = classify "has-text-left-touch"
textLeftDesktop = classify "has-text-left-desktop"
textLeftDesktopOnly = classify "has-text-left-desktop-only"
textLeftWidescreen = classify "has-text-left-widescreen"
textLeftWidescreenOnly = classify "has-text-left-widescreen-only"
textLeftFullhd = classify "has-text-left-fullhd"
textRight = classify "has-text-right"
textRightMobile = classify "has-text-right-mobile"
textRightTablet = classify "has-text-right-tablet"
textRightTabletOnly = classify "has-text-right-tablet-only"
textRightTouch = classify "has-text-right-touch"
textRightDesktop = classify "has-text-right-desktop"
textRightDesktopOnly = classify "has-text-right-desktop-only"
textRightWidescreen = classify "has-text-right-widescreen"
textRightWidescreenOnly = classify "has-text-right-widescreen-only"
textRightFullhd = classify "has-text-right-fullhd"

textWeightLight = classify "has-text-weight-light"
textWeightNormal = classify "has-text-weight-normal"
textWeightSemibold = classify "has-text-weight-semibold"
textWeightBold = classify "has-text-weight-bold"

capitalize = classify "is-capitalized"
lowercase = classify "is-lowercase"
uppercase = classify "is-uppercase"
italic = classify "is-italic"


clearfix = classify "is-clearfix"
pullLeft = classify "is-pulled-left"
pullRight = classify "is-pulled-right"
clip = classify "is-clipped"
overlay = classify "is-overlay"

transparent = classify "is-transparent"
invisible = classify "is-invisible"
marginless = classify "is-marginless"
paddingless = classify "is-paddingless"
radiusless = classify "is-radiusless"
shadowless = classify "is-shadowless"
unselectable = classify "is-unselectable"

mobile = classify "mobile"
tablet = classify "tablet"
tabletOnly = classify "tablet-only"
touch = classify "touch"
desktop = classify "desktop"
desktopOnly = classify "desktopOnly"
widescreen = classify "widescreen"
widescreenOnly = classify "widescreenOnly"
fullhd = classify "fullhd"

block = classify "is-block"
blockMobile = classify "is-block-mobile"
blockTablet = classify "is-block-tablet"
blockTabletOnly = classify "is-block-tablet-only"
blockDesktop = classify "is-block-desktop"
blockDesktopOnly = classify "is-block-desktop-only"
blockWidescreen = classify "is-block-widescreen"
blockWidescreenOnly = classify "is-block-widescreen-only"
blockFullHd = classify "is-block-fullhd"

flex = classify "is-flex"
flexMobile = classify "is-flex-mobile"
flexTablet = classify "is-flex-tablet"
flexTabletOnly = classify "is-flex-tablet-only"
flexDesktop = classify "is-flex-desktop"
flexDesktopOnly = classify "is-flex-desktop-only"
flexWidescreen = classify "is-flex-widescreen"
flexWidescreenOnly = classify "is-flex-widescreen-only"
flexFullHd = classify "is-flex-fullhd"

inline = classify "is-inline"
inlineMobile = classify "is-inline-mobile"
inlineTablet = classify "is-inline-tablet"
inlineTabletOnly = classify "is-inline-tablet-only"
inlineDesktop = classify "is-inline-desktop"
inlineDesktopOnly = classify "is-inline-desktop-only"
inlineWidescreen = classify "is-inline-widescreen"
inlineWidescreenOnly = classify "is-inline-widescreen-only"
inlineFullHd = classify "is-inline-fullhd"

inlineBlock = classify "is-inline-block"
inlineBlockMobile = classify "is-inline-block-mobile"
inlineBlockTablet = classify "is-inline-block-tablet"
inlineBlockTabletOnly = classify "is-inline-block-tablet-only"
inlineBlockDesktop = classify "is-inline-block-desktop"
inlineBlockDesktopOnly = classify "is-inline-block-desktop-only"
inlineBlockWidescreen = classify "is-inline-block-widescreen"
inlineBlockWidescreenOnly = classify "is-inline-block-widescreen-only"
inlineBlockFullHd = classify "is-inline-block-fullhd"

inlineFlex = classify "is-inline-flex"
inlineFlexMobile = classify "is-inline-flex-mobile"
inlineFlexTablet = classify "is-inline-flex-tablet"
inlineFlexTabletOnly = classify "is-inline-flex-tablet-only"
inlineFlexDesktop = classify "is-inline-flex-desktop"
inlineFlexDesktopOnly = classify "is-inline-flex-desktop-only"
inlineFlexWidescreen = classify "is-inline-flex-widescreen"
inlineFlexWidescreenOnly = classify "is-inline-flex-widescreen-only"
inlineFlexFullHd = classify "is-inline-flex-fullhd"

hidden = classify "is-hidden"
hiddenMobile = classify "is-hidden-mobile"
hiddenTablet = classify "is-hidden-tablet"
hiddenTabletOnly = classify "is-hidden-tablet-only"
hiddenDesktop = classify "is-hidden-desktop"
hiddenDesktopOnly = classify "is-hidden-desktop-only"
hiddenWidescreen = classify "is-hidden-widescreen"
hiddenWidescreenOnly = classify "is-hidden-widescreen-only"
hiddenFullHd = classify "is-hidden-fullhd"

table = classify "table"
bordered = classify "is-bordered"
striped = classify "is-striped"
hoverable = classify "is-hoverable"

tag = classify "tag"
tags = classify "tags"

spaced = classify "is-spaced"

container = classify "container"


columns = classify "columns"
column = classify "column"

fluid = classify "is-fluid"
narrow = classify "is-narrow"
gapless = classify "is-gapless"
multiline = classify "is-multiline"

content = classify "content"

hero = classify "hero"
heroBody = classify "hero-body"

media = classify "media"
mediaLeft = classify "media-left"
mediaRight = classify "media-right"
mediaContent = classify "media-content"

level = classify "level"
levelLeft = classify "level-left"
levelRight = classify "level-right"
levelItem = classify "level-item"

fullwidth = classify "is-full-width"
threeQuarters = classify "is-three-quarters"
twoThirds = classify "is-two-thirds"
half = classify "is-half"
oneThird = classify "is-one-third"
oneQuarter = classify "is-one-quarter"
fourFifths = classify "is-four-fifths"
threeFifths = classify "is-three-fifths"
twoFifths = classify "is-two-fifths"
oneFifth = classify "is-one-fifth"

offsetThreeQuarters = classify "is-offset-three-quarters"
offsetTwoThirds = classify "is-offset-two-thirds"
offsetHalf = classify "is-offset-half"
offsetOneThird = classify "is-offset-one-third"
offsetOneQuarter = classify "is-offset-one-quarter"
offsetFourFifths = classify "is-offset-four-fifths"
offsetThreeFifths = classify "is-offset-three-fifths"
offsetTwoFifths = classify "is-offset-two-fifths"
offsetOneFifth = classify "is-offset-one-fifth"

cols2 = classify "is-2"
cols3 = classify "is-3"
cols4 = classify "is-4"
cols5 = classify "is-5"
cols6 = classify "is-6"
cols7 = classify "is-7"
cols8 = classify "is-8"
cols9 = classify "is-9"
cols10 = classify "is-10"
cols11 = classify "is-11"

offset2 = classify "is-offset-2"
offset3 = classify "is-offset-3"
offset4 = classify "is-offset-4"
offset5 = classify "is-offset-5"
offset6 = classify "is-offset-6"
offset7 = classify "is-offset-7"
offset8 = classify "is-offset-8"
offset9 = classify "is-offset-9"
offset10 = classify "is-offset-10"
offset11 = classify "is-offset-11"

section = classify "section"

title = classify "title"
subtitle = classify "subtitle"

header = classify "footer"
footer = classify "footer"

tile = classify "tile"

delete = classify "delete"

image = classify "image"
square = classify "is-square"
square16 = classify "is-16x16"
square24 = classify "is-24x24"
square32 = classify "is-32x32"
square48 = classify "is-48x48"
square64 = classify "is-64x64"
square96 = classify "is-96x96"
square128 = classify "is-128x128"

ratio1by1 = classify "is-1by1"
ratio4by3 = classify "is-4by3"
ratio3by2 = classify "is-3by2"
ratio16by9 = classify "is-16by9"
ratio2by1 = classify "is-2by1"


notification = classify "notification"
progress = classify "progress"


control = classify "control"

box = classify "box"


selected = classify "is-selected"


label = classify "label"
input = classify "input"
textarea = classify "textarea"
select = classify "select"
checkbox = classify "checkbox"
radio = classify "radio"
button = classify "button"

file = classify "file"
fileLabel = classify "file-label"
fileInput = classify "file-input"
fileCta = classify "file-cta"
fileIcon = classify "file-icon"
fileName = classify "file-name"

help = classify "help"


field = classify "field"
fieldLabel = classify "field-label"
fieldBody = classify "field-body"

name = classify "has-name"

addons = classify "has-addons"
addonsCentered = classify "has-addons-centered"
addonsRight = classify "has-addons-right"

grouped = classify "is-grouped"
groupedCentered = classify "is-grouped-centered"
groupedRight = classify "is-grouped-right"
groupedMultiline = classify "is-grouped-multiline"

rounded = classify "is-rounded"

horizontal = classify "is-horizontal"

expanded = classify "is-expanded"

static = classify "is-static"

boxed = classify "is-boxed"

-- Fontawesome

icon = classify "icon"
iconsLeft = classify "has-icons-left"
iconsRight = classify "has-icons-right"

-- Components

-- Breadcrumb

breadcrumb = classify "breadcrumb"
arrowSeperator = classify "has-arrow-separator"
bulletSeparator = classify "has-bullet-separator"
dotSeparator = classify "has-dot-separator"
succeedsSeparator = classify "has-succeeds-separator"

-- Card

card = classify "card"
cardHeader = classify "card-header"
cardHeaderTitle = classify "card-header-title"
cardHeaderIcon = classify "card-header-icon"
cardImage = classify "card-image"
cardContent = classify "card-content"
cardFooter = classify "card-footer"
cardFooterItem = classify "card-footer-item"

-- Dropdown

dropdown = classify "dropdown"
dropdownTrigger = classify "dropdown-trigger"
dropdownMenu = classify "dropdown-menu"
dropdownContent = classify "dropdown-content"
dropdownItem = classify "dropdown-item"
dropdownDivider = classify "dropdown-divider"

-- Menu

menu = classify "menu"
menuLabel = classify "menu-label"
menuList = classify "menu-list"

-- Message

message = classify "message"
messageHeader = classify "message-header"
messageBody = classify "message-body"

-- Modal

modal = classify "modal"
modalBackground = classify "modal-background"
modalContent = classify "modal-content"
modalClose = classify "modal-close"

-- Navbar

navbar = classify "navbar"
navbarBrand = classify "navbar-brand"
navbarBurger = classify "navbar-burger"
navbarMenu = classify "navbar-menu"
navbarStart = classify "navbar-start"
navbarEnd = classify "navbar-end"
navbarItem = classify "navbar-item"
navbarLink = classify "navbar-link"
navbarDropdown = classify "navbar-dropdown"
navbarDivider = classify "navbar-divider"

-- for html tag
navbarFixedTop = classify "has-navbar-fixed-top"
navbarFixedBottom = classify "has-navbar-fixed-bottom"
-- for navbar (ewww has)
hasDropdown = classify "has-dropdown"
hasDropup = classify "has-dropdown-up"
fixedTop = classify "is-fixed-top"
fixedBottom = classify "is-fixed-bottom"

-- Pagination

paginationPrevious = classify "pagination-previous"
paginationNext = classify "pagination-next"
paginationList = classify "pagination-list"
paginationLink = classify "pagination-link"
paginationEllipsis = classify "pagination-ellipsis"

-- Panel

panel = classify "panel"
panelHeading = classify "panel-heading"
panelTabs = classify "panel-tabs"
panelBlock = classify "panel-block"

-- Tabs

tabs = classify "tabs"

