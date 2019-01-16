module Capability.UserSession where

import Data.HTTP.Payloads (SubmitLogin, SubmitRegister)
import Data.Maybe (Maybe)
import Model (Session)
import Model.Keyring (Keyring)
import Prelude (class Monad)

class Monad m <= ManageUser m where
  loginUser :: Keyring -> SubmitLogin -> m (Maybe Session)
  register :: Keyring -> SubmitRegister -> m (Maybe Session)
