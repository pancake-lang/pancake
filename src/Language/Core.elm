module Language.Core exposing (lib, lookup)

import Array exposing (Array)
import Basics.Extra exposing (flip)
import Dict exposing (Dict)
import Language.Machine as Machine
    exposing
        ( Command
        , Machine
        , Value(..)
        , asBool
        , combine
        , panic
        , push
        )
import Language.World as World
import Maybe.Extra as MaybeX



-- LIB


lib : Dict String Command
lib =
    Dict.fromList
        -- State controll.
        [ ( "pass", identity )
        , ( "not", unOp not_ )
        , ( "flip", flip_ )
        , ( "flip if true", flipIfTrue )
        , ( "flip if false", unOp not_ >> flipIfTrue )

        -- Arithmetic.
        , ( "+", binOp (+) )
        , ( "-", binOp <| flip (-) )
        , ( "*", binOp (*) )
        , ( "/", binOp <| flip (//) )
        ]


lookup : String -> Maybe Command
lookup =
    flip Dict.get lib



-- FLIPS


flip_ : Command
flip_ machine =
    { machine | world = World.flip machine.world }


flipIfTrue : Command
flipIfTrue machine =
    let
        arg =
            List.head machine.stack
    in
    case arg of
        Just value ->
            case asBool value of
                Just True ->
                    popN 1 machine |> flip_

                Just False ->
                    popN 1 machine

                Nothing ->
                    combine "flip expected a boolean" "type error"
                        |> flip panic machine

        Nothing ->
            wrongArgCount machine



-- UNARY OPERATION


unOp : (Int -> Int) -> Command
unOp func machine =
    case unOpArg machine of
        Nothing ->
            wrongArgCount machine

        Just x ->
            popN 1 machine |> push (func x |> Int)


unOpArg : Machine -> Maybe Int
unOpArg machine =
    List.head machine.stack |> Maybe.andThen Machine.toInt


not_ : Int -> Int
not_ bool =
    case bool of
        0 ->
            1

        _ ->
            0



-- BININARY OPERATION


binOp : (Int -> Int -> Int) -> Command
binOp func machine =
    let
        args =
            binOpArgs machine

        x =
            Maybe.withDefault 0 <| Array.get 0 args

        y =
            Maybe.withDefault 0 <| Array.get 1 args
    in
    if Array.length args /= 2 then
        wrongArgCount machine

    else
        popN 2 machine |> push (func x y |> Int)


binOpArgs : Machine -> Array Int
binOpArgs machine =
    List.take 2 machine.stack
        |> List.map Machine.toInt
        |> MaybeX.values
        |> Array.fromList



-- WRONG NUMBER OF ARGUMENTS


wrongArgCount : Command
wrongArgCount =
    panic "wrong number of arguments in function call"



-- POP N ARGS OFF OF THE STACK


popN : Int -> Command
popN argc machine =
    { machine | stack = List.drop argc machine.stack }
