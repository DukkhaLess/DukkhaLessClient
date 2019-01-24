module Model.Journal where

import Data.Default
import Prelude

import Data.Crypto.Class (class Encrypt, decrypt, encrypt)
import Data.Crypto.Types (Document(..), DocumentId, DocumentMetaData(..))
import Data.DateTime (DateTime)
import Data.Map (Map, empty)
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (unwrap, wrap, class Newtype)
import Effect.Class (liftEffect)
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
    createdAt <- liftEffect $ maybe nowDateTime pure meta.createdAt
    lastUpdated <- liftEffect $ maybe nowDateTime pure meta.lastUpdated
    pure $ DocumentMetaData {
      title: wrap title,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
      id: meta.id
    }
  decrypt ring (DocumentMetaData documentMeta) = do
    let titleCt = unwrap documentMeta.title
    title <- decrypt ring titleCt 
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

setTitle :: String -> JournalEntry -> JournalEntry
setTitle nextTitle (JournalEntry j) = wrap nextJournal where
  nextJournal = j { metaData = wrap nextMeta }
  nextMeta = (unwrap j.metaData) { title = nextTitle }

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
  decrypt ring (Document document) = do
    meta <- decrypt ring document.metaData
    contents <- decrypt ring (unwrap document.content)
    pure $ JournalEntry {
      content: contents,
      metaData: meta
    }