#Set-ExecutionPolicy "Unrestricted"

function Add-NativeHelperType
{
    $nativeHelperTypeDefinition =
    @"
    using System;
    using System.Runtime.InteropServices;

    public static class NativeHelper
        {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        public static bool SetForeground(IntPtr windowHandle)
        {
           return NativeHelper.SetForegroundWindow(windowHandle);
        }

    }
"@
if(-not ([System.Management.Automation.PSTypeName] "NativeHelper").Type)
    {
        Add-Type -TypeDefinition $nativeHelperTypeDefinition
    }
}


[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
$DebugViewWindow_TypeDef = @'

[DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]

public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
private const int MOUSEEVENTF_LEFTDOWN = 0x02;
private const int MOUSEEVENTF_LEFTUP = 0x04;
private const int MOUSEEVENTF_RIGHTDOWN = 0x08;
private const int MOUSEEVENTF_RIGHTUP = 0x10;
 
public static void LeftClick(){
    mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
}
 
public static void RightClick(){
    mouse_event(MOUSEEVENTF_RIGHTDOWN | MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
}
'@

Add-Type -MemberDefinition $DebugViewWindow_TypeDef -Namespace AutoClicker -Name Temp -ReferencedAssemblies System.Drawing


$dir="\\dc01\disk_t\Soft\ARMFM\Spravochnik\Terror\"
$dirTemp="D:\Scripts\Terr\temp"

$url="https://portal.fedsfm.ru/account/login"
$username="7708031739775001001"
$password="348t239y5"


$PSEmailServer="mail.pirbank.ru"
$utf8=[System.Text.Encoding]::UTF8
$to="ddorkin@pirbank.ru"
$subject="Information Rosfinmonitoring"
$from="bis@pirbank.ru"

function sendmail ([string]$body) {
    Send-Mailmessage -from $from -to "$to" -subject $subject -body $body -encoding $utf8
}

function Expand-ZIPFile($file, $destination)
{
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
{
    $shell.Namespace($destination).copyhere($item)
}
}


$ie = New-Object -com InternetExplorer.Application
$ie.visible=$true
$ie.navigate($url)

Remove-Item "$dirTemp\*"

while($ie.ReadyState -ne 4) {start-sleep -m 100}
if ($ie.Document.Title -ne "Росфинмониторинг | Вход"){
    sendmail "Unavailable website!"
    $ie.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
    Remove-Variable ie
    break
}

$ie.document.getElementById("loginEditor").value=$username
$ie.document.getElementById("passwordEditor").value=$password
$ie.document.getElementById("loginButton").click()

Get-Process | foreach { if ($_.Name -eq "iexplore"){$ieproc=$_;$ieId = $_.Id}} 

$ie.fullscreen=$true

Add-Type -AssemblyName System.Windows.Forms
#$wshell = New-Object -ComObject wscript.shell
#$wshell.AppActivate($ieId)

Add-NativeHelperType
[NativeHelper]::SetForeground($ie.HWND)
sleep 10
[Windows.Forms.Cursor]::Position = "$(150),$(200)"
[AutoClicker.Temp]::LeftClick()
sleep 10
[Windows.Forms.Cursor]::Position = "$(150),$(280)"
[AutoClicker.Temp]::LeftClick()
#[AutoClicker.Temp]::RightClick()
sleep 10
[Windows.Forms.Cursor]::Position = "$(350),$(270)"
[AutoClicker.Temp]::LeftClick()
sleep 10
[Windows.Forms.Cursor]::Position = "$(575),$(390)"
#[AutoClicker.Temp]::RightClick()
[AutoClicker.Temp]::LeftClick()
sleep 5
$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys("{Home}")
sleep 1
$wshell.SendKeys("$dirTemp\")
sleep 1
$wshell.SendKeys("{Enter}")

Start-Sleep 20
$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)

Get-Childitem -Filter "*.zip" $dirTemp | % {$FileName = $_.Name}
Expand-ZIPFile –File “$dirTemp\$Filename” –Destination “$dirTemp”
