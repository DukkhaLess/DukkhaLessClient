module Test.Model.Keyring where

import Prelude        (Unit)
import Effect         (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck', (<?>), quickCheck)
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)

test :: Effect Unit
test = do
  log "Keyring tests"
