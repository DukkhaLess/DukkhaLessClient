module Intl.Terms.Validation where

data FieldName
  = Password

data CharacterType
  = Letters
  | Capitalized
  | NonLetters

data ValidationMsg
  = InsufficientLength Int
  | RequiredCharacters (Array CharacterType)
  | MustMatchOtherField FieldName