module Main exposing (..)

import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Models exposing (Environment(..), Model)
import Msgs exposing (..)
import RemoteData exposing (RemoteData(..))
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View


determineEnvironment : String -> Environment
determineEnvironment environment =
    case environment of
        "test" ->
            Test

        "production" ->
            Production

        _ ->
            Development


initialModel : Flags -> Model
initialModel flags =
    { assumedAnnualValueAppreciationRate = 2
    , downPaymentPercent = 30
    , environment = determineEnvironment flags.environment
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
    , ui =
        { isModalShown = False
        }
    , zillowSearchAddressField = ""
    , zillowSearchResult = NotAsked
    }


type alias Flags =
    { environment : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    initialModel flags ! []



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = View.view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
