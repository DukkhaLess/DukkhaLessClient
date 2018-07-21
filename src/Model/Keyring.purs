module Model.Keyring where

import Prelude    (pure, bind, ($))
import Effect     (Effect)
import Crypt.NaCl (generateBoxKeyPair, generateSecretBoxKey)
import Crypt.NaCl.Types (BoxKeyPair, SecretBoxKey)

generateKeyring :: Effect Keyring
generateKeyring = do
  boxKeyPair <- generateBoxKeyPair
  secretBoxKey <- generateSecretBoxKey
  pure $ Keyring { secretBoxKey: secretBoxKey, boxKeyPair: boxKeyPair }

newtype Keyring = Keyring
  { secretBoxKey :: SecretBoxKey
  , boxKeyPair :: BoxKeyPair
  }

