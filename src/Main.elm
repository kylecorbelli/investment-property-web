module Main exposing (..)

import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Models exposing (Environment(..), Model)
import Navigation exposing (Location, programWithFlags)
import Msgs exposing (..)
import RemoteData exposing (RemoteData(..))
import Routing exposing (parseLocation, renderPage)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View.Main exposing (view)


determineEnvironment : String -> Environment
determineEnvironment environment =
    case environment of
        "test" ->
            Test

        "production" ->
            Production

        _ ->
            Development


initialModel : Flags -> Location -> Model
initialModel flags location =
    { assumedAnnualValueAppreciationRate = 2
    , capitalExpendituresExpensePercent = 10
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
    , repairsAndMaintenanceExpensePercent = 10
    , route = parseLocation location
    , ui =
        { isModalShown = False
        }
    , vacancyRate = 5
    , zillowSearchAddressField = ""
    , zillowSearchResult = NotAsked
    }


type alias Flags =
    { environment : String
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    initialModel flags location ! []



---- PROGRAM ----


main : Program Flags Model Msg
main =
    programWithFlags LocationChanged
        { view = renderPage >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
