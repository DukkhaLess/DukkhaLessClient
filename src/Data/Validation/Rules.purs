module Data.Validation.Rules where

import Data.Validation

import Data.Eq (eq, class Eq)
import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Data.Tuple (fst, snd, Tuple)
import Intl.Terms (Term(Validation))
import Intl.Terms.Validation (FieldName(..), ValidationMsg(..))
import Prelude ((<<<), flip, ($), (<#>))

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Validation (InsufficientLength n)

matchingField :: forall a. (Eq a) => FieldName -> Validator (Tuple a a) a
matchingField name = val <#> snd where
  val = validator' (\t -> eq (fst t) (snd t)) $ Validation (MustMatchOtherField Password)