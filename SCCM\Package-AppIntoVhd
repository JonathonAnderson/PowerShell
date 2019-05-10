<#
    .AUTHOR
        Jonathon Anderson
    .COPYRIGHT 
        Jonathon Anderson
    .SYNOPSIS
        Packaging applications into VHD helps SCCM manage content. This script is tailored for applications deployed with
        the "PowerShell Application Deployment Toolkit" and depends on the default folder structure of the toolkit.
    .PARAMETER
    .EXAMPLE
        Package-AppIntoVhd -PsadtRoot "\\sccm-server.in.your.domain\Sources\Applications\ApplicationToPackage"
    .TODO
        -- Beta Test
#>

function Package-AppIntoVhd
{
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.DirectoryInfo[]]$PsadtRoot
    )

    BEGIN 
    {
        $CreateVhdScriptName = "CreateVhd.dps"
        $DismountVhdScriptName = "DismountVhd.dps"

        $DiskPartExe = "$env:windir\system32\diskpart.exe"

        $WorkingDir = "$env:USERPROFILE\AppPacking"
        $VhdFile = "$WorkingDir\payload.vhd"
        $VhdMnt = "$WorkingDir\mnt"

        $Date = Get-Date -Format "ddMMMyyyy"
    }

    PROCESS 
    {
    foreach($Root in $PsadtRoot)
    {
        # Find payload size
        if(!(Test-Path -Path $Root)) { Write-Host -BackgroundColor Black -ForegroundColor Red "The specified path does not exist: $Root" }

        if(Test-Path -Path "$Root\Files")
        {
            $FileDirectoryBytes = (Get-ChildItem -Path "$Root\Files" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum
        }
        
        if(Test-Path -Path "$Root\SupportFiles")
        {
            $SupportFileDirectoryBytes = (Get-ChildItem -Path "$Root\SupportFiles" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum
        }

        $PayloadBytes = $FileDirectoryBytes + $SupportFileDirectoryBytes      
        
        # Create the VHD and mount it for writing
        $VhdBytes = [int](($PayloadBytes + ($PayloadBytes * 0.10)) / 1MB)

        $CreateVhdScript =
@"
create vdisk file=$VhdFile maximum=$VhdBytes type=fixed
select vdisk file=$VhdFile
attach vdisk
detail vdisk
convert mbr
create partition primary
format fs=ntfs label="PSADT" quick
assign mount=$VhdMnt
"@
        New-Item -ItemType Directory -Path $WorkingDir -Force
        New-Item -ItemType Directory -Path $VhdMnt -Force

        New-Item -ItemType File -Path $WorkingDir -Name $CreateVhdScriptName -Value $CreateVhdScript -Force
        Start-Process -FilePath "cmd" -ArgumentList "/C DISKPART /S $WorkingDir\$CreateVhdScriptName > $WorkingDir\createVhd.log" -Wait
        
        # Copy payload into VHD
        New-Item -ItemType Directory -Path $VhdMnt -Name "Files" -Force
        New-Item -ItemType Directory -Path $VhdMnt -Name "SupportFiles" -Force

        Copy-Item -Path "$Root\Files" -Destination "$VhdMnt\" -Recurse -Force
        Copy-Item -Path "$Root\SupportFiles" -Destination "$VhdMnt\" -Recurse -Force
        
        # Everything is migrated, dismount and cleanup
        $DismountVhdScript = 
@"
select vdisk file=$VhdFile
detach vdisk
"@
        New-Item -ItemType File -Path $WorkingDir -Name $DismountVhdScriptName -Value $DismountVhdScript -Force
        Start-Process -FilePath "cmd" -ArgumentList "/C DISKPART /S $WorkingDir\$DismountVhdScriptName > $WorkingDir\dismountVhd.log" -Wait
        Get-Item -Path $VhdMnt | Remove-Item -Force
        
        New-Item -ItemType Directory -Path $Root -Name "vhd" -Force
        Get-ChildItem $WorkingDir\* -Include *.vhd | Move-Item -Destination "$Root\vhd"

        New-Item -ItemType Directory -Path "$Root\vhd" -Name $Date -Force
        Get-ChildItem $WorkingDir\* -Include *.log,*.dps | Move-Item -Destination "$Root\vhd\$Date" -Force
        
        Get-Item -Path $WorkingDir | Remove-Item -Recurse -Force
    }
    }

    END 
    {
        
    }
}
