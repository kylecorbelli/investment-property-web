module Tests.Lenses exposing (..)

import Test exposing (..)
import Expect
import Fixtures exposing (model)
import Models exposing (Model)
import Monocle.Lens exposing (Lens)
import RemoteData exposing (RemoteData(..))
import Lenses
    exposing
        ( errorMessageLens
        , errorMessageCountdownLens
        , grossMonthlyRentLens
        , grossMonthlyRentFormFieldLens
        , isModalShownLens
        , purchasePriceLens
        , purchasePriceFormFieldLens
        , uiLens
        , uiIsModalShownLens
        , zillowSearchAddressFieldLens
        , zillowSearchResultLens
        )


all : Test
all =
    describe "Lenses"
        [ testTopLevelLens
            "purchasePriceLens"
            model
            purchasePriceLens
            .purchasePrice
            (\model newValue -> { model | purchasePrice = newValue })
            95000
        , testTopLevelLens
            "purchasePriceFormFieldLens"
            model
            purchasePriceFormFieldLens
            .purchasePriceFormField
            (\model newValue -> { model | purchasePriceFormField = newValue })
            "86000"
        , testTopLevelLens
            "grossMonthlyRentFormFieldLens"
            model
            grossMonthlyRentFormFieldLens
            .grossMonthlyRentFormField
            (\model newValue -> { model | grossMonthlyRentFormField = newValue })
            "1400"
        , testTopLevelLens
            "grossMonthlyRentLens"
            model
            grossMonthlyRentLens
            .grossMonthlyRent
            (\model newValue -> { model | grossMonthlyRent = newValue })
            1400
        , testTopLevelLens
            "errorMessageLens"
            model
            errorMessageLens
            .errorMessage
            (\model newValue -> { model | errorMessage = newValue })
            "something bad happened"
        , testTopLevelLens
            "errorMessageCountdownLens"
            model
            errorMessageCountdownLens
            .errorMessageCountdown
            (\model newValue -> { model | errorMessageCountdown = newValue })
            7
        , testTopLevelLens
            "zillowSearchAddressFieldLens"
            model
            zillowSearchAddressFieldLens
            .zillowSearchAddressField
            (\model newValue -> { model | zillowSearchAddressField = newValue })
            "712 Park Lane Petaluma"
        , testTopLevelLens
            "zillowSearchResultLens"
            model
            zillowSearchResultLens
            .zillowSearchResult
            (\model newValue -> { model | zillowSearchResult = newValue })
            Loading
        , testTopLevelLens
            "uiLens"
            model
            uiLens
            .ui
            (\model newValue -> { model | ui = newValue })
            { isModalShown = True }
        , describe "uiIsModalShownLens"
            [ test "get" <|
                \_ ->
                    Expect.equal model.ui.isModalShown (uiIsModalShownLens.get model.ui)
            , test "set" <|
                \_ ->
                    let
                        existingUi =
                            model.ui

                        newUi =
                            { existingUi | isModalShown = True }
                    in
                        Expect.equal newUi (uiIsModalShownLens.set True model.ui)
            ]
        , describe "isModalShownLens"
            [ test "get" <|
                \_ ->
                    Expect.equal model.ui.isModalShown (isModalShownLens.get model)
            , test "set" <|
                \_ ->
                    let
                        existingUi =
                            model.ui

                        newUi =
                            { existingUi | isModalShown = True }

                        newModel =
                            { model | ui = newUi }
                    in
                        Expect.equal newModel (isModalShownLens.set True model)
            ]
        ]


testTopLevelLens : String -> Model -> Lens Model a -> (Model -> a) -> (Model -> a -> Model) -> a -> Test
testTopLevelLens lensName model lens getter setter newValue =
    describe lensName
        [ test "get" <|
            \_ ->
                Expect.equal (getter model) (lens.get model)
        , test "set" <|
            \_ ->
                Expect.equal (setter model newValue) (lens.set newValue model)
        ]
