write-host "About to twiddle some network setting thing. This _may_ not be required"
get-netadapter | where-object {$_.InterfaceDescription -Match "Cisco AnyConnect"}  | Set-NetIPInterface -InterfaceMetric 6000
write-host "Setting twiddled" -f Green
write-host
write-host "https://colhountech.com/2021/04/01/wsl2-ubuntu-ping-hostname-temporary-failure-in-name-resolution/" -f Yellow
write-host "Ensure that the WSL instance has the right nameserver setup" -f Cyan
write-host "Get the correct address from your network adapter properties" -f Cyan
