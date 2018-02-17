module Msgs exposing (..)

import Models exposing (..)
import RemoteData exposing (WebData)

type Msg
    = UpdatePurchasePriceFormField String
    | UpdateGrossMonthlyRentFormField String
    | CommitInputs
    | AdvanceErrorMessageCountdown
    | UpdateZillowSearchAddressField String
    | ZillowSearchResultsRequestSent
    | ZillowSearchResultsRequestCompleted (WebData ZillowSearchResult) -- again, probably use RemoteData
    | UseZillowDataInAnalysis
    | ToggleModal
    | DismissZillowModal
    | DismissZillowSearchResult
