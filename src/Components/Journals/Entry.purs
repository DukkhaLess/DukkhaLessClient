module Components.Journals.Entry where

import Prelude

import AppM (CurrentSessionRow, EditingJournalEntryRow)
import Components.Helpers.Markdown (renderMarkdown)
import Components.Markdown.Edit as Edit
import Control.Monad.Reader.Class (class MonadAsk, asks)
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
import Model.Journal (JournalEntry(..), JournalMeta(..))
import Network.RemoteData (RemoteData(..))
import Style.Bulogen as SB
import Type.Data.Boolean (kind Boolean)
import Type.Row (type (+))
import Web.HTML.Event.EventTypes (offline)

data Query a
  = Initialize a
  | ToggleEdit Boolean a
  | UpdateContents String a

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
  , editing :: Boolean
  }

newtype Input
  = Input
  { desiredEntry :: Maybe DocumentId
  }

initialState :: Input -> State
initialState (Input input) = 
  { entry: NotAsked
  , editing: false
  , desiredEntryId: input.desiredEntry
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
      , eval
      , receiver: const Nothing
      , initializer: Just $ H.action Initialize
      , finalizer: Nothing
      }
  where

  render :: State -> H.ParentHTML Query ChildQuery ChildSlot m
  render state = case state.entry of
    Failure e -> loadingFailed e
    Success a ->
      case state.editing of 
        false -> markdownRendered a
        true  ->
          HH.slot'
            pathToEdit
            Edit.Slot
            (Edit.component t)
            (unwrap a).content
            mapEditMessageToQuery
    NotAsked -> notAsked
    Loading  -> loading
    where

    markdownRendered :: JournalEntry -> H.ParentHTML Query ChildQuery ChildSlot m
    markdownRendered (JournalEntry e) =
      HH.div []
        [ HH.p [ HE.onClick (HE.input_ $ ToggleEdit true)]
          [ HH.text "test"
          , HH.div
            [ HP.class_ (HH.ClassName "markdown-body")
            ]
            [ renderMarkdown $ MarkdownText e.content
            ]
          ]
        ]

    loadingFailed :: DecryptionError -> H.ParentHTML Query ChildQuery ChildSlot m
    loadingFailed _ = HH.text "Error"

    notAsked :: H.ParentHTML Query ChildQuery ChildSlot m
    notAsked = HH.text "None requested"
    
    loading :: H.ParentHTML Query ChildQuery ChildSlot m
    loading = HH.text "Loading"

  eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Message m
  eval (Initialize next) = do
    desiredEntry <- H.gets (_.desiredEntryId)
    case desiredEntry of
      Just id -> do
        H.modify_ (_{ entry = Loading })
      Nothing -> H.modify_ (_{ entry = Success default })
    pure next
  eval (ToggleEdit edit next) = do
    H.modify_ (_{ editing = edit })
    pure next
  eval (UpdateContents mdText next) = do
    entry <- H.gets (_.entry)
    let newEntry = (wrap <<< (_{ content = mdText }) <<< unwrap ) <$> entry 
    H.modify_ (_{ entry = newEntry })
    pure next
  
  mapEditMessageToQuery :: Edit.Message -> Maybe (Query Unit)
  mapEditMessageToQuery msg = case msg of
    Edit.Finalized -> Just $ ToggleEdit false unit
    Edit.UpdatedContent c -> Just $ UpdateContents c unit

    
    