module WebCrypto.CryptoKey where

data Usage
  = Encrypt
  | Decrypt
  | Sign
  | Verify
  | DeriveKey
  | DeriveBits
  | WrapKey
  | UnwrapKey

data KeyType
  = SharedSecret
  | Public
  | Private

data Algo
  = AES_CBC
  | AES_CTR
  | AES_GCM
  | RSA_OAEP
  | HMAC
  | PBKDF2

data HashAlgo
  = SHA_256
  | SHA_512
