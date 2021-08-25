module Main exposing (..)

import Browser exposing (Document, document)
import Editor.Class
import Help.Class
import Help.Info
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { source : String
    , help : Bool
    }



-- MSG


type Msg
    = EditorChange String
    | ToggleHelp



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
    ( { source = startingProgramSource
      , help = False
      }
    , Cmd.none
    )


startingProgramSource : String
startingProgramSource =
    """1
# 3
2
3
<
flip if
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

        ToggleHelp ->
            ( { model | help = not model.help }, Cmd.none )



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

        editor =
            [ textarea
                [ Editor.Class.textarea
                , onInput EditorChange
                , autofocus True
                ]
                [ text model.source ]
            , section [] []
            ]

        readme =
            [ div [ Help.Class.container ] Help.Info.info ]
    in
    titled <|
        if model.help then
            readme

        else
            editor



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
