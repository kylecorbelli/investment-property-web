module View.SignUp exposing (..)

import Html.Styled exposing (button, div, form, Html, input, text)
import Html.Styled.Attributes exposing (type_)
import Models exposing (Model)
import Msgs exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
      [ form []
        [ input [ type_ "text" ] []
        , input [ type_ "text" ] []
        , button [ type_ "submit" ] [ text "Sign Up" ]
        ]
      ]
