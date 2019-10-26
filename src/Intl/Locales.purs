module Intl.Locales
  ( Polity(..)
  , Language(..)
  , defaultPolityLanguage
  , preferredUserLanguages
  ) where

import Prelude

import Control.Bind (bindFlipped)
import Data.Array (snoc, head, catMaybes, nub)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Data.Generic.Rep.Eq as GEq
import Data.Generic.Rep.Ord as GOrd
import Data.Maybe (Maybe(..))
import Data.String (split, Pattern(..))
import Effect (Effect)

data Polity
  = Sweden
  | Canada

data Language
  = English
  | Swedish

derive instance genericLanguage :: G.Generic Language _

instance showLanguage :: Show Language where
  show = GShow.genericShow

instance eqLanguage :: Eq Language where
  eq = GEq.genericEq

instance ordLanguage :: Ord Language where
  compare = GOrd.genericCompare

-- | Returns the statistically most dominantly spoken language for a given State/Country/Empire/Whatever
-- | This means that even though nations like Canada have large "minority language" populations, Canada will default to its majority, English.
-- | TODO: Determine at what order of importance this should be used, if at all, and how it is expected to be determined, if at all.
defaultPolityLanguage :: Polity -> Language
defaultPolityLanguage Sweden = Swedish
defaultPolityLanguage Canada = English

foreign import userLanguages :: Effect (Array String)

preferredUserLanguages :: Effect (Array Language)
preferredUserLanguages = do
  languageStrings <- userLanguages
  let chosenLanguages = catMaybes $ map ((bindFlipped langStringToLanguage) <<< head <<< split (Pattern "-")) languageStrings
  pure $ nub $ snoc chosenLanguages globalFallbackLanguage

langStringToLanguage :: String -> Maybe Language
langStringToLanguage "en" = Just English
langStringToLanguage "sv" = Just Swedish
langStringToLanguage _    = Nothing



-- | Provides the universal fallback langauge when text cannot be localised for a user.
-- | English is chosen for two reasons:
-- |    1) It is the language that the current software author writes first, being her native language
-- |    2) It is a widely spoken language and taught widely in the world. In terms of universality, other
-- |       applicable languages would likely be Mandarin, Hindi, Spanish, and Arabic, but as the author does not
-- |       speak those languages, it is a "this is the best I can do" sort of thing. Hopefully in time fallback won't be needed.
globalFallbackLanguage :: Language
globalFallbackLanguage = English
