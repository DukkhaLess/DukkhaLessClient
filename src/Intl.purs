module Intl where

import Intl.TypeDefs (Language(..), Term)
import Intl.English  (localiseEnglishString)

localiseString :: Language -> Term -> String
localiseString English = localiseEnglishString
