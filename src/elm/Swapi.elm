module Swapi exposing (..)

import Http
import Msg exposing (Msg, QueryResponse)



---- DTO ----


type alias Character =
    { name : String
    , homeworld : { name : String }
    , spcies : Maybe { name : String }
    }


type alias Movie =
    { node :
        { title : String
        , openingCrawl : String
        , director : String
        , producers : String
        , characterConnection :
            { characters : List Character
            }
        }
    }


type alias Movies =
    { allFilms :
        { edges : List Movie
        }
    }



---- Queries ----


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
          \tname,
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
