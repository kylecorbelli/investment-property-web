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


vacancyAllowanceMonthly : Model -> Float
vacancyAllowanceMonthly { grossMonthlyRent, vacancyRate } =
    Calculate.vacancyAllowanceMonthly grossMonthlyRent vacancyRate


netMonthlyRent : Model -> Float
netMonthlyRent { grossMonthlyRent, vacancyRate } =
    Calculate.netMonthlyRent grossMonthlyRent vacancyRate


capitalExpendituresExpenseMonthly : Model -> Float
capitalExpendituresExpenseMonthly { grossMonthlyRent, capitalExpendituresExpensePercent } =
    Calculate.capitalExpendituresExpenseMonthly grossMonthlyRent capitalExpendituresExpensePercent


repairsAndMaintenanceExpenseMonthly : Model -> Float
repairsAndMaintenanceExpenseMonthly { grossMonthlyRent, repairsAndMaintenanceExpensePercent } =
    Calculate.repairsAndMaintenanceExpenseMonthly grossMonthlyRent repairsAndMaintenanceExpensePercent


operatingExpensesMonthly : Model -> Float
operatingExpensesMonthly { grossMonthlyRent, operatingExpensePercent } =
    Calculate.operatingExpensesMonthly grossMonthlyRent operatingExpensePercent


propertyManagementExpensesMonthly : Model -> Float
propertyManagementExpensesMonthly { grossMonthlyRent, propertyManagementFeePercent } =
    Calculate.propertyManagementExpensesMonthly grossMonthlyRent propertyManagementFeePercent


totalMonthlyExpenses : Model -> Float
totalMonthlyExpenses model =
    let
        selectedTaxesAndInsuranceMonthlyAmount =
            taxesAndInsuranceMonthlyAmount model

        selectedCapitalExpendituresExpenseMonthly =
            capitalExpendituresExpenseMonthly model

        selectedRepairsAndMaintenanceExpenseMonthly =
            repairsAndMaintenanceExpenseMonthly model

        selectedPropertyManagementExpensesMonthly =
            propertyManagementExpensesMonthly model
    in
        Calculate.totalMonthlyExpenses
            selectedTaxesAndInsuranceMonthlyAmount
            selectedCapitalExpendituresExpenseMonthly
            selectedRepairsAndMaintenanceExpenseMonthly
            selectedPropertyManagementExpensesMonthly


netMonthlyOperatingIncome : Model -> Float
netMonthlyOperatingIncome model =
    let
        selectedNetMonthlyRent =
            netMonthlyRent model

        selectedTotalMonthlyExpenses =
            totalMonthlyExpenses model
    in
        Calculate.netMonthlyOperatingIncome selectedNetMonthlyRent selectedTotalMonthlyExpenses


netMonthlyCashflow : Model -> Float
netMonthlyCashflow model =
    let
        selectedNetMonthlyOperatingIncome =
            netMonthlyOperatingIncome model

        selectedMortgagePrincipalAndInterestMonthly =
            mortgagePrincipalAndInterestMonthly model
    in
        Calculate.netMonthlyCashflow selectedNetMonthlyOperatingIncome selectedMortgagePrincipalAndInterestMonthly


netAnnualCashflow : Model -> Float
netAnnualCashflow model =
    let
        selectedNetMonthlyCashflow =
            netMonthlyCashflow model
    in
        selectedNetMonthlyCashflow * 12


grossRentMultiplier : Model -> Float
grossRentMultiplier { grossMonthlyRent, purchasePrice } =
    let
        grossAnnualRent =
            grossMonthlyRent * 12
    in
        Calculate.grossRentMultiplier purchasePrice grossAnnualRent


capitalizationRate : Model -> Float
capitalizationRate model =
    let
        netOperatingIncomeAnnual =
            12 * netMonthlyOperatingIncome model
    in
        Calculate.capitalizationRate netOperatingIncomeAnnual model.purchasePrice


debtCoverageRatio : Model -> Float
debtCoverageRatio model =
    let
        netOperatingIncome =
            netMonthlyOperatingIncome model

        debtService =
            mortgagePrincipalAndInterestMonthly model
    in
        Calculate.debtCoverageRatio netOperatingIncome debtService


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


totalAnnualYield : Model -> Float
totalAnnualYield model =
    let
        selectedTotalAnnualGain =
            totalAnnualGain model

        selectedDownPayment =
            downPayment model
    in
        Calculate.annualPercentageYield selectedTotalAnnualGain selectedDownPayment
