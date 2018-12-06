module Data.Crypto.Class where

import Crypt.NaCl (boxBefore)
import Crypt.NaCl.Types (BoxSharedKey, Message, Nonce, SecretBoxKey)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Crypto.Types (DocumentMetaData, Document, EncryptedMessage(..), MessageContents(..))
import Data.Either (Either)
import Effect (Effect)
import Effect.Exception (message)
import Model.Keyring (Keyring(..), boxPrivateKey)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document

data DecryptionError
  = Description String

data CryptoKey
  = BoxShared BoxSharedKey
  | SecretBox SecretBoxKey

class (CipherText b, EncodeJson a, DecodeJson a) <= Encrypt a b where
  findAppropriateKey :: b -> Keyring -> CryptoKey
  encrypt :: (Message -> Nonce -> CryptoKey -> EncryptedMessage) -> a -> Effect b
  decrypt :: b -> Either DecryptionError a

instance encryptStringMessage :: Encrypt String EncryptedMessage where
  findAppropriateKey (EncryptedMessage message) (Keyring keyring) = 
    case message.contents of
      (Boxed _ senderPublicKey) -> BoxShared (boxBefore senderPublicKey (boxPrivateKey keyring))
      (SecretBoxed _) -> SecretBox keyring.secretBoxKey