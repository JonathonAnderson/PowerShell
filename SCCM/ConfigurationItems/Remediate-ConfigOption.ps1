$ConfigString = ""
$ConfigFile = ""
### End Variables ###

$Pref = $ErrorActionPreference
$ErrorActionPreference = "Stop"

try
{
    $File = Get-Item -Path $ConfigFile
}
catch
{
    $File = New-Item -ItemType File -Path $ConfigFile -Force
}

$ErrorActionPreference = $Pref
Add-Content -Path $File.FullName -Value $ConfigString
