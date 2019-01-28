module Components.Pure.Nav where

import Prelude

import Data.Array (snoc)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..))
import Halogen.HTML (HTML)
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms (Term(Journal))
import Intl.Terms.Journals (Journals(..))
import Model (Session)
import Style.Bulogen as SB

sessionlessMenuItems
 :: forall a b
 .  LocaliseFn
 -> Array (HTML a b)
sessionlessMenuItems t =
  map (Left >>> link t)
    [ R.Intro
    , R.Resources
    , R.Sessions RS.Login
    ]

navWrapper
  :: forall a b
  .  LocaliseFn
  -> Array (HTML a b)
  -> HTML a b
navWrapper t items =
  HH.nav
    [ HP.classes
      [ SB.navbar
      , SB.success
      ]
    ]
    [ HH.div
      [ HP.classes
        [ SB.navbarBrand
        ]
      ]
      [ HH.a
          [ HP.classes
            [ SB.navbarItem
            ]
          ]
          [ HH.img
              [ HP.alt "DukkhaLess, a self-care and jounraling application for everyone!"
              , HP.src "static/assets/branding.png"
              , HP.width 120
              , HP.height 28
              ]
          ]
      ]
    , HH.div
        [ HP.classes
          [ SB.navbarStart
          ]
        ]
        items
    , HH.div
      [ HP.classes
        [ SB.navbarEnd
        ]
      ]
      []
    ]
   
sessionlessMenu
  :: forall a b
  .  LocaliseFn
  -> HTML a b
sessionlessMenu t = navWrapper t (sessionlessMenuItems t)

sessionedMenu
  :: forall a b
  .  LocaliseFn
  -> Session
  -> HTML a b
sessionedMenu t = sessionedMenuItems t >>> navWrapper t

sessionedMenuItems
  :: forall a b
  .  LocaliseFn
  -> Session
  -> Array (HTML a b)
sessionedMenuItems t _ =
  snoc 
    ( map (Left >>> link t) 
        [ R.Intro
        , R.Resources
        ]
    )
    ( link t $ Right $ Tuple (Journal Journals)
      [ R.Journals $ RJ.Edit Nothing
      , R.Journals RJ.List
      ]
    )

link
  :: forall a b
  .  LocaliseFn
  -> Either R.Routes (Tuple Term (Array R.Routes))
  -> HTML a b
link t routes =
  case routes of
    Left r ->
      HH.a 
        [ HP.href $ R.reverseRoute r
        , HP.classes
          [ SB.navbarItem
          ]
        ]
        [ HH.text $ R.reverseRoute r ]
    Right (Tuple term rs) ->
      HH.div
        [ HP.classes
          [ SB.navbarItem
          , SB.hasDropdown
          ]
        ]
        (map (Left >>> link t) rs)
        
