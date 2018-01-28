module Calculate exposing (..)


downPayment : Float -> Float -> Float
downPayment purchasePrice downPaymentPercent =
    purchasePrice * downPaymentPercent / 100



-- Can we abstract this pattern? Test then refactor!


mortgageAmount : Float -> Float -> Float
mortgageAmount purchasePrice downPayment =
    purchasePrice - downPayment


propertyTaxAnnualAmount : Float -> Float -> Float
propertyTaxAnnualAmount purchasePrice propertyTaxRate =
    purchasePrice * propertyTaxRate / 100


taxesAndInsuranceMonthlyAmount : Float -> Float -> Float
taxesAndInsuranceMonthlyAmount homeInsuranceAnnualAmount propertyTaxAnnualAmount =
    (homeInsuranceAnnualAmount + propertyTaxAnnualAmount) / 12


operatingExpensesMonthly : Float -> Float -> Float
operatingExpensesMonthly grossMonthlyRent operatingExpensePercent =
    grossMonthlyRent * operatingExpensePercent / 100


propertyManagementExpensesMonthly : Float -> Float -> Float
propertyManagementExpensesMonthly grossMonthlyRent propertyManagementFeePercent =
    grossMonthlyRent * propertyManagementFeePercent / 100


mortgagePrincipalAndInterestMonthly : Float -> Float -> Float -> Float
mortgagePrincipalAndInterestMonthly interestRate mortgageTermInYears mortgageAmount =
    let
        monthlyInterestDecimal =
            interestRate / 100 / 12

        mortgageTermInMonths =
            mortgageTermInYears * 12
    in
        mortgageAmount * monthlyInterestDecimal / (1 - (1 + monthlyInterestDecimal) ^ -mortgageTermInMonths)


totalMonthlyExpenses : Float -> Float -> Float -> Float -> Float
totalMonthlyExpenses mortgagePrincipalAndInterestMonthly taxesAndInsuranceMonthlyAmount operatingExpensesMonthly propertyManagementExpensesMonthly =
    List.sum
        [ mortgagePrincipalAndInterestMonthly
        , taxesAndInsuranceMonthlyAmount
        , operatingExpensesMonthly
        , propertyManagementExpensesMonthly
        ]


netMonthlyCashflow : Float -> Float -> Float
netMonthlyCashflow grossMonthlyRent totalMonthlyExpenses =
    grossMonthlyRent - totalMonthlyExpenses


netAnnualCashflow : Float -> Float
netAnnualCashflow netMonthlyCashflow =
    netMonthlyCashflow * 12


firstYearAppreciationAmount : Float -> Float -> Float
firstYearAppreciationAmount purchasePrice assumedAnnualValueAppreciationRate =
    purchasePrice * assumedAnnualValueAppreciationRate / 100


firstYearPrincipalPaydownAmount : Float -> Float -> Float -> Float
firstYearPrincipalPaydownAmount mortgageAmount interestRate mortgagePrincipalAndInterestMonthly =
    let
        monthlyInterestDecimal =
            interestRate / 100 / 12

        numberOfTerms =
            13

        remainingLoanBalance =
            mortgageAmount * (1 + monthlyInterestDecimal) ^ numberOfTerms - mortgagePrincipalAndInterestMonthly * ((1 + monthlyInterestDecimal) ^ numberOfTerms - 1) / monthlyInterestDecimal
    in
        mortgageAmount - remainingLoanBalance


totalAnnualGain : Float -> Float -> Float -> Float
totalAnnualGain netAnnualCashflow firstYearAppreciationAmount firstYearPrincipalPaydownAmount =
    List.sum
        [ netAnnualCashflow
        , firstYearAppreciationAmount
        , firstYearPrincipalPaydownAmount
        ]


annualPercentageYield : Float -> Float -> Float
annualPercentageYield gainAmount initialInvestment =
    gainAmount / initialInvestment * 100
