$xCmdString = {rundll32.exe user32.dll,LockWorkStation}

While ( 1 -gt 0 ) {
    $flag=$false
    $flag = gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | % {echo $_.Name; echo $_.DeviceId;} | Select-String "5266CB982AFA83B8E199433ACEB0023326926B8B"
    if ($flag){} else {Invoke-Command $xCmdString}
}

