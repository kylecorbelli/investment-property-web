module Update exposing (update)

import APIs.Zillow exposing (zillowSearchResultRequest)
import Constants exposing (errorMessageCountdownSeconds, genericErrorMessage)
import Http exposing (Error(..))
import Models exposing (..)
import Msgs exposing (..)
import RemoteData exposing (RemoteData(..))


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

        UpdateZillowSearchAddressField text ->
            { model | zillowSearchAddressField = text } ! []

        ZillowSearchResultsRequestSent ->
            { model | zillowSearchResult = Loading } ! [ zillowSearchResultRequest model.environment model.zillowSearchAddressField ]

        ZillowSearchResultsRequestCompleted result ->
            let
                ( errorMessage, errorMessageCountdown ) =
                    case result of
                        Failure err ->
                            let
                                errorMessage =
                                    case err of
                                        BadStatus response ->
                                            case response.status.code of
                                                404 ->
                                                    "No properties matched that address. Give it another shot."

                                                _ ->
                                                    genericErrorMessage

                                        _ ->
                                            genericErrorMessage
                            in
                                ( errorMessage, errorMessageCountdownSeconds )

                        _ ->
                            ( model.errorMessage, model.errorMessageCountdown )

                newModel =
                    { model
                        | errorMessage = errorMessage
                        , errorMessageCountdown = errorMessageCountdown
                        , zillowSearchResult = result
                    }
            in
                newModel ! []

        UseZillowDataInAnalysis ->
            let
                newModel =
                    case model.zillowSearchResult of
                        Success zillowSearchResult ->
                            let
                                zestimateAmount =
                                    zillowSearchResult.zestimateData.amount

                                rentZestimateAmount =
                                    zillowSearchResult.rentZestimateData.amount

                                existingUi =
                                    model.ui

                                updatedUi =
                                    { existingUi | isModalShown = False }
                            in
                                { model
                                    | purchasePrice = zestimateAmount |> toFloat
                                    , grossMonthlyRent = rentZestimateAmount |> toFloat
                                    , purchasePriceFormField = zestimateAmount |> toString
                                    , grossMonthlyRentFormField = rentZestimateAmount |> toString
                                    , ui = updatedUi
                                    , zillowSearchResult = NotAsked
                                }

                        _ ->
                            model
            in
                newModel ! []

        ToggleModal ->
            let
                existingUi =
                    model.ui

                updatedUi =
                    { existingUi | isModalShown = (not existingUi.isModalShown) }
            in
                { model | ui = updatedUi } ! []

        DismissZillowModal ->
            let
                existingUi =
                    model.ui

                updatedUi =
                    { existingUi | isModalShown = False }
            in
                { model | ui = updatedUi, zillowSearchResult = NotAsked, zillowSearchAddressField = "" } ! []

        DismissZillowSearchResult ->
            { model | zillowSearchResult = NotAsked, zillowSearchAddressField = "" } ! []
