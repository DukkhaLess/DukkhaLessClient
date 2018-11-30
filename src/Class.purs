module Class where

import Data.Argonaut.Encode (class EncodeJson)

class EncodeJson a <= CipherText a