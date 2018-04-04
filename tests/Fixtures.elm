module Fixtures exposing (model)

import Models exposing (Environment(..), Model, Route(..))
import RemoteData exposing (RemoteData(..))

model : Model
model =
  { assumedAnnualValueAppreciationRate = 2
  , capitalExpendituresExpensePercent = 10
  , downPaymentPercent = 30
  , environment = Development
  , errorMessage = ""
  , errorMessageCountdown = 3
  , grossMonthlyRent = 1200
  , grossMonthlyRentFormField = ""
  , homeInsuranceAnnualAmount = 2000
  , interestRate = 4.75
  , mortgageTermInYears = 30
  , operatingExpensePercent = 20
  , propertyManagementFeePercent = 10
  , propertyTaxRate = 1.2
  , purchasePrice = 100000
  , purchasePriceFormField = ""
  , repairsAndMaintenanceExpensePercent = 10
  , route = Home
  , ui =
      { isModalShown = False
      }
  , vacancyRate = 5
  , zillowSearchAddressField = ""
  , zillowSearchResult = NotAsked
  }
