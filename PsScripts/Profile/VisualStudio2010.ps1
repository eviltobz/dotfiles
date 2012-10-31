function Get-Batchfile ($file) {
        $cmd = "`"$file`" & set"
        cmd /c $cmd | Foreach-Object {
                $p, $v = $_.split('=')
                Set-Item -path env:$p -value $v
        }
}

function SetVisualStudioX86($version = "10.0")
{
        $key = "HKLM:SOFTWARE\Wow6432Node\Microsoft\VisualStudio\" + $version
        $VsKey = get-ItemProperty $key
        $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
        $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
        $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
        $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
        Get-Batchfile $BatchFile
        #[System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
        $message = "Visual Studio " + $version + " configured"
        Echo $message
}

SetVisualStudioX86
