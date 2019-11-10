module Main exposing (main)

import Bootstrap exposing (errorPanel, listGroup, listItem, primaryButton, primaryPanel)
import Browser
import Html exposing (Html, div, em, h2, h3, img, text)
import Html.Attributes exposing (class, src, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Msg exposing (..)
import Swapi exposing (..)



-- Extract all the titles of the movies into a list


getCharacters : Movie -> List Character
getCharacters m =
    .characters <| .characterConnection <| m


getTitle : Movie -> String
getTitle m =
    .title <| m


getFilms : Movies -> List Movie
getFilms m =
    m
        |> .allFilms
        |> .edges
        |> List.map (\n -> n.node)


moviesTitles : Movies -> List String
moviesTitles movies =
    List.map getTitle (getFilms movies)



-- Reducer callback: this is the function that retrieve the Result of the HTTP request getMovies
-- and generate a new (model, cmd) tuple


gotMovies : Model -> QueryResponse -> ( Model, Cmd Msg )
gotMovies model res =
    case res of
        Ok data ->
            ( { model | value = SWMovies (Just (jsonToMovies data)) }, Cmd.none )

        Err err ->
            ( { model | value = Result err }, Cmd.none )



-- update is function accept a Msg and a Model and return a new (model, cmd) tuple


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        ShowMovieCharacters title ->
            if model.visible == Just title then
                ( { model | visible = Nothing }, Cmd.none )

            else
                ( { model | visible = Just title }, Cmd.none )

        GetMovies ->
            ( { model | value = Loading }, getMovies GotMovies )

        GotMovies res ->
            gotMovies model res



---- MODEL ----


type MoviesResult
    = Result Http.Error
    | Loading
    | SWMovies (Maybe Movies)


type alias Model =
    { value : MoviesResult, visible : Maybe String }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { value = SWMovies Nothing
      , visible = Nothing
      }
    , Cmd.none
    )



---- VIEW ----
-- Convert a movie list to a list of LI Html elements


type alias MovieLister =
    Movie -> List (Html Msg)


movieChildren : Maybe String -> MovieLister -> Movie -> Html Msg
movieChildren visible childrenOut movie =
    case visible of
        Just vis ->
            if movie.title == vis then
                listGroup [] (childrenOut movie)

            else
                Html.text ""

        _ ->
            Html.text ""


moviesLI : MovieLister -> Maybe String -> Movies -> List (Html Msg)
moviesLI charatersOut visible movies =
    movies
        |> getFilms
        |> List.map
            (\movie ->
                listItem
                    [ style "background-color" "rgba(100,100,100,0.1)"
                    , style "border" "none"
                    , style "cursor" "pointer"
                    , onClick (ShowMovieCharacters movie.title)
                    ]
                    [ Html.h3 [] [ Html.text movie.title ]
                    , movieChildren visible charatersOut movie
                    ]
            )


charcterInfo : Character -> Html Msg
charcterInfo c =
    Html.span []
        [ Html.strong [] [ Html.text c.name ]
        , Html.text " from: "
        , Html.em [] [ Html.text c.homeworld.name ]
        ]


charactersLI : MovieLister
charactersLI movie =
    movie
        |> getCharacters
        |> List.map
            (\character ->
                listItem [] [ charcterInfo character ]
            )


outData : Model -> Html Msg
outData model =
    case model.value of
        Loading ->
            primaryPanel [ Html.code [] [ Html.text "Loading..." ] ]

        Result err1 ->
            errorPanel [ Html.code [] [ Html.text "Some Error" ] ]

        SWMovies swmovies ->
            case swmovies of
                Just movies ->
                    primaryPanel
                        [ listGroup
                            [ style "background-color" "transparent" ]
                            (moviesLI charactersLI model.visible movies)
                        ]

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
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
