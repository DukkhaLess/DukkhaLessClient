module Components.Nav (component, Slot(..), Message, Input(..)) where

import Prelude
import AppM (CurrentSessionRow')
import Components.Helpers.Class (makeIcon)
import Components.Helpers.StateAccessors (logout)
import Control.Monad.Reader (class MonadAsk, asks)
import Control.Monad.State (class MonadState, gets, modify_)
import Data.Array (cons, (:))
import Data.Const (Const(..))
import Data.Either (Either(..))
import Data.Foldable (foldr)
import Data.Guards (mapIf)
import Data.Maybe (Maybe(..))
import Data.Maybe (maybe)
import Data.Routing.Routes (Routes)
import Data.Routing.Routes as R
import Data.Routing.Routes.Journals as RJ
import Data.Routing.Routes.Sessions as RS
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\), type (/\))
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

data Action
  = ToggleBurger
  | Initialize
  | Synchronize Routes
  | PerformLogout

data Slot
  = Slot

derive instance eqSlot :: Eq Slot

derive instance ordSlot :: Ord Slot

type State
  = { session :: Maybe Session
    , expandedBurger :: Boolean
    , currentRouteContext :: Routes
    }

type Input
  = Routes

type Message
  = Unit

initialState :: Input -> State
initialState r =
  { session: Nothing
  , expandedBurger: false
  , currentRouteContext: r
  }

component ::
  forall m r.
  MonadAff m =>
  MonadEffect m =>
  MonadAsk (CurrentSessionRow' r) m =>
  LocaliseFn -> H.Component HH.HTML (Const Void) Input Unit m
component t =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ ( H.defaultEval
              { receive = receive
              }
          )
    }
  where
  render :: State -> H.ComponentHTML Action () m
  render state = case state.session of
    Nothing -> sessionlessMenu state
    Just session -> sessionedMenu state session

  handleAction ::
    forall t.
    MonadState State t =>
    MonadEffect t =>
    MonadAsk (CurrentSessionRow' r) t =>
    Action -> t Unit
  handleAction action = case action of
    ToggleBurger -> do
      expandedBurger <- gets (_.expandedBurger)
      modify_ (_ { expandedBurger = not expandedBurger })
    Initialize -> do
      syncSession
    Synchronize r -> do
      syncSession
      modify_ (_ { currentRouteContext = r })
    PerformLogout -> do
      logout
      syncSession
    where
    syncSession = do
      session <- asks _.currentSession >>= Ref.read >>> liftEffect
      modify_ (_ { session = session })

  receive :: Input -> Maybe Action
  receive r = Just $ Synchronize r

  sessionlessMenuItems ::
    Tuple (Array (H.ComponentHTML Action () m)) (Array (H.ComponentHTML Action () m))
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
              [ HH.i [ HP.classes [ FA.solid, FA.signInAlt ] ] []
              , HH.span_ [ HH.text $ t $ Session Login ]
              ]
          ]
      ]

  navWrapper ::
    State ->
    Tuple (Array (H.ComponentHTML Action () m)) (Array (H.ComponentHTML Action () m)) ->
    H.ComponentHTML Action () m
  navWrapper state (Tuple leftItems rightItems) =
    HH.div
      [ HP.classes
          [ SB.paddingless
          ]
      ]
      [ HH.nav
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
                      $ mapIf
                          (const state.expandedBurger)
                          [ SB.navbarBurger
                          , SB.burger
                          ]
                          (cons SB.active)
                  , HE.onClick (const $ Just ToggleBurger)
                  ]
                  [ HH.span_ []
                  , HH.span_ []
                  , HH.span_ []
                  ]
              ]
          , HH.div
              [ HP.classes
                  $ mapIf
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

  sessionlessMenu ::
    State ->
    H.ComponentHTML Action () m
  sessionlessMenu state = navWrapper state (sessionlessMenuItems)

  sessionedMenu ::
    State ->
    Session ->
    H.ComponentHTML Action () m
  sessionedMenu state = sessionedMenuItems >>> navWrapper state

  sessionedMenuItems ::
    Session ->
    Tuple (Array (H.ComponentHTML Action () m)) (Array (H.ComponentHTML Action () m))
  sessionedMenuItems _ =
    Tuple
      leftItems
      rightItems
    where
    leftItems =
      ( link $ Right $ Journal Journals /\ Just FA.penAlt
          /\ [ R.Journals $ RJ.Edit Nothing
            , R.Journals RJ.List
            ]
      )
        : []

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
              , HE.onClick (const $ Just PerformLogout)
              ]
              [ HH.i [ HP.classes [ FA.solid, FA.signOutAlt ] ] []
              , HH.span_ [ HH.text $ t $ Session Logout ]
              ]
          ]
      ]

  link ::
    Either R.Routes (Term /\ Maybe (FontAwesomeIconClass) /\ Array R.Routes) ->
    H.ComponentHTML Action () m
  link routes = case routes of
    Left r ->
      HH.a
        [ HP.href $ R.reverseRoute r
        , HP.classes
            [ SB.navbarItem
            ]
        ]
        ( foldr cons
            [ HH.span_ [ HH.text $ t $ describe r ]
            ]
            (makeIcon r)
        )
    Right (term /\ iconClass /\ rs) ->
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
            ( foldr cons
                [ HH.span_ [ HH.text $ t $ term ]
                , HH.div
                    [ HP.classes
                        [ SB.navbarDropdown
                        ]
                    ]
                    (map (Left >>> link) rs)
                ]
                ( iconClass
                    <#> \c ->
                        HH.i [ HP.classes [ FA.solid, c ] ] []
                )
            )
        ]

type FontAwesomeIconClass
  = HH.ClassName
