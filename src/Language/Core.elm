module Language.Core exposing (add, lib)

import Array exposing (Array)
import Dict exposing (Dict)
import Language.Machine as Machine
    exposing
        ( Command
        , Error
        , Value(..)
        , combine
        )
import Maybe.Extra as MaybeX



-- LIB


lib : Dict String Command
lib =
    Dict.fromList
        [ ( "pass", identity )
        , ( "+", add )
        ]



-- ADD


add : Command
add machine =
    let
        argc =
            2

        args =
            List.take argc machine.stack
                |> List.map Machine.toInt
                |> MaybeX.values
                |> Array.fromList

        return =
            call argc args (Array.toList >> List.sum >> Int)
    in
    case return of
        Err error ->
            Machine.panic (combine error "failed to add") machine

        Ok value ->
            Machine.push value
                { machine | stack = List.drop argc machine.stack }



-- CALL


call : Int -> Array a -> (Array a -> Value) -> Result Error Value
call argc args func =
    if argc /= Array.length args then
        Err "wrong number of arguments in function"

    else
        Ok <| func args
