module Components.Nav
  (component, Slot(..), Query, Message, Input(..)) where

import Prelude

import Control.Monad.State (class MonadState, gets, modify_)
import Data.Array (cons, (:))
import Data.Either (Either(..))
import Data.Guards (mapIf)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms (Term(Journal, Session))
import Intl.Terms.Journals (Journals(..))
import Intl.Terms.Sessions (Sessions(Login))
import Model (Session)
import Style.Bulogen as SB


data Query a
  = ToggleBurger a
  | UpdateSession (Maybe Session) a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

type State =
  { session :: Maybe Session
  , expandedBurger :: Boolean
  }

type Input = Maybe Session

type Message = Unit

initialState :: Input -> State
initialState s =
  { session: s
  , expandedBurger: false
  }

component 
  :: forall m
  . MonadAff m
  => LocaliseFn -> H.Component HH.HTML Query Input Unit m
component t =
  H.component
    { initialState
    , render
    , eval
    , receiver
    }
    where

  render :: State -> H.ComponentHTML Query
  render state =
    case state.session of
      Nothing -> sessionlessMenu state t
      Just session -> sessionedMenu state t session

  eval
    :: forall t
    . MonadState State t
    => Query ~> t
  eval query = case query of
    ToggleBurger next -> do
      expandedBurger <- gets (_.expandedBurger)
      modify_ (_{ expandedBurger = not expandedBurger })
      pure next
    UpdateSession newSession next -> do
      modify_ (_{ session = newSession })
      pure next

  receiver :: Input -> Maybe (Query Unit)
  receiver newSession = Just (UpdateSession newSession unit)


sessionlessMenuItems
 :: LocaliseFn
 -> Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
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
  :: State
  -> LocaliseFn
  -> Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
  -> H.ComponentHTML Query
navWrapper state t (Tuple leftItems rightItems) =
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
            [ HP.classes $
                mapIf
                  (const state.expandedBurger)
                  [ SB.navbarBurger
                  , SB.burger
                  ]
                  (cons SB.active)
            , HE.onClick (HE.input_ ToggleBurger)
            ]
            [ HH.span_ []
            , HH.span_ []
            , HH.span_ []
            ]
          ]
        , HH.div 
          [ HP.classes $
              mapIf
              (const state.expandedBurger)
              [ SB.navbarMenu
              ]
              (cons SB.active)
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
  :: State 
  -> LocaliseFn
  -> H.ComponentHTML Query
sessionlessMenu state t = navWrapper state t (sessionlessMenuItems t)

sessionedMenu
  :: State 
  -> LocaliseFn
  -> Session
  -> H.ComponentHTML Query
sessionedMenu state t = sessionedMenuItems t >>> navWrapper state t

sessionedMenuItems
  :: LocaliseFn
  -> Session
  -> Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
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
  :: LocaliseFn
  -> Either R.Routes (Tuple Term (Array R.Routes))
  -> H.ComponentHTML Query
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
        
