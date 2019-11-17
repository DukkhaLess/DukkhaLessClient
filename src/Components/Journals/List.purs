module Components.Journals.List where

import Prelude
import AppM (CurrentSessionRow, JournalMetaCacheRow)
import Control.Monad.Reader.Class (class MonadAsk)
import Data.Const (Const)
import Effect.Aff.Class (class MonadAff)
import Halogen (mkEval)
import Halogen as H
import Halogen.HTML as HH
import Intl (LocaliseFn)
import Type.Row (type (+))

newtype State
  = State {}

type ChildSlots
  = ()

initialState :: forall a. a -> State
initialState = const $ State {}

type RequiredState r
  = ( CurrentSessionRow
        + JournalMetaCacheRow
        + r
    )

component ::
  forall m r.
  MonadAff m =>
  MonadAsk (Record (RequiredState r)) m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) {} Void m
component t =
  H.mkComponent
    { initialState
    , render
    , eval: mkEval $ H.defaultEval
    }
  where
  render :: State -> H.ComponentHTML Void ChildSlots m
  render _ = HH.text "Hi"
