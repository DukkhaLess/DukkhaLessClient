module Model.Document where

import Affjax.ResponseFormat (ResponseFormat(..))
import CSS (Abs)
import Class (class CipherText, class Encrypt, decrypt, encrypt)
import Crypt.NaCl (Box, SecretBox, Nonce)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Base64 (Base64(..))
import Data.DateTime (DateTime(..))
import Web.HTML.History (DocumentTitle(..))

data DocumentCategory
  = Journal

data MessageContents
  = Boxed Box
  | SecretBoxed SecretBox

newtype EncryptedMessage
  = EncryptedMessage
  { nonce :: Nonce
  , contents :: MessageContents
  }

newtype Title = Title EncryptedMessage

newtype DocumentContent = DocumentContent EncryptedMessage

newtype DocumentMetaData
  = DocumentMetaData
    { title :: Title
    , createdAt :: DateTime
    , lastUpdated :: DateTime
    , category :: DocumentCategory
    }

newtype Document
  = Document
    { metaData :: DocumentMetaData
    , content :: DocumentContent
    }


instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

instance cipherTextDocument :: CiphetText Document