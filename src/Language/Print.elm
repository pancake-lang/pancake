module Language.Print exposing (pretty)

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


pretty : Ast -> String
pretty ast =
    let
        allLines =
            List.repeat
                (ListX.last ast
                    |> Maybe.withDefault (AstLine 1 <| Label "empty")
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
    case line.item of
        Label label ->
            withNumber <| "@ " ++ label

        Citizen world citizen ->
            case world of
                Alpha ->
                    withNumber <| "    " ++ item citizen

                Omega ->
                    withNumber <| "#   " ++ item citizen


item : Item -> String
item this =
    case this of
        Int int ->
            String.fromInt int

        Str str ->
            StringX.quote str

        Id id ->
            id
