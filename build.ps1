$ErrorActionPreference = "Stop"
Import-Module Pscx

$vcvarsarch = "x86_arm64"

cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars$vcvarsarch.bat`" && set > %temp%\vcvars$vcvarsarch.txt"
Get-Content "$env:temp\vcvars$vcvarsarch.txt" | Foreach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Content "env:\$($matches[1])" $matches[2]
    }
}

cd win

Start-Process -NoNewWindow -Wait nmake "-f makefile.vc OPTS=static MACHINE=ARM64 all"
