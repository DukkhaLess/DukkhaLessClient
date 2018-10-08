module Data.Validation.Rules where

import Data.Validation

import Data.Eq (eq)
import Data.Maybe (maybe, Maybe)
import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Data.Tuple (fst, snd, Tuple)
import Intl.Terms (Term(Validation))
import Intl.Terms.Validation (FieldName(..), ValidationMsg(..))
import Prelude ((<<<), flip, ($), (<#>))

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Validation (InsufficientLength n)

matchingField :: FieldName -> Validator (Tuple (Maybe String) String) String
matchingField name = val <#> snd where
  val = validator' (\t -> maybe false (eq (snd t)) $ fst t) $ Validation (MustMatchOtherField Password)