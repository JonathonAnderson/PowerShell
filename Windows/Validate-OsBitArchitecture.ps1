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

function Validate-OsBitArchitecture
{
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('32','64')]
        [string]$Is
    )

    BEGIN 
    {
        $OSBitArchitecture = $(Get-CimInstance -ClassName Win32_OperatingSystem -Property OSArchitecture).OSArchitecture
        
        # Legacy Support
        #$OSBitArchitecture = $(Get-WmiObject -Class Win32_OperatingSystem -Property OSArchitecture).OSArchitecture
    }

    PROCESS 
    {
        switch -Regex ($OSBitArchitecture)
        {
            "([^\d])*(32)([^\d])*" { return $($Is -eq '32') }
            "([^\d])*(64)([^\d])*" { return $($Is -eq '64') }
        }
    }
    
    END {}
}
