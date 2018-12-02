module Model.Journal where

import Prelude

import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Model.Document (Document)

newtype JournalEntry
  = JournalEntry
    { title :: String
    , content :: String
    }

instance encryptJournalEntry :: Encrypt JournalEntry Document where
  encrypt = foo
  decrypt = foo