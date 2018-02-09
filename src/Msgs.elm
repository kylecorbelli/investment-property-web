module Msgs exposing (..)


type Msg
    = UpdatePurchasePriceFormField String
    | UpdateGrossMonthlyRentFormField String
    | CommitInputs
    | AdvanceErrorMessageCountdown
