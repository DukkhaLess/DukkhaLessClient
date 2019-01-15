module Components.Journals.List where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)

data Query a = NoOp a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

data Message = MNoMsg

newtype State = State {}

initialState :: forall a. a -> State
initialState = const $ State {}

component :: forall a. LocaliseFn -> H.Component HH.HTML Query a Message Aff
component t =
  H.component
    { initialState: initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: State -> H.ComponentHTML Query
  render _ = HH.text "Hi"

  eval :: Query ~> H.ComponentDSL State Query Message Aff
  eval (NoOp next) = pure next