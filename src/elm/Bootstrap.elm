module Bootstrap exposing (..)

import Html exposing (Html, div, h2, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


primaryPanel =
    Html.div [ class "alert alert-primary mx-4 my-2" ]


errorPanel =
    Html.div [ class "alert alert-danger mx-4 my-2" ]


primaryButton moreAttributes =
   Html.button (List.append [ class "btn btn-primary mx-4 my-2" ] moreAttributes)