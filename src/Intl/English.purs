module Intl.English where

import Data.Maybe (Maybe(..))
import Intl.TypeDefs (Term(..))

localiseEnglishString :: Term -> Maybe String
localiseEnglishString Unit = Just "Nothing"
localiseEnglishString _    = Nothing
