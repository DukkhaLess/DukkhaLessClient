module Data.Validation where

import Prelude (pure)
import Data.Either (Either)
import Data.Newtype (class Newtype, wrap)

newtype ValidationError = ValidationError String
derive instance newtypeValidationError :: Newtype ValidationError _

type ValidationErrors = Array ValidationError

newtype ValidatorG e a r = ValidatorG (a -> Either e r)

type Validator a r = ValidatorG ValidationErrors a r

validator :: forall a r. (a -> Either String r) -> Validator a r
validator = lmap (pure <<< wrap)

data InputState
  = Initial
  | Dirty

data ValidationG e a r = ValidationG InputState (ValidatorG e a r) a
type Validation a r = ValidationG ValidationErrors a r

validation :: forall e a r. ValidatorG e a r -> a -> ValidationG e a r
validation = ValidationG Initial

validate :: forall e a r. ValidationG e a r -> Either e r
validate (ValidationG _ (ValidatorG p) a) = p a

updateValidation :: forall e a r. ValidationG e a r -> a -> ValidationG e a r
updateValidation (ValidationG _ validator _) = ValidationG Dirty validator

combine :: forall a1 r1 a2 r2. Validation a1 r1 -> Validation a2 r2 -> Validation (a1, a2) (r1, r2)
combine (ValidationG _ v1 i1) (ValidationG _ v2 i2) = ValidationG Dirty combined (i1, i2) where
  -- combined :: (a1, a2) -> Either ValidationErrors (r1, r2)
  combined = map v1 ()