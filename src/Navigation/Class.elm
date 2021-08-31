module Navigation.Class exposing (bar, check, icon, pad)

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


check : Attribute msg
check =
    navigtaion "check"


icon : Attribute msg
icon =
    navigtaion "icon"
