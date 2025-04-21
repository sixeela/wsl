$ProgressPreference = 'SilentlyContinue'

$Date = Get-Date -Format "yyyyMMdd"
$Version = "42"
$WslName = "Fedora-" + $Version
$BaseFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path + "\" + $WslName
$BaseUrl = "https://github.com/fedora-cloud/docker-brew-fedora/tree/$Version/x86_64"
# Retrieve raw link to fedora-*.tar file
$Filename = (Invoke-WebRequest -Uri $BaseUrl).Links | Where-Object { $_.href -match "fedora-.*.tar" } | Select-Object -First 1 -ExpandProperty href
$Filename = $Filename.split("/")[-1]
$DownloadURI = "https://github.com/fedora-cloud/docker-brew-fedora/raw/refs/heads/$Version/x86_64/$Filename"
$DownloadDest = "$BaseFolder\$(Split-Path -Path $DownloadURI -Leaf)"
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

New-Item -Path $BaseFolder -ItemType Directory
Invoke-WebRequest -URI $DownloadURI -OutFile $DownloadDest
New-Item -Path ("$HOME/wsl/" + $WslName) -ItemType Directory
wsl --import $WslName ("$HOME/wsl/" + $WslName) $($BaseFolder + "\$Filename") --version 2
Remove-Item $BaseFolder -Recurse
