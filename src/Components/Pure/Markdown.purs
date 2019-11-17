module Components.Pure.Markdown where

import Prelude
import Data.Markdown.Parser (MarkdownText, parse)
import Data.Newtype (unwrap)
import Halogen.HTML (HTML)
import Html.Renderer.Halogen as RH

renderMarkdown :: forall p i. MarkdownText -> HTML p i
renderMarkdown = parse >>> unwrap >>> RH.render_
