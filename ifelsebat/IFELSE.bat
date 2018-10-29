@Echo Off

Set Direct=C:\test\ifelsebat\obr

Set FLAG=0 & If Exist "%Direct%" FOR /F "usebackq" %%f IN (`Dir "%Direct%\02050A*"  /b`) DO Set FLAG=1 & del obr\%%f

if "%FLAG%" == "1" (
echo "Est PRN"
)