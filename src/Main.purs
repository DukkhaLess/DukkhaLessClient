{-
    The MySelfCare Client is a web application designed to give people
    a safe space to write their innermost thoughts and help them
    monitor their mental health.
    Copyright (C) 2018  Alexandra DeWit

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
-}
module Main where

import Prelude

import AppM (makeEnv, runAppM)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as Routes
import Effect (Effect)
import Effect.Aff (forkAff)
import Effect.Class (liftEffect)
import Halogen.VDom.Driver (runUI)
import Halogen as H
import Intl (localiseString)
import Intl.Locales (preferredUserLanguages)

import Components.Router as Router
import Halogen.Aff as HA

foreign import removeLoader :: Effect Unit

main :: Effect Unit
main = HA.runHalogenAff $ do
    userLanguages <- liftEffect preferredUserLanguages
    let translate = localiseString userLanguages
        
    env <- makeEnv translate

    existingSession <- pure Nothing
        
    body <- HA.awaitBody
    _ <- liftEffect removeLoader
    let rootComponent = H.hoist (runAppM env) (Router.component translate)
    router <- runUI rootComponent unit body
    forkAff $ liftEffect $ Router.routeSignal router
