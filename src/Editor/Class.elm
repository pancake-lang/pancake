module Editor.Class exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


editor : String -> Attribute msg
editor string =
    class <| "editor-" ++ string


half : Attribute msg
half =
    editor "half"


lineNumbers : Attribute msg
lineNumbers =
    editor "line-numbers"


number : Attribute msg
number =
    editor "number"


textarea : Attribute msg
textarea =
    editor "textarea"
