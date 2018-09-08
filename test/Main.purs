module Test.Main where

import Prelude
import Effect         (Effect)
import Effect.Console (log)
import Test.Model.Keyring as KR
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)

main :: Effect Unit
main = run [consoleReporter] do
  KR.test
