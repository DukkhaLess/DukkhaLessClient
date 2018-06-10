module Intl.English where

import Data.Maybe (Maybe(..))
import Intl.Terms (Term(..))

localiseEnglishString :: Term -> Maybe String
localiseEnglishString MySelfCare = Just "My Selfcare"
localiseEnglishString _    = Nothing
