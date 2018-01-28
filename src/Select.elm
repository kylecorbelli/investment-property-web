module Select exposing (..)

import Models exposing (Model)
import Calculate


downPayment : Model -> Float
downPayment { purchasePrice, downPaymentPercent } =
    Calculate.downPayment purchasePrice downPaymentPercent


mortgageAmount : Model -> Float
mortgageAmount model =
    let
        selectedDownPayment =
            downPayment model
    in
        Calculate.mortgageAmount model.purchasePrice selectedDownPayment


propertyTaxAnnualAmount : Model -> Float
propertyTaxAnnualAmount { purchasePrice, propertyTaxRate } =
    Calculate.propertyTaxAnnualAmount purchasePrice propertyTaxRate


taxesAndInsuranceMonthlyAmount : Model -> Float
taxesAndInsuranceMonthlyAmount model =
    let
        selectedPropertyTaxAnnualAmount =
            propertyTaxAnnualAmount model
    in
        Calculate.taxesAndInsuranceMonthlyAmount model.homeInsuranceAnnualAmount selectedPropertyTaxAnnualAmount


mortgagePrincipalAndInterestMonthly : Model -> Float
mortgagePrincipalAndInterestMonthly model =
    let
        selectedMortgageAmount =
            mortgageAmount model

        term =
            model.mortgageTermInYears |> toFloat
    in
        Calculate.mortgagePrincipalAndInterestMonthly model.interestRate term selectedMortgageAmount


operatingExpensesMonthly : Model -> Float
operatingExpensesMonthly { grossMonthlyRent, operatingExpensePercent } =
    Calculate.operatingExpensesMonthly grossMonthlyRent operatingExpensePercent


propertyManagementExpensesMonthly : Model -> Float
propertyManagementExpensesMonthly { grossMonthlyRent, propertyManagementFeePercent } =
    Calculate.propertyManagementExpensesMonthly grossMonthlyRent propertyManagementFeePercent


totalMonthlyExpenses : Model -> Float
totalMonthlyExpenses model =
    let
        selectedMortgagePrincipalAndInterestMonthly =
            mortgagePrincipalAndInterestMonthly model

        selectedTaxesAndInsuranceMonthlyAmount =
            taxesAndInsuranceMonthlyAmount model

        selectedOperatingExpensesMonthly =
            operatingExpensesMonthly model

        selectedPropertyManagementExpensesMonthly =
            propertyManagementExpensesMonthly model
    in
        Calculate.totalMonthlyExpenses selectedMortgagePrincipalAndInterestMonthly selectedTaxesAndInsuranceMonthlyAmount selectedOperatingExpensesMonthly selectedPropertyManagementExpensesMonthly


netMonthlyCashflow : Model -> Float
netMonthlyCashflow model =
    let
        selectedTotalMonthlyExpenses =
            totalMonthlyExpenses model
    in
        Calculate.netMonthlyCashflow model.grossMonthlyRent selectedTotalMonthlyExpenses


netAnnualCashflow : Model -> Float
netAnnualCashflow model =
    let
        selectedNetMonthlyCashflow =
            netMonthlyCashflow model
    in
        selectedNetMonthlyCashflow * 12


firstYearAppreciationAmount : Model -> Float
firstYearAppreciationAmount { purchasePrice, assumedAnnualValueAppreciationRate } =
    Calculate.firstYearAppreciationAmount purchasePrice assumedAnnualValueAppreciationRate


firstYearPrincipalPaydownAmount : Model -> Float
firstYearPrincipalPaydownAmount model =
    let
        selectedMortgageAmount =
            mortgageAmount model

        selectedMortgagePrincipalAndInterestMonthly =
            mortgagePrincipalAndInterestMonthly model
    in
        Calculate.firstYearPrincipalPaydownAmount selectedMortgageAmount model.interestRate selectedMortgagePrincipalAndInterestMonthly


totalAnnualGain : Model -> Float
totalAnnualGain model =
    let
        selectedNetAnnualCashflow =
            netAnnualCashflow model

        selectedFirstYearAppreciationAmount =
            firstYearAppreciationAmount model

        selectedFirstYearPrincipalPaydownAmount =
            firstYearPrincipalPaydownAmount model
    in
        Calculate.totalAnnualGain selectedNetAnnualCashflow selectedFirstYearAppreciationAmount selectedFirstYearPrincipalPaydownAmount



-- These could likely stand to be abstracted:


cashOnCashYield : Model -> Float
cashOnCashYield model =
    let
        selectedNetAnnualCashflow =
            netAnnualCashflow model

        selectedDownPayment =
            downPayment model
    in
        Calculate.annualPercentageYield selectedNetAnnualCashflow selectedDownPayment


firstYearAppreciationYield : Model -> Float
firstYearAppreciationYield model =
    let
        selectedFirstYearAppreciationAmount =
            firstYearAppreciationAmount model

        selectedDownPayment =
            downPayment model
    in
        Calculate.annualPercentageYield selectedFirstYearAppreciationAmount selectedDownPayment


firstYearPrincipalPaydownYield : Model -> Float
firstYearPrincipalPaydownYield model =
    let
        selectedFirstYearPrincipalPaydownAmount =
            firstYearPrincipalPaydownAmount model

        selectedDownPayment =
            downPayment model
    in
        Calculate.annualPercentageYield selectedFirstYearPrincipalPaydownAmount selectedDownPayment
