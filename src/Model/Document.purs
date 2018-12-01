module Model.Document where

import Affjax.ResponseFormat (ResponseFormat(..))
import CSS (Abs)
import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Crypt.NaCl (Box, SecretBox, Nonce)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Base64 (Base64(..))
import Data.DateTime (DateTime(..))
import Web.HTML.History (DocumentTitle(..))

data DocumentCategory
  = Journal

data MessageContents
  = Boxed Box
  | SecretBoxed SecretBox

instance encodeJsonMessageContents :: EncodeJson MessageContents where
  encodeJson = foo

instance decodeJsonMessageContents :: DecodeJson MessageContents where
  decodeJson = foo

newtype EncryptedMessage
  = EncryptedMessage
  { nonce :: Nonce
  , contents :: MessageContents
  }

instance encodeJsonEncryptedMessage :: EncodeJson EncryptedMessage where
  encodeJson = foo

instance decodeJsonEncryptedMessage :: DecodeJson EncryptedMessage where
  decodeJson = foo


newtype Title = Title EncryptedMessage

instance encodeJsonTitle :: EncodeJson Title where
  encodeJson = foo

instance decodeJsonTitle :: DecodeJson Title where
  decodeJson = foo


newtype DocumentContent = DocumentContent EncryptedMessage

instance encodeJsonDocumentContent :: EncodeJson DocumentContent where
  encodeJson = foo

instance decodeJsonDocumentContent :: DecodeJson DocumentContent where
  decodeJson = foo

newtype DocumentMetaData
  = DocumentMetaData
    { title :: Title
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , category :: DocumentCategory
    }

instance encodeJsonDocumentMetaData :: EncodeJson DocumentMetaData where
  encodeJson = foo

instance decodeJsonDocumentMetaData :: DecodeJson DocumentMetaData where
  decodeJson = foo

newtype Document
  = Document
    { metaData :: DocumentMetaData
    , content :: DocumentContent
    }

instance encodeJsonDocument :: EncodeJson Document where
  encodeJson = foo

instance decodeJsonDocument :: DecodeJson Document where
  decodeJson = foo

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

instance cipherTextDocument :: CiphetText Document