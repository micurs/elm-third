module Swapi exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, float, int, list, map, map2, map3, map5, maybe, string)
import Msg exposing (Msg, QueryResponse)



-- import Json.Decode.Pipeline exposing (required, optional, hardcoded)
---- DTO ----


type alias Name =
    { name : String }


type alias Character =
    { name : String
    , homeworld : Name
    , species : Maybe Name
    }


type alias Characters =
    { characters : List Character }


type alias Movie =
    { title : String
    , openingCrawl : String
    , director : String
    , producers : List String
    , characterConnection : Characters
    }


type alias Node =
    { node : Movie }


type alias Edges =
    { edges : List Node }


type alias Movies =
    { allFilms : Edges }


type alias Data =
    { data : Movies }


nameDecoder : Decoder Name
nameDecoder =
    map Name
        (field "name" string)


characterDecoder : Decoder Character
characterDecoder =
    map3 Character
        (field "name" string)
        (field "homeworld" nameDecoder)
        (maybe (field "species" nameDecoder))


charactersDecoder : Decoder Characters
charactersDecoder =
    map Characters
        (field "characters" (list characterDecoder))


movieDecoder : Decoder Movie
movieDecoder =
    map5 Movie
        (field "title" string)
        (field "openingCrawl" string)
        (field "director" string)
        (field "producers" (list string))
        (field "characterConnection" charactersDecoder)


nodeDecoder : Decoder Node
nodeDecoder =
    map Node
        (field "node" movieDecoder)


edgesDecoder : Decoder Edges
edgesDecoder =
    map Edges
        (field "edges" (list nodeDecoder))


moviesDecoder : Decoder Movies
moviesDecoder =
    map Movies
        (field "allFilms" edgesDecoder)


dataDecoder : Decoder Data
dataDecoder =
    map Data
        (field "data" moviesDecoder)


jsonToMovies : String -> Movies
jsonToMovies js =
    let
        res =
            Decode.decodeString dataDecoder js

        _ =
            Debug.log "Decoded" res
    in
    case res of
        Ok movies ->
            movies.data

        Err err ->
            { allFilms = { edges = [] } }



---- Queries ----


swfilms : String
swfilms =
    """
{
  allFilms{
    edges{
      node{
        title,
        openingCrawl,
        director,
        producers,
        characterConnection {
          characters {
            name,
            homeworld {
              name
            },
            species {
              name
            }
          }
        }
      }
    }
  }
}
"""


type alias WebHandler =
    QueryResponse -> Msg


getMovies : WebHandler -> Cmd Msg
getMovies handleData =
    Http.request
        { method = "POST"
        , body = Http.stringBody "application/graphql" swfilms
        , expect = Http.expectString handleData
        , url = "https://swapi.apis.guru"
        , headers =
            [ Http.header "Accept" "application/json"
            ]
        , timeout = Just 5000
        , tracker = Just "Nothing"
        }


moviesTitle : Movies -> List String
moviesTitle movies =
    List.map
        (\n ->
            let
                t =
                    n.node.title

                _ =
                    Debug.log "title" t
            in
            t
        )
        movies.allFilms.edges



-- type Msg
--     = GotMovies (Result Http.Error String)
-- This is the function that trigger the HTTP request to get movies
-- Note it generate a HttpMsg triggered when result became available
-- getMovies : Cmd Msg
-- getMovies =
--     Http.post
--         { body = Http.stringBody "application/json" swfilms
--         , expect = Http.expectString GotMovies
--         , url = "https://swapi.apis.guru"
--         }
