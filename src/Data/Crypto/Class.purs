module Data.Crypto.Class where

import Crypt.NaCl.Types (BoxSharedKey, Message, Nonce, SecretBoxKey)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Crypto.Types (DocumentMetaData, Document, EncryptedMessage)
import Data.Either (Either)
import Effect (Effect)
import Model.Keyring (Keyring)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document

data DecryptionError
  = Description String

data CryptoKey
  = BoxShared BoxSharedKey
  | SecretBox SecretBoxKey

class (CipherText b, EncodeJson a, DecodeJson a) <= Encrypt a b where
  findAppropriateKey :: a -> Keyring -> CryptoKey
  encrypt :: (Message -> Nonce -> CryptoKey -> EncryptedMessage) -> a -> Effect b
  decrypt :: b -> Either DecryptionError a

instance encryptStringMessage :: Encrypt String EncryptedMessage where