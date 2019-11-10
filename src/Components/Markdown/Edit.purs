module Components.Markdown.Edit where

import Prelude
import Data.Const (Const)
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (unwrap, wrap)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen as H
import Halogen.Aff.Util as HU
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms (Term)
import Style.Bulogen as SB
import Style.Classes as SC
import Web.HTML.HTMLElement as WE

type State
  = { content :: String
    , fieldPrompt :: Term
    }

data Action
  = Initialize
  | UpdateContents String
  | SendFinalize

type Input
  = State

data Message
  = UpdatedContent String
  | Finalized

type ChildSlots
  = ()

component ::
  forall m.
  MonadAff m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) Input Message m
component t =
  H.mkComponent
    { initialState: identity
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction = handleAction
            }
    }
  where
  textFieldClassName :: HH.ClassName
  textFieldClassName = HH.ClassName "markdown_editor_open"

  render :: State -> H.ComponentHTML Action ChildSlots m
  render s =
    HH.div []
      [ HH.textarea
          [ HE.onValueChange (Just <<< UpdateContents)
          , HE.onFocusOut (\_ -> Just SendFinalize)
          , HP.placeholder $ t $ s.fieldPrompt
          , HP.value $ s.content
          , HP.rows 20
          , HP.classes
              [ textFieldClassName
              , SB.textarea
              , SB.block
              , SC.xWrapped
              ]
          ]
      ]

  handleAction :: Action -> H.HalogenM State Action ChildSlots Message m Unit
  handleAction Initialize = do
    element <- liftAff $ HU.selectElement $ wrap $ "." <> unwrap textFieldClassName
    H.liftEffect $ maybe (pure unit) (WE.focus) element

  handleAction (UpdateContents newText) = do
    H.modify_ (_ { content = newText })
    H.raise $ UpdatedContent newText

  handleAction SendFinalize = do
    H.raise Finalized
