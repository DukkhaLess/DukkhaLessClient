module Intl.Terms.Validation where

data FieldName
  = Password

data ValidationMsg
  = InsufficientLength Int
  | RequiredCharacters String
  | MustMatchOtherField FieldName