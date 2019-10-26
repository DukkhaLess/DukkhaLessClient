{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "dukkhaless-client"
, dependencies =
    [ "aff"
    , "aff-promise"
    , "affjax"
    , "argonaut"
    , "arraybuffer-types"
    , "base64-codec"
    , "bifunctors"
    , "console"
    , "css"
    , "datetime"
    , "datetime-iso"
    , "effect"
    , "generics-rep"
    , "halogen"
    , "newtype"
    , "now"
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "remotedata"
    , "routing"
    , "spec"
    , "text-encoding"
    , "tuples"
    , "tweetnacl"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
