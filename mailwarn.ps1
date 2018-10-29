Clear-Host
function Warning ($message)
{
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing");

$objForm = New-Object Windows.Forms.Form 

$objForm.Text = "Внимание!" 
$objForm.Size = New-Object Drawing.Size @(400,200) 
$objForm.StartPosition = "CenterScreen"

$Warningtext=New-Object System.Windows.Forms.Label
$objForm.Controls.Add($Warningtext)
$Warningtext.Location = New-Object System.Drawing.Size(140,20)
$Warningtext.Size = New-Object System.Drawing.Size(200,50)
$Warningtext.Text = "$message"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(160,100)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($OKButton)

$objForm.Controls.Add($OKButton) 
$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})  
[void] $objForm.ShowDialog() 
}

Warning "Полученно новое сообщение электронной почты!"