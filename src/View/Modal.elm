module View.Modal exposing (modal)

import Html.Styled exposing (div, Html)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (Msg)


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
