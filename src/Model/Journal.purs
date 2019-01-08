module Model.Journal where

import Prelude

import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Crypto.Class (class CipherText, class Encrypt, decrypt, encrypt)
import Data.Crypto.Types (Document, DocumentId, DocumentMetaData(..))
import Data.DateTime (DateTime(..))
import Data.Maybe (Maybe)

newtype JournalEntry
  = JournalEntry
    { title :: String
    , content :: String
    , createdAt :: DateTime
    , updatedAt :: DateTime
    }

newtype JournalMeta
  = JournalMeta
    { title :: String
    , createdAt :: DateTime
    , updatedAt :: DateTime
    , id :: Maybe DocumentId
    }
{-
instance encryptJournalMeta :: Encrypt JournalMeta DocumentMetaData where
  encrypt = ?encJournal
  decrypt = ?decJournal

instance encryptJournalEntry :: Encrypt JournalEntry Document where
  encrypt = ?entEntry
  decrypt = ?decEntry
-}
