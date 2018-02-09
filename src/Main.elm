module Main exposing (..)

import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Models exposing (Model)
import Msgs exposing (..)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View


initialModel : Model
initialModel =
    { assumedAnnualValueAppreciationRate = 4
    , downPaymentPercent = 30
    , errorMessage = ""
    , errorMessageCountdown = 0
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
    initialModel ! []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = View.view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
