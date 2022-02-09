<#
This script builds libiconv,libxml2 and libxslt
#>
Param(
    [switch]$x64,
    [switch]$arm64,
    [switch]$vs2008
)

$ErrorActionPreference = "Stop"
Import-Module Pscx

$platDir = If($x64) { "\x64" } ElseIf ($arm64) { "\arm64" } Else { "" }
$distname = If($x64) { "win64" } ElseIf($arm64) { "win-arm64" } Else { "win32" }
If($vs2008) { $distname = "vs2008.$distname" }

If($vs2008) {
    $vcvarsarch = If($x64) { "amd64" } Else { "x86" }
    Import-VisualStudioVars -VisualStudioVersion "90" -Architecture $vcvarsarch
} Else {
    $vcvarsarch = If($x64) { "x86_amd64" } ElseIf ($arm64) { "x86_arm64" } Else { "32" }
    cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars$vcvarsarch.bat`" && set > %temp%\vcvars$vcvarsarch.txt"
    Get-Content "$env:temp\vcvars$vcvarsarch.txt" | Foreach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            Set-Content "env:\$($matches[1])" $matches[2]
        }
    }
}

Set-Location $PSScriptRoot

Set-Location .\win

cl

Start-Process -NoNewWindow -Wait nmake "-f makefile.vc all"
