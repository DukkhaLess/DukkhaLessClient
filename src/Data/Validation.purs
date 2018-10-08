module Data.Validation where

import Data.Either (Either)

newtype ValidatorG e a r = ValidatorG (a -> Either e r)

type Validator a r = ValidatorG String a r

data InputState
  = Initial
  | Dirty

data ValidationG e a r = ValidationG InputState (ValidatorG e a r) a
type Validation a r = ValidationG String a r

validation :: forall e a r. ValidatorG e a r -> a -> ValidationG e a r
validation = ValidationG Initial

validate :: forall e a r. ValidationG e a r -> Either e r
validate (ValidationG _ (ValidatorG p) a) = p a

updateValidation :: forall e a r. ValidationG e a r -> a -> ValidationG e a r
updateValidation (ValidationG _ validator _) = ValidationG Dirty validator

-- Some combinator? Hmm.