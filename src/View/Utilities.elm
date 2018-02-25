module View.Utilities exposing (..)

import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Locale, usLocale)
import Html.Styled exposing (Html)
import Html.Styled.Events exposing (onWithOptions)
import Json.Decode as Decode
import Msgs exposing (Msg)
import Regex exposing (HowMany(All), replace, regex)


onSubmit : Msg -> Html.Styled.Attribute Msg
onSubmit msg =
    onWithOptions
        "submit"
        { stopPropagation = True, preventDefault = True }
        (Decode.succeed msg)


roundedString : Int -> Float -> String
roundedString =
    format << roundedLocale


roundedLocale : Int -> Locale
roundedLocale decimals =
    { usLocale | decimals = decimals }


dollarFormat : Float -> String
dollarFormat value =
    let
        removeNegativeSign =
            replace All (regex "−") (always "")
    in
        case value < 0 of
            True ->
                "($" ++ (removeNegativeSign << roundedString 0 <| value) ++ ")"

            False ->
                "$" ++ roundedString 0 value


ratioLocale : Locale
ratioLocale =
    { usLocale | decimals = 2 }

percentFormat : Int -> Float -> String
percentFormat decimals value =
    roundedString decimals value ++ "%"

inParens : String -> String
inParens value =
    "(" ++ value ++ ")"
