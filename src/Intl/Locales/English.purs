module Intl.Locales.English where

import Data.Maybe (Maybe(..))
import Intl.Terms (j, n)
import Intl.Terms as Term
import Intl.Terms.Introduction as Intro
import Intl.Terms.Resources as Resource
import Intl.Terms.Sessions as Sessions

localise :: Term.Term -> Maybe String
localise (Term.Intro intro) = localiseIntro intro
localise (Term.Resource resource) = localiseResource resource
localise (Term.Session session) = localiseSession session

localiseIntro :: Intro.Introduction -> Maybe String
localiseIntro Intro.Title = j "My Selfcare"
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

