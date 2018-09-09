module Test.Model.Keyring where

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Data.Either (Either(..))
import Data.String.Read (read)
import Model.Keyring (generateKeyring)
import Prelude
import Test.QuickCheck (quickCheck', (<?>), quickCheck)
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (fail, shouldEqual)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)

test :: Spec Unit
test = do
  describe "Keyring" do
    it "Performs a JSON encoding round-trip" do
      keyring <- liftEffect $ generateKeyring
      let json = encodeJson $ keyring
      let decoded = decodeJson $ json
      case decoded of
        Right result -> if result /= keyring then fail "Round trip failed. Result differed from original." else pure unit
        Left failureReason -> fail $ "Failed to decode the generated json during round trip, error given was:\n" <> failureReason

    it "can perform a show <-> read round-trip" do
      keyring <- liftEffect $ generateKeyring
      let roundtrip = read $ show $ keyring
      roundtrip `shouldEqual` (Right keyring)


