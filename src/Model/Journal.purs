module Model.Journal where

import Prelude

import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Crypto.Class (class CipherText, class Encrypt, decrypt, encrypt)
import Data.Crypto.Types (Document(..), DocumentId, DocumentMetaData(..))
import Data.Newtype (unwrap, wrap)
import Data.DateTime (DateTime(..))
import Data.Maybe (Maybe)

newtype JournalEntry
  = JournalEntry
    { title :: String
    , content :: String
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    }

newtype JournalMeta
  = JournalMeta
    { title :: String
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , id :: Maybe DocumentId
    }

instance encryptJournalEntry :: Encrypt JournalEntry Document where
  encrypt entry keyFn ring = ?entEntry
  decrypt (Document document) ring = do
    ?impl

instance encryptJournalMeta :: Encrypt JournalMeta DocumentMetaData where
  encrypt meta keyFn ring = ?encryptJournalMeta
  decrypt (DocumentMetaData documentMeta) ring = do
    let titleCt = unwrap documentMeta.title
    title <- decrypt titleCt ring
    pure $ JournalMeta {
      title: title,
      createdAt: documentMeta.createdAt,
      lastUpdated: documentMeta.lastUpdated,
      id: documentMeta.id
    }

    