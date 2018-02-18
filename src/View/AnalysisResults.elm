module View.AnalysisResults exposing (..)

import Html.Styled exposing (h2, Html, section, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (class)
import Models exposing (Model, UnderlineStyle(..))
import Msgs exposing (Msg)
import Select
import View.Utilities exposing (dollarFormat, percentFormat, roundedString)


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
