/**********************************************
 * Обработка для переноса дополнительного     *
 * реквизита "Статистика" на клиента.         *
 **********************************************
 * Автор : Маслов Д. А. Maslov D. A.          *
 * Дата  : 11.07.13                           *
 * Заявка: #3397                              *
 **********************************************/

 {globals.i}
 {tmprecid.def}
 {intrface.get xclass}
 {intrface.get db2l}

 DEF VAR currStatUnit AS CHAR NO-UNDO.

{setdest.i}

  FOR EACH signs WHERE signs.file-name = "acct" 
                   AND signs.code = "Статистика" 
                   AND CAN-DO("!,*",xattr-value) NO-LOCK,
   FIRST acct WHERE acct.acct = ENTRY(1,signs.surrogate) NO-LOCK:

   currStatUnit = getXAttrValueEx("acct",GetSurrogateBuffer("acct",BUFFER acct:HANDLE),"Статистика",?).

   CASE acct.cust-cat:

      WHEN "Ч" THEN DO:
             PUT UNFORMATTED "Изменям физ. лицо" SKIP.
          UpdateSigns("person",STRING(acct.cust-id),"Статистика",currStatUnit,?).
      END.

      WHEN "Ю" THEN DO:
             PUT UNFORMATTED "Изменям юр. лицо" SKIP.
          UpdateSigns("cust-corp",STRING(acct.cust-id),"Статистика",currStatUnit,?).
      END.

   END CASE.

   PUT UNFORMATTED acct.acct "=" currStatUnit SKIP.

 END.

{preview.i}

{intrface.del}