module Data.Crypto.Class where

import Prelude

import Crypt.NaCl (boxAfter, boxBefore, boxOpenAfter, fromUint8Array, generateNonce, secretBox, secretBoxOpen, toUint8Array)
import Crypt.NaCl.Types (BoxSharedKey, Message, Nonce, SecretBoxKey)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.ArrayBuffer.ArrayBuffer (fromString)
import Data.Base64 (Base64(..))
import Data.Crypto.Types (DocumentMetaData, Document, EncryptedMessage(..), MessageContents(..), SenderPublicKey(..))
import Data.Either (Either)
import Data.TextEncoder (encodeUtf8)
import Effect (Effect)
import Model.Keyring (Keyring(..), boxPrivateKey)
import Data.Newtype (unwrap)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document

data DecryptionError
  = Description String

data CryptoKey
  = BoxShared BoxSharedKey
  | SecretBox SecretBoxKey

class FindKey a where
  findKey :: a -> Keyring -> CryptoKey

instance findkeyEncryptedMessage :: FindKey EncryptedMessage where
  findKey (EncryptedMessage message) (Keyring keyring) = 
    case message.contents of
      (Boxed _ (SenderPublicKey senderPublicKey)) -> BoxShared (boxBefore senderPublicKey (boxPrivateKey $ Keyring keyring))
      (SecretBoxed _) -> SecretBox keyring.secretBoxKey


class (CipherText b, FindKey b, EncodeJson a, DecodeJson a) <= Encrypt a b where
  encrypt :: a -> CryptoKey -> Effect b
  decrypt :: b -> Keyring -> Either DecryptionError a

instance encryptStringMessage :: Encrypt Base64 EncryptedMessage where
  encrypt (Base64 s) key = do
    message <- fromUint8Array $ toUint8Array $ fromString s
    nonce <- generateNonce
    let cryptFn = case key of
          (BoxShared sharedKey) -> (\a b -> boxAfter a b sharedKey)
          (SecretBox secretKey) -> (\a b -> secretBox a b secretKey)
    pure $ cryptFn message nonce
  decrypt message ring = do
    let unwrappedMessage = unwrap message
    let key = findKey message
    let nonce = unwrappedMessage.nonce
    let decryptFn = case key of
          (BoxShared sharedKey) -> (\b n -> boxOpenAfter b n sharedKey)
          (SecretBox secretKey) -> (\b n -> secretBoxOpen b n secretKey)
    pure $ decryptFn message nonce


    