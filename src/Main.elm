module Main exposing (..)

import Html exposing (button, form, Html, text, div, h1, img, input, p, span)
import Html.Attributes exposing (placeholder, src, type_, value)
import Html.Events exposing (onInput, onWithOptions)
import Json.Decode as Decode
import Models exposing (Model)
import Select


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


type Msg
    = UpdatePurchasePriceFormField String
    | UpdateGrossMonthlyRentFormField String
    | CommitInputs


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



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , form [ onWithOptions "submit" { stopPropagation = True, preventDefault = True } (Decode.succeed CommitInputs) ]
            [ input [ type_ "number", placeholder "Purchase price", onInput UpdatePurchasePriceFormField, value model.purchasePriceFormField ] []
            , input [ type_ "number", placeholder "Gross monthly rent", onInput UpdateGrossMonthlyRentFormField, value model.grossMonthlyRentFormField ] []
            , button [ type_ "submit" ] [ text "Calculate" ]
            ]
        , viewValues model
        ]


viewValues : Model -> Html Msg
viewValues model =
    div []
        [ viewValue "Purchase price" model.purchasePrice
        , viewValue "Down payment" (Select.downPayment model)
        , viewValue "Gross monthly rent" model.grossMonthlyRent
        , viewValue "Mortgage amount" (Select.mortgageAmount model)
        , viewValue "Property tax annual amount" (Select.propertyTaxAnnualAmount model)
        , viewValue "Taxes and insurance monthly" (Select.taxesAndInsuranceMonthlyAmount model)
        , viewValue "Mortgage principal and interest monthly" (Select.mortgagePrincipalAndInterestMonthly model)
        , viewValue "Operating expenses monthly" (Select.operatingExpensesMonthly model)
        , viewValue "Property management fees monthly" (Select.propertyManagementExpensesMonthly model)
        , viewValue "Total monthly expenses" (Select.totalMonthlyExpenses model)
        , viewValue "Net monthly cashflow" (Select.netMonthlyCashflow model)
        , viewValue "Net annual cashflow" (Select.netAnnualCashflow model)
        , viewValue "First year appreciation amount" (Select.firstYearAppreciationAmount model)
        , viewValue "First year principal paydown" (Select.firstYearPrincipalPaydownAmount model)
        , viewValue "Total annual gain" (Select.totalAnnualGain model)
        , viewValue "Cash-on-cash yield" (Select.cashOnCashYield model)
        , viewValue "First year appreciation yield" (Select.firstYearAppreciationYield model)
        , viewValue "First year principal paydown yield" (Select.firstYearPrincipalPaydownYield model)
        ]


viewValue : String -> number -> Html Msg
viewValue label value =
    p []
        [ span [] [ text <| label ++ ": " ]
        , span [] [ text <| toString value ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
