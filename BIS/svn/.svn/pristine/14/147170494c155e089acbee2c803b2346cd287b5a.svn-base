/* проверка наличия файла */

&IF DEFINED(FEXIST_DEFINED) EQ 0 &THEN 

&GLOBAL-DEFINE FEXIST_DEFINED 1

function FExist returns log
         (input filedir as char ,input filename as char ):
DEF VAR flagAnswer AS LOG NO-UNDO.
DEF VAR fileItem AS CHAR NO-UNDO.

    flagAnswer = FALSE.

    IF filename = "" OR filename = ? THEN
       RETURN flagAnswer.
    
    INPUT STREAM listDirExch FROM OS-DIR (filedir) NO-ATTR-LIST.
    REPEAT:
       IMPORT STREAM listDirExch fileItem.
       IF fileItem EQ filename THEN flagAnswer = TRUE.
    END.
    INPUT STREAM listDirExch CLOSE.
    return flagAnswer.
end.

&ENDIF 