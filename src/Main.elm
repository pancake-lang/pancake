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
import Icon
import Json.Decode
import Keyboard.Event as Keyboard exposing (KeyboardEvent, decodeKeyboardEvent)
import Language.Compiler as Compiler
import Language.Machine exposing (Machine)
import Language.World exposing (World(..))
import Navigation.Class
import Terminal.Class



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { editor : Editor.Model
    , help : Bool
    , runtime : Maybe Machine
    }



-- MSG


type Msg
    = EditorMsg Editor.Msg
    | ToggleHelp
    | CheckSource
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
      , runtime = Nothing
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

        CheckSource ->
            ( checkSourceAndUpdate model, Cmd.none )

        KeyboardEvent event ->
            updateOnKeyBinding event model


updateOnKeyBinding : KeyboardEvent -> Model -> ( Model, Cmd Msg )
updateOnKeyBinding event model =
    if isToggleHelp event then
        update ToggleHelp model

    else if isCheckSource event then
        update CheckSource model

    else
        ( model, Cmd.none )


checkSourceAndUpdate : Model -> Model
checkSourceAndUpdate model =
    let
        editor =
            Editor.update Editor.SourceCheck model.editor
    in
    { model
        | editor = editor
        , runtime =
            case editor.result of
                Just (Ok ast) ->
                    Just <| Compiler.compile ast

                _ ->
                    Nothing
    }


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



-- VIEW


view : Model -> Document Msg
view model =
    let
        titled elems =
            Document "Pancake Playground"
                [ main_ [ class "app" ] elems
                , navigation
                ]

        checkResult =
            case model.editor.result of
                Nothing ->
                    Icon.check

                Just (Err _) ->
                    Icon.fail

                Just (Ok _) ->
                    Icon.ok

        navigation =
            nav [ Navigation.Class.bar ]
                [ p [ Navigation.Class.check ] [ text "Check:" ]
                , Icon.map
                    [ Navigation.Class.icon, onClick CheckSource ]
                    checkResult
                , div [ Navigation.Class.pad ] []
                , Icon.map
                    [ Navigation.Class.icon, onClick ToggleHelp ]
                    Icon.help
                ]

        ide =
            let
                world_ =
                    case model.runtime of
                        Just { world } ->
                            section [ Terminal.Class.world ]
                                [ h6 []
                                    [ text <|
                                        case world of
                                            Alpha ->
                                                "alpha"

                                            Omega ->
                                                "omega"
                                    ]
                                ]

                        Nothing ->
                            section
                                [ Terminal.Class.worldUnknown
                                , Terminal.Class.world
                                ]
                                [ h6 [] [ text "{ world }" ] ]
            in
            [ section [ Editor.Class.half ] <|
                List.map (Html.map EditorMsg) <|
                    Editor.view model.editor
            , section [ Terminal.Class.half ]
                [ world_
                ]
            ]

        readme =
            [ div [ Help.Class.container ]
                [ div [ Help.Class.body ] Help.Info.info ]
            ]
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
