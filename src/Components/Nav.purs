module Components.Nav
  (component, Slot(..), Query, Message, Input(..)) where

import Prelude

import AppM (CurrentSessionRow')
import Components.Helpers.StateAccessors (logout)
import Components.Helpers.Class (makeIcon)
import Control.Monad.Reader (class MonadAsk, asks)
import Control.Monad.State (class MonadState, gets, modify_)
import Data.Array (cons, (:))
import Data.Maybe (maybe)
import Data.Either (Either(..))
import Data.Foldable (foldr)
import Data.Guards (mapIf)
import Data.Maybe (Maybe(..))
import Data.Routing.Routes (Routes)
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Class (describe)
import Intl.Terms (Term(Journal, Session))
import Intl.Terms.Journals (Journals(..))
import Intl.Terms.Sessions (Sessions(..))
import Model (Session)
import Style.Bulogen as SB
import Style.FontHawesome as FA


data Query a
  = ToggleBurger a
  | Initialize a
  | Synchronize Routes a
  | PerformLogout a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

type State =
  { session :: Maybe Session
  , expandedBurger :: Boolean
  , currentRouteContext :: Routes
  }

type Input = Routes

type Message = Unit

initialState :: Input -> State
initialState r =
  { session: Nothing
  , expandedBurger: false
  , currentRouteContext: r
  }

component 
  :: forall m r
  .  MonadAff m
  => MonadEffect m
  => MonadAsk (CurrentSessionRow' r) m
  => LocaliseFn -> H.Component HH.HTML Query Input Unit m
component t =
  H.lifecycleComponent
    { initialState
    , render
    , eval
    , receiver
    , initializer: Just $ Initialize unit
    , finalizer: Nothing
    }
    where

  render :: State -> H.ComponentHTML Query
  render state =
    case state.session of
      Nothing -> sessionlessMenu state
      Just session -> sessionedMenu state session

  eval
    :: forall t
    .  MonadState State t
    => MonadEffect t
    => MonadAsk (CurrentSessionRow' r) t
    => Query ~> t
  eval query = case query of
    ToggleBurger next -> do
      expandedBurger <- gets (_.expandedBurger)
      modify_ (_{ expandedBurger = not expandedBurger })
      pure next
    Initialize next -> do
      syncSession
      pure next
    Synchronize r next -> do
      syncSession
      modify_ (_{ currentRouteContext = r })
      pure next
    PerformLogout next -> do
      logout
      syncSession
      pure next
    where
      syncSession = do
        session <- asks _.currentSession >>= Ref.read >>> liftEffect
        modify_ (_{ session = session })



  receiver :: Input -> Maybe (Query Unit)
  receiver r = Just $ Synchronize r unit

  sessionlessMenuItems
    :: Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
  sessionlessMenuItems = 
    Tuple
    (map (Left >>> link) [])
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
          [ HH.i [ HP.classes [FA.solid, FA.signInAlt]] []
          , HH.span_ [ HH.text $ t $ Session Login ]
          ]
        ]
    ]

  navWrapper
    :: State
    -> Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
    -> H.ComponentHTML Query
  navWrapper state (Tuple leftItems rightItems) =
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
    -> H.ComponentHTML Query
  sessionlessMenu state = navWrapper state (sessionlessMenuItems)

  sessionedMenu
    :: State 
    -> Session
    -> H.ComponentHTML Query
  sessionedMenu state = sessionedMenuItems >>> navWrapper state

  sessionedMenuItems
    :: Session
    -> Tuple (Array (H.ComponentHTML Query)) (Array (H.ComponentHTML Query))
  sessionedMenuItems _ =
    Tuple
      leftItems
      rightItems
      where
      leftItems =
        ( link $ Right $ Tuple (Journal Journals)
          [ R.Journals $ RJ.Edit Nothing
          , R.Journals RJ.List
          ]
        ) : []
      rightItems =
        [ HH.div
            [ HP.classes
              [ SB.navbarItem
              ]
            ]
            [ HH.a
              [ HP.classes
                [ SB.button
                , SB.info
                ]
                , HE.onClick (HE.input_ $ PerformLogout)
              ]
              [ HH.i [ HP.classes [FA.solid, FA.signOutAlt]] []
              , HH.span_ [ HH.text $ t $ Session Logout ]
              ]
            ]
        ]


  link
    :: Either R.Routes (Tuple Term (Array R.Routes))
    -> H.ComponentHTML Query
  link routes =
    case routes of
      Left r ->
        HH.a 
          [ HP.href $ R.reverseRoute r
          , HP.classes
            [ SB.navbarItem
            ]
          ]
          (foldr cons
            [ HH.span_ [HH.text $ t $ describe r]
            ]
            (makeIcon r))
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
              (map (Left >>> link) rs)
          ]
        ]
          
