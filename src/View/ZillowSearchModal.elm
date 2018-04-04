module View.ZillowSearchModal exposing (..)

import Html.Styled exposing (button, div, form, h2, h3, Html, i, img, input, p, text)
import Html.Styled.Attributes exposing (class, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Model, ZillowSearchResult)
import Msgs exposing (Msg(..))
import RemoteData exposing (RemoteData(..), WebData)
import View.Utilities exposing (dollarFormat, onSubmit)


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
                        , zillowSearchFormView model.zillowSearchAddressField
                        ]
    in
        div [ class "pa4 ph5-ns w-100" ]
            [ i [ class "fas fa-times absolute f5 f4-ns hover-gray top-1 right-1 pointer pa1", onClick DismissZillowModal ] []
            , markup
            ]


searchZillowButton : Html Msg
searchZillowButton =
    button [ class "ba b--green bg-green bw0 f5 hover-bg-dark-green outline-0 pa3 pointer white", onClick ToggleModal ]
        [ text "load property by address" ]


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


zillowSearchFormView : String -> Html Msg
zillowSearchFormView zillowSearchAddressField =
    form [ class "ba b--silver flex w-100", onSubmit ZillowSearchResultsRequestSent ]
        [ input [ class "bw0 flex-auto f4 outline-0 pa3", onInput UpdateZillowSearchAddressField, placeholder "address", value zillowSearchAddressField ] []
        , button [ class "bg-green bw0 hover-bg-dark-green outline-0 ph4 pointer white", type_ "submit" ] [ text "Search" ]
        ]


useZillowValuesButton : WebData ZillowSearchResult -> Html Msg
useZillowValuesButton zillowSearchResult =
    case zillowSearchResult of
        Success result ->
            button [ onClick UseZillowDataInAnalysis ] [ text "Use Zillow Values" ]

        _ ->
            text ""
