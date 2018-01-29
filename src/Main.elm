module Main exposing (..)

import Html exposing (button, form, Html, text, div, h1, img, input, p, span)
import Html.Styled exposing (toUnstyled)
import Models exposing (Model)
import Msgs exposing (..)
import View


initialModel : Model
initialModel =
    { assumedAnnualValueAppreciationRate = 4
    , downPaymentPercent = 30
    , grossMonthlyRent = 0
    , grossMonthlyRentFormField = ""
    , homeInsuranceAnnualAmount = 2000
    , interestRate = 4.75
    , mortgageTermInYears = 30
    , operatingExpensePercent = 20
    , propertyManagementFeePercent = 10
    , propertyTaxRate = 1.2
    , purchasePrice = 0
    , purchasePriceFormField = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePurchasePriceFormField purchasePrice ->
            ( { model | purchasePriceFormField = purchasePrice }, Cmd.none )

        UpdateGrossMonthlyRentFormField grossMonthlyRent ->
            ( { model | grossMonthlyRentFormField = grossMonthlyRent }, Cmd.none )

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
                ( newModel, Cmd.none )



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = View.view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
