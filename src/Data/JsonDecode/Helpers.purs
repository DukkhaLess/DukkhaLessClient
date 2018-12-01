module Data.JsonDecode.Helpers where

import Data.Argonaut(Json, toObject)
import Data.Either(Either, note)
import Foreign.Object (Object)
import Prelude

decodeJObject :: Json -> Either String (Object Json)
decodeJObject = toObject >>> note "Value was not a JSON Object"