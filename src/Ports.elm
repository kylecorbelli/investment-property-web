port module Ports
    exposing
        ( gtmAnalyzeProperty
        , gtmPageView
        )


port gtmPageView : String -> Cmd msg


type alias AnalyzePropertyArgs =
    { purchasePrice : String
    , grossMonthlyRent : String
    }


port gtmAnalyzeProperty : AnalyzePropertyArgs -> Cmd msg
