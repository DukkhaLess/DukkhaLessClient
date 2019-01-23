module Data.Crypto.Types where

import Prelude

import Crypt.NaCl (Box, BoxPublicKey, BoxSharedKey, Nonce, SecretBox, SecretBoxKey, fromUint8Array, toUint8Array)
import Data.Argonaut (jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Combinators ((.?))
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Combinators ((~>), (:=))
import Data.Crypto.Codec (decodeBytes, encodeBytes)
import Data.DateTime (DateTime)
import Data.DateTime.ISO (ISO(..), unwrapISO)
import Data.Either (Either(..))
import Data.JsonDecode.Helpers (decodeJObject, decodeJString)
import Data.Lens (_1)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

newtype SenderPublicKey = SenderPublicKey BoxPublicKey

data MessageContents
  = Boxed Box SenderPublicKey
  | SecretBoxed SecretBox

newtype DocumentId
  = UUID String
derive instance newtypeDocumentId :: Newtype DocumentId _

instance encodeDocumentId :: EncodeJson DocumentId where
  encodeJson (UUID id) = encodeJson id

instance decodeDocumentId :: DecodeJson DocumentId where
  decodeJson json = decodeJString json <#> UUID

instance encodeJsonMessageContents :: EncodeJson MessageContents where
  encodeJson (Boxed box (SenderPublicKey senderKey))
    = "type" := "boxed"
    ~> "data" :=
      ( "box" := (encodeBytes $ toUint8Array box)
      ~> "senderPublicKey" := (encodeBytes $ toUint8Array senderKey)
      ~> jsonEmptyObject
      )
    ~> jsonEmptyObject
  encodeJson (SecretBoxed box)
    = "type" := "secretBoxed"
    ~> "data" := (encodeBytes $ toUint8Array box)
    ~> jsonEmptyObject


instance decodeJsonMessageContents :: DecodeJson MessageContents where
  decodeJson json = do
    obj <- decodeJObject json
    dataComponent <- obj .? "data"
    discriminator <- obj .? "type"
    case discriminator of
      "boxed" -> do
        box <- obj .? "box" >>= decodeBytes <#> fromUint8Array
        senderPublicKey <- obj .? "senderPublicKey" >>= decodeBytes <#> fromUint8Array
        pure $ Boxed box (SenderPublicKey senderPublicKey)
      "secretBoxed" -> decodeBytes dataComponent <#> fromUint8Array <#> SecretBoxed
      other -> Left $ other <> " is not a valid type discriminator."

newtype Title = Title EncryptedMessage

derive instance newtypeTitle :: Newtype Title _

instance encodeJsonTitle :: EncodeJson Title where
  encodeJson (Title msg) = encodeJson msg

instance decodeJsonTitle :: DecodeJson Title where
  decodeJson str = decodeJson str <#> Title

newtype DocumentContent = DocumentContent EncryptedMessage

derive instance newtypeDocumentContent :: Newtype DocumentContent _

newtype EncryptedMessage
  = EncryptedMessage
  { nonce :: Nonce
  , contents :: MessageContents
  }

derive instance newtypeEncryptedMessage :: Newtype EncryptedMessage _

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

derive instance newtypeDocumentMeta :: Newtype DocumentMetaData _

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
derive instance newtypeDocument :: Newtype Document _