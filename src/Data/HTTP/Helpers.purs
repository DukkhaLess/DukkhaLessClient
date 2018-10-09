module Data.HTTP.Helpers where

import Affjax (defaultRequest, Request)
import Affjax.RequestBody (RequestBody(..))
import Affjax.RequestHeader (RequestHeader(..))
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (Either(Left))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Semigroup ((<>))
import Data.String.CodeUnits (charAt)
import Model (SessionToken(..))
import Prelude (Unit, ($))

newtype ApiPath = ApiPath String
derive instance newtypeApiPath :: Newtype ApiPath _

apiLocation :: String
apiLocation = "/api"

post :: forall a. EncodeJson a => ApiPath -> a -> Request Unit
post (ApiPath path) payload
 = defaultRequest
  { url = path'
  , content = Just $ Json (encodeJson payload)
  , method = Left POST
  } where
    payload' = encodeJson payload
    path' = apiLocation <> withLeadingSlash path

post' :: forall a. EncodeJson a => ApiPath -> a -> SessionToken-> Request Unit
post' a p (SessionToken t)
  = (post a p)
    { headers = [RequestHeader "Authorization" t]
    , withCredentials = true
    }

withLeadingSlash :: String -> String
withLeadingSlash s = case charAt 0 s of
  Nothing -> ""
  Just '/' -> s
  Just _   -> "/" <> s