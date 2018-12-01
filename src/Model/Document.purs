module Model.Document where

import Affjax.ResponseFormat (ResponseFormat(..))
import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Base64 (Base64(..))
import Data.DateTime (DateTime(..))

data DocumentCategory
  = Journal

data DocumentOwnership
  = Shared
  | Own

newtype DocumentMetaData
  = DocumentMetaData
    { titleNonce :: Base64
    , titleCipherText :: Base64
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , document :: DocumentCategory
    , ownership :: DocumentOwnership
    }

newtype DocumentContent
  = DocumentContent
    { nonce :: Base64
    , cipherText :: Base64
    }

newtype Document
  = Document
    { metaData :: DocumentMetaData
    , content :: DocumentContent
    }


instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

instance cipherTextDocument :: CiphetText Document