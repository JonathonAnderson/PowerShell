$ConfigString = 
$ConfigFile = 

### End Variables ###

$Pref = $ErrorActionPreference
$ErrorActionPreference = "Stop"

try
{
	$File = Get-Item -Path $ConfigFile
	$Configured = !([string]::IsNullOrEmpty((Get-Content $File.FullName) -like $ConfigString))
}
catch
{}

$ErrorActionPreference = $Pref

[bool]$Configured
