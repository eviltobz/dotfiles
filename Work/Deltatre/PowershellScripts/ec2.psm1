function OpenTunnel($target, $remotePort, $localPort, $host) {
  Write-Host "SKIP LOGIN" -f RED
#aws sso login --profile AWSAdministratorAccess-309066805775
#echo "logged in"

  $documentName = "AWS-StartPortForwardingSession"
#$parameters = ""
  if($host -eq $null){
    $parameters = "portNumber=$remotePort,localPortNumber=$localPort"
  } else {
    $parameters = "host=""$host"",portNumber=$remotePort,localPortNumber=$localPort"
    $documentName = $documentName + "ToRemoteHost"
  }

  $connectionCommand = "aws ssm start-session --target $target --document-name $documentName --parameters '$parameters' --profile AWSAdministratorAccess-309066805775 --region eu-central-1"

  echo "command:"
  echo $connectionCommand
  echo "------"
  iex $connectionCommand
}

function Login() {
  aws sso login --profile AWSAdministratorAccess-309066805775
  echo "logged in"
}

function ConnectTo($target, $localPort) {
#$ssoCommand = aws sso login --profile AWSAdministratorAccess-309066805775
#iex $ssoCommand
  Write-Host "SKIP LOGIN" -f RED
#aws sso login --profile AWSAdministratorAccess-309066805775



  $rdpCommand = "mstsc /v:localhost:$localPort"
  iex $rdpCommand

  $connectionCommand = "aws ssm start-session --target $target --document-name AWS-StartPortForwardingSession --parameters 'portNumber=3389,localPortNumber=$localPort' --profile AWSAdministratorAccess-309066805775 --region eu-central-1"

echo "command:"
echo $connectionCommand
echo "------"
  iex $connectionCommand
}

function ConnectToDevCore() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV Core" -f Green
  ConnectTo "i-04edbe2d2e8d7b963" "4027"
}

function ConnectToDevEsb() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV ESB" -f Green
  ConnectTo "i-0f50f099864e3dff2" "4026"
}

#function ConnectToDevIsl() {
#  Write-Host "Connecting to " -nonewline ; Write-Host "DEV ISL" -f Green
#  aws ssm start-session --target i-0d5c746a97486f0a3 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\": [ \"dev-isl.d3.dyn.sport\"], \"portNumber\":[\"443\"], \"localPortNumber\":[\"10000\"]}' --region eu-central-1
#}

function ConnectToDevIsl() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV ISL" -f Green
#aws ssm start-session --target i-0711f8efcd052aa17 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\": [ \"dev-isl.d3.dyn.sport\"], \"portNumber\":[\"8002\"], \"localPortNumber\":[\"10000\"]}' --region eu-central-1
  OpenTunnel i-0d5c746a97486f0a3 "443" "9443" "dev-isl.d3.dyn.sport"
}

function ConnectToDevBastion() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV BASTION" -f Green
  OpenTunnel i-0d5c746a97486f0a3 "10000" "10000"
}


function ConnectToDevDB() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV DB" -f Green
  OpenTunnel vpc-08730c609d830cac8 "3389" "4040"
}

function ConnectToDevSearch() {
  Write-Host "Connecting to " -nonewline ; Write-Host "DEV SEARCH" -f Green
  Write-Host "This IP was correct on 09/05/2024. It may not be now. Check here for details about how to get the latest value:  https://github.com/deltatre-vxp/axis-docs/blob/master/docs/platform/how-to-guides/how-to-deploy-a-new-environment.md#stage-7-repopulate-catalog"
  OpenTunnel i-0d5c746a97486f0a3 "6000" "6000" "172.16.25.122"
}

#ISL tunnel
# aws ssm start-session --target i-0d5c746a97486f0a3 --document-name AWS-StartPortForwardingSession --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "host=dev-isl.d3.dyn.sport,portNumber=443,localPortNumber=10000" --profile default --region eu-central-1
 
#Search tunnel
# aws ssm start-session --target i-0d5c746a97486f0a3 --document-name AWS-StartPortForwardingSession --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "host=dev-isl.d3.dyn.sport,portNumber=6000,localPortNumber=6012" --profile default --region eu-central-1
 
#Segmentation tunnel
# aws ssm start-session --target i-0d5c746a97486f0a3 --document-name AWS-StartPortForwardingSession --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "host=dev-isl.d3.dyn.sport,portNumber=6000,localPortNumber=6011" --profile default --region eu-central-1


function ConnectToStagCore() {
  Write-Host "Connecting to " -nonewline ; Write-Host "STAG Core" -f Yellow
  ConnectTo "i-060653155a0311a4a" "4036"
}

function ConnectToStagEsb() {
  Write-Host "Connecting to " -nonewline ; Write-Host "STAG ESB" -f Yellow
  ConnectTo "i-097580a08849ec1a9" "4037"
}

function ConnectToStagBastion() {
  Write-Host "Connecting to " -nonewline ; Write-Host "STAG BASTION" -f Yellow
}

function ConnectToProdCore() {
  Write-Host "Connecting to " -nonewline ; Write-Host "PROD Core" -f Red
  ConnectTo "i-00011dfb1a77674aa" "4046"
}

function ConnectToProdBastion() {
  Write-Host "Connecting to " -nonewline ; Write-Host "PROD BASTION" -f Red
}


function DisplayCommand($command) {
  if($command[0] -eq "") {
    return
  }
  Write-Host "  $($command[0])".PadRight(12) -f Yellow -nonewline; 
  if($command.Length -eq 2) {
    Write-Host "- $($command[1])"
  } else {
    Write-Host "- $($command[2])"
  }
}

function GetCommand($argCommand) {
  if($null -eq $argCommand) {
    return $null
  }

  $expected = $argCommand.ToLower()
  foreach($command in $allCommands) {
#write-host "DEBUG - C:$command, E:$expected, $($command.GetType().Name)"
    if($command -eq $expected) {
      return $command[1]
    }
  }
  Write-Host "Unknown command: " -nonewline ; Write-Host $argCommand -f Yellow
  return $null
}

function DisplayWarningSection($title, $section) {
    Write-Host " $title" -f Red
    DisplayCommands $section
}

function DisplaySection($title, $section) {
    Write-Host " $title" -f Green
    DisplayCommands $section
}

function DisplayCommands($section) {
    if($section[0].GetType() -eq "the type of a string".GetType()) {
      DisplayCommand $section
    } else {
      foreach($command in $section){
        DisplayCommand $command
    }
  }
}

function displayUsage() {
  Write-Host "EC2 instance connector " -ForegroundColor Cyan 
  Write-Host "Usage: " -NoNewline -ForegroundColor Cyan 
  Write-Host " ec2 [instance]"

DisplaySection "General" $general
DisplaySection "Dev" $dev
DisplaySection "Staging" $stag
DisplayWarningSection "Production" $prod
}


function ec2 () {
  $a = GetCommand $args[0]
  $Script:Arg = $args[1] 
  $script:args = $args

  if(!$a) {
    displayUsage
  } else {
    Invoke-Expression $a
  }
}

$general = @(
  @("sso", "Login", "SSO Login"),
  @("", "", "") # Have a blank at the end because powershell arrays are mental
    )

$dev = @(
  @("core", "ConnectToDevCore", "Connect to dev-core"),
  @("esb", "ConnectToDevEsb", "Connect to dev-esb-0"),
  @("db", "ConnectToDevDB", "Connect to dev-db"),
  @("isl", "ConnectToDevIsl", "Connect to dev-isl"),
  @("bast", "ConnectToDevBastion", "Connect to dev-bastion"),
  @("search", "ConnectToDevSearch", "Connect to dev search via bastion")
  )

$stag = @(
  @("stagcore", "ConnectToStagCore", "Connect to stag-core"),
  @("stagesb", "ConnectToStagESB", "Connect to stag-esb"),
  @("stagbast", "ConnectToStagBastion", "Connect to stag-bastion")
#, @("", "", "") # Have a blank at the end because powershell arrays are mental
  )

$prod = @(
  @("prodcore", "ConnectToProdCore", "Connect to prod-core"),
  @("prodesb", "ConnectToProdEsb", "Connect to prod-esb"),
  @("prodbast", "ConnectToProdBastion", "Connect to prod-bastion")
#, @("", "", "") # Have a blank at the end because powershell arrays are mental
  )

# cli arg, help title, tunnel/rdp, local port


$allCommands = $general + $dev + $stag + $prod

Export-ModuleMember -Function ec2
