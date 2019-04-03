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

function Get-AadAuthToken
{
    [CmdletBinding(DefaultParameterSetName="AppName")]
    Param 
    (
        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceName")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceUri")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceName")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceUri")]
        [ValidateNotNullOrEmpty()]
        [string]$TenantID,

        [Parameter(ParameterSetName = "AppNameResourceName")]
        [Parameter(ParameterSetName = "AppNameResourceUri")]
        [Parameter(ParameterSetName = "AppIDResourceName")]
        [Parameter(ParameterSetName = "AppIDResourceUri")]
        [string]$RedirectUri = "urn:ietf:wg:oauth:2.0:oob:auto",

        [Parameter(ParameterSetName = "AppNameResourceName")]
        [Parameter(ParameterSetName = "AppNameResourceUri")]
        [Parameter(ParameterSetName = "AppIDResourceName")]
        [Parameter(ParameterSetName = "AppIDResourceUri")]
        [string]$Authority = "https://login.microsoftonline.com/$TenantID",

        [Parameter(ParameterSetName = "AppNameResourceName")]
        [Parameter(ParameterSetName = "AppNameResourceUri")]
        [Parameter(ParameterSetName = "AppIDResourceName")]
        [Parameter(ParameterSetName = "AppIDResourceUri")]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceName")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceUri")]
        [ValidateSet('PowerShell')]
        [string]$ClientApp,

        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceName")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceUri")]
        [ValidateNotNullOrEmpty()]
        [string]$ClientAppId,

        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceName")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceName")]
        [ValidateSet('MsGraph')]
        [string]$RequestedResource,

        [Parameter(Mandatory = $true, ParameterSetName = "AppNameResourceUri")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppIDResourceUri")]
        [string]$ResourceUri = "https://graph.microsoft.com"
    )

    BEGIN 
    {
        Import-Module Azure

        switch($ClientApp)
        {
            "PowerShell" { $ClientAppId = "1950a258-227b-4e31-a9cf-717495945fc2" }
        }

        switch($RequestedResource)
        {
            "MsGraph" { $ResourceUri = "https://graph.microsoft.com" }
        }

        if($Credential -eq $null)
        {
            $Credential = Get-Credential -Message "Enter your AAD credentials."
        }

        $AuthContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $Authority
        $AadCredential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential -ArgumentList $Credential.Username,$Credential.Password
    }

    PROCESS 
    {
        $AuthResult = $AuthContext.AcquireToken($ResourceUri, $ClientAppId, $AadCredential)
    }

    END 
    {
        return $AuthResult        
    }
}
