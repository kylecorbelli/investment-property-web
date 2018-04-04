module Lenses exposing (..)

import Models exposing (Model, UIModel, ZillowSearchResult)
import Monocle.Common exposing ((<|>))
import Monocle.Lens exposing (Lens)
import RemoteData exposing (WebData)


purchasePriceLens : Lens Model Float
purchasePriceLens =
    Lens .purchasePrice (\purchasePrice model -> { model | purchasePrice = purchasePrice })


purchasePriceFormFieldLens : Lens Model String
purchasePriceFormFieldLens =
    Lens .purchasePriceFormField (\purchasePriceFormField model -> { model | purchasePriceFormField = purchasePriceFormField })


grossMonthlyRentFormFieldLens : Lens Model String
grossMonthlyRentFormFieldLens =
    Lens .grossMonthlyRentFormField (\grossMonthlyRentFormField model -> { model | grossMonthlyRentFormField = grossMonthlyRentFormField })


grossMonthlyRentLens : Lens Model Float
grossMonthlyRentLens =
    Lens .grossMonthlyRent (\grossMonthlyRent model -> { model | grossMonthlyRent = grossMonthlyRent })


errorMessageLens : Lens Model String
errorMessageLens =
    Lens .errorMessage (\errorMessage model -> { model | errorMessage = errorMessage })


errorMessageCountdownLens : Lens Model Int
errorMessageCountdownLens =
    Lens .errorMessageCountdown (\errorMessageCountdown model -> { model | errorMessageCountdown = errorMessageCountdown })


zillowSearchAddressFieldLens : Lens Model String
zillowSearchAddressFieldLens =
    Lens .zillowSearchAddressField (\zillowSearchAddressField model -> { model | zillowSearchAddressField = zillowSearchAddressField })


zillowSearchResultLens : Lens Model (WebData ZillowSearchResult)
zillowSearchResultLens =
    Lens .zillowSearchResult (\zillowSearchResult model -> { model | zillowSearchResult = zillowSearchResult })


uiLens : Lens Model UIModel
uiLens =
    Lens .ui (\ui model -> { model | ui = ui })


uiIsModalShownLens : Lens UIModel Bool
uiIsModalShownLens =
    Lens .isModalShown (\isModalShown ui -> { ui | isModalShown = isModalShown })


isModalShownLens : Lens Model Bool
isModalShownLens =
    uiLens <|> uiIsModalShownLens
