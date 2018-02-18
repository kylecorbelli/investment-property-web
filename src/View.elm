module View exposing (..)

import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Locale, usLocale)
import Html.Styled exposing (button, div, form, h1, h2, h3, Html, i, img, input, label, p, section, span, table, tbody, td, th, thead, text, tr)
import Html.Styled.Attributes exposing (class, css, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onWithOptions)
import Json.Decode as Decode
import Models exposing (Model, ZillowSearchResult)
import Msgs exposing (..)
import Select
import Views.ErrorMessageBanner exposing (errorMessageBannerView)
import RemoteData exposing (RemoteData(..), WebData)
import Regex exposing (HowMany(All), replace, regex)


view : Model -> Html Msg
view model =
    div [ class "flex flex-column items-center" ]
        [ errorMessageBannerView model.errorMessage model.errorMessageCountdown
        , div [ class "bg-black flex justify-center justify-start-ns mb4 pa3 w-100" ]
            [ h1 [ class "f3 fw1 helvetica light-green" ] [ text "income property analysis" ]
            ]
        , div [ class "mw7 pa3 w-100" ]
            [ viewInputs model
            , div [ class "flex flex-column flex-row-ns justify-between" ]
                [ viewMonthlyAnalysis model
                , viewAnnualYieldAnalysis model
                ]
            ]
        , searchZillowButton
        , modal model zillowSearchModalContent DismissZillowModal
        ]


onSubmit : Msg -> Html.Styled.Attribute Msg
onSubmit msg =
    onWithOptions
        "submit"
        { stopPropagation = True, preventDefault = True }
        (Decode.succeed msg)


viewInputs : Model -> Html Msg
viewInputs model =
    section [ class "mb5" ]
        [ h2 [ class "mb3" ] [ text "inputs" ]
        , form [ onSubmit CommitInputs, class "flex flex-column flex-row-ns" ]
            [ viewInput "purchase price" "" model.purchasePriceFormField UpdatePurchasePriceFormField
            , viewInput "gross monthly rent" "" model.grossMonthlyRentFormField UpdateGrossMonthlyRentFormField
            , button [ class "bg-green bn cl f5 hover-bg-dark-green outline-0 pa3 pa1-ns pointer w-100 w-20-ns white", type_ "submit" ] [ text "analyze" ]
            ]
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput labelText placeholderText fieldValue msg =
    div [ class "fl mb3 mb0-ns pr3-ns w-100 w-40-ns" ]
        [ label [ class "" ]
            [ text labelText
            , input
                [ class "bt-0 bl-0 br-0 bb bb-1 b--gray f4 fw1 mt2 outline-0 w-100"
                , onInput msg
                , placeholder placeholderText
                , type_ "number"
                , value fieldValue
                ]
                []
            ]
        ]


viewMonthlyAnalysis : Model -> Html Msg
viewMonthlyAnalysis model =
    section [ class "mb4 pr3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "monthly cashflow analysis" ]
        , Html.Styled.table [ class "mb1 w-100" ]
            [ tbody []
                [ viewLineItem "gross rent" ( NoUnderline, "" ) ( NoUnderline, model.grossMonthlyRent |> dollarFormat )
                , viewLineItem "mortgage principal & interest" ( NoUnderline, Select.mortgagePrincipalAndInterestMonthly model |> dollarFormat ) ( NoUnderline, "" )
                , viewLineItem "taxes & insurance" ( NoUnderline, Select.taxesAndInsuranceMonthlyAmount model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "operating expenses" ( NoUnderline, Select.operatingExpensesMonthly model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "property management fees" ( SingleUnderline, Select.propertyManagementExpensesMonthly model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "total expenses" ( NoUnderline, "" ) ( SingleUnderline, Select.totalMonthlyExpenses model |> roundedString )
                , viewLineItem "net cashflow" ( NoUnderline, "" ) ( DoubleUnderline, Select.netMonthlyCashflow model |> dollarFormat )
                ]
            ]
        ]


viewAnnualYieldAnalysis : Model -> Html Msg
viewAnnualYieldAnalysis model =
    section [ class "mb4 pl3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "annual yield analysis" ]
        , Html.Styled.table [ class "mb3 w-100" ]
            [ tbody []
                [ viewLineItem "initial investment" ( NoUnderline, "" ) ( NoUnderline, Select.downPayment model |> dollarFormat )
                ]
            ]
        , Html.Styled.table [ class "mb1 w-100" ]
            [ thead []
                [ tr []
                    [ th [] []
                    , th [ class "fw3 i tr" ] [ text "amount" ]
                    , th [ class "fw3 i tr" ] [ text "yield" ]
                    ]
                ]
            , tbody []
                [ viewLineItem "net cashflow" ( NoUnderline, Select.netAnnualCashflow model |> dollarFormat ) ( NoUnderline, Select.cashOnCashYield model |> percentFormat )
                , viewLineItem "first year appreciation" ( NoUnderline, Select.firstYearAppreciationAmount model |> roundedString ) ( NoUnderline, Select.firstYearAppreciationYield model |> percentFormat )
                , viewLineItem "first year principal paydown" ( SingleUnderline, Select.firstYearPrincipalPaydownAmount model |> roundedString ) ( SingleUnderline, Select.firstYearPrincipalPaydownYield model |> percentFormat )
                , viewLineItem "total gain" ( DoubleUnderline, Select.totalAnnualGain model |> dollarFormat ) ( DoubleUnderline, Select.totalAnnualYield model |> percentFormat )
                ]
            ]
        ]


type UnderlineStyle
    = SingleUnderline
    | DoubleUnderline
    | NoUnderline


viewLineItem : String -> ( UnderlineStyle, String ) -> ( UnderlineStyle, String ) -> Html Msg
viewLineItem label ( underlineStyleOne, firstVal ) ( underlineStyleTwo, secondVal ) =
    let
        noClasses =
            ""

        determineUnderlineClasses underlineStyle =
            case underlineStyle of
                SingleUnderline ->
                    "bb"

                DoubleUnderline ->
                    "re-bbs-double"

                NoUnderline ->
                    noClasses

        underlineClassesOne =
            determineUnderlineClasses underlineStyleOne

        underlineClassesTwo =
            determineUnderlineClasses underlineStyleTwo
    in
        tr []
            [ td [] [ text label ]
            , td [ class <| "tr" ++ " " ++ underlineClassesOne ] [ text firstVal ]
            , td [ class <| "tr" ++ " " ++ underlineClassesTwo ] [ text secondVal ]
            ]


roundedString : Float -> String
roundedString =
    format roundedLocale


roundedLocale : Locale
roundedLocale =
    { usLocale | decimals = 0 }


dollarFormat : Float -> String
dollarFormat value =
    let
        removeNegativeSign =
            replace All (regex "−") (always "")
    in
        case value < 0 of
            True ->
                "($" ++ (removeNegativeSign << roundedString <| value) ++ ")"

            False ->
                "$" ++ roundedString value


percentFormat : Float -> String
percentFormat =
    roundedString >> ((flip String.append) "%")


viewValue : String -> number -> Html Msg
viewValue label value =
    p []
        [ span [] [ text <| label ++ ": " ]
        , span [] [ text <| toString value ]
        ]


searchZillowButton : Html Msg
searchZillowButton =
    button [ class "ba b--green bg-green bw0 f5 hover-bg-dark-green outline-0 pa3 pointer white", onClick ToggleModal ] [ text "load property by address" ]


modal : Model -> (Model -> Html Msg) -> Msg -> Html Msg
modal model viewFunction onDismiss =
    let
        displayClass =
            if model.ui.isModalShown then
                "flex"
            else
                "dn"

        containerClasses =
            "bottom-0 fixed items-center justify-center left-0 right-0 top-0" ++ " " ++ displayClass
    in
        div [ class containerClasses ]
            [ div [ class "bg-white flex items-center justify-center mw7 relative w-90 z-4" ] [ viewFunction model ]
            , div [ class "bg-black bottom-0 fixed left-0 o-80 right-0 top-0 z-1", onClick onDismiss ] []
            ]


zillowSearchModalContent : Model -> Html Msg
zillowSearchModalContent model =
    let
        markup =
            case model.zillowSearchResult of
                Success zillowSearchResult ->
                    zillowSearchResultsSuccessView zillowSearchResult

                Loading ->
                    div [ class "items-center flex flex-column justify-center" ]
                        [ img [ src "/spinner.gif", class "h3 mb3" ] []
                        , p [ class "f4" ] [ text "searching..." ]
                        ]

                _ ->
                    div []
                        [ h2 [ class "h2 mb4 tc" ] [ text "search for a property" ]
                        , zillowSearchFormView
                        ]
    in
        div [ class "pa4 ph5-ns w-100" ]
            [ i [ class "fas fa-times absolute f5 f4-ns hover-gray top-1 right-1 pointer pa1", onClick DismissZillowModal ] []
            , markup
            ]


zillowSearchResultsSuccessView : ZillowSearchResult -> Html Msg
zillowSearchResultsSuccessView { address, bathroomCount, bedroomCount, rentZestimateData, squareFootage, zestimateData } =
    div [ class "tc" ]
        [ h2 [ class "h2 mb4 tc" ] [ text "search results" ]
        , div [ class "cf mb4" ]
            [ div [ class "fl w-100 w-third-ns tc tl-ns mb3 mb0-ns" ]
                [ h3 [] [ text address.street ]
                , p [ class "f6" ] [ text <| address.city ++ ", " ++ address.state ++ " " ++ address.zipCode ]
                , p [ class "f6 gray" ] [ text <| (toString bedroomCount) ++ " bed | " ++ (toString bathroomCount) ++ " bath | " ++ (toString squareFootage) ++ " sqft" ]
                ]
            , div [ class "fl w-100 w-two-thirds-ns" ]
                [ div [ class "fl w-100 w-50-ns" ]
                    [ h3 [] [ text "market value estimate" ]
                    , p [ class "f6 mb3" ] [ text <| (dollarFormat << toFloat) zestimateData.amount ]
                    ]
                , div [ class "fl w-100 w-50-ns" ]
                    [ h3 [] [ text "market rent estimate" ]
                    , p [ class "f6" ] [ text <| (dollarFormat << toFloat) rentZestimateData.amount ]
                    ]
                ]
            ]
        , div [ class "cf flex-ns justify-between-ns" ]
            [ button [ class "bw1 hover-bg-light-gray b--light-gray gray mb3 mb0-ns outline-0 ph3 pv2 pointer w-100 w-40-ns", onClick DismissZillowSearchResult ] [ text "search again" ]
            , button [ class "bg-green bw0 hover-bg-dark-green outline-0 ph3 pv2 pointer white w-100 w-40-ns", onClick UseZillowDataInAnalysis ] [ text "load this property" ]
            ]
        ]


zillowSearchFormView : Html Msg
zillowSearchFormView =
    form [ class "ba b--silver flex w-100", onSubmit ZillowSearchResultsRequestSent ]
        [ input [ class "bw0 flex-auto f4 outline-0 pa3", onInput UpdateZillowSearchAddressField, placeholder "address" ] []
        , button [ class "bg-green bw0 hover-bg-dark-green outline-0 ph4 pointer white", type_ "submit" ] [ text "Search" ]
        ]


useZillowValuesButton : WebData ZillowSearchResult -> Html Msg
useZillowValuesButton zillowSearchResult =
    case zillowSearchResult of
        Success result ->
            button [ onClick UseZillowDataInAnalysis ] [ text "Use Zillow Values" ]

        _ ->
            text ""
