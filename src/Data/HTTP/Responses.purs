module Data.HTTP.Responses where

import Model

import Crypt.NaCl.Class (toUint8Array)
import Crypt.NaCl.Types (BoxPublicKey(..))
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Newtype (class Newtype, unwrap)
import Model.Keyring (encodeKey)