@echo off
setlocal enabledelayedexpansion
@for /f "tokens=* delims=" %%A in (C:\train\countfromfilebat\file.txt) do ( 
set /a flag=%%A + 1 )
echo "Count=%flag%"
echo %flag%>C:\train\countfromfilebat\file.txt
pause
call C:\train\countfromfilebat\count.bat