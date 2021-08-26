module Main exposing (..)

import Browser exposing (Document, document)
import Browser.Events as Events
import Editor.Class
import Editor.Main as Editor
import Help.Class
import Help.Info
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Keyboard.Event as Keyboard exposing (KeyboardEvent, decodeKeyboardEvent)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { editor : Editor.Model
    , help : Bool
    }



-- MSG


type Msg
    = EditorMsg Editor.Msg
    | ToggleHelp
    | KeyboardEvent KeyboardEvent



-- MAIN


main : Program Flags Model Msg
main =
    document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { editor = Editor.init
      , help = False
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditorMsg editorMsg ->
            ( { model | editor = Editor.update editorMsg model.editor }
            , Cmd.none
            )

        ToggleHelp ->
            ( { model | help = not model.help }, Cmd.none )

        KeyboardEvent event ->
            ( updateOnKeyBinding event model, Cmd.none )


type KeyBinding
    = ShowHelp
    | CheckSource


key : String -> KeyboardEvent -> Bool
key k event =
    case event.key of
        Just pressed ->
            pressed == k

        _ ->
            False


isCheckSource : KeyboardEvent -> Bool
isCheckSource e =
    e.ctrlKey && key "Enter" e


isToggleHelp : KeyboardEvent -> Bool
isToggleHelp e =
    e.ctrlKey && key ";" e


updateOnKeyBinding : KeyboardEvent -> Model -> Model
updateOnKeyBinding event model =
    if isToggleHelp event then
        { model | help = not model.help }

    else if isCheckSource event then
        { model | editor = Editor.update Editor.SourceCheck model.editor }

    else
        model



-- VIEW


view : Model -> Document Msg
view model =
    let
        titled elems =
            Document "Pancake Playground" <| showHelpButton :: elems

        showHelpButton =
            button
                [ Help.Class.showButton
                , onClick ToggleHelp
                ]
                [ text "👽" ]

        ide =
            [ section [ Editor.Class.half ] <|
                List.map (Html.map EditorMsg) <|
                    Editor.view model.editor
            , section [] []
            ]

        readme =
            [ div [ Help.Class.container ] Help.Info.info ]
    in
    titled <|
        if model.help then
            readme

        else
            ide



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Events.onKeyDown <|
        Json.Decode.map KeyboardEvent decodeKeyboardEvent
