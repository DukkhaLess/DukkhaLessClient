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

module Style.Bulogen.Elements where

import Data.Array (snoc)
import Halogen.HTML as HH
import Halogen.HTML (HTML, ElemName(..), ClassName)
import Halogen.HTML.Properties as HP
import Style.Bulogen.TypeDefs (ClassProps)

element :: forall p i t2. String -> Array (HP.IProp t2 i) -> Array (HTML p i) -> HTML p i
element name = HH.element (ElemName name)

withClasses :: forall r i. Array ClassName -> ClassProps r i -> ClassProps r i
withClasses cs as = snoc as (HP.classes cs)

classy :: forall r p i. String -> Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
classy elem cs as = element elem (withClasses cs as)

classier :: forall p i. String -> Array ClassName -> Array (HTML p i) -> HTML p i
classier elem cs = classy elem cs []

a :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
a = classy "a"
a_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
a_ = classier "a"

abbr :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
abbr = classy "abbr"
abbr_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
abbr_ = classier "abbr"
address :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
address = classy "address"
address_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
address_ = classier "address"
area :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
area = classy "area"
area_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
area_ = classier "area"
article :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
article = classy "article"
article_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
article_ = classier "article"
aside :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
aside = classy "aside"
aside_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
aside_ = classier "aside"
audio :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
audio = classy "audio"
audio_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
audio_ = classier "audio"
b :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
b = classy "b"
b_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
b_ = classier "b"
base :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
base = classy "base"
base_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
base_ = classier "base"
bdi :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
bdi = classy "bdi"
bdi_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
bdi_ = classier "bdi"
bdo :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
bdo = classy "bdo"
bdo_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
bdo_ = classier "bdo"
blockquote :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
blockquote = classy "blockquote"
blockquote_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
blockquote_ = classier "blockquote"
body :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
body = classy "body"
body_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
body_ = classier "body"
br :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
br = classy "br"
br_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
br_ = classier "br"
button :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
button = classy "button"
button_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
button_ = classier "button"
canvas :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
canvas = classy "canvas"
canvas_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
canvas_ = classier "canvas"
caption :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
caption = classy "caption"
caption_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
caption_ = classier "caption"
cite :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
cite = classy "cite"
cite_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
cite_ = classier "cite"
code :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
code = classy "code"
code_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
code_ = classier "code"
col :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
col = classy "col"
col_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
col_ = classier "col"
colgroup :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
colgroup = classy "colgroup"
colgroup_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
colgroup_ = classier "colgroup"
command :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
command = classy "command"
command_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
command_ = classier "command"
datalist :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
datalist = classy "datalist"
datalist_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
datalist_ = classier "datalist"
dd :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
dd = classy "dd"
dd_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
dd_ = classier "dd"
del :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
del = classy "del"
del_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
del_ = classier "del"
details :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
details = classy "details"
details_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
details_ = classier "details"
dfn :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
dfn = classy "dfn"
dfn_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
dfn_ = classier "dfn"
dialog :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
dialog = classy "dialog"
dialog_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
dialog_ = classier "dialog"
div :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
div = classy "div"
div_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
div_ = classier "div"
dl :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
dl = classy "dl"
dl_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
dl_ = classier "dl"
dt :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
dt = classy "dt"
dt_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
dt_ = classier "dt"
em :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
em = classy "em"
em_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
em_ = classier "em"
embed :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
embed = classy "embed"
embed_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
embed_ = classier "embed"
fieldset :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
fieldset = classy "fieldset"
fieldset_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
fieldset_ = classier "fieldset"
figcaption :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
figcaption = classy "figcaption"
figcaption_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
figcaption_ = classier "figcaption"
figure :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
figure = classy "figure"
figure_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
figure_ = classier "figure"
footer :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
footer = classy "footer"
footer_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
footer_ = classier "footer"
form :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
form = classy "form"
form_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
form_ = classier "form"
h1 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h1 = classy "h1"
h1_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h1_ = classier "h1"
h1__ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h1__ = classier "h1_"
h2 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h2 = classy "h2"
h2_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h2_ = classier "h2"
h3 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h3 = classy "h3"
h3_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h3_ = classier "h3"
h4 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h4 = classy "h4"
h4_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h4_ = classier "h4"
h5 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h5 = classy "h5"
h5_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h5_ = classier "h5"
h6 :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
h6 = classy "h6"
h6_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
h6_ = classier "h6"
head :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
head = classy "head"
head_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
head_ = classier "head"
header :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
header = classy "header"
header_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
header_ = classier "header"
hr :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
hr = classy "hr"
hr_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
hr_ = classier "hr"
i :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
i = classy "i"
i_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
i_ = classier "i"
iframe :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
iframe = classy "iframe"
iframe_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
iframe_ = classier "iframe"
img :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
img = classy "img"
img_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
img_ = classier "img"
input :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
input = classy "input"
input_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
input_ = classier "input"
ins :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
ins = classy "ins"
ins_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
ins_ = classier "ins"
kbd :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
kbd = classy "kbd"
kbd_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
kbd_ = classier "kbd"
label :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
label = classy "label"
label_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
label_ = classier "label"
legend :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
legend = classy "legend"
legend_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
legend_ = classier "legend"
li :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
li = classy "li"
li_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
li_ = classier "li"
link :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
link = classy "link"
link_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
link_ = classier "link"
main :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
main = classy "main"
main_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
main_ = classier "main"
map :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
map = classy "map"
map_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
map_ = classier "map"
mark :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
mark = classy "mark"
mark_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
mark_ = classier "mark"
menu :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
menu = classy "menu"
menu_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
menu_ = classier "menu"
menuitem :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
menuitem = classy "menuitem"
menuitem_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
menuitem_ = classier "menuitem"
meta :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
meta = classy "meta"
meta_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
meta_ = classier "meta"
meter :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
meter = classy "meter"
meter_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
meter_ = classier "meter"
nav :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
nav = classy "nav"
nav_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
nav_ = classier "nav"
noscript :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
noscript = classy "noscript"
noscript_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
noscript_ = classier "noscript"
object :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
object = classy "object"
object_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
object_ = classier "object"
ol :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
ol = classy "ol"
ol_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
ol_ = classier "ol"
optgroup :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
optgroup = classy "optgroup"
optgroup_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
optgroup_ = classier "optgroup"
option :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
option = classy "option"
option_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
option_ = classier "option"
output :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
output = classy "output"
output_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
output_ = classier "output"
p :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
p = classy "p"
p_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
p_ = classier "p"
pre :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
pre = classy "pre"
pre_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
pre_ = classier "pre"
param :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
param = classy "param"
param_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
param_ = classier "param"
progress :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
progress = classy "progress"
progress_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
progress_ = classier "progress"
q :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
q = classy "q"
q_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
q_ = classier "q"
rp :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
rp = classy "rp"
rp_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
rp_ = classier "rp"
rt :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
rt = classy "rt"
rt_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
rt_ = classier "rt"
ruby :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
ruby = classy "ruby"
ruby_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
ruby_ = classier "ruby"
samp :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
samp = classy "samp"
samp_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
samp_ = classier "samp"
script :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
script = classy "script"
script_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
script_ = classier "script"
section :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
section = classy "section"
section_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
section_ = classier "section"
select :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
select = classy "select"
select_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
select_ = classier "select"
small :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
small = classy "small"
small_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
small_ = classier "small"
source :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
source = classy "source"
source_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
source_ = classier "source"
span :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
span = classy "span"
span_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
span_ = classier "span"
strong :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
strong = classy "strong"
strong_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
strong_ = classier "strong"
style :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
style = classy "style"
style_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
style_ = classier "style"
sub :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
sub = classy "sub"
sub_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
sub_ = classier "sub"
summary :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
summary = classy "summary"
summary_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
summary_ = classier "summary"
sup :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
sup = classy "sup"
sup_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
sup_ = classier "sup"
table :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
table = classy "table"
table_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
table_ = classier "table"
tbody :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
tbody = classy "tbody"
tbody_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
tbody_ = classier "tbody"
td :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
td = classy "td"
td_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
td_ = classier "td"
textarea :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
textarea = classy "textarea"
textarea_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
textarea_ = classier "textarea"
tfoot :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
tfoot = classy "tfoot"
tfoot_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
tfoot_ = classier "tfoot"
th :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
th = classy "th"
th_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
th_ = classier "th"
thead :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
thead = classy "thead"
thead_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
thead_ = classier "thead"
time :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
time = classy "time"
time_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
time_ = classier "time"
title :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
title = classy "title"
title_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
title_ = classier "title"
tr :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
tr = classy "tr"
tr_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
tr_ = classier "tr"
track :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
track = classy "track"
track_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
track_ = classier "track"
u :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
u = classy "u"
u_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
u_ = classier "u"
ul :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
ul = classy "ul"
ul_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
ul_ = classier "ul"
var :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
var = classy "var"
var_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
var_ = classier "var"
video :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
video = classy "video"
video_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
video_ = classier "video"
wbr :: forall r p i. Array ClassName -> ClassProps r i -> Array (HTML p i) -> HTML p i
wbr = classy "wbr"
wbr_ :: forall p i. Array ClassName -> Array (HTML p i) -> HTML p i
wbr_ = classier "wbr"

