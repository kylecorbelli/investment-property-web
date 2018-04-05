module Update exposing (update)

import API.Zillow exposing (zillowSearchResultRequest)
import Constants exposing (errorMessageCountdownSeconds, genericErrorMessage)
import Http exposing (Error(..))
import Models exposing (..)
import Ports exposing (gtmAnalyzeProperty, gtmPageView)
import Routing exposing (parseLocation)
import Msgs exposing (..)
import RemoteData exposing (RemoteData(..))
import Lenses
    exposing
        ( errorMessageCountdownLens
        , errorMessageLens
        , grossMonthlyRentLens
        , grossMonthlyRentFormFieldLens
        , isModalShownLens
        , purchasePriceLens
        , purchasePriceFormFieldLens
        , zillowSearchAddressFieldLens
        , zillowSearchResultLens
        )


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
                            model
                                |> purchasePriceLens.set pp
                                |> grossMonthlyRentLens.set gmr

                        _ ->
                            model
            in
                newModel
                    ! [ gtmAnalyzeProperty
                            { purchasePrice = model.purchasePriceFormField
                            , grossMonthlyRent = model.grossMonthlyRentFormField
                            }
                      ]

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
                    model
                        |> errorMessageLens.set errorMessage
                        |> errorMessageCountdownLens.set errorMessageCountdown
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
                    model
                        |> errorMessageLens.set errorMessage
                        |> errorMessageCountdownLens.set errorMessageCountdown
                        |> zillowSearchResultLens.set result
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
                            in
                                model
                                    |> purchasePriceLens.set (toFloat zestimateAmount)
                                    |> grossMonthlyRentLens.set (toFloat rentZestimateAmount)
                                    |> purchasePriceFormFieldLens.set (toString zestimateAmount)
                                    |> grossMonthlyRentFormFieldLens.set (toString rentZestimateAmount)
                                    |> isModalShownLens.set False
                                    |> zillowSearchResultLens.set NotAsked

                        _ ->
                            model
            in
                newModel ! []

        ToggleModal ->
            let
                newModel =
                    model
                        |> isModalShownLens.set (isModalShownLens.get model |> not)
            in
                newModel ! []

        DismissZillowModal ->
            let
                newModel =
                    model
                        |> zillowSearchAddressFieldLens.set ""
                        |> zillowSearchResultLens.set NotAsked
                        |> isModalShownLens.set False
            in
                newModel ! []

        DismissZillowSearchResult ->
            let
                newModel =
                    model
                        |> zillowSearchAddressFieldLens.set ""
                        |> zillowSearchResultLens.set NotAsked
            in
                newModel ! []

        LocationChanged location ->
            { model | route = parseLocation location } ! [ gtmPageView location.hash ]
