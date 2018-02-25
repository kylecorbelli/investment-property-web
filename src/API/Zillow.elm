module API.Zillow exposing (..)

import API.Constants exposing (baseApiUrl)
import Http.Xml
import Models exposing (..)
import Msgs exposing (..)
import RemoteData exposing (sendRequest)
import Xml.Decode as Decode exposing (Decoder, float, int, single, string)
import Xml.Decode.Pipeline exposing (optionalPath, requiredPath)


zillowSearchResultsBaseUrl : Environment -> String
zillowSearchResultsBaseUrl environment =
    (baseApiUrl environment) ++ "/zillow-search-results"


zillowSearchResultUrl : Environment -> String -> String
zillowSearchResultUrl environment address =
    (zillowSearchResultsBaseUrl environment) ++ "?address=" ++ address


zillowAddressDecoder : Decoder ZillowAddress
zillowAddressDecoder =
    Decode.succeed ZillowAddress
        |> requiredPath [ "street" ] (single string)
        |> requiredPath [ "zipcode" ] (single string)
        |> requiredPath [ "city" ] (single string)
        |> requiredPath [ "state" ] (single string)
        |> requiredPath [ "latitude" ] (single float)
        |> requiredPath [ "longitude" ] (single float)


zillowZestimateDataDecoder : Decoder ZillowZestimateData
zillowZestimateDataDecoder =
    Decode.succeed ZillowZestimateData
        |> requiredPath [ "amount" ] (single int)
        |> requiredPath [ "valuationRange", "high" ] (single int)
        |> requiredPath [ "valuationRange", "low" ] (single int)


zillowSearchResultDecoder : Decoder ZillowSearchResult
zillowSearchResultDecoder =
    Decode.succeed ZillowSearchResult
        |> requiredPath [ "response", "results", "result", "zpid" ] (single string)
        |> requiredPath [ "response", "results", "result", "address" ] (single zillowAddressDecoder)
        |> optionalPath [ "response", "results", "result", "bathrooms" ] (single float) 0
        |> optionalPath [ "response", "results", "result", "bedrooms" ] (single float) 0
        |> requiredPath [ "response", "results", "result", "rentzestimate" ] (single zillowZestimateDataDecoder)
        |> optionalPath [ "response", "results", "result", "finishedSqFt" ] (single int) 0
        |> requiredPath [ "response", "results", "result", "zestimate" ] (single zillowZestimateDataDecoder)


zillowSearchResultRequest : Environment -> String -> Cmd Msg
zillowSearchResultRequest environment address =
    zillowSearchResultUrl environment address
        |> (flip Http.Xml.get) zillowSearchResultDecoder
        |> sendRequest
        |> Cmd.map ZillowSearchResultsRequestCompleted
