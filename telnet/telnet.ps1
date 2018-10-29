$RemoteHost="10.0.0.100"
#$RemoteHost="192.168.3.15"
$Port="23"
$Socket = New-Object System.Net.Sockets.TcpClient($RemoteHost, $Port)

Clear-Host

If ($Socket)
{  $Stream = $Socket.GetStream()
    $writer = new-object System.IO.StreamWriter($stream)
    Start-Sleep 1
    $writer.WriteLine("admin")
    $Writer.Flush()
    Start-Sleep 1
    $writer.WriteLine("nfnjirf")
    $Writer.Flush()
    Start-Sleep 1
    $writer.WriteLine("ping 192.168.10.1 times 3")
    $Writer.Flush()
    Start-Sleep 10
    $writer.WriteLine("logout")
    $Writer.Flush()


    
    $buffer = new-object System.Byte[] 1024
    $encoding = new-object System.Text.AsciiEncoding
	$Reader = New-Object System.IO.StreamReader($Stream)
	while($stream.DataAvailable) {
	    $read = $stream.Read($buffer, 0, 1024)
	    write-host -n ($encoding.GetString($buffer, 0, $read))
	 }
	 
}