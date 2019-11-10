module Bootstrap exposing (..)

import Html exposing (Html, div, h2, img, li, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


addAttrClass c ma =
    List.append [ class c ] ma


primaryPanel =
    Html.div [ class "alert alert-primary mx-4 my-2" ]


errorPanel =
    Html.div [ class "alert alert-danger mx-4 my-2" ]


primaryButton moreAttributes =
    Html.button (addAttrClass "btn btn-primary mx-4 my-2" moreAttributes)


listGroup moreAttributes =
    Html.ul (addAttrClass "list-group" moreAttributes)


listItem moreAttributes =
    Html.li (addAttrClass "list-group-item" moreAttributes)
