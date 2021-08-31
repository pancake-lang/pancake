module Navigation.Class exposing (bar, pad)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


navigtaion : String -> Attribute msg
navigtaion string =
    class <| "navigation-" ++ string


bar : Attribute msg
bar =
    navigtaion "bar"


pad : Attribute msg
pad =
    navigtaion "pad"
