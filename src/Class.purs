module Class where

import Data.Either (Either)
import Data.Argonaut.Encode (class EncodeJson)

class EncodeJson a <= CipherText a

data DecryptionError
  = Description String

class CipherText b <= Encrypt a b where
  encrypt :: a -> b
  decrypt :: b -> Either DecryptionError a
