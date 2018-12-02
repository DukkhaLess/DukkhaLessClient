module Model.Document where

import Model.Crypto
import Prelude

import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Crypt.NaCl (Box, Nonce, SecretBox, fromUint8Array, toUint8Array)
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Core as AC
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.DateTime (DateTime)
import Data.DateTime.ISO (ISO(..), unwrapISO)
import Data.Either (Either(..))
import Data.JsonDecode.Helpers (decodeJObject, decodeJString)
import Data.Maybe (Maybe)

data MessageContents
  = Boxed Box
  | SecretBoxed SecretBox

data DocumentId
  = UUID String

instance encodeDocumentId :: EncodeJson DocumentId where
  encodeJson (UUID id) = encodeJson id

instance decodeDocumentId :: DecodeJson DocumentId where
  decodeJson json = decodeJString json <#> UUID

instance encodeJsonMessageContents :: EncodeJson MessageContents where
  encodeJson (Boxed box)
    = "type" := "boxed"
    ~> "data" := (encodeBytes $ toUint8Array box)
    ~> jsonEmptyObject
  encodeJson (SecretBoxed box)
    = "type" := "secretBoxed"
    ~> "data" := (encodeBytes $ toUint8Array box)
    ~> jsonEmptyObject

instance decodeJsonMessageContents :: DecodeJson MessageContents where
  decodeJson json = do
    obj <- decodeJObject json
    bytes <- obj .? "data"
    dataBytes <- decodeBytes bytes
    discriminator <- obj .? "type"
    case discriminator of
      "boxed" -> Right $ Boxed (fromUint8Array dataBytes)
      "secretBoxed" -> Right $ SecretBoxed (fromUint8Array dataBytes)
      other -> Left $ other <> " is not a valid type discriminator."

newtype EncryptedMessage
  = EncryptedMessage
  { nonce :: Nonce
  , contents :: MessageContents
  }

instance encodeJsonEncryptedMessage :: EncodeJson EncryptedMessage where
  encodeJson (EncryptedMessage message)
    = "nonce" := (encodeBytes $ toUint8Array message.nonce)
    ~> "contents" := (encodeJson message.contents)
    ~> jsonEmptyObject

instance decodeJsonEncryptedMessage :: DecodeJson EncryptedMessage where
  decodeJson json = do
    obj <- decodeJObject json
    nonce <- obj .? "nonce" >>= decodeBytes <#> fromUint8Array
    contents <- obj .? "contents"
    pure $ EncryptedMessage
      { nonce: nonce
      , contents: contents
      }

newtype Title = Title EncryptedMessage

instance encodeJsonTitle :: EncodeJson Title where
  encodeJson (Title msg) = encodeJson msg

instance decodeJsonTitle :: DecodeJson Title where
  decodeJson str = decodeJson str <#> Title

newtype DocumentContent = DocumentContent EncryptedMessage

instance encodeJsonDocumentContent :: EncodeJson DocumentContent where
  encodeJson (DocumentContent message) = encodeJson message

instance decodeJsonDocumentContent :: DecodeJson DocumentContent where
  decodeJson str = decodeJson str <#> DocumentContent

newtype DocumentMetaData
  = DocumentMetaData
    { title :: Title
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , id :: Maybe DocumentId
    }

instance encodeJsonDocumentMetaData :: EncodeJson DocumentMetaData where
  encodeJson (DocumentMetaData metaData)
    = "title" := metaData.title
    ~> "id" := metaData.id
    ~> "createdAt" := ISO metaData.createdAt
    ~> "lastUpdated" := ISO metaData.lastUpdated
    ~> jsonEmptyObject

instance decodeJsonDocumentMetaData :: DecodeJson DocumentMetaData where
  decodeJson json = do 
    obj <- decodeJObject json
    title <- obj .? "title"
    id <- obj .? "id"
    createdAt <- obj .? "createdAt" <#> unwrapISO
    lastUpdated <- obj .? "lastUpdated" <#> unwrapISO
    pure $ DocumentMetaData
     { title: title
     , createdAt: createdAt
     , lastUpdated: lastUpdated
     , id: id
     }

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

newtype Document
  = Document
    { metaData :: DocumentMetaData
    , content :: DocumentContent
    }

instance encodeJsonDocument :: EncodeJson Document where
  encodeJson (Document document)
    = "metaData" := document.metaData
    ~> "content" := document.content
    ~> jsonEmptyObject

instance decodeJsonDocument :: DecodeJson Document where
  decodeJson json = do
    obj <- decodeJObject json
    metaData <- obj .? "metaData"
    content <- obj .? "content"
    pure $ Document
      { metaData: metaData
      , content: content
      }

instance cipherTextDocument :: CipherText Document