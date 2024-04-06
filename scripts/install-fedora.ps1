$ProgressPreference = 'SilentlyContinue'

$Date = Get-Date -Format "yyyyMMdd"
$Version = "39"
$WslName = "Fedora-" + $Version
$BaseFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path + "\" + $WslName
$DownloadURI = "https://kojipkgs.fedoraproject.org/packages/Fedora-Container-Base/" + $Version + "/" + $Date + ".0/images/Fedora-Container-Base-" + $Version + "-" + $Date + ".0.x86_64.tar.xz"
$DownloadDest = $BaseFolder + "\Fedora-Container-Base-" + $Version + "-" + $Date + ".0.x86_64.tar.xz"
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip file '$7zipPath' not found"
}
Set-Alias Start-SevenZip $7zipPath

New-Item -Path $BaseFolder -ItemType Directory
Invoke-WebRequest -URI $DownloadURI -OutFile $DownloadDest
Start-SevenZip e $DownloadDest -o"$BaseFolder"
Start-SevenZip e $DownloadDest.Replace('.xz', '') -o"$BaseFolder"

New-Item -Path ("$HOME/wsl/" + $WslName) -ItemType Directory
wsl --import $WslName ("$HOME/wsl/" + $WslName) $($BaseFolder + "\layer.tar")

Remove-Item $BaseFolder -Recurse
