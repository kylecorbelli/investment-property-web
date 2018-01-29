module View exposing (..)

import Colors exposing (..)
import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled exposing (button, div, form, h1, h2, Html, input, p, section, span, table, tbody, td, text, tr)
import Html.Styled.Attributes exposing (css, placeholder, src, type_, value)
import Html.Styled.Events exposing (onInput, onWithOptions)
import Json.Decode as Decode
import Models exposing (Model)
import Msgs exposing (..)
import Select


view : Model -> Html Msg
view model =
    div [ css [ pageStyle ] ]
        [ div [ css [ headerStyle ] ]
            [ h1 [ css [ headlineStyle ] ] [ text "income property analysis" ]
            ]
        , div [ css [ contentStyle ] ]
            [ viewInputs model
            , div [ css [ analysisSectionsStyle ] ]
                [ viewMonthlyAnalysis model
                , viewAnnualYieldAnalysis model
                ]
            ]
        ]


viewInputs : Model -> Html Msg
viewInputs model =
    section [ css [ inputSectionStyle ] ]
        [ h2 [] [ text "inputs" ]
        , form [ onWithOptions "submit" { stopPropagation = True, preventDefault = True } (Decode.succeed CommitInputs), css [ formStyle ] ]
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
        [ h2 [] [ text "monthly cashflow analysis" ]
        , Html.Styled.table [ css [ tableStyle ] ]
            [ tbody []
                [ viewLineItem "gross rent" ( NoUnderline, "" ) ( NoUnderline, model.grossMonthlyRent |> roundedString )
                , viewLineItem "mortgage principal & interest" ( NoUnderline, Select.mortgagePrincipalAndInterestMonthly model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "taxes & insurance" ( NoUnderline, Select.taxesAndInsuranceMonthlyAmount model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "operating expenses" ( NoUnderline, Select.operatingExpensesMonthly model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "property management fees" ( SingleUnderline, Select.propertyManagementExpensesMonthly model |> roundedString ) ( NoUnderline, "" )
                , viewLineItem "total expenses" ( NoUnderline, "" ) ( SingleUnderline, Select.totalMonthlyExpenses model |> roundedString )
                , viewLineItem "net cashflow" ( NoUnderline, "" ) ( DoubleUnderline, Select.netMonthlyCashflow model |> roundedString )
                ]
            ]
        ]


viewAnnualYieldAnalysis : Model -> Html Msg
viewAnnualYieldAnalysis model =
    section [ css [ analysisSection, rightSectionStyle ] ]
        [ h2 [] [ text "annual yield analysis" ]
        , Html.Styled.table [ css [ tableStyle ] ]
            [ tbody []
                [ viewLineItem "net cashflow" ( NoUnderline, Select.netAnnualCashflow model |> roundedString ) ( NoUnderline, Select.cashOnCashYield model |> roundedString )
                , viewLineItem "first year appreciation" ( NoUnderline, Select.firstYearAppreciationAmount model |> roundedString ) ( NoUnderline, Select.firstYearAppreciationYield model |> roundedString )
                , viewLineItem "first year principal paydown" ( SingleUnderline, Select.firstYearPrincipalPaydownAmount model |> roundedString ) ( SingleUnderline, Select.firstYearPrincipalPaydownYield model |> roundedString )
                , viewLineItem "total gain" ( DoubleUnderline, Select.totalAnnualGain model |> roundedString ) ( DoubleUnderline, Select.totalAnnualYield model |> roundedString )
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
    Basics.round >> toString


viewValue : String -> number -> Html Msg
viewValue label value =
    p []
        [ span [] [ text <| label ++ ": " ]
        , span [] [ text <| toString value ]
        ]



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
        [ width (pct 100)
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
