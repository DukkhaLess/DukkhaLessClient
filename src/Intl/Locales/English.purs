module Intl.Locales.English where

import Data.Maybe (Maybe(..))
import Data.Semigroup ((<>))
import Data.Validation (Validation)
import Intl.Terms (j, n)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.NotFound as NotFound
import Intl.Terms.Resources as Resource
import Intl.Terms.Sessions as Sessions
import Intl.Terms.Validation (ValidationMsg(..))
import Intl.Terms.Validation as Validation
import Prelude (show, ($))

localise :: Term.Term -> Maybe String
localise term = case term of
  Term.Intro intro -> localiseIntro intro
  Term.Resource resource -> localiseResource resource
  Term.Session session -> localiseSession session
  Term.NotFound notFound -> localiseNotFound notFound
  Term.Validation validation -> localiseValidation validation

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = j "Dukkhaless Self-Care"
localiseIntro Intro.Explanation = j "A Selfcare application with encryption to help work on your mental health"

localiseResource :: Resource.Resources -> Maybe String
localiseResource Resource.Title = j "Resources"

localiseSession :: Sessions.Sessions -> Maybe String
localiseSession Sessions.Login = j "Login"
localiseSession Sessions.Password = j "Password"
localiseSession Sessions.ConfirmPassword = j "Confirm Password"
localiseSession Sessions.Register = j "Register"
localiseSession Sessions.Username = j "Username"
localiseSession Sessions.KeyRing = j "Your secret keys"
localiseSession Sessions.KeyRingInstructions = j "Please save your secret keys. If they are lost, you will no longer be able to access your data."
localiseSession Sessions.RegisterButtonText = j "Register and Download Keys"
localiseSession Sessions.Logout = j "Logout"
localiseSession Sessions.LoginInstead = j "Already have an account? Login!"
localiseSession Sessions.RegisterInstead = j "Don't have an account? Register!"
localiseSession Sessions.CopyKey = j "Copy"
localiseSession Sessions.DownloadKey = j "Download"
localiseSession Sessions.KeySubtitle = j "Your Secret Keys"

localiseNotFound :: NotFound.NotFound -> Maybe String
localiseNotFound t = j case t of
  NotFound.Title -> "Not Found"
  NotFound.Explanation -> "The desired page could not be located"

localiseValidation :: Validation.ValidationMsg -> Maybe String
localiseValidation msg = case msg of
  (InsufficientLength rl) -> j $ "Must be at least " <> show rl <> " characters long."
  (RequiredCharacters cts) -> j $ "Must contain: "
  (MustMatchOtherField field) -> j $ "Does not match"