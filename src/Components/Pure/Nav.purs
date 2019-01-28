module Components.Pure.Nav where

import Prelude

import Data.Array ((:))
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
import Intl.Terms (Term(Journal, Session))
import Intl.Terms.Journals (Journals(..))
import Intl.Terms.Sessions (Sessions(Login))
import Model (Session)
import Style.Bulogen as SB

sessionlessMenuItems
 :: forall a b
 .  LocaliseFn
 -> Tuple (Array (HTML a b)) (Array (HTML a b))
sessionlessMenuItems t = 
  Tuple
  (map (Left >>> link t) [])
  [ HH.div
      [ HP.classes
        [ SB.navbarItem
        ]
      ]
      [ HH.a
        [ HP.href $ R.reverseRoute $ R.Sessions RS.Login 
        , HP.classes
          [ SB.button
          , SB.info
          ]
        ]
        [ HH.text $ t $ Session Login
        ]
      ]
  ]

navWrapper
  :: forall a b
  .  LocaliseFn
  -> Tuple (Array (HTML a b)) (Array (HTML a b))
  -> HTML a b
navWrapper t (Tuple leftItems rightItems) =
  HH.div
    [ HP.classes
      [ SB.paddingless
      ]
    ]
    [
      HH.nav
        [ HP.classes
          [ SB.navbar
          , SB.primary
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
                , HP.href $ R.reverseRoute R.Intro
              ]
              [ HH.img
                  [ HP.alt "DukkhaLess, a self-care and jounraling application for everyone!"
                  , HP.src "static/assets/branding.png"
                  , HP.width 120
                  , HP.height 28
                  ]
              ]
          , HH.div
            [ HP.classes
              [ SB.navbarBurger
              , SB.burger
              ]
            ]
            [ HH.span_ []
            , HH.span_ []
            , HH.span_ []
            ]
          ]
        , HH.div 
          [ HP.classes
            [ SB.navbarMenu
            ]
          ]
          [ HH.div
            [ HP.classes
              [ SB.navbarStart
              ]
            ]
            leftItems
          , HH.div
            [ HP.classes
              [ SB.navbarEnd
              ]
            ]
            rightItems
          ]
        ]
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
  -> Tuple (Array (HTML a b)) (Array (HTML a b))
sessionedMenuItems t _ =
  Tuple
    leftItems
    []
    where
    leftItems =
      ( link t $ Right $ Tuple (Journal Journals)
        [ R.Journals $ RJ.Edit Nothing
        , R.Journals RJ.List
        ]
      ) : []

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
          , SB.hoverable
          ]
        ]
        [ HH.a
          [ HP.classes
            [ SB.navbarLink
            ]
          ]
          [ HH.text $ t $ term
          , HH.div
            [ HP.classes
              [ SB.navbarDropdown
              ]
            ]
            (map (Left >>> link t) rs)
        ]
      ]
        
