{pirsavelog.p}

/*

03/03/06	поиск файла по пропасу...

		[vk]

*/


{globals.i}


DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE fs AS CHAR.
def var file as char format "x(20)".
{setdest.i}


SET fs format "x(20)" LABEL "Что ищем?" WITH FRAME osfile-info.
 
FILE-INFO:FILE-NAME = fs.

file = search (fs).
if file = ? then put unformatted "не найдено!!!" skip(2).
else put unformatted "Берется из:"skip file skip(2).

REPEAT i = 1 TO NUM-ENTRIES(PROPATH):
 if search(ENTRY(i,PROPATH) + "/" + fs) = ? then 
    put unformatted ENTRY(i,PROPATH) FORMAT "x(30)" "?" skip.

 else do:
    FILE-INFO:FILE-NAME = (ENTRY(i,PROPATH) + "/" + fs).
    put unformatted ENTRY(i , PROPATH) FORMAT "x(30)" space 
		string(file-info:file-size,">>>>>>>>9") space 
                string(file-info:FILE-MOD-DATE,"99/99/99") space
		string(search(ENTRY(i,PROPATH) + "/" + fs),"x(45)") space
	/*	string(file-info:FILE-MOD-time,"99:99") space  тут надо integer в time пересчитать */
		skip.
 end.
END.

 

{preview.i}