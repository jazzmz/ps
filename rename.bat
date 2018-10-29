for /F "tokens=*" %%f in ('hostname') DO set myVar=%%f

wmic computersystem where name="%myVar%" call rename name="%1"