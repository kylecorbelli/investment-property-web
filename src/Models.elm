module Models exposing (..)

import RemoteData exposing (WebData)


type alias ZillowAddress =
    { street : String
    , zipCode : String
    , city : String
    , state : String
    , latitude : Float
    , longitude : Float
    }


type alias ZillowZestimateData =
    { amount : Int
    , high : Int
    , low : Int
    }


type alias ZillowSearchResult =
    { zpid : String
    , address : ZillowAddress
    , bathroomCount : Float
    , bedroomCount : Float
    , rentZestimateData : ZillowZestimateData
    , squareFootage : Int
    , zestimateData : ZillowZestimateData
    }


type alias UIModel =
    { isModalShown : Bool
    }


type Environment
    = Development
    | Production
    | Test


type UnderlineStyle
    = SingleUnderline
    | DoubleUnderline
    | NoUnderline


type alias Model =
    { assumedAnnualValueAppreciationRate : Float
    , downPaymentPercent : Float -- will be 30 instead of 0.3
    , environment : Environment
    , errorMessage : String
    , errorMessageCountdown : Int
    , grossMonthlyRent : Float
    , grossMonthlyRentFormField : String
    , homeInsuranceAnnualAmount : Float
    , interestRate : Float -- will be 4.75 instead of 0.0475
    , mortgageTermInYears : Int
    , operatingExpensePercent : Float
    , propertyManagementFeePercent : Float
    , propertyTaxRate : Float
    , purchasePrice : Float
    , purchasePriceFormField : String
    , ui : UIModel
    , zillowSearchAddressField : String
    , zillowSearchResult : WebData ZillowSearchResult
    }
