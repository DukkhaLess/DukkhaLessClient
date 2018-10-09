module Data.Validation where

import Data.Bifunctor (lmap)
import Data.Either (Either(..), either)
import Data.Functor ((<#>), class Functor)
import Data.Newtype (class Newtype, wrap, unwrap)
import Data.Semigroup (append, class Semigroup)
import Data.Tuple (Tuple(..))
import Intl.Terms (Term)
import Prelude (pure, const, (<<<), map, ($))

newtype ValidationError = ValidationError Term
derive instance newtypeValidationError :: Newtype ValidationError _

type ValidationErrors = Array ValidationError

newtype ValidatorG e a r = ValidatorG (a -> Either e r)
derive instance newtypeValidatorG :: Newtype (ValidatorG e a r) _
instance functorValidatorG :: Functor (ValidatorG e a) where
  map f g = wrap $ map (map f) (unwrap g)

instance semigroupValidatorG :: Semigroup (ValidatorG (Array ValidationError) a r) where
  append (ValidatorG f) (ValidatorG g) = ValidatorG h where
    h :: a -> Either ValidationErrors r
    h a = case f a of
      Left errs ->
        Left $ either (append errs) (const errs) (g a)
      Right rs ->
        g a

type Validator a r = ValidatorG ValidationErrors a r

validator' :: forall a. (a -> Boolean) -> Term -> Validator a a
validator' p e = validator f where
  f :: a -> Either Term a
  f i =
   case p i of
      true -> Right i
      false -> Left e

validator :: forall a r. (a -> Either Term r) -> Validator a r
validator f = ValidatorG f' where
  f' = f <#> lmap (pure <<< wrap)

validator_ :: forall a r. (Newtype r a) => (a -> Boolean) -> Term -> Validator a r
validator_ p e = validator' p e <#> wrap

data InputState
  = Initial
  | Dirty

data ValidationG e a r = ValidationG InputState (ValidatorG e a r) a

type Validation a r = ValidationG ValidationErrors a r

validation :: forall e a r. ValidatorG e a r -> a -> ValidationG e a r
validation = ValidationG Initial

inputState :: forall e a r. ValidationG e a r -> InputState
inputState (ValidationG i _ _) = i

validate :: forall e a r. ValidationG e a r -> Either e r
validate (ValidationG _ (ValidatorG p) a) = p a

updateValidation :: forall e a r. ValidationG e a r -> a -> ValidationG e a r
updateValidation (ValidationG _ v _) = ValidationG Dirty v

combine :: forall a1 r1 a2 r2. Validation a1 r1 -> Validation a2 r2 -> Validation (Tuple a1 a2) (Tuple r1 r2)
combine (ValidationG _ v1 i1) (ValidationG _ v2 i2) = ValidationG Dirty (ValidatorG combined) (Tuple i1 i2) where
  combined :: Tuple a1 a2 -> Either ValidationErrors (Tuple r1 r2)
  combined (Tuple f s) = result where
    result :: Either ValidationErrors (Tuple r1 r2)
    result = case l of
      Left errs ->
        Left $ either (append errs) (const errs) r
      Right rs ->
        map (Tuple rs) r
    l :: Either ValidationErrors r1
    l = unwrap v1 $ f
    r :: Either ValidationErrors r2
    r = unwrap v2 $ s