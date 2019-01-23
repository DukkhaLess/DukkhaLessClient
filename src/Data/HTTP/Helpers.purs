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
import Effect.Aff.Class (class MonadAff, liftAff)
import Model (SessionToken(..))

newtype ApiPath = ApiPath String
derive instance newtypeApiPath :: Newtype ApiPath _

apiLocation :: String
apiLocation = "/api"

unsafeRequestCleartext :: forall a. EncodeJson a => Method -> ApiPath -> a -> Request Json
unsafeRequestCleartext method (ApiPath path) payload
 = defaultRequest
  { url = path'
  , content = Just $ RB.Json (encodeJson payload)
  , method = Left method
  , responseFormat = json
  } where
    payload' = encodeJson payload
    path' = apiLocation <> withLeadingSlash path

unsafePostCleartext :: forall a. EncodeJson a => ApiPath -> a -> Request Json
unsafePostCleartext = unsafeRequestCleartext POST

sessionHeaders :: Request Json -> SessionToken -> Request Json
sessionHeaders req (SessionToken t) =
    req 
    { headers = [RequestHeader "Authorization" t]
    , withCredentials = true
    }

post :: forall a. CipherText a => ApiPath -> a -> SessionToken -> Request Json
post a p = sessionHeaders (unsafePostCleartext a p)

get :: forall a. CipherText a => ApiPath -> a -> SessionToken -> Request Json
get a p = sessionHeaders (unsafeRequestCleartext GET a p)

withLeadingSlash :: String -> String
withLeadingSlash s = case charAt 0 s of
  Nothing -> ""
  Just '/' -> s
  Just _   -> "/" <> s

-- | Request the desired JSON endpoint, parsing the result from JSON using the needed decoder
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