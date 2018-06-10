module Intl.Locales
  ( Polity(..)
  , Language(..)
  , defaultPolityLanguage
  , preferredUserLanguages
  , globalFallbackLanguage
  )where

data Polity
  = Sweden
  | Canada

data Language
  = English
  | Swedish

-- | Returns the statistically most dominantly spoken language for a given State/Country/Empire/Whatever
-- | This means that even though nations like Canada have large "minority language" populations, Canada will default to its majority, English.
defaultPolityLanguage :: Polity -> Language
defaultPolityLanguage Sweden = Swedish
defaultPolityLanguage Canada = English

preferredUserLanguages :: Array Language
preferredUserLanguages = []

-- | Provides the universal fallback langauge when text cannot be localised for a user.
-- | English is chosen for two reasons:
-- |    1) It is the language that the current software author writes first, being her native language
-- |    2) It is a widely spoken language and taught widely in the world. In terms of universality, other
-- |       applicable languages would likely be Mandarin, Hindi, Spanish, and Arabic, but as the author does not
-- |       speak those languages, it is a "this is the best I can do" sort of thing. Hopefully in time fallback won't be needed.
globalFallbackLanguage :: Language
globalFallbackLanguage = English
