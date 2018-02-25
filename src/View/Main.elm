module View.Main exposing (..)

import Html.Styled exposing (button, div, form, h1, h2, h3, Html, i, img, input, label, p, section, span, table, tbody, td, th, thead, text, tr)
import Html.Styled.Attributes exposing (class, css, placeholder, src, type_, value)
import Models exposing (Model, ZillowSearchResult)
import Msgs exposing (..)
import View.AnalysisResults exposing (viewAnnualYieldAnalysis, viewMonthlyCashFlowAnalysis, viewMonthlyOperatingIncomeAnalysis, viewPropertyMetrics)
import View.ErrorMessageBanner exposing (errorMessageBannerView)
import View.Modal exposing (modal)
import View.PropertyDetailsInputs exposing (viewInputs)
import View.ZillowSearchModal exposing (searchZillowButton, zillowSearchModalContent)


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
                [ viewMonthlyOperatingIncomeAnalysis model
                , viewMonthlyCashFlowAnalysis model
                ]
            , div [ class "flex flex-column flex-row-ns justify-between" ]
                [ viewAnnualYieldAnalysis model
                , viewPropertyMetrics model
                ]
            ]
        , searchZillowButton
        , modal model zillowSearchModalContent DismissZillowModal
        ]