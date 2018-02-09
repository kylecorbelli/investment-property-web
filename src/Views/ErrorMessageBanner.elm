module Views.ErrorMessageBanner exposing (..)

import Colors exposing (red, white)
import Css exposing (..)
import Html.Styled exposing (div, Html, i, span, text)
import Html.Styled.Attributes exposing (class, css)
import Msgs exposing (..)


errorMessageBannerView : String -> Int -> Html Msg
errorMessageBannerView errorMessage errorMessageCountdown =
    if errorMessageCountdown > 0 then
        div [ css [ containerStyle ] ]
            [ i [ class "fas fa-exclamation-triangle" ] []
            , span [ css [ messageStyle ] ] [ text errorMessage ]
            ]
    else
        text ""


containerStyle : Style
containerStyle =
    Css.batch
        [ alignItems center
        , backgroundColor red
        , color white
        , displayFlex
        , height (em 5)
        , justifyContent center
        , left (px 0)
        , position fixed
        , top (px 0)
        , right (px 0)
        ]

messageStyle : Style
messageStyle =
    Css.batch
        [ marginLeft (em 1)
        ]
