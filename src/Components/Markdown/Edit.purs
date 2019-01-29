module Components.Markdown.Edit where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (unwrap, wrap)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen (liftEffect)
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

type State =
  { content :: String
  , fieldPrompt :: Term
  }

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Query a
  = Initialize a
  | UpdateContents String a
  | SendFinalize a

type Input = State

data Message
  = UpdatedContent String
  | Finalized

component
  :: forall m
  . MonadAff m 
  => LocaliseFn
  -> H.Component HH.HTML Query Input Message m
component t =
  H.lifecycleComponent
    { initialState: identity
    , render
    , eval
    , receiver: const Nothing
    , initializer: Just $ H.action Initialize
    , finalizer: Nothing
    }
  where

  textFieldClassName :: HH.ClassName
  textFieldClassName = HH.ClassName "markdown_editor_open"

  render :: State -> H.ComponentHTML Query
  render s =
      HH.div [] 
        [ HH.textarea
          [ HE.onValueChange (HE.input UpdateContents)
          , HE.onFocusOut (HE.input_ $ SendFinalize)
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

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval (Initialize next) = do
    element <- liftAff $ HU.selectElement $ wrap $ "." <> unwrap textFieldClassName
    liftEffect $ maybe (pure unit) (WE.focus) element
    pure next
  eval (UpdateContents newText next) = do
    H.modify_ (_{ content = newText })
    H.raise $ UpdatedContent newText
    pure next
  eval (SendFinalize next) = do
    H.raise Finalized
    pure next

