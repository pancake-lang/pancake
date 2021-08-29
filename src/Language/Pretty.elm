module Language.Pretty exposing (print)

import Dict
import Language.Parser
    exposing
        ( Ast
        , AstLine
        , Citizen(..)
        , Item(..)
        )
import Language.World exposing (World(..))
import List.Extra as ListX
import String.Extra as StringX


print : Ast -> String
print ast =
    let
        allLines =
            List.repeat
                (ListX.last ast
                    |> Maybe.withDefault (AstLine 1 <| Label "" "")
                ).number
                ""

        prettyLines =
            List.map astLine ast |> Dict.fromList

        fillIn number empty =
            case Dict.get (number + 1) prettyLines of
                Nothing ->
                    empty

                Just line ->
                    line
    in
    List.indexedMap fillIn allLines |> String.join "\n"


astLine : AstLine -> ( Int, String )
astLine line =
    let
        withNumber =
            Tuple.pair line.number
    in
    withNumber <|
        case line.item of
            Label label comment ->
                "@ " ++ label ++ comment

            Citizen world citizen comment ->
                case world of
                    Alpha ->
                        "    " ++ item citizen ++ comment

                    Omega ->
                        "#   " ++ item citizen ++ comment

            Note comment ->
                comment


item : Item -> String
item this =
    case this of
        Int int ->
            String.fromInt int

        Str str ->
            StringX.quote str

        Id id ->
            id
