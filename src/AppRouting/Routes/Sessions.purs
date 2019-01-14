module AppRouting.Routes.Sessions where

import AppRouting.Class (class ReverseRoute)

data Sessions
  = Login
  | Register


instance reverseRouteSessions :: ReverseRoute Sessions where
  reverseRoute r = case r of
    Login -> "login"
    Register -> "register"


