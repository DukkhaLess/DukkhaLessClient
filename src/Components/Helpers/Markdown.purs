module Components.Helpers.Markdown where

import Prelude

import Data.Markdown.Parser (MarkdownText, parse)
import Data.Newtype (unwrap)
import Halogen.HTML (HTML)
import Html.Parser.Halogen as PH

renderMarkdown :: forall p i. MarkdownText -> HTML p i
renderMarkdown = parse >>> unwrap >>> PH.render