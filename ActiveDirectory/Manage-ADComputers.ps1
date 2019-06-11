<#
    .AUTHOR
        Jonathon Anderson
    .COPYRIGHT 
        Jonathon Anderson

    .SYNOPSIS
    .PARAMETER
    .EXAMPLE
    .TODO
#>

function Manage-ADComputers
{
    [CmdletBinding()]
    Param 
    (
        [timespan]$StaleTimeSpan,
        [timespan]$ExpiredTimeSpan,
        [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]$StaleOU
    )

    BEGIN 
    {
        $StaleComputers   = Search-ADAccount -ComputersOnly -AccountInactive -TimeSpan $StaleTimeSpan
        $ExpiredComputers = Search-ADAccount -ComputersOnly -AccountInactive -TimeSpan $ExpiredTimeSpan

        $DisabledComputers = Search-ADAccount -ComputersOnly -AccountDisabled

    }

    PROCESS 
    {
        foreach ($Computer in $StaleComputers)
        {
            Disable-ADAccount -Identity $Computer
            Move-ADObject -Identity $Computer -TargetPath $StaleOU
        }
        foreach ($Computer in $DisabledComputers)
        {
            if($Computer.Name -in $ExpiredComputers.Name)
            {
                Remove-ADComputer -Identity $Computer -Confirm:$false
            }
        }
    }

    END {}
}

