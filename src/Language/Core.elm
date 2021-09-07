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
        , ( "flip", flip_ )
        , ( "flip if true", flipIfTrue )

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
            panic "wrong number of arguments in function call" machine



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
        panic "wrong number of arguments in function call" machine

    else
        popN 2 machine |> push (func x y |> Int)


binOpArgs : Machine -> Array Int
binOpArgs machine =
    List.take 2 machine.stack
        |> List.map Machine.toInt
        |> MaybeX.values
        |> Array.fromList



-- POP N ARGS OFF OF THE STACK


popN : Int -> Command
popN argc machine =
    { machine | stack = List.drop argc machine.stack }
