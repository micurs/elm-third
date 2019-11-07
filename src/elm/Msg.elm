module Msg exposing (..)

import Http exposing (Error)


type alias QueryResponse =
    Result Error String


type Msg
    = NoOp
    | GetMovies
    | GotMovies QueryResponse
