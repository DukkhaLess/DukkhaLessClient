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
