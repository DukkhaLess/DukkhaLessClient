module Model.Keyring where

import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey)

newtype Keyring = Keyring
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

