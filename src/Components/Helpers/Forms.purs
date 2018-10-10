module Components.Helpers.Forms where

import Data.Validation

import Data.Bifunctor (lmap)
import Data.Either (either)
import Data.Newtype (unwrap)
import Data.Semigroup ((<>))
import Halogen.HTML as HH
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Properties (IProp)
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms (Term)
import Prelude (($), const, map)
import Style.Bulogen as SB
import Unsafe.Coerce (unsafeCoerce)

validated' :: forall a r p i. Validation a r -> LocaliseFn -> HTML p i -> HTML p i
validated' v t f =
  validated
    v
    t
    (map unwrap)
    f
    [ HP.classes
      [ SB.danger
      , SB.help
      ]
    ]

validated :: forall a e r r2 p i. ValidationG e a r -> LocaliseFn -> (e -> Array Term) -> HTML p i -> Array (IProp r2 i) -> HTML p i
validated v t describeError field ps = elem where
  elem = HH.div
    [ HP.classes
      [ SB.control
      ]
    ]
    children
  children = case inputState v of
    Dirty -> either (\es -> [field] <> errElems es)  (const [field]) result
    Initial -> [field]
  errElem err = HH.p (unsafeCoerce ps) [ HH.text $ t err ]
  errElems = map errElem
  result = lmap describeError (validate v)