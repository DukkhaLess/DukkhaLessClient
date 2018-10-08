module Data.Validation.Rules where

import Data.Validation

import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Intl.Terms (Term(Validation))
import Intl.Terms.Validation (FieldName(..), ValidationMsg(..))
import Prelude ((<<<), flip, ($))

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Validation (InsufficientLength n)