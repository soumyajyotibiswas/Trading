<#
.SYNOPSIS
This script calculates compound interest on a starting amount of investment agains an input of interest rate. Also allows you to specify what percent of it will you keep as profit.
You have to specify the number of trades. The output is to the console as csv.
.Description
Compound interest (or compounding interest) is the interest on a loan or deposit calculated based on both the initial principal and the accumulated interest from previous periods. Thought to have originated in 17th-century Italy, compound interest can be thought of as "interest on interest," and will make a sum grow at a faster rate than simple interest, which is calculated only on the principal amount.
The rate at which compound interest accrues depends on the frequency of compounding, such that the higher the number of compounding periods, the greater the compound interest. Thus, the amount of compound interest accrued on $100 compounded at 10% annually will be lower than that on $100 compounded at 5% semi-annually over the same time period. Since the interest-on-interest effect can generate increasingly positive returns based on the initial principal amount, it has sometimes been referred to as the "miracle of compound interest." 
https://www.investopedia.com/terms/c/compoundinterest.asp
.PARAMETER Principal
Enter the starting investment amount as an integer.
Default: 200
Type: Integer
.PARAMETER TradeMultiplier
Enter the percent rate to compound with as divided by 100. So if you want to compound for 50% enter 0.5, if you want to compound for 130% enter 1.3.
Default: 0.5
Type: Integer
.PARAMETER ProfitKeep
For the investment in the next trade, define how much percent of profit you want to keep as divided by 100. So if you want to keep 50% profit enter 0.5. This has to be less than 1.
Default: 0.5
Type: Integer
.PARAMETER Trades
Enter the number of trades you want to calculate over.
Default: 2
Type: Integer
.Example
& 'W:\My Documents\Trading\TradeMultiplier.ps1' -Principal 6500 -TradeMultiplier 0.15 -ProfitKeep 0.1 -Trades 45
.Example
& 'W:\My Documents\Trading\TradeMultiplier.ps1' -Principal 300 -TradeMultiplier 0.5 -ProfitKeep 0.1 -Trades 2
#>

Param(
    [Float]$Principal = 200,
    [Float]$TradeMultiplier = 0.5,
    [ValidateRange(0,0.99)]
    [Float]$ProfitKeep = 0.5,
    [INT]$Trades = 2
)

[System.Collections.ArrayList]$MasterObject = @()
$TotalProfitSaved = 0

For($x=1;$x -le $Trades;$x++){
    $TotalReturn = $Principal + ($Principal * $TradeMultiplier)
    $TotalProfit = $TotalReturn - $Principal
    $KeepProfit = $TotalProfit * $ProfitKeep
    $NextInvestment = $TotalReturn - $KeepProfit
    $TotalProfitSaved += $KeepProfit

    $Props = [Ordered]@{
        "TradeCounter" = $x
        "StartInvestmentofTrade" = "{0:C2}" -f [Math]::Round($Principal,2)
        "TotalReturnFromTrade" = "{0:C2}" -f [Math]::Round($TotalReturn,2)
        "TotalProfitFromTrade" = "{0:C2}" -f [Math]::Round($TotalProfit,2)
        "TotalProfitMovedToSavedBalanceFromTrade" = "{0:C2}" -f [Math]::Round($KeepProfit,2)
        "StartInvestmentofNextTrade" = "{0:C2}" -f [Math]::Round($NextInvestment,2)
        "TotalProfitSavedFromAllTrades" = "{0:C2}" -f [Math]::Round($TotalProfitSaved,2)
        "TotalBalance" = "{0:C2}" -f [Math]::Round(($NextInvestment + $TotalProfitSaved),2)
    }
    $Obj = New-Object -TypeName PsCustomObject -Property $Props
    $MasterObject += $Obj
    $Principal = $NextInvestment
}

$MasterObject | ConvertTo-Csv -NoTypeInformation
