### PowerShell
```
iex (iwr https://raw.githubusercontent.com/Faelayis/mc-mod-packs/script/install.ps1).Content
```
Method 2
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Faelayis/mc-mod-packs/script/install.ps1'))
```
