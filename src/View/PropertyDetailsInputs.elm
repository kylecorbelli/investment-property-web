module View.PropertyDetailsInputs exposing (..)

import Html.Styled exposing (button, div, form, h2, Html, input, label, section, text)
import Html.Styled.Attributes exposing (class, placeholder, type_, value)
import Html.Styled.Events exposing (onInput)
import Models exposing (Model)
import Msgs exposing (Msg(..))
import View.Utilities exposing (onSubmit)

viewInputs : Model -> Html Msg
viewInputs model =
    section [ class "mb5" ]
        [ h2 [ class "mb3" ] [ text "inputs" ]
        , form [ onSubmit CommitInputs, class "flex flex-column flex-row-ns" ]
            [ viewInput "purchase price:" "" model.purchasePriceFormField UpdatePurchasePriceFormField
            , viewInput "gross monthly rent:" "" model.grossMonthlyRentFormField UpdateGrossMonthlyRentFormField
            , button [ class "bg-green bn cl f5 hover-bg-dark-green outline-0 pa3 pa1-ns pointer w-100 w-20-ns white", type_ "submit" ] [ text "analyze" ]
            ]
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput labelText placeholderText fieldValue msg =
    div [ class "fl mb3 mb0-ns pr3-ns w-100 w-40-ns" ]
        [ label []
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
