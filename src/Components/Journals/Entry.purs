module Components.Journals.Entry (component, Message, Input(..)) where

import Data.Guards
import Prelude
import AppM (CurrentSessionRow, EditingJournalEntryRow)
import Components.Markdown.Edit as Edit
import Components.Pure.Markdown (renderMarkdown)
import Components.Pure.Widgets as CW
import Components.Util (OpaqueSlot)
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
import Data.Symbol (SProxy(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Now (nowDateTime)
import Halogen as H
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Intl (LocaliseFn)
import Intl.Terms (Term(..))
import Intl.Terms.Common (Common(..))
import Intl.Terms.Journals (Journals(..))
import Model (Session(..))
import Model.Journal (JournalEntry(..), JournalMeta(..), mapJournalMetaRec, setTitle)
import Network.RemoteData (RemoteData(..))
import Style.Bulogen as SB
import Style.Classes as SC
import Type.Data.Boolean (kind Boolean)
import Type.Row (type (+))

data Action
  = Initialize
  | ToggleContentEdit Boolean
  | UpdateContents String
  | UpdateTitle String
  | ToggleTitleEdit Boolean

type ChildSlots
  = ( edit :: Edit.Slot Unit
    )

pathToEdit = SProxy :: SProxy "edit"

data Message
  = MNoMsg

type State
  = { entry :: RemoteData DecryptionError JournalEntry
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

type RequiredState r
  = ( EditingJournalEntryRow
        + CurrentSessionRow
        + r
    )

component ::
  forall m r.
  MonadAff m =>
  MonadAsk (Record (RequiredState r)) m =>
  LocaliseFn -> H.Component HH.HTML (Const Void) Input Message m
component t =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ ( H.defaultEval
              { initialize = Just Initialize
              , handleAction = handleAction H.raise
              }
          )
    }
  where
  render :: State -> H.ComponentHTML Action ChildSlots m
  render state = case state.entry of
    Failure e -> loadingFailed e
    Success a -> entryRender a
    NotAsked -> notAsked
    Loading -> CW.loading
    where
    entryRender :: JournalEntry -> H.ComponentHTML Action ChildSlots m
    entryRender entry =
      HH.div
        [ HP.classes
            [ SB.container
            , SC.padTop
            ]
        ]
        [ case state.titleEditing of
            false ->
              HH.h1
                [ HP.classes
                    [ SB.title
                    ]
                , HE.onClick (\_ -> Just $ ToggleTitleEdit true)
                ]
                [ HH.text $ guardMap ((/=) "") (t $ Journal PlaceholderTitle) identity title
                ]
            true ->
              HH.div
                [ HP.classes
                    [ SB.field
                    , SB.addons
                    ]
                ]
                [ HH.div
                    [ HP.classes
                        [ SB.control
                        , SB.expanded
                        ]
                    ]
                    [ HH.input
                        [ HP.classes
                            [ SB.input
                            ]
                        , HP.value title
                        , HP.placeholder $ t $ Journal FieldPlaceholderTitle
                        , HE.onValueChange (Just <<< UpdateTitle)
                        , HE.onFocusOut (\_ -> Just $ ToggleTitleEdit false)
                        ]
                    ]
                , HH.div
                    [ HP.classes
                        [ SB.control
                        ]
                    ]
                    [ HH.button
                        [ HP.classes
                            [ SB.primary
                            , SB.button
                            ]
                        , HE.onClick (\_ -> Just $ ToggleTitleEdit false)
                        ]
                        [ HH.text $ t $ Common Save
                        ]
                    ]
                ]
        , case state.contentEditing of
            false -> guardMap ((/=) "") (markdownRendered $ t $ Journal PlaceholderContent) markdownRendered (unwrap entry).content
            true ->
              HH.slot
                pathToEdit
                unit
                (Edit.component t)
                { content: (unwrap entry).content
                , fieldPrompt: Journal FieldPlaceholderContent
                }
                (const Nothing)
        ]
      where
      title = (unwrap (unwrap entry).metaData).title

    markdownRendered :: String -> H.ComponentHTML Action ChildSlots m
    markdownRendered content =
      HH.div []
        [ HH.p [ HE.onClick (\_ -> Just $ ToggleContentEdit true) ]
            [ HH.div
                [ HP.class_ (HH.ClassName "markdown-body")
                ]
                [ renderMarkdown $ MarkdownText content
                ]
            ]
        ]

    loadingFailed :: DecryptionError -> H.ComponentHTML Action ChildSlots m
    loadingFailed _ = HH.text $ t $ Journal $ LoadingError

    notAsked :: H.ComponentHTML Action ChildSlots m
    notAsked = HH.text $ t $ Journal Uninitialised

  handleAction ::
    forall t.
    MonadState State t =>
    MonadAff t =>
    MonadEffect t =>
    (Message -> t Unit) ->
    Action -> t Unit
  handleAction raise actiong = case actiong of
    Initialize -> do
      desiredEntry <- MS.gets (_.desiredEntryId)
      case desiredEntry of
        Just id -> do
          MS.modify_ (_ { entry = Loading })
        Nothing -> do
          currentDate <- liftEffect nowDateTime
          defaultEntry <- pure default
          entry <-
            pure
              $ mapJournalMetaRec
                  (_ { lastUpdated = Just currentDate, createdAt = Just currentDate })
                  defaultEntry
          MS.modify_ (_ { entry = Success entry })
      raise $ MNoMsg
    (ToggleContentEdit edit) -> do
      MS.modify_ (_ { contentEditing = edit })
    (ToggleTitleEdit edit) -> do
      MS.modify_ (_ { titleEditing = edit })
    (UpdateContents mdText) -> do
      entry <- MS.gets (_.entry)
      let
        newEntry = (wrap <<< (_ { content = mdText }) <<< unwrap) <$> entry
      MS.modify_ (_ { entry = newEntry })
    (UpdateTitle nextTitle) -> do
      entry <- MS.gets (_.entry)
      let
        nextEntry = entry <#> setTitle nextTitle
      MS.modify_ (_ { entry = nextEntry })

  mapEditMessageToAction :: Edit.Message -> Maybe Action
  mapEditMessageToAction msg = case msg of
    Edit.Finalized -> Just $ ToggleContentEdit false
    Edit.UpdatedContent c -> Just $ UpdateContents c
