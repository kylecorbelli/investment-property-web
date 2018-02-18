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


roundedString : Float -> String
roundedString =
    format roundedLocale


roundedLocale : Locale
roundedLocale =
    { usLocale | decimals = 0 }


dollarFormat : Float -> String
dollarFormat value =
    let
        removeNegativeSign =
            replace All (regex "−") (always "")
    in
        case value < 0 of
            True ->
                "($" ++ (removeNegativeSign << roundedString <| value) ++ ")"

            False ->
                "$" ++ roundedString value


percentFormat : Float -> String
percentFormat =
    (flip String.append) "%" << roundedString
