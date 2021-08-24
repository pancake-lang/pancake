module Main exposing (..)

import Browser exposing (Document, document)
import Editor.Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { source : String }



-- MSG


type Msg
    = EditorChange String



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
    ( { source = startingProgramSource }
    , Cmd.none
    )


startingProgramSource : String
startingProgramSource =
    """1
# 3
2
3
<
flip_if
4
5
# 2
# flip
+
halt"""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditorChange source ->
            ( { model | source = source }, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    let
        titled =
            Document "Pancake Playground"
    in
    titled
        [ textarea
            [ Editor.Class.textarea
            , onInput EditorChange
            , autofocus True
            ]
            [ text model.source ]
        , section [] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
