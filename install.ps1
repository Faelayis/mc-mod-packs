$Esc = [char]27
$OrangeForeColor = "$Esc[{0};2;{1};{2};{3}m" -f '38', 255, 165, 0
Write-Host "$($OrangeForeColor)MC Mods Install Script By Faelayis"
Write-Host "$($OrangeForeColor)Version 1.1.0"
function Install-Java {
    Write-Output "" 
    Import-Module BitsTransfer -Force
    Start-BitsTransfer -Source "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=246808_424b9da4b48848379167015dcc250d8d" -Destination "jre-8u341-windows-x64.exe"
    Write-Host "Install Java 8 for 64 bit Please Wait.." -ForegroundColor Yellow
    Start-Process -FilePath "jre-8u341-windows-x64.exe" -ArgumentList "INSTALL_SILENT=Enable" -Wait
}
function CheckJava {
    if ($JavaVersion = (Get-Command java | Select-Object -ExpandProperty Version)) {
        Write-Host "Current Java Version $($JavaVersion)" -ForegroundColor Green
        Get-Command java | Select-Object -ExpandProperty Version
        Write-Host ""
        if (($JavaVersion | Select-Object Major | Out-String) -notmatch 8) {
            Write-Host "Recommend Java Version 8" -ForegroundColor Yellow
            $confirmation_install_java = Read-Host "Do you want install java 8 64 bit (y/n)"
            if ($confirmation_install_java -eq 'y') {
                Install-Java
            }
        }
    }
    else {
        Write-Host "Not Found Java Version 8" -ForegroundColor Red
        Install-Java
    }
}

CheckJava -wait

Set-Location "$($env:APPDATA)"

if (Test-Path -Path '.minecraft') {
    Write-Host "Found .minecraft folder" -ForegroundColor Green
    Set-Location '.minecraft'
}
else {
    Write-Host "Not Found .minecraft folder" -ForegroundColor Red
    pause
}
function Install-Fabric {
    New-Item -ItemType Directory -Force -Path 'Temp\Faelayis' | Out-Null
    Write-Host "Install Fabric 0.11.1" -ForegroundColor Yellow
    Set-Location 'Temp\Faelayis'
    Start-BitsTransfer -Source "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.11.1/fabric-installer-0.11.1.jar" -Destination "fabric-installer-0.11.1.jar"
    java -jar fabric-installer-0.11.1.jar client -mcversion 1.18.2 -downloadMinecraft
    Write-Host "Install Fabric API For 1.18.2" -ForegroundColor Yellow
    if (Test-Path -Path "$($env:APPDATA)\.minecraft\mods") {
        Write-Host "Found Mods folder" -ForegroundColor Green
        $confirmation_delete_mods_folder = Read-Host "Do you want delete mods folder (y/n)"
        if ($confirmation_delete_mods_folder -eq 'y') {
            Remove-Item "$($env:APPDATA)\.minecraft\config" -Force -Recurse | Out-Null
            Remove-Item "$($env:APPDATA)\.minecraft\kubejs" -Force -Recurse | Out-Null
            Remove-Item "$($env:APPDATA)\.minecraft\paintings" -Force -Recurse | Out-Null
            Remove-Item "$($env:APPDATA)\.minecraft\mods" -Force -Recurse | Out-Null
        }
    }
    New-Item -ItemType Directory -Force -Path "$($env:APPDATA)\.minecraft\mods" | Out-Null
    # Start-BitsTransfer -Source "https://mediafiles.forgecdn.net/files/4006/117/fabric-api-0.62.0%2B1.19.2.jar" -Destination "$($env:APPDATA)\.minecraft\mods\fabric-api-0.62.0+1.19.2.jar"
    Write-Host "Download Mods.." -ForegroundColor Yellow
    Start-BitsTransfer -Source "https://github.com/Faelayis/mc-mod-packs/releases/download/Part-1/Valhelsia.Enhanced.Vanilla.zip" -Destination "mods.zip"
    Write-Host "Unzip Mods" -ForegroundColor Yellow
    Expand-Archive -Path '.\mods.zip' -DestinationPath "$($env:APPDATA)\.minecraft" -Force
    Write-Host "Done." -ForegroundColor Green
}
Install-Fabric
pause