module Data.HTTP.Payloads where

import Model

import Crypt.NaCl.Types (BoxPublicKey)

type SubmitRegister =
  { publicKey :: BoxPublicKey
  , username :: Username
  , password :: Password
  , passwordConfirmation :: Password
  }