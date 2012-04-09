Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline

    Write-VcsStatus

    $LASTEXITCODE = $realLASTEXITCODE
    Write-Host ""
    return "> "
}

Enable-GitColors

Pop-Location

#Start-SshAgent -Quiet
