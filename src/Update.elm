module Update exposing (update)

import Models exposing (..)
import Msgs exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePurchasePriceFormField purchasePrice ->
            { model | purchasePriceFormField = purchasePrice } ! []

        UpdateGrossMonthlyRentFormField grossMonthlyRent ->
            { model | grossMonthlyRentFormField = grossMonthlyRent } ! []

        CommitInputs ->
            let
                purchasePrice =
                    model.purchasePriceFormField |> String.toFloat

                grossMonthlyRent =
                    model.grossMonthlyRentFormField |> String.toFloat

                newModel =
                    case ( purchasePrice, grossMonthlyRent ) of
                        ( Ok pp, Ok gmr ) ->
                            { model
                                | purchasePrice = pp
                                , grossMonthlyRent = gmr
                            }

                        _ ->
                            model
            in
                newModel ! []

        AdvanceErrorMessageCountdown ->
            let
                errorMessageCountdown =
                    model.errorMessageCountdown - 1

                errorMessage =
                    if errorMessageCountdown > 0 then
                        model.errorMessage
                    else
                        ""

                updatedModel =
                    { model
                        | errorMessage = errorMessage
                        , errorMessageCountdown = errorMessageCountdown
                    }
            in
                updatedModel ! []
