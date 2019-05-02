<#
    .AUTHOR
        Jonathon Anderson
    .COPYRIGHT 
        Jonathon Anderson
    .SYNOPSIS
    .PARAMETER
    .EXAMPLE
        Validate-OsBitArchitecture -Is 32
        Validate-OsBitArchitecture -Is 64
        
    .TODO
#>

function Get-NumericBitArchitecture
{
    [CmdletBinding()]
    Param ()

    BEGIN 
    {
        $ErrorActionPreference = "Stop"
        try
        {
            $OSBitArchitecture = $(Get-CimInstance -ClassName Win32_OperatingSystem -Property OSArchitecture).OSArchitecture
        }
        catch
        {
            $OSBitArchitecture = $(Get-WmiObject -Class Win32_OperatingSystem -Property OSArchitecture).OSArchitecture
        }
        $ErrorActionPreference = "Continue"
    }

    PROCESS 
    {
        return [int]$($OSBitArchitecture -replace "[^\d]","")

    }

    END {}
}
