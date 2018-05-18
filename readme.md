To install for windows run the following command in a powershell session after changing the value of $path to the desired location:

$path="c:\dotfiles" ; [Net.ServicePointManager]::SecurityProtocol = "tls12"; (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/eviltobz/dotfiles/master/Install/bootstrap.ps1") | Invoke-Expression 


