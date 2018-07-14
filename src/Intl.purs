module Intl
  (localiseString, LocaliseFn)
  where

import Data.Array (catMaybes, head)
import Data.Maybe (Maybe(..), fromMaybe)
import Intl.Locales (Language(..))
import Intl.Terms (Term)
import Prelude (map, ($))

import Intl.Locales.English as ENG
import Intl.Locales.Swedish as SWE

type LocaliseFn
  = Term ->
  String

localiseString :: Array Language -> Term -> String
localiseString languages term = fromMaybe ">> Translation Missing <<" bestTerm
    where
    maybeTerms = map toTerm languages
    
    bestTerm = head $ catMaybes $ maybeTerms
    
    -- | Language function mappings
    toTerm :: Language -> Maybe String
    toTerm English = ENG.localise term
    
    toTerm Swedish = SWE.localise term
    
