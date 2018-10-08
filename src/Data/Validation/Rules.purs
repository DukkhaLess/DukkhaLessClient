module Data.Validation.Rules where

import Data.Validation

import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Prelude ((<<<), flip, ($))
import Intl.Terms.Sessions
import Intl.Terms

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Session Login