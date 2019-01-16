module Data.HTTP.Helpers where

import Prelude

import Affjax (defaultRequest, Request, Response, printResponseFormatError)
import Affjax as AJ
import Affjax.RequestBody as RB
import Affjax.RequestHeader (RequestHeader(..))
import Affjax.ResponseFormat (json)
import Data.Crypto.Class (class CipherText)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Bifunctor (lmap)
import Data.Either (Either(Left))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.String.CodeUnits (charAt)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Model (SessionToken(..))

newtype ApiPath = ApiPath String
derive instance newtypeApiPath :: Newtype ApiPath _

apiLocation :: String
apiLocation = "/api"

unsafePostCleartext :: forall a. EncodeJson a => ApiPath -> a -> Request Json
unsafePostCleartext (ApiPath path) payload
 = defaultRequest
  { url = path'
  , content = Just $ RB.Json (encodeJson payload)
  , method = Left POST
    , responseFormat = json
  } where
    payload' = encodeJson payload
    path' = apiLocation <> withLeadingSlash path

post :: forall a. CipherText a => ApiPath -> a -> SessionToken -> Request Json
post a p (SessionToken t) = (unsafePostCleartext a p)
    { headers = [RequestHeader "Authorization" t]
    , withCredentials = true
    }

withLeadingSlash :: String -> String
withLeadingSlash s = case charAt 0 s of
  Nothing -> ""
  Just '/' -> s
  Just _   -> "/" <> s

request
  :: forall a m
  . DecodeJson a
  => MonadAff m
  => Request Json -> m (Response (Either String a))
request req = do
  resp <- liftAff $ AJ.request req
  let body = lmap printResponseFormatError resp.body >>= decodeJson
  pure $ resp
    { body = body
    }