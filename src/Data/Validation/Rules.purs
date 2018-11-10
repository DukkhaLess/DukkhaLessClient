module Data.Validation.Rules where

import Data.Validation
import Prelude

import Data.ArrayBuffer.ArrayBuffer (decodeToString)
import Data.Base64 (Base64(..))
import Data.Base64 (Base64(..), decodeBase64)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), note)
import Data.Eq (eq, class Eq)
import Data.Ord (greaterThanOrEq)
import Data.String (length)
import Data.String.Read (read)
import Data.Tuple (fst, snd, Tuple)
import Effect.Exception (message)
import Intl.Terms (Term(Validation))
import Intl.Terms.Validation (FieldName(..), ValidationMsg(..))
import Model.Keyring (Keyring(..))

minimumLength :: Int -> Validator String String
minimumLength n = validator' ((flip greaterThanOrEq $ n) <<< length) $ Validation (InsufficientLength n)

matchingField :: forall a. (Eq a) => FieldName -> Validator (Tuple a a) a
matchingField name = val <#> snd where
  val = validator' (\t -> eq (fst t) (snd t)) $ Validation (MustMatchOtherField Password)

parsableKeyring :: Validator String Keyring
parsableKeyring = validator (parser <#> (lmap (Validation <<< ParserFailed))) where
  parser :: String -> Either String Keyring
  parser = Base64 >>> decodeBase64 >>> (note "Could not decode base64 content") >=> (decodeToString <#> (lmap message)) >=> read