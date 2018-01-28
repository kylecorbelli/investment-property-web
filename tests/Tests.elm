module Tests exposing (..)

import Test exposing (..)
import Expect
import Calculate


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


all : Test
all =
    describe "A Test Suite"
        [ test "Addition" <|
            \_ ->
                Expect.equal 10 (3 + 7)
        , test "String.left" <|
            \_ ->
                Expect.equal "a" (String.left 1 "abcdefg")
        , test "mortgagePrincipalAndInterestMonthly" <|
            \_ ->
                let
                    interestRate =
                        4.75

                    mortgageTermInYears =
                        30

                    mortgageAmount =
                        105000

                    result =
                        Calculate.mortgagePrincipalAndInterestMonthly interestRate mortgageTermInYears mortgageAmount
                in
                    result |> Expect.within (Expect.Absolute 0.000001) 547.7297033
        ]
