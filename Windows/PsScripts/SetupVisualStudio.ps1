function Get-Batchfile ($file) {
        $cmd = "`"$file`" & set"
        cmd /c $cmd | Foreach-Object {
                $p, $v = $_.split('=')
                Set-Item -path env:$p -value $v
        }
}

function SetVS_Pre2017($version = "12.0")
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

function SetVS_Post2017($version = "12.0")
{
  $key = get-ItemProperty "HKLM:SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7"
  $rootPath = [System.IO.Path]::GetDirectoryName($($key.$version))
  Echo "Skipping VisualStudio $version setup... rootpath would be $rootPath"
}

#SetVS_Pre2017("11.0")
#SetVS_Pre2017("14.0")
SetVS_Post2017("15.0")
