{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-log-v.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Программа просмотра класса pir-log - протокола запусков модулей/инклюдников из src-local 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.1  2007/08/08 11:55:03  lavrinenko
Изменения     : Процедура протоколирования заупусков модулей
Изменения     :
------------------------------------------------------ */
DEF var f-time as char       	no-undo. 
def var x-doc-num as char       no-undo. 
def var x-usr as char 			no-undo.

{sv-form#.i 
    &postfind   = "pir-log-v.fnd " 
    &prg        = "pir-log-v" 
}

FORM
       {pir-log-v.uf}
WITH frame browse title color bright-white "[ " + caps(branch.short-name) + " - " + caps(DataClass.Name) +     " ЗА " + caps(per) + " ]" width 255  .

{pir-log.i &module="$RCSfile: pir-log-v.p,v $" &comment="Программа просмотра класса pir-log - протокола запусков модулей/инклюдников из src-local"}
