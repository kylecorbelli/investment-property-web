module View exposing (..)

import Colors exposing (..)
import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Debug
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


view : Model -> Html Msg
view model =
    div [ css [ pageStyle ] ]
        [ errorMessageBannerView model.errorMessage model.errorMessageCountdown
        , div [ css [ headerStyle ] ]
            [ h1 [ css [ headlineStyle ] ] [ text "income property analysis" ]
            ]
        , div [ css [ contentStyle ] ]
            [ viewInputs model
            , div [ css [ analysisSectionsStyle ] ]
                [ viewMonthlyAnalysis model
                , viewAnnualYieldAnalysis model
                ]
            ]
        , searchZillowButton

        -- , zillowSearchFormView
        -- , button [ onClick ZillowSearchResultsRequestSent ] [ text "Send Zillow Request" ]
        -- , useZillowValuesButton model.zillowSearchResult
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
    section [ css [ inputSectionStyle ] ]
        [ h2 [ css [ sectionHeaderStyle ] ] [ text "inputs" ]
        , form [ onSubmit CommitInputs, css [ formStyle ] ]
            [ viewInput "Purchase price..." model.purchasePriceFormField UpdatePurchasePriceFormField
            , viewInput "Gross monthly rent..." model.grossMonthlyRentFormField UpdateGrossMonthlyRentFormField
            , button [ css [ buttonStyle ], type_ "submit" ] [ text "analyze" ]
            ]
        ]


viewInput : String -> String -> (String -> Msg) -> Html Msg
viewInput placeholderText fieldValue msg =
    input
        [ css [ inputStyle ]
        , onInput msg
        , placeholder placeholderText
        , type_ "number"
        , value fieldValue
        ]
        []


viewMonthlyAnalysis : Model -> Html Msg
viewMonthlyAnalysis model =
    section [ css [ analysisSection, leftSectionStyle ] ]
        [ h2 [ css [ sectionHeaderStyle ] ] [ text "monthly cashflow analysis" ]
        , Html.Styled.table [ css [ tableStyle ] ]
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
    section [ css [ analysisSection, rightSectionStyle ] ]
        [ h2 [ css [ sectionHeaderStyle ] ] [ text "annual yield analysis" ]
        , Html.Styled.table [ css [ tableStyle ] ]
            [ tbody []
                [ viewLineItem "initial investment" ( NoUnderline, "" ) ( NoUnderline, Select.downPayment model |> dollarFormat )
                ]
            ]
        , Html.Styled.table [ css [ tableStyle ] ]
            [ thead []
                [ tr []
                    [ th [] []
                    , th [ css [ thStyle ] ] [ text "amount" ]
                    , th [ css [ thStyle ] ] [ text "yield" ]
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
        noClass =
            Css.batch []

        determineUnderlineClass underlineStyle =
            case underlineStyle of
                SingleUnderline ->
                    underlinedCell

                DoubleUnderline ->
                    doubleUnderlinedCell

                NoUnderline ->
                    noClass

        underlineClassOne =
            determineUnderlineClass underlineStyleOne

        underlineClassTwo =
            determineUnderlineClass underlineStyleTwo
    in
        tr []
            [ td [] [ text label ]
            , td [ css [ lineItemValue, underlineClassOne ] ] [ text firstVal ]
            , td [ css [ lineItemValue, underlineClassTwo ] ] [ text secondVal ]
            ]


roundedString : Float -> String
roundedString =
    format roundedLocale


roundedLocale : Locale
roundedLocale =
    { usLocale | decimals = 0 }


dollarFormat : Float -> String
dollarFormat =
    roundedString >> (String.append "$")


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
    button [ class "bg-green bw0 hover-bg-dark-green outline-0 ph3 pv2 pointer white", onClick ToggleModal ] [ text "Analyze Property by Address" ]


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
                    div [ class "items-center flex flex-column justify-center"]
                        [ img [ src "/spinner.gif", class "h3 mb3" ] []
                        , p [ class "f4" ] [ text "searching..." ]
                        ]

                _ ->
                    div []
                        [ h2 [ class "h2 mb4 tc" ] [ text "Search For a Property" ]
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
        [ h2 [ class "h2 mb4 tc" ] [ text "Search Results" ]
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
            [ button [ class "bw1 hover-bg-light-gray b--light-gray gray mb3 mb0-ns outline-0 ph3 pv2 pointer w-100 w-40-ns", onClick DismissZillowSearchResult ] [ text "Search Again" ]
            , button [ class "bg-green bw0 hover-bg-dark-green outline-0 ph3 pv2 pointer white w-100 w-40-ns", onClick UseZillowDataInAnalysis ] [ text "Load This Property" ]
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



-- CSS


headerStyle : Style
headerStyle =
    Css.batch
        [ backgroundColor greenDarkest
        , displayFlex
        , justifyContent center
        , marginBottom (em 2)
        , padding (em 1)
        , width (pct 100)
        ]



-- Get this somewhere more convenient:


breakPointMin : Float -> List Style -> Style
breakPointMin pixels styles =
    withMedia [ only screen [ Media.minWidth (px pixels) ] ] styles


fromTablet : List Style -> Style
fromTablet =
    breakPointMin 600


fromDesktop : List Style -> Style
fromDesktop =
    breakPointMin 1000


redBorder : Style
redBorder =
    border3 (px 1) solid (hex "#ff0000")


pageStyle : Style
pageStyle =
    Css.batch
        [ alignItems center
        , displayFlex
        , flexDirection column
        , minHeight (vh 100)
        ]


headlineStyle : Style
headlineStyle =
    Css.batch
        [ color greenLightest
        , flexGrow (int 1)
        , fontFamilies [ "Helvetica Neue" ]
        , fontSize (em 1.75)
        , fontWeight (int 100)
        , textAlign center
        , fromTablet
            [ textAlign left
            ]
        ]


contentStyle : Style
contentStyle =
    Css.batch
        [ padding (em 1)
        , maxWidth (px 960)
        , width (pct 100)
        ]


inputSectionStyle : Style
inputSectionStyle =
    Css.batch
        [ marginBottom (em 3)
        ]


formStyle : Style
formStyle =
    Css.batch
        [ alignItems stretch
        , displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , fromTablet
            [ alignItems flexEnd
            , flexDirection row
            ]
        ]


inputStyle : Style
inputStyle =
    Css.batch
        [ backgroundColor transparent
        , border (px 0)
        , borderBottom3 (px 1) solid greenMedium
        , color greenDarkest
        , flexBasis (pct 40)
        , fontSize (em 1.5)
        , fontWeight (int 100)
        , marginBottom (em 1)
        , outline none
        , fromTablet
            [ marginBottom (px 0)
            ]
        ]


buttonStyle : Style
buttonStyle =
    Css.batch
        [ backgroundColor greenLight
        , border (px 0)
        , color (hex "#fff")
        , cursor pointer
        , fontSize (em 1.5)
        , fontWeight (int 100)
        , hover
            [ backgroundColor greenLightest
            ]
        , outline none
        , padding (em 0.5)
        , fromTablet
            [ padding2 (em 0.25) (em 0.5)
            ]
        ]


analysisSectionsStyle : Style
analysisSectionsStyle =
    Css.batch
        [ displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , width (pct 100)
        , fromTablet
            [ flexDirection row
            ]
        ]


sectionHeaderStyle : Style
sectionHeaderStyle =
    Css.batch
        [ marginBottom (em 0.5)
        ]


analysisSection : Style
analysisSection =
    Css.batch
        [ flexGrow (int 1)
        , marginBottom (em 2)
        ]


leftSectionStyle : Style
leftSectionStyle =
    Css.batch
        [ fromTablet [ paddingRight (em 2) ]
        ]


rightSectionStyle : Style
rightSectionStyle =
    Css.batch
        [ fromTablet [ paddingLeft (em 2) ]
        ]


tableStyle : Style
tableStyle =
    Css.batch
        [ marginBottom (em 1)
        , width (pct 100)
        ]


thStyle : Style
thStyle =
    Css.batch
        [ fontStyle italic
        , fontWeight (int 300)
        , textAlign right
        ]


lineItemValue : Style
lineItemValue =
    Css.batch
        [ textAlign right
        ]


underlinedCell : Style
underlinedCell =
    Css.batch
        [ borderBottom3 (px 1) solid greenDarkest
        ]


doubleUnderlinedCell : Style
doubleUnderlinedCell =
    Css.batch
        [ borderBottom3 (px 3) double greenDarkest
        ]
