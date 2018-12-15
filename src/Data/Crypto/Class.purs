module Data.Crypto.Class where

import Prelude

import Crypt.NaCl (BoxPublicKey, BoxSecretKey, boxAfter, boxBefore, boxOpenAfter, fromUint8Array, generateNonce, secretBox, secretBoxOpen, toUint8Array)
import Crypt.NaCl.Types (BoxSharedKey, Message, Nonce, SecretBoxKey)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.ArrayBuffer.ArrayBuffer (fromString)
import Data.Base64 (Base64(..), encodeBase64)
import Data.Crypto.Types (DocumentMetaData, Document, EncryptedMessage(..), MessageContents(..), SenderPublicKey(..))
import Data.Either (Either)
import Data.Newtype (unwrap)
import Data.TextEncoder (encodeUtf8)
import Effect (Effect)
import Model.Keyring (Keyring(..), boxPrivateKey, boxPublicKey)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document

data DecryptionError
  = Description String

data CryptoKey
  = BoxPair BoxPublicKey BoxSecretKey
  | SecretBox SecretBoxKey

class (CipherText b, EncodeJson a, DecodeJson a) <= Encrypt a b where
  encrypt :: a -> (Keyring -> CryptoKey) -> Keyring -> Effect b
  decrypt :: b -> Keyring -> Either DecryptionError a

instance encryptStringMessage :: Encrypt Base64 EncryptedMessage where
  encrypt (Base64 s) keyFn keyring = do
    message <- fromUint8Array $ toUint8Array $ fromString s
    nonce <- generateNonce
    pure $ encryptMessage message keyFn keyring nonce
  decrypt message ring = do
    let unwrappedMessage = unwrap message
    let key = findKey message ring
    let nonce = unwrappedMessage.nonce
    let decryptFn = case key of
          (BoxPair senderPublic recipientPrivate) -> (\b n -> boxOpenAfter b n (boxBefore senderPublic recipientPrivate)
          (SecretBox secretKey) -> (\b n -> secretBoxOpen b n secretKey)
    pure $ decryptFn message nonce

encryptMessage :: Message -> (Keyring -> CryptoKey) -> Keyring -> Nonce -> EncryptedMessage
encryptMessage message keyFn keyring nonce = cryptoFn key where
  key :: CryptoKey
  key = keyFn keyring 
  cryptoFn :: CryptoKey -> EncryptedMessage
  cryptoFn (BoxPair recipientPublic senderPrivate) = EncryptedMessage { nonce: nonce, contents: contents } where
    contents = Boxed (boxAfter message nonce sharedKey) (SenderPublicKey $ boxPublicKey keyring)
    sharedKey = boxBefore recipientPublic senderPrivate
  cryptoFn (SecretBox secretKey) =  EncryptedMessage { nonce: nonce, contents: contents } where
    contents =  SecretBoxed (secretBox message nonce secretKey)
