module Help.Class exposing (body, container)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


help : String -> Attribute msg
help string =
    class <| "help-" ++ string


container : Attribute msg
container =
    help "container"


body : Attribute msg
body =
    help "body"
