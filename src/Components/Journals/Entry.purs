module Components.Journals.Entry where

import Data.Guards
import Prelude

import AppM (CurrentSessionRow, EditingJournalEntryRow)
import Components.Pure.Markdown (renderMarkdown)
import Components.Pure.Widgets as CW
import Components.Markdown.Edit as Edit
import Control.Monad.Reader.Class (class MonadAsk, asks)
import Control.Monad.State (class MonadState)
import Control.Monad.State as MS
import Data.Const (Const)
import Data.Crypto.Types (DocumentId, DecryptionError)
import Data.Default (default)
import Data.Markdown.Parser (MarkdownText(..))
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Newtype (wrap, unwrap)
import Data.Routing.Routes.Journals (Journals(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Component.ChildPath (ChildPath, cpL, cpR, (:>))
import Halogen.Data.Prism (type (<\/>), type (\/))
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..), setTitle)
import Network.RemoteData (RemoteData(..))
import Style.Bulogen as SB
import Type.Data.Boolean (kind Boolean)
import Type.Row (type (+))

data Query a
  = Initialize a
  | ToggleContentEdit Boolean a
  | UpdateContents String a
  | UpdateTitle String a
  | ToggleTitleEdit Boolean a

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

type ChildQuery
  = Edit.Query
  <\/> Const Void

type ChildSlot
  = Edit.Slot
  \/ Void

pathToEdit :: ChildPath Edit.Query ChildQuery Edit.Slot ChildSlot
pathToEdit = cpL

data Message = MNoMsg

type State =
  { entry :: RemoteData DecryptionError JournalEntry
  , desiredEntryId :: Maybe DocumentId
  , contentEditing :: Boolean
  , titleEditing :: Boolean
  }

newtype Input
  = Input
  { desiredEntry :: Maybe DocumentId
  }

initialState :: Input -> State
initialState (Input input) = 
  { entry: NotAsked
  , contentEditing: false
  , desiredEntryId: input.desiredEntry
  , titleEditing: false
  }

type RequiredState r =
  ( EditingJournalEntryRow
  + CurrentSessionRow
  + r
  )

component 
  :: forall m r
  . MonadAff m
  => MonadAsk (Record (RequiredState r)) m
  => LocaliseFn -> H.Component HH.HTML Query Input Message m
component t =
  H.lifecycleParentComponent
      { initialState
      , render
      , eval: eval H.raise
      , receiver: const Nothing
      , initializer: Just $ H.action Initialize
      , finalizer: Nothing
      }
  where

  render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
  render state = case state.entry of
    Failure e -> loadingFailed e
    Success a -> entryRender a
    NotAsked -> notAsked
    Loading  -> CW.loading
    where

    entryRender :: JournalEntry -> H.ParentHTML Query ChildQuery ChildSlot m
    entryRender entry =
      HH.div []
        [ case state.titleEditing of
            false ->
              HH.h1
                [ HP.classes
                  [ SB.tile
                  ]
                ] 
                [ HH.text $ guardMap ((/=) "") "Title" identity title
                ]
            true ->
              HH.div
                [ HP.classes
                  [
                  ]
                ]
                [ HH.input
                    [ HP.classes
                      [ SB.input
                      ]
                    , HP.value title
                    , HE.onValueChange (HE.input UpdateTitle)
                    , HE.onFocusOut (HE.input_ $ ToggleTitleEdit false)
                    ]
                , HH.button
                  [ HP.classes
                    [ SB.primary
                    , SB.button
                    ]
                  ]
                  [ HH.text "Save"
                  ]
                ]
        , case state.contentEditing of 
            false -> guardMap ((/=) "") markdownPlaceholder markdownRendered (unwrap entry).content
            true  ->
              HH.slot'
                pathToEdit
                Edit.Slot
                (Edit.component t)
                (unwrap entry).content
                mapEditMessageToQuery
        ]
        where
          title = (unwrap (unwrap entry).metaData).title
        
    markdownPlaceholder :: H.ParentHTML Query ChildQuery ChildSlot m
    markdownPlaceholder =
      HH.div
        [ HP.classes
          [ SB.section
          , SB.medium
          ]
        , HE.onClick (HE.input_ $ ToggleContentEdit true)
        ]
        [ HH.p []
          [ HH.text "Placeholder!"
          ]
        ]


    markdownRendered :: String -> H.ParentHTML Query ChildQuery ChildSlot m
    markdownRendered content =
      HH.div []
        [ HH.p [ HE.onClick (HE.input_ $ ToggleContentEdit true)]
          [ HH.div
            [ HP.class_ (HH.ClassName "markdown-body")
            ]
            [ renderMarkdown $ MarkdownText content
            ]
          ]
        ]

    loadingFailed :: DecryptionError -> H.ParentHTML Query ChildQuery ChildSlot m
    loadingFailed _ = HH.text "Error"

    notAsked :: H.ParentHTML Query ChildQuery ChildSlot m
    notAsked = HH.text "None requested"

  eval
    :: forall t
    . MonadState State t
    => (Message -> t Unit)
    -> Query ~> t
  eval raise query = case query of
    (Initialize next) -> do
      desiredEntry <- MS.gets (_.desiredEntryId)
      case desiredEntry of
        Just id -> do
          MS.modify_ (_{ entry = Loading })
        Nothing -> MS.modify_ (_{ entry = Success default })
      raise $ MNoMsg
      pure next
    (ToggleContentEdit edit next) -> do
      MS.modify_ (_{ contentEditing = edit })
      pure next
    (ToggleTitleEdit edit next) -> do
      MS.modify_ (_{ titleEditing = edit })
      pure next
    (UpdateContents mdText next) -> do
      entry <- MS.gets (_.entry)
      let newEntry = (wrap <<< (_{ content = mdText }) <<< unwrap ) <$> entry 
      MS.modify_ (_{ entry = newEntry })
      pure next
    (UpdateTitle nextTitle next) -> do
      entry <- MS.gets (_.entry)
      let nextEntry = entry <#> setTitle nextTitle
      MS.modify_ (_{ entry = nextEntry })
      pure next
    
  mapEditMessageToQuery :: Edit.Message -> Maybe (Query Unit)
  mapEditMessageToQuery msg = case msg of
    Edit.Finalized -> Just $ ToggleContentEdit false unit
    Edit.UpdatedContent c -> Just $ UpdateContents c unit
    