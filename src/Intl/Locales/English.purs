module Intl.Locales.English where

import Data.Maybe (Maybe)
import Data.Semigroup ((<>))
import Intl.Terms (j)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.NotFound as NotFound
import Intl.Terms.Resources as Resource
import Intl.Terms.Sessions as Sessions
import Intl.Terms.Validation (ValidationMsg(..))
import Intl.Terms.Validation as Validation
import Intl.Terms.Journals as Journals
import Prelude (show, ($))

localise :: Term.Term -> Maybe String
localise term = case term of
  Term.Intro intro -> localiseIntro intro
  Term.Resource resource -> localiseResource resource
  Term.Session session -> localiseSession session
  Term.NotFound notFound -> localiseNotFound notFound
  Term.Validation validation -> localiseValidation validation
  Term.Journal journal -> localiseJournal journal

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = j "Dukkhaless Self-Care"
localiseIntro Intro.Explanation = j "A Selfcare application with encryption to help work on your mental health"

localiseResource :: Resource.Resources -> Maybe String
localiseResource Resource.Title = j "Resources"

localiseSession :: Sessions.Sessions -> Maybe String
localiseSession s = case s of
   Sessions.Login -> j "Login"
   Sessions.Password -> j "Password"
   Sessions.ConfirmPassword -> j "Confirm Password"
   Sessions.Register -> j "Register"
   Sessions.Username -> j "Username"
   Sessions.KeyRing -> j "Your secret keys"
   Sessions.KeyRingInstructions -> j "Please save your secret keys. If they are lost, you will no longer be able to access your data."
   Sessions.RegisterButtonText -> j "Register and Download Keys"
   Sessions.Logout -> j "Logout"
   Sessions.LoginInstead -> j "Already have an account? Login!"
   Sessions.RegisterInstead -> j "Don't have an account? Register!"
   Sessions.CopyKey -> j "Copy"
   Sessions.DownloadKey -> j "Download"
   Sessions.KeySubtitle -> j "Your Secret Keys"
   Sessions.Submit -> j "Submit"

localiseNotFound :: NotFound.NotFound -> Maybe String
localiseNotFound t = j case t of
  NotFound.Title -> "Not Found"
  NotFound.Explanation -> "The desired page could not be located"

localiseValidation :: Validation.ValidationMsg -> Maybe String
localiseValidation msg = case msg of
  (InsufficientLength rl) -> j $ "Must be at least " <> show rl <> " characters long."
  (RequiredCharacters cts) -> j $ "Must contain: "
  (MustMatchOtherField field) -> j $ "Does not match"
  (ParserFailed reason) -> j $ "Parsing failed. Reason given was: " <> reason
  
localiseJournal :: Journals.Journals -> Maybe String
localiseJournal msg = case msg of
  (Journals.JournalEntries) -> j $ "Journal Entries"
  (Journals.Create) -> j $ "New Entry"
