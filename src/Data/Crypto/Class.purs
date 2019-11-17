module Data.Crypto.Class where

import Data.Crypto.Types
import Prelude (bind, pure, ($))
import Crypt.NaCl (boxAfter, boxBefore, boxOpenAfter, fromUint8Array, generateNonce, secretBox, secretBoxOpen, toUint8Array)
import Crypt.NaCl.Types (Message, Nonce)
import Data.Argonaut.Encode (class EncodeJson)
import Data.ArrayBuffer.Typed (buffer, whole)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Either (Either, note)
import Data.HTTP.Payloads (SubmitLogin, SubmitRegister)
import Data.Newtype (unwrap)
import Data.TextEncoding (encodeUtf8)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Model.Keyring (Keyring, boxPrivateKey, boxPublicKey, secretBoxKey)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData

instance cipherTextDocument :: CipherText Document

instance cipherTextEncryptedMessage :: CipherText EncryptedMessage

class
  CipherText b <= Encrypt a b where
  encrypt :: forall m. MonadAff m => a -> (Keyring -> CryptoKey) -> Keyring -> m b
  decrypt :: Keyring -> b -> Either DecryptionError a

instance encryptStringMessage :: Encrypt String EncryptedMessage where
  encrypt str keyFn keyring = do
    let
      buff = buffer $ encodeUtf8 str
    encrypt buff keyFn keyring
  decrypt ring message = do
    buff <- decrypt ring message
    pure buff

instance encryptArrayBufferMessage :: Encrypt ArrayBuffer EncryptedMessage where
  encrypt buff keyFn keyring = do
    message <- liftEffect $ whole buff
    nonce <- liftEffect $ generateNonce
    pure $ encryptMessage (fromUint8Array message) keyFn keyring nonce
  decrypt ring message = do
    let
      unwrappedMessage = unwrap message
    let
      nonce = unwrappedMessage.nonce
    let
      contents = unwrappedMessage.contents
    decryptedBytes <- decryptMessage nonce contents ring
    pure $ buffer $ toUint8Array $ decryptedBytes

decryptMessage :: Nonce -> MessageContents -> Keyring -> Either DecryptionError Message
decryptMessage nonce (Boxed boxContents (SenderPublicKey senderKey)) ring =
  note InvalidKeys
    $ boxOpenAfter boxContents nonce
    $ boxBefore senderKey (boxPrivateKey ring)

decryptMessage nonce (SecretBoxed secretBoxContents) ring =
  note InvalidKeys
    $ secretBoxOpen secretBoxContents nonce (secretBoxKey ring)

encryptMessage :: Message -> (Keyring -> CryptoKey) -> Keyring -> Nonce -> EncryptedMessage
encryptMessage message keyFn keyring nonce = cryptoFn key
  where
  key :: CryptoKey
  key = keyFn keyring

  cryptoFn :: CryptoKey -> EncryptedMessage
  cryptoFn (BoxPair recipientPublic senderPrivate) = EncryptedMessage { nonce: nonce, contents: contents }
    where
    contents = Boxed (boxAfter message nonce sharedKey) (SenderPublicKey $ boxPublicKey keyring)

    sharedKey = boxBefore recipientPublic senderPrivate

  cryptoFn (SecretBox secretKey) = EncryptedMessage { nonce: nonce, contents: contents }
    where
    contents = SecretBoxed (secretBox message nonce secretKey)

class EncodeJson a <= PlainText a

instance plaintextSubmitRegister :: PlainText SubmitRegister

instance plaintextSubmitLogion :: PlainText SubmitLogin
