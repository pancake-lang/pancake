module Language.Runtime exposing (..)

import Array
import Language.Core as Core
import Language.Machine
    exposing
        ( Command
        , Instruction
        , Value(..)
        , panic
        , push
        , skip
        )
import Language.World exposing (World(..))


step : Command
step machine =
    let
        currentInstruction =
            Array.get machine.ip machine.code
    in
    case currentInstruction of
        Nothing ->
            panic "failed to fetch instruction" machine

        Just instruction ->
            skipOnWorldMismatch instruction machine


skipOnWorldMismatch : Instruction -> Command
skipOnWorldMismatch instruction machine =
    if instruction.world /= machine.world then
        skip machine

    else
        exec instruction machine |> skip


exec : Instruction -> Command
exec { value } =
    case value of
        Id id ->
            name id

        atom ->
            push atom


name : String -> Command
name id =
    case Core.lookup id of
        Just command ->
            command

        Nothing ->
            push <| Id id
