module Main exposing (main)

import Bootstrap exposing (errorPanel, primaryButton, primaryPanel)
import Browser
import Html exposing (Html, div, h2, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D
import Msg exposing (..)
import Swapi exposing (..)



-- Reducer callback: this is the function that retrieve the Result of the HTTP request getMovies
-- and generate a new (model, cmd) tuple


gotMovies : Model -> QueryResponse -> ( Model, Cmd Msg )
gotMovies model res =
    case res of
        Ok data ->
            ( { model | value = Value data }, Cmd.none )

        Err err ->
            ( { model | value = Result err }, Cmd.none )



-- update is function accept a Msg and a Model and return a new (model, cmd) tuple


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        GetMovies ->
            ( { model | value = Loading }, getMovies GotMovies )

        GotMovies res ->
            gotMovies model res



---- MODEL ----


type MoviesResult
    = Result Http.Error
    | Loading
    | Value String
    | Nothing


type alias Model =
    { value : MoviesResult }


init : ( Model, Cmd Msg )
init =
    ( { value = Nothing }, Cmd.none )



---- VIEW ----


outData : Model -> Html Msg
outData model =
    case model.value of
        Loading ->
            primaryPanel [ Html.code [] [ Html.text "Loading" ] ]

        Result err ->
            errorPanel [ Html.code [] [ Html.text "Some Error" ] ]

        Value val ->
            primaryPanel [ Html.code [] [ Html.text val ] ]

        Nothing ->
            Html.text "Click the button to fetch the data"


view : Model -> Html Msg
view model =
    div [ class "p-2" ]
        [ Html.h2 [] [ text "Elm got StarWars" ]
        , primaryButton [ onClick GetMovies ] [ Html.text "Get Movies" ]
        , outData model
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
