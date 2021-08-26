module Editor.Main exposing (..)

import Editor.Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MODEL


type alias Model =
    { source : String
    }



-- MSG


type Msg
    = SourceChange String



-- INIT


init : Model
init =
    Model demo


demo : String
demo =
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        SourceChange change ->
            { model | source = change }



-- VIEW


view : Model -> List (Html Msg)
view model =
    let
        lineNumber n =
            p [ Editor.Class.number ] [ text <| String.fromInt n ]

        numberOfLines =
            model.source |> String.lines |> List.length

        lineNumbers =
            List.range 1 numberOfLines |> List.map lineNumber
    in
    [ nav [ Editor.Class.lineNumbers ] lineNumbers
    , textarea
        [ Editor.Class.textarea
        , onInput SourceChange
        , autofocus True
        ]
        [ text <| model.source ]
    ]
