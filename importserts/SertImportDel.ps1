$certs = New-Object system.security.cryptography.x509certificates.x509certificate2

$path = "C:\test\importserts\bazhinova_cert.pfx"

#$password = Read-Host "Type password for PFX certificate" -AsSecureString

$password = 'Pa$$word'

$flags = "UserKeySet, Exportable"

$certs.Import($path, $password, $flags)

$store = New-Object system.security.cryptography.X509Certificates.X509Store "My", "CurrentUser"

$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)

$store.Add($certs)

$store.Close()