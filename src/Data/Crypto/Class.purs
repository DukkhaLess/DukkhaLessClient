module Data.Crypto.Class where

import Effect (Effect)
import Crypt.NaCl.Types (Message, Nonce)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Crypto.Types (DocumentMetaData, Document, EncryptedMessage)
import Data.Either (Either)
import Model.Keyring (Keyring)

class EncodeJson a <= CipherText a

instance cipherTextDocumentMetaData :: CipherText DocumentMetaData
instance cipherTextDocument :: CipherText Document

data DecryptionError
  = Description String

class (CipherText b, EncodeJson a, DecodeJson a) <= Encrypt a b where
  encrypt :: (Message -> Nonce -> EncryptedMessage) -> a -> Effect b
  decrypt :: Keyring -> b -> Either DecryptionError a
