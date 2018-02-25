module View.AnalysisResults exposing (..)

import Html.Styled exposing (h2, Html, section, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (class)
import Models exposing (Model, UnderlineStyle(..))
import Msgs exposing (Msg)
import Select
import View.Utilities exposing (dollarFormat, inParens, percentFormat, roundedString)


viewMonthlyOperatingIncomeAnalysis : Model -> Html Msg
viewMonthlyOperatingIncomeAnalysis model =
    section [ class "mb4 pr3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "monthly operating income" ]
        , Html.Styled.table [ class "mb1 w-100" ]
            [ tbody []
                [ viewLineItem "gross rent" ( NoUnderline, model.grossMonthlyRent |> dollarFormat ) ( NoUnderline, "" )
                , viewLineItem "vacancy allowance" ( SingleUnderline, roundedString 0 << Select.vacancyAllowanceMonthly <| model ) ( NoUnderline, "" )
                , viewLineItem "net rent" ( NoUnderline, "" ) ( NoUnderline, dollarFormat << Select.netMonthlyRent <| model )
                , viewLineItem "taxes & insurance" ( NoUnderline, dollarFormat << Select.taxesAndInsuranceMonthlyAmount <| model ) ( NoUnderline, "" )
                , viewLineItem "capital expenditures" ( NoUnderline, roundedString 0 << Select.capitalExpendituresExpenseMonthly <| model ) ( NoUnderline, "" )
                , viewLineItem "repairs & maintenence" ( NoUnderline, roundedString 0 << Select.repairsAndMaintenanceExpenseMonthly <| model ) ( NoUnderline, "" )
                , viewLineItem "property management fees" ( SingleUnderline, Select.propertyManagementExpensesMonthly model |> roundedString 0 ) ( NoUnderline, "" )
                , viewLineItem "total expenses" ( NoUnderline, "" ) ( SingleUnderline, Select.totalMonthlyExpenses model |> roundedString 0 )
                , viewLineItem "net operating income" ( NoUnderline, "" ) ( DoubleUnderline, Select.netMonthlyOperatingIncome model |> dollarFormat )
                ]
            ]
        ]



-- , viewLineItem "operating expenses" ( NoUnderline, Select.operatingExpensesMonthly model |> roundedString 0 ) ( NoUnderline, "" )
-- , viewLineItem "mortgage principal & interest" ( NoUnderline, Select.mortgagePrincipalAndInterestMonthly model |> dollarFormat ) ( NoUnderline, "" )


viewAnnualYieldAnalysis : Model -> Html Msg
viewAnnualYieldAnalysis model =
    section [ class "mb4 pr3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "annual yield" ]
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
                [ viewLineItem "cashflow" ( NoUnderline, Select.netAnnualCashflow model |> dollarFormat ) ( NoUnderline, Select.cashOnCashYield model |> percentFormat 0 )
                , viewLineItem "first year appreciation" ( NoUnderline, Select.firstYearAppreciationAmount model |> roundedString 0 ) ( NoUnderline, Select.firstYearAppreciationYield model |> percentFormat 0 )
                , viewLineItem "first year principal paydown" ( SingleUnderline, Select.firstYearPrincipalPaydownAmount model |> roundedString 0 ) ( SingleUnderline, Select.firstYearPrincipalPaydownYield model |> percentFormat 0 )
                , viewLineItem "total gain" ( DoubleUnderline, Select.totalAnnualGain model |> dollarFormat ) ( DoubleUnderline, Select.totalAnnualYield model |> percentFormat 0 )
                ]
            ]
        ]


viewMonthlyCashFlowAnalysis : Model -> Html Msg
viewMonthlyCashFlowAnalysis model =
    section [ class "mb4 pl3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "monthly cashflow" ]
        , Html.Styled.table [ class "mb3 w-100" ]
            [ tbody []
                [ viewLineItem "net operating income" ( NoUnderline, "" ) ( NoUnderline, dollarFormat << Select.netMonthlyOperatingIncome <| model )
                , viewLineItem "mortgage principal & interest" ( NoUnderline, "" ) ( SingleUnderline, roundedString 0 << Select.mortgagePrincipalAndInterestMonthly <| model )
                , viewLineItem "cashflow" ( NoUnderline, "" ) ( DoubleUnderline, dollarFormat << Select.netMonthlyCashflow <| model )
                ]
            ]
        ]


viewPropertyMetrics : Model -> Html Msg
viewPropertyMetrics model =
    section [ class "mb4 pl3-ns w-100 w-50-ns" ]
        [ h2 [ class "mb3" ] [ text "metrics" ]
        , Html.Styled.table [ class "mb3 w-100" ]
            [ viewLineItem "gross rent multiplier" ( NoUnderline, "" ) ( NoUnderline, roundedString 2 << Select.grossRentMultiplier <| model )
            , viewLineItem "capitalization rate" ( NoUnderline, "" ) ( NoUnderline, percentFormat 1 << Select.capitalizationRate <| model )
            , viewLineItem "debt coverage ratio" ( NoUnderline, "" ) ( NoUnderline, roundedString 2 << Select.debtCoverageRatio <| model )
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
