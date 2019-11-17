module Data.Validation.Rules where

import Data.Validation
import Prelude
import Data.Argonaut (decodeJson, jsonParser)
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Data.Tuple (fst, snd, Tuple)
import Intl.Terms (Term(..))
import Intl.Terms.Validation (FieldName(..), ValidationMsg(..))
import Model.Keyring (Keyring)

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Validation (InsufficientLength n)

matchingField :: forall a. (Eq a) => FieldName -> Validator (Tuple a a) a
matchingField name = val <#> snd
  where
  val = validator' (\t -> eq (fst t) (snd t)) $ Validation (MustMatchOtherField Password)

parsableKeyring :: Validator String Keyring
parsableKeyring = validator (lmap (Validation <<< ParserFailed) <$> (jsonParser >=> decodeJson))
