module Msg exposing (..)

import Http


type alias QueryResponse =
    Result Http.Error String


type Msg
    = NoOp
    | GetMovies
    | GotMovies QueryResponse
