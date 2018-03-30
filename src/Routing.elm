module Routing exposing (..)

import Html.Styled exposing (Html, text)
import Models exposing (Model, Route(..))
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import UrlParser exposing (Parser, oneOf, parseHash, s, top)
import View.Main
import View.SignUp


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ UrlParser.map Home top
        , UrlParser.map SignUp (s "signup")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        _ ->
            NotFoundRoute


renderPage : Model -> Html Msg
renderPage model =
    case model.route of
        Home ->
            View.Main.view model

        SignUp ->
            View.SignUp.view model

        NotFoundRoute ->
            text "this can probably be a cooler 404 page"
