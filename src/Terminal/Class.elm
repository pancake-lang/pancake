module Terminal.Class exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


terminal : String -> Attribute msg
terminal string =
    class <| "terminal-" ++ string


half =
    terminal "half"


world =
    terminal "world"


worldUnknown =
    terminal "world-unknown"
