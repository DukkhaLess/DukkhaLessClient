module Class where

import Effect (Effect)
import Data.Argonaut.Encode (class EncodeJson)

class EncodeJson a <= CipherText a

class CipherText b <= Encrypt a b where
  encrypt :: a -> Effect b
  decrypt :: b -> Effect a
