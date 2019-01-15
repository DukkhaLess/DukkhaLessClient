module Model.Journal where

import Prelude

import Data.Crypto.Class (class Encrypt, decrypt, encrypt)
import Data.Crypto.Types (Document(..), DocumentId, DocumentMetaData(..))
import Data.Default
import Data.Map (Map, empty)
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (unwrap, wrap, class Newtype)
import Data.DateTime (DateTime)
import Effect.Now (nowDateTime)

newtype JournalMeta
  = JournalMeta
    { title :: String
    , createdAt :: Maybe DateTime
    , lastUpdated :: Maybe DateTime
    , id :: Maybe DocumentId
    }

derive instance newtypeJournalMeta :: Newtype JournalMeta _

instance defaultJournalMeta :: Default JournalMeta where
  default
    = JournalMeta
      { title: ""
      , createdAt: Nothing
      , lastUpdated: Nothing
      , id: Nothing
      }

instance encryptJournalMeta :: Encrypt JournalMeta DocumentMetaData where
  encrypt (JournalMeta meta) keyFn ring = do
    title <- encrypt meta.title keyFn ring
    createdAt <- maybe nowDateTime pure meta.createdAt
    lastUpdated <- maybe nowDateTime pure meta.lastUpdated
    pure $ DocumentMetaData {
      title: wrap title,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
      id: meta.id
    }
  decrypt (DocumentMetaData documentMeta) ring = do
    let titleCt = unwrap documentMeta.title
    title <- decrypt titleCt ring
    pure $ JournalMeta {
      title: title,
      createdAt: Just documentMeta.createdAt,
      lastUpdated: Just documentMeta.lastUpdated,
      id: documentMeta.id
    }

newtype JournalEntry
  = JournalEntry
    { content :: String
    , metaData :: JournalMeta
    }

derive instance newtypeJournalEntry :: Newtype JournalEntry _

instance defaultJournalEntry :: Default JournalEntry where
  default
    = JournalEntry
      { content: ""
      , metaData: default
      }

instance encryptJournalEntry :: Encrypt JournalEntry Document where
  encrypt (JournalEntry entry) keyFn ring = do
    meta <- encrypt entry.metaData keyFn ring
    contents <- encrypt entry.content keyFn ring
    pure $ Document {
      metaData: meta,
      content: wrap contents
    }
  decrypt (Document document) ring = do
    meta <- decrypt document.metaData ring
    contents <- decrypt (unwrap document.content) ring
    pure $ JournalEntry {
      content: contents,
      metaData: meta
    }

newtype JournalsState
  = JournalsState
    { openForEdit :: Maybe JournalEntry
    , cachedMeta :: Map DocumentId JournalMeta
    }

instance defaultJournalsState :: Default JournalsState where
  default
    = JournalsState
      { openForEdit: Nothing
      , cachedMeta: empty
      }

derive instance newtypeJournalsState :: Newtype JournalsState _
