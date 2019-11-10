module Components.NotFound where

import Prelude
import Data.Const (Const)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms as Term
import Intl.Terms.NotFound as NF
import Style.Bulogen (container, hero, heroBody, subtitle, title)

component ::
  forall m.
  MonadAff m =>
  LocaliseFn ->
  H.Component HH.HTML (Const Void) Unit Void m
component localiseFn =
  H.mkComponent
    { initialState: const localiseFn
    , render
    , eval: H.mkEval $ H.defaultEval
    }
  where
  render :: LocaliseFn -> H.ComponentHTML Void () m
  render state =
    let
      pageTitle = state $ Term.NotFound NF.Title

      pageExplanation = state $ Term.NotFound NF.Explanation
    in
      HH.section [ HP.classes [ hero ] ]
        [ HH.div [ HP.classes [ heroBody ] ]
            [ HH.div [ HP.classes [ container ] ]
                [ HH.h1 [ HP.classes [ title ] ] [ HH.text pageTitle ]
                , HH.h2 [ HP.classes [ subtitle ] ] [ HH.text pageExplanation ]
                ]
            ]
        ]
