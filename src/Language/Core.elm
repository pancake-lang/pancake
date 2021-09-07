module Language.Core exposing (lib, lookup)

import Array exposing (Array)
import Basics.Extra exposing (flip)
import Dict exposing (Dict)
import Language.Machine as Machine
    exposing
        ( Command
        , Machine
        , Value(..)
        , panic
        , push
        )
import Maybe.Extra as MaybeX



-- LIB


lib : Dict String Command
lib =
    Dict.fromList
        [ ( "pass", identity )
        , ( "+", binOp (+) )
        , ( "-", binOp (-) )
        , ( "*", binOp (*) )
        , ( "/", binOp (//) )
        ]


lookup : String -> Maybe Command
lookup =
    flip Dict.get lib



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
        panic "wrong number of arguments in call to function" machine

    else
        popN 2 machine |> push (func x y |> Int)


binOpArgs : Machine -> Array Int
binOpArgs machine =
    List.take 2 machine.stack
        |> List.map Machine.toInt
        |> MaybeX.values
        |> Array.fromList



-- POP N ARGS OFF OF THE STACK


popN : Int -> Machine -> Machine
popN argc machine =
    { machine | stack = List.drop argc machine.stack }
