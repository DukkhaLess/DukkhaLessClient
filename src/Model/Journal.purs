module Model.Journal where

import Prelude

import Data.Crypto.Class (class CipherText, class Encrypt, decrypt, encrypt)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Crypto.Types (Document)

newtype JournalEntry
  = JournalEntry
    { title :: String
    , content :: String
    }