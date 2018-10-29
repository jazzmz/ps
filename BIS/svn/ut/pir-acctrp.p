/*****************************************
 *
 * Отчет по дополнительным реквизитам
 * лицевых счетов.
 *
 *****************************************
 *
 * Автор         : Маслов Д. А. Maslov D. A.
 * Дата создания : 20.11.12
 * Заявка        : #1780
 *
 *****************************************/

 {globals.i}
 {tmprecid.def}
 {intrface.get xclass}
 {intrface.get db2l}

 /**
  * Счетов будет много поэтому
  * нельзя использовать TTable.
  **/
 {setdest.i}

  PUT UNFORMATTED "Наименование счета" FORMAT "x(35)" "|" "Наименование счета" FORMAT "x(20)" "|" "Значение ДР" SKIP.
  PUT UNFORMATTED " " SKIP.                                          

 /**
  * По заявке #1949
  *
  **/
 FOR EACH tmprecid NO-LOCK,
   FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK 
   BY INT(SUBSTRING(acct.acct,1,5)) BY INT(SUBSTRING(acct.acct,12,9)):


   PUT UNFORMATTED acct.details FORMAT "x(35)" "|"
                   acct.acct FORMAT "x(20)" "|"
                   getXAttrValueEx("acct",getSurrogateBuffer("acct",BUFFER acct:HANDLE),"Прим1","-") SKIP.
 END.

 {preview.i}
 {intrface.del}