module Model.Document where

import Prelude
import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Crypt.NaCl (Box, SecretBox, Nonce)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Base64 (Base64(..))
import Data.DateTime (DateTime(..))

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