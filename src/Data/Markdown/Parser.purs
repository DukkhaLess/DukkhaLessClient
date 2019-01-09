module Data.Markdown.Parser
  ( MarkdownHTML(..)
  , MarkdownText(..)
  , parse
  ) where

import Prelude
import Data.Newtype (class Newtype)


newtype MarkdownHTML = MarkdownHTML String
derive instance newtypeMarkdownHTML :: Newtype MarkdownHTML _

newtype MarkdownText = MarkdownText String
derive instance newtypeMarkdownText :: Newtype MarkdownText _

foreign import parseImpl :: String -> String

parse :: MarkdownText -> MarkdownHTML
parse (MarkdownText raw) = MarkdownHTML $ parseImpl raw
