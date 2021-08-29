module Language.Stack exposing (..)


type alias Stack a =
    List a


empty : Stack a
empty =
    []


push : a -> Stack a -> Stack a
push item stack =
    item :: stack


pop : Stack a -> ( Maybe a, Stack a )
pop stack =
    ( List.head stack, Maybe.withDefault [] <| List.tail stack )
