module Language.Compiler exposing (..)

import Array
import Dict exposing (Dict)
import Language.Machine as Machine exposing (Instruction, Machine, Value(..))
import Language.Parser as Parser
    exposing
        ( Ast
        , AstLine
        , Citizen(..)
        , getLabel
        , isLabel
        , isNote
        )
import Language.World exposing (World(..))
import Maybe.Extra as MaybeX


compile : Ast -> Machine
compile ast =
    let
        noNotes =
            ast
                |> List.filter (\astLine -> astLine.item |> isNote |> not)
                |> Array.fromList

        labels : Dict String Int
        labels =
            noNotes
                |> Array.indexedMap
                    (\id astLine ->
                        if isLabel astLine.item then
                            Just
                                ( Maybe.withDefault "" <| getLabel astLine.item
                                , id
                                )

                        else
                            Nothing
                    )
                |> Array.toList
                |> MaybeX.values
                |> Dict.fromList

        code : Machine.Code
        code =
            Array.map toInstruction noNotes
    in
    Machine.init code labels


toInstruction : AstLine -> Instruction
toInstruction { number, item } =
    case item of
        Citizen world atom _ ->
            case atom of
                Parser.Int int ->
                    Instruction number world <| Int int

                Parser.Str str ->
                    String.toList str
                        |> List.map Char
                        |> List
                        |> Instruction number world

                Parser.Id id ->
                    Instruction number world <| Id id

        Label _ _ ->
            -- It doesn't matter to which world this `pass` belongs to as it
            -- will get skipped no matter what.
            Instruction number Alpha <| Id "pass"

        _ ->
            Instruction number Alpha <|
                Id "Language.Compiler.toInstruction: fix if this blows up"
