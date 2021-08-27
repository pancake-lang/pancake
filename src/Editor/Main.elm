module Editor.Main exposing (..)

import Editor.Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Language.Parser as Parser exposing (ParseResult)
import Language.Print as Print
import Maybe.Extra as MaybeX
import Set



-- MODEL


type alias Model =
    { source : String
    , result : Maybe ParseResult
    }



-- MSG


type Msg
    = SourceChange String
    | SourceCheck



-- INIT


init : Model
init =
    Model demo Nothing


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
@end
exit"""



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        SourceChange change ->
            { model | source = change }

        SourceCheck ->
            let
                result =
                    Parser.parse model.source

                source =
                    case result of
                        Err _ ->
                            model.source

                        Ok ast ->
                            Print.pretty ast
            in
            Model source <| Just result



-- VIEW


view : Model -> List (Html Msg)
view model =
    let
        errorLines =
            case model.result of
                Nothing ->
                    Set.empty

                Just (Ok _) ->
                    Set.empty

                Just (Err errors) ->
                    Parser.toErrorLineNumbers errors

        lineNumber n =
            let
                error =
                    if Set.member n errorLines then
                        Just Editor.Class.numberError

                    else
                        Nothing
            in
            p (Editor.Class.number :: MaybeX.toList error)
                [ text <| String.fromInt n ]

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
        , value model.source
        ]
        []
    ]
