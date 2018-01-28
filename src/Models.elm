module Models exposing (..)

type alias Model =
  { assumedAnnualValueAppreciationRate: Float
  , downPaymentPercent: Float -- will be 30 instead of 0.3
  , grossMonthlyRent: Float
  , grossMonthlyRentFormField: String
  , homeInsuranceAnnualAmount: Float
  , interestRate: Float -- will be 4.75 instead of 0.0475
  , mortgageTermInYears: Int
  , operatingExpensePercent: Float
  , propertyManagementFeePercent: Float
  , propertyTaxRate: Float
  , purchasePrice: Float
  , purchasePriceFormField: String
  }
