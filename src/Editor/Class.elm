module Editor.Class exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


editor : String -> Attribute msg
editor string =
    class <| "editor-" ++ string


textarea : Attribute msg
textarea =
    editor "textarea"
