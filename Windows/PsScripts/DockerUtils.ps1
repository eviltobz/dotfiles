new-alias dckcli 'C:\program files\docker\docker\dockercli.exe' -Force

function global:dck($arg, $arg2, $arg3) {
  #
  # Internal helper functions
  #

#  $commands = @{
#      "ls" = @("docker container ls -a");
#      "stop" = @("stopAll", "Stop all running containers")
#      "up" = @("docker-compose up", "Run docker-compose up. NOTE: will not rebuild if things have changed.");
#      "reup" = @("docker-compose up --build", "Rebuild and run docker compose");
#      "bash" = @("bash", "Start an image in the bash shell")
#  }

  $systemCommands = @(
      @("mode", "displayMode", "Display the current container mode"),
      @("lin", "dcklin", "Switch to Linux containers"),
      @("win", "dckwin", "Switch to Windows containers"),
      @("sh", "shell", "Open a shell to browse the DockerDesktopVM"),
      @("reSource", "reSource", "Re-source the docker utils script."),
      @("edit", "edit", "Edit the docker utils script.")
      )
  $daemonCommands = @(
      @("ls", "docker container ls -a"),
      @("stop", "stopAll", "Stop all running containers"),
      @("bash", "bash", "Start the specified image in the bash shell. Add 'sh' to fallback to /bin/sh"),
      @("ssh", "ssh", "Attach an SSH session to a running container. Add 'sh' to fallback to /bin/sh")
      )
  $composeCommands = @(
      @("up", "docker-compose up", "Run docker-compose up. NOTE: will not rebuild if things have changed."),
      @("upd", "docker-compose up -d", "Run docker-compose up detached."),
      @("reup", "docker-compose build --up", "Rebuild and run docker compose")
      )
  $kubernetesCommands = @(
      @("pod", "attachToPod", "Attach a shell to the specified Kubernetes pod."),
      @("", "", "") # Have a blank at the end because powershell arrays are mental
      )
  $buildCommands = @(
      @("bld", "build", "Build the csproj & dockerfile"),
      @("", "", "") # Have a blank at the end because powershell arrays are mental
      )
  $allCommands = $systemCommands + $daemonCommands + $composeCommands + $kubernetesCommands + $buildCommands

  function getFullPodName($partialName) {
    $running = (kubectl get pods | Select-Object -skip 1 )
    $match = $null
    $partialUpper = $partialName.ToUpper()
    $count = 0
    $names = ""

    $running | Foreach-Object { 
      $id = ($_ -split '\s+')[0]
      if($id.ToUpper().StartsWith($partialUpper)) {
        if($match -eq $null) {
          $match = $id
        }
        $count += 1
        $names += "  $id `n"
      }
    }
    if($count -gt 1) {
      Write-Host "Found $count matching pods: "  
      Write-Host $names -f YELLOW -nonewline
    }
    return $match
  }

  function reSource() {
    &  "$PsScripts\DockerUtils.ps1"
  }

  function edit() {
    gvim "$PsScripts\DockerUtils.ps1"
  }

  function build() {
    $csproj = Get-ChildItem *.csproj
    dotnet publish $csproj -c Release
    if($lastexitcode -ne 0) {
      Write-Host "Build error at $([System.DateTime]::Now)" -f Yellow
      return
    }
    Write-Host "Build complete at $([System.DateTime]::Now)" -f Green
    echo "test..."

    $dockerfiles = (Get-ChildItem *.dockerfile)

    if($dockerfiles -eq $null) {
      Write-Host "No .dockerfile to build" -f Yellow
      $dockerfile = (Get-ChildItem dockerfile)[0]
      if($dockerfile -eq $null) {
        Write-Host "No dockerfile to build either :(" -f Red
      } else {
        $csprojfile = (Get-ChildItem *.csproj)[0]
        $name = $csprojfile.Name
        $extension = $csprojfile.Extension
        $imageName = $csprojfile.Name.Substring(0, $name.Length - $extension.Length).ToLower()

        Write-Host "Building default dockerfile for $imageName" -f Yellow
        docker build -t "$($imageName):latest" .

        if($lastexitcode -eq 0) {
          Write-Host "Build complete at $([System.DateTime]::Now)" -f Green
        } else {
          Write-Host "Docker build failed at $([System.DateTime]::Now)" -f Red
        }
      }
    } else {

      $dockerfile = (Get-ChildItem *.dockerfile)[0]
      if($dockerfile -eq $null) {
        Write-Host "No .dockerfile to build" -f Yellow
        $dockerfile = (Get-ChildItem dockerfile)[0]
        if($dockerfile -eq $null) {
          Write-Host "No dockerfile to build either :(" -f Red
        } else {
          $name = $dockerfile.Name
#$extension = $dockerfile.Extension
#$imageName = $dockerfile.Name.Substring(0, $name.Length - $extension.Length).ToLower()
#docker build -t "$($imageName):latest" -f $name .
          docker build -t "$($name):latest" -f $name .

          if($lastexitcode -eq 0) {
            Write-Host "Build complete at $([System.DateTime]::Now)" -f Green
          } else {
            Write-Host "Docker build failed at $([System.DateTime]::Now)" -f Red
          }
        }

      } else {
        $name = $dockerfile.Name
        $extension = $dockerfile.Extension
        $imageName = $dockerfile.Name.Substring(0, $name.Length - $extension.Length).ToLower()
        docker build -t "$($imageName):latest" -f $name .

        if($lastexitcode -eq 0) {
          Write-Host "Build complete at $([System.DateTime]::Now)" -f Green
        } else {
          Write-Host "Docker build failed at $([System.DateTime]::Now)" -f Red
        }
      }
    }
  }

  function stopAll() {
    $running = (docker ps | Select-Object -skip 1 )
    # yeah, cos $running may be a string or an array, depending on how many rows are returned. because of course you would...
    if($running.GetType() -eq "the type of a string".GetType()) {
      Write-Host "1 container to stop:"
    } else {
      Write-Host "$($running.Length) containers to stop:"
    }

    $running | Foreach-Object { 
      $id = ($_ -split '\s+')[0]
      Write-Host "Stopping $id  " -nonewline
      docker stop $id  
    }
  }

  function bash() {
    if($arg3 -ne $null -and $arg3.ToUpper() -eq "SH") {
      Write-Host "Falling back to /bin/sh for $arg2" -f RED
      docker run -it --rm --entrypoint /bin/sh $arg2
    } else {
      docker run -it --rm --entrypoint /bin/bash $arg2
    }
  }

  function ssh() {
    if($arg3 -ne $null -and $arg3.ToUpper() -eq "SH") {
      Write-Host "Falling back to /bin/sh for $arg2" -f RED
      docker exec -it $arg2 /bin/sh
    } else {
      docker exec -it $arg2 /bin/bash
    }
  }

  function attachToPod() {
    if($arg2 -eq $null) {
      kubectl get pods
      return
    }
    $podName = getFullPodName $arg2
    if($podName -eq $null) {
      Write-Host "Could not find pod matching: " -nonewline ; Write-Host $arg2 -f RED
      kubectl get pods
    } else {
      Write-Host "Attaching to pod: " -nonewline ; Write-Host $podName -f GREEN
      kubectl exec -it $podName -- /bin/bash
    }
  }

  function dckMode() {
    return (docker system info | Select-String -pattern "OSType").ToString().Trim().Split(" ")[1].ToUpper()
  }

  function displayMode() {
    Write-Host "Docker is configured to run " -nonewline; Write-Host (dckMode) -f Yellow -nonewline; Write-Host " containers."
  }

  function shell() {
    Write-Host "When you connect, run the command " -nonewline ; Write-Host "chroot /host" -f GREEN
    docker run --rm -it -v /:/host mcr.microsoft.com/dotnet/core/runtime:2.2-stretch-slim /bin/sh 
  }

  function dckwin() {
    if((dckMode) -eq "WINDOWS") { 
      Write-Host "Already running Docker in Windows mode." -f Green
    } else {
      Write-Host "Switching Docker to Windows mode." -f Yellow
      & 'C:\program files\docker\docker\dockercli.exe' -SwitchWindowsEngine
    }
  }

  function dcklin() {
    if((dckMode) -eq "LINUX") { 
      Write-Host "Already running Docker in Linux mode." -f Green
    } else {
      Write-Host "Switching Docker to Linux mode." -f Yellow
      & 'C:\program files\docker\docker\dockercli.exe' -SwitchLinuxEngine
    }
  }

  function GetCommand($argCommand) {
    if($arg -eq $null) {
      return $null
    }

    $expected = $argCommand.ToLower()
    foreach($command in $allCommands) {
      if($command -eq $expected) {
        return $command[1]
      }
    }
    Write-Host "Unknown command: " -nonewline ; Write-Host $arg -f Yellow
    return $null
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


  function DisplaySection($title, $section) {
    Write-Host " $title" -f Green

    if($section[0].GetType() -eq "the type of a string".GetType()) {
      DisplayCommand $section
    } else {
      foreach($command in $section){
        DisplayCommand $command
      }
    }
  }

  function displayUsage() {
    Write-Host "Usage: dck [command] [arg]"

    DisplaySection "System" $systemCommands
    DisplaySection "Docker daemon shortcuts" $daemonCommands
    DisplaySection "Docker compose shortcuts" $composeCommands
    DisplaySection "Kubernetes shortcuts" $kubernetesCommands
    DisplaySection "Build shortcuts" $buildCommands
  }


  #
  # Main routine
  #
  if($arg -eq $null) { $lArg = $null }
  else { $lArg = $arg.ToLower() }

  $a = GetCommand $arg
  if(!$a) {
    displayUsage
  } else {
    Invoke-Expression $a
  }

#  if($lArg -eq "LIN" -OR $lArg -eq "LINUX") {
#    dcklin
#  } elseif($lArg -eq "WIN" -OR $lArg -eq "WINDOWS") {
#    dckwin
#  } elseif($lArg -eq "MODE") {
#    displayMode
#  } elseif(($lArg) -and $commands.ContainsKey($lArg)) {
#    $command = $commands[$lArg][0]
#    Invoke-Expression $command
#  } else {
#    displayUsage
#  }

}
