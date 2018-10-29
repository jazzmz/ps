$url="http://mail.ru"
$username = "jazzmz@mail.ru"

$password = "jt8qf9cA"

$ie = New-Object -com InternetExplorer.Application

$ie.visible=$true

$ie.navigate($url)

while($ie.ReadyState -ne 4) {start-sleep -m 100}

$ie.document.getElementById("mailbox__login").value= $username

$ie.document.getElementById("mailbox__password").value = $password

$ie.document.getElementById("mailbox__auth__button").click()

$ie | Get-Member