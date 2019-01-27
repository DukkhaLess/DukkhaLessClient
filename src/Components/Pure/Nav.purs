module Components.Pure.Nav where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Halogen.HTML (HTML(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Model (Session(..))

sessionlessMenu :: forall a b. HTML a b
sessionlessMenu =
  HH.nav_
    [ HH.ul_ (map link [R.Intro, R.Resources, R.Sessions RS.Login])
    ]

sessionedMenu
  :: forall a b
  . Session
  -> HTML a b
sessionedMenu _ =
  HH.nav_
    [ HH.ul_ (map link [R.Intro, R.Resources, R.Journals $ RJ.Edit Nothing])
    ]

link :: forall a b. R.Routes -> HTML a b
link r = HH.li_ [ HH.a [ HP.href $ R.reverseRoute r ] [ HH.text $ R.reverseRoute r ] ]
