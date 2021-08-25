module Help.Class exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (..)


help : String -> Attribute msg
help string =
    class <| "help-" ++ string


container : Attribute msg
container =
    help "container"


showButton : Attribute msg
showButton =
    help "show-button"
