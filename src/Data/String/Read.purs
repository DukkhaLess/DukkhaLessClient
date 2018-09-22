{-
MIT License

Copyright (c) 2017 TruQu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-}
{- Original Author published code at: https://github.com/truqu/purescript-read -}

module Data.String.Read
  -- * Classes
  ( class Read, read
  , class Zero, zero

  -- * Utility
  , readDefault
  ) where

import Prelude ((>>>), pure, (<>), ($))
import Data.Either (Either(..), note, hush)
import Data.Maybe (fromMaybe)
import Data.String.CodeUnits (charAt)


-- | Represent types that can be read from strings (enum-like ADT)
class Read a where
  read
    :: String
    -> Either String a


-- | Represent types that have a zero value
class Zero a where
  zero :: a


-- | Read a value `a` from a `String` but fallback on `Zero a` on failure
readDefault
  :: forall a. Read a => Zero a
  => String
  -> a
readDefault =
  read >>> hush >>> fromMaybe zero


instance readString :: Read String where
  read =
    pure


instance readChar :: Read Char where
  read =
    charAt 0 >>> note "Could not read the first char of an empty string."


instance readBoolean :: Read Boolean where
  read s =
    case s of
      "true"  -> pure true
      "false" -> pure false
      o       -> Left $ o <> " is not a representation of a boolean value."


instance zeroString :: Zero String where
  zero =
    ""


instance zeroBoolean :: Zero Boolean where
  zero =
    false
