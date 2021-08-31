module Help.Class exposing (container)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


help : String -> Attribute msg
help string =
    class <| "help-" ++ string


container : Attribute msg
container =
    help "container"
