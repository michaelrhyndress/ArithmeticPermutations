function Find-ArithmeticPermutations {
<#
    .SYNOPSIS
    Determine which digits can be added together to result in the same digits.

    .DESCRIPTION
    Loop through all numbers in range and test to determine if the digit pairs
    create arithmetic permutations so that two whole numbers and their
    combined value make use of the same digits.

    .EXAMPLE
    Find-ArithmeticPermutations
#>
    Param (
        [Parameter(Mandatory=$false)]
        [int] $DigitalCount = 3
    )

    $Script:DigitCount = $DigitalCount #determines max range of numbers, 3 will be 0-999

    foreach ($num in 0..(Format-TrailingZeros -Base 1 -Zeros $Script:DigitCount)) {
        $BaseInt = [int]$num
        $BaseString = $num | ConvertTo-String

        #region Get Permutations and determine if they are arithmetic permutations
        $BaseString | Get-StringPermutations | %{
            $PermString = $_ | ConvertTo-String
            $Sum = ConvertTo-String -InputObject ($BaseInt + ([int]$_))
            $Compare = (Compare-Object -ReferenceObject ($BaseString -split '') -DifferenceObject ($Sum -split ''))
            if (($Compare | Measure).count -eq 0) {
                Write-Output ("{0} + {1} = {2}" -f $BaseString, ($_ | ConvertTo-String), $Sum)
            }
        }
        #endregion Get Permutations and determine if they are arithmetic permutations
    }
}


function Get-StringPermutations {
<#
    .SYNOPSIS
    Get all permutations for a given string

    .DESCRIPTION
    Get all permutations for a given string

    .EXAMPLE
    Get-StringPermutations -InputObject 'abc'
#>
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $InputObject
    )

    function generate ($Length, $InputObject, $Order) {
        if ($Length -eq 1) {
            Write-Output ($InputObject[$Order] -join '')
        }
        else {
            #region swap
            for( $i = 0; $i -lt ($Length - 1); $i += 1) {
                Write-Output (generate ($Length - 1) $InputObject $Order)
                if($Length % 2 -eq 0){
                    $i1, $i2 = $i, ($Length-1)
                    $Order[$i1], $Order[$i2] = $Order[$i2], $Order[$i1]
                }
                else{
                    $i1, $i2 = 0, ($Length-1)
                    $Order[$i1], $Order[$i2] = $Order[$i2], $Order[$i1]
                }
            }
            #endregion swap
            Write-Output (generate ($Length - 1) $InputObject $Order)
        }
    }

    $Length = $InputObject.length

    if ($length -gt 0) {
        Write-Output (generate $Length $InputObject (0..($Length-1)))
    } else {
        Write-Output $InputObject
    }
}


function Format-TrailingZeros {
<#
    .SYNOPSIS
    Add trailing 0's to a base number

    .DESCRIPTION
    Add trailing 0's to a base number

    .EXAMPLE
    Format-TrailingZeros -Base 2 -Zeros 2  #results in 200
#>

    Param (
        [Parameter(Mandatory=$false)]
        [int] $Base = 1,
        [Parameter(Mandatory=$true)]
        [int] $Zeros
    )

    return [int]("{0}{1}" -f $Base, ("0"*$Zeros)) #Format with trailing 0's
}


function ConvertTo-String {
<#
    .SYNOPSIS
    Converts an integer into a string while appending 0's

    .DESCRIPTION
    Converts an integer into a string while appending 0's to fit DigitalCount variable

    .EXAMPLE
    ConvertTo-String -InputObject 2 #Result: '002'
#>

    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [int] $InputObject
    )

    return ("{0:D$($Script:DigitCount)}" -f $InputObject) #Format with leading 0's
}

Find-ArithmeticPermutations
