#Set-ExecutionPolicy RemoteSigned

Clear-Host

Import-Module -Name C:\test\telnet\SSH-Sessions #-Verbose

New-SshSession -ComputerName era -Username root -Password 'Pa$$word' |  Out-Null


$Query = Invoke-SshCommand -ComputerName era -Command "ping -c 3 192.168.1.65" -Quiet

$Strings = $Query[0] -split "`n" 

foreach ($string in $Strings){ 
    $line = $string | select-string 'icmp_seq' 
    if ("$line" -ne ""){
        echo "Line=$line" 
    }
}

Remove-SshSession -ComputerName era |  Out-Null