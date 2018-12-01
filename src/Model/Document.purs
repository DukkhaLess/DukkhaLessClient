module Model.Document where

import Model.Crypto
import Prelude

import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Crypt.NaCl (Box, Nonce, SecretBox, toUint8Array)
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Core as AC
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Base64 (Base64(..))
import Data.DateTime (DateTime(..))
import Data.Generic.Rep.Show (genericShow)
import Data.Generic.Rep (class Generic)
import Effect.Exception (message)

data DocumentCategory
  = Journal

derive instance genericDocumentCategory :: Generic DocumentCategory _

instance showDocumentCategory :: Show DocumentCategory where
  show = genericShow

instance encodeJsonDocumentCategory :: EncodeJson DocumentCategory where
  encodeJson = show >>> AC.fromString

data MessageContents
  = Boxed Box
  | SecretBoxed SecretBox

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
  decodeJson = foo

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
  decodeJson = foo


newtype Title = Title EncryptedMessage

instance encodeJsonTitle :: EncodeJson Title where
  encodeJson = encodeJson <#> Title

instance decodeJsonTitle :: DecodeJson Title where
  decodeJson (Title message) = decodeJson message


newtype DocumentContent = DocumentContent EncryptedMessage

instance encodeJsonDocumentContent :: EncodeJson DocumentContent where
  encodeJson = encodeJson <#> DocumentContent

instance decodeJsonDocumentContent :: DecodeJson DocumentContent where
  decodeJson (DocumentContent message) = decodeJson message

newtype DocumentMetaData
  = DocumentMetaData
    { title :: Title
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , category :: DocumentCategory
    }

instance encodeJsonDocumentMetaData :: EncodeJson DocumentMetaData where
  encodeJson (DocumentMetaData metaData)
    = "title" := (encodeJson metaData.title)
    ~> "category" := (encodeJson metaData.category)
    ~> "createdAt" := (encodeJson metaData.createdAt)
    ~> "lastUpdated" := (encodeJson metaData.lastUpdated)
    ~> jsonEmptyObject

instance decodeJsonDocumentMetaData :: DecodeJson DocumentMetaData where
  decodeJson = foo

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

newtype Document
  = Document
    { metaData :: DocumentMetaData
    , content :: DocumentContent
    }

instance encodeJsonDocument :: EncodeJson Document where
  encodeJson (Document document)
    = "metaData" := (encodeJson document.metaData)
    ~> "content" := (encodeJson document.content)
    ~> jsonEmptyObject

instance decodeJsonDocument :: DecodeJson Document where
  decodeJson = foo

instance cipherTextDocument :: CipherText Document