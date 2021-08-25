module Language.Parser exposing
    ( Ast
    , AstLine
    , ErrorLine
    , Item(..)
    , ParseError
    , ParseResult
    , parse
    )

import Result.Extra as ResultX



-- PARSE RESULT


type alias ParseResult =
    Result ParseError Ast


type alias ParseError =
    List ErrorLine


type alias ErrorLine =
    { number : Int
    , error : String
    }


type alias Ast =
    List AstLine


type alias AstLine =
    { number : Int
    , item : Item
    }


type Item
    = Int Int
    | Id String



-- PARSE


type alias Line =
    { number : Int, value : String }


parse : String -> ParseResult
parse source =
    let
        results : List (Result ErrorLine AstLine)
        results =
            source |> lines |> List.map parseLine
    in
    case ResultX.combine results of
        Ok ast ->
            Ok ast

        Err _ ->
            Err <| List.filterMap ResultX.error results


lines : String -> List Line
lines =
    let
        enumerate ls =
            List.map2
                (\num str -> String.trim str |> Line num)
                (List.range 1 <| List.length ls)
                ls

        notEmpty =
            List.filter (\{ value } -> value |> String.isEmpty |> not)
    in
    String.lines >> enumerate >> notEmpty


parseLine : Line -> Result ErrorLine AstLine
parseLine { number, value } =
    case String.toInt value of
        Just int ->
            Ok <| AstLine number <| Int int

        Nothing ->
            Ok <| AstLine number <| Id value
