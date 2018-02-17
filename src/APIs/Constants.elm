module APIs.Constants exposing (..)

import Models exposing (Environment(..))


baseApiUrl : Environment -> String
baseApiUrl environment =
    case environment of
        Production ->
            "https://stark-brushlands-96968.herokuapp.com"

        _ ->
            "http://localhost:3000"
