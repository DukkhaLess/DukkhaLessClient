module Data.Crypto.Class where

import Prelude

import Crypt.NaCl (BoxPublicKey, BoxSecretKey, boxAfter, boxBefore, boxOpenAfter, fromUint8Array, generateNonce, secretBox, secretBoxOpen, toUint8Array)
import Crypt.NaCl.Types (BoxSharedKey, Message, Nonce, SecretBoxKey)
import Data.Argonaut.Encode (class EncodeJson)
import Data.ArrayBuffer.ArrayBuffer (fromString, decodeToString)
import Data.ArrayBuffer.DataView (whole, buffer)
import Data.ArrayBuffer.Typed (asUint8Array, dataView)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Base64 (Base64(..), encodeBase64, decodeBase64)
import Data.Bifunctor (lmap)
import Data.Crypto.Types
import Data.Either (Either, note)
import Data.Newtype (unwrap)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Model.Keyring (Keyring(..), boxPrivateKey, boxPublicKey, secretBoxKey)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document
instance cipherTextEncryptedMessage :: CipherText EncryptedMessage

class CipherText b <= Encrypt a b where
  encrypt :: forall m. MonadAff m => a -> (Keyring -> CryptoKey) -> Keyring -> m b
  decrypt :: Keyring -> b -> Either DecryptionError a

instance encryptStringMessage :: Encrypt String EncryptedMessage where
  encrypt str keyFn keyring = do
    let buff = fromString str
    encrypt buff keyFn keyring
  decrypt ring message = do
    buff <- decrypt ring message
    lmap (\e -> Description (show e)) $ decodeToString buff

instance encryptArrayBufferMessage :: Encrypt ArrayBuffer EncryptedMessage where
  encrypt buff keyFn keyring = do
    let message = fromUint8Array $ asUint8Array $ whole buff
    nonce <- liftEffect $ generateNonce
    pure $ encryptMessage message keyFn keyring nonce
  decrypt ring message = do
    let unwrappedMessage = unwrap message
    let nonce = unwrappedMessage.nonce
    let contents = unwrappedMessage.contents
    decryptedBytes <- decryptMessage nonce contents ring
    pure $ buffer $ dataView $ toUint8Array $ decryptedBytes
    
decryptMessage :: Nonce -> MessageContents -> Keyring -> Either DecryptionError Message
decryptMessage nonce (Boxed boxContents (SenderPublicKey senderKey)) ring
  = note InvalidKeys
  $ boxOpenAfter boxContents nonce
  $ boxBefore senderKey (boxPrivateKey ring) 
decryptMessage nonce (SecretBoxed secretBoxContents) ring
  = note InvalidKeys
  $ secretBoxOpen secretBoxContents nonce (secretBoxKey ring)

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
