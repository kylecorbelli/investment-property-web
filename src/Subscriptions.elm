module Subscriptions exposing (subscriptions)

import Models exposing (Model)
import Msgs exposing (..)
import Time exposing (every, second)


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subs =
            if model.errorMessageCountdown > 0 then
                [ every second (always AdvanceErrorMessageCountdown) ]
            else
                []
    in
        Sub.batch subs
