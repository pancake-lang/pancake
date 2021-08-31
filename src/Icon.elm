module Icon exposing (check, help, map)

import Html exposing (Attribute, Html, span)
import Material.Icons.Outlined exposing (flaky, help_outline)
import Material.Icons.Types exposing (Coloring(..), Icon)


map : List (Attribute msg) -> Icon msg -> Html msg
map attrs icon =
    span attrs [ icon 24 Inherit ]


help : Icon msg
help =
    help_outline


check : Icon msg
check =
    flaky
