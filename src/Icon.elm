module Icon exposing (help, map)

import Html exposing (Attribute, Html, span)
import Material.Icons.Outlined exposing (help_outline)
import Material.Icons.Types exposing (Coloring(..), Icon)


map : List (Attribute msg) -> Icon msg -> Html msg
map attrs icon =
    span attrs [ icon 24 Inherit ]


help : Icon msg
help =
    help_outline
