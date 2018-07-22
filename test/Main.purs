module Test.Main where

import Prelude
import Effect         (Effect)
import Effect.Console (log)
import Test.Model.Keyring as KR

main :: Effect Unit
main = do
  log "You should add some tests."
  KR.test
