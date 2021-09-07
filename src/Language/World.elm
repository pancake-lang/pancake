module Language.World exposing (World(..), flip)


type World
    = Alpha
    | Omega


flip : World -> World
flip world =
    case world of
        Alpha ->
            Omega

        Omega ->
            Alpha
