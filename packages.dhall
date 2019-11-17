{-
Welcome to your new Dhall package-set!

Below are instructions for how to edit this file for most use
cases, so that you don't need to know Dhall to use it.

## Warning: Don't Move This Top-Level Comment!

Due to how `dhall format` currently works, this comment's
instructions cannot appear near corresponding sections below
because `dhall format` will delete the comment. However,
it will not delete a top-level comment like this one.

## Use Cases

Most will want to do one or both of these options:
1. Override/Patch a package's dependency
2. Add a package not already in the default package set

This file will continue to work whether you use one or both options.
Instructions for each option are explained below.

### Overriding/Patching a package

Purpose:
- Change a package's dependency to a newer/older release than the
    default package set's release
- Use your own modified version of some dependency that may
    include new API, changed API, removed API by
    using your custom git repo of the library rather than
    the package set's repo

Syntax:
Replace the overrides' "{=}" (an empty record) with the following idea
The "//" or "⫽" means "merge these two records and
  when they have the same value, use the one on the right:"
-------------------------------
let override =
  { packageName =
      upstream.packageName // { updateEntity1 = "new value", updateEntity2 = "new value" }
  , packageName =
      upstream.packageName // { version = "v4.0.0" }
  , packageName =
      upstream.packageName // { repo = "https://www.example.com/path/to/new/repo.git" }
  }
-------------------------------

Example:
-------------------------------
let overrides =
  { halogen =
      upstream.halogen // { version = "master" }
  , halogen-vdom =
      upstream.halogen-vdom // { version = "v4.0.0" }
  }
-------------------------------

### Additions

Purpose:
- Add packages that aren't already included in the default package set

Syntax:
Replace the additions' "{=}" (an empty record) with the following idea:
-------------------------------
let additions =
  { "package-name" =
       { dependencies =
           [ "dependency1"
           , "dependency2"
           ]
       , repo =
           "https://example.com/path/to/git/repo.git"
       , version =
           "tag ('v4.0.0') or branch ('master')"
       }
  , "package-name" =
       { dependencies =
           [ "dependency1"
           , "dependency2"
           ]
       , repo =
           "https://example.com/path/to/git/repo.git"
       , version =
           "tag ('v4.0.0') or branch ('master')"
       }
  , etc.
  }
-------------------------------

Example:
-------------------------------
let additions =
  { benchotron =
      { dependencies =
          [ "arrays"
          , "exists"
          , "profunctor"
          , "strings"
          , "quickcheck"
          , "lcg"
          , "transformers"
          , "foldable-traversable"
          , "exceptions"
          , "node-fs"
          , "node-buffer"
          , "node-readline"
          , "datetime"
          , "now"
          ],
      , repo =
          "https://github.com/hdgarrood/purescript-benchotron.git"
      , version =
          "v7.0.0"
      }
  }
-------------------------------
-}


let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.4-20191025/packages.dhall sha256:f9eb600e5c2a439c3ac9543b1f36590696342baedab2d54ae0aa03c9447ce7d4

let overrides = {
  form-urlencoded = {
    dependencies = [
      "globals",
      "maybe",
      "newtype",
      "prelude",
      "strings",
      "tuples",
      "foldable-traversable"
    ],
    repo = "https://github.com/purescript-contrib/purescript-form-urlencoded.git",
    version = "v4.0.1"
  }
}

let additions = {
  base64-codec = {
    dependencies = [
      "prelude",
      "arraybuffer-types",
      "newtype"
    ],
    repo = "https://github.com/AlexaDeWit/purescript-base64-codec.git",
    version = "v1.0.0"
  },
  datetime-iso = {
    dependencies = [
      "newtype",
      "parsing",
      "argonaut-codecs",
      "datetime"
    ],
    repo = "https://github.com/jmackie/purescript-datetime-iso.git",
    version = "v4.0.0"
  },
  text-encoding = {
    dependencies = [
      "prelude",
      "functions",
      "either",
      "arraybuffer-types",
      "exceptions",
      "strings"
    ],
    repo = "https://github.com/AlexaDeWit/purescript-text-encoding.git",
    version = "v1.0.0"
  },
  affjax = {
    dependencies = [
      "aff",
      "argonaut-core",
      "arraybuffer-types",
      "web-xhr",
      "foreign",
      "form-urlencoded",
      "http-methods",
      "integers",
      "math",
      "media-types",
      "nullable",
      "refs",
      "unsafe-coerce"
    ],
    repo = "https://github.com/slamdata/purescript-affjax.git",
    version = "v9.0.1"
  },
  tweetnacl = {
    dependencies = [
      "prelude",
      "effect",
      "unsafe-coerce",
      "maybe",
      "arraybuffer",
      "arraybuffer-types",
      "nullable",
      "exceptions",
      "either",
      "text-encoding"
    ],
    repo = "https://github.com/AlexaDeWit/purescript-tweetnacl.git",
    version = "v1.0.0"
  },
  html-parser-halogen = {
    dependencies = [
      "string-parsers",
      "generics-rep",
      "halogen"
    ],
    repo = "https://github.com/rnons/purescript-html-parser-halogen.git",
    version = "7d37fd6a29bff2a143d91c2ebfe5ca582ca76018"
  }
}

in  upstream // overrides // additions
