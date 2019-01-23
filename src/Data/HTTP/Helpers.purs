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
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.String.CodeUnits (charAt)
import Effect.Aff.Class (class MonadAff, liftAff)
import Model (SessionToken(..))

newtype ApiPath = ApiPath String
derive instance newtypeApiPath :: Newtype ApiPath _
instance semigroupApiPath :: Semigroup ApiPath where
  append a b = wrap $ unwrap a <> unwrap b

apiLocation :: String
apiLocation = "/api"

unsafeRequestCleartext :: Method -> ApiPath -> Maybe Json -> Request Json
unsafeRequestCleartext method (ApiPath path) payload
 = defaultRequest
  { url = path'
  , content = RB.Json <$> payload
  , method = Left method
  , responseFormat = json
  } where
    path' = apiLocation <> withLeadingSlash path

unsafePostCleartext :: forall p. EncodeJson p => ApiPath -> p -> Request Json
unsafePostCleartext a = unsafeRequestCleartext POST a <<< Just <<< encodeJson

sessionHeaders :: Request Json -> SessionToken -> Request Json
sessionHeaders req (SessionToken t) =
    req 
    { headers = [RequestHeader "Authorization" t]
    , withCredentials = true
    }

post :: forall p. CipherText p => ApiPath -> p -> SessionToken -> Request Json
post a p = sessionHeaders (unsafePostCleartext a $ Just p)

get :: ApiPath -> SessionToken -> Request Json
get a = sessionHeaders (unsafeRequestCleartext GET a Nothing)

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