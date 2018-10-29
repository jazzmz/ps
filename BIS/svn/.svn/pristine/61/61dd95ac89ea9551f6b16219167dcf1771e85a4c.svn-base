/* pir_show_user_accts.p 
(далее добавляет) показывает права на лиц.счета пользователя 
ДР dop-acct,Л/С,ОперСчетДБ,ОперСчетКР
сортирует лиц.счета и удаляет переводы строк
*/

DEF VAR STR_LENGTH AS INT NO-UNDO INIT 78.

DEF VAR drCode  AS CHAR NO-UNDO INIT "dop-acct,Л/С,ОперСчетДБ,ОперСчетКР".
DEF VAR drNames AS CHAR NO-UNDO INIT "Список доп.счетов для просмотра,Список л/с, доступных для просм. остатк.,Счета дебетуемые,Счета кредитуемые".

{pirsavelog.p}
{globals.i}
{intrface.get xclass}

DEFINE TEMP-TABLE TmpSortAcct NO-UNDO
   FIELD acct       AS CHAR
   INDEX acct	acct 
.

/* добавляет к списку маску, если она не проходит по CAN-DO и сортирует список масок */
FUNCTION Add2SortCanDo RETURNS CHARACTER
   (  INPUT pAcctsCanDo AS CHARACTER	/* список масок счетов 		 */
    , INPUT pAcct2Add 	AS CHARACTER	/* список масок добавляемых счет */
) :
  /* чистим таблицу */
  FOR EACH TmpSortAcct:
    DELETE TmpSortAcct.
  END.
  pAcctsCanDo = REPLACE(pAcctsCanDo, "#tab", "").
  pAcctsCanDo = REPLACE(pAcctsCanDo, "#cr" , "").
  pAcctsCanDo = REPLACE(pAcctsCanDo, " "   , "").

  /* проходим по всему списку масок и скидываем во временную таблицу для сортировки */
  DEF VAR k       AS INTEGER NO-UNDO.
  DO k = 1 TO NUM-ENTRIES(pAcctsCanDo) :
    DEF VAR  cAcctCanDo AS CHAR NO-UNDO.
    cAcctCanDo = ENTRY(k, pAcctsCanDo).
    /* нет такого счета по маске */
/*  IF NOT CAN-DO(cAcctCanDo, ...) THEN DO: */
      CREATE TmpSortAcct.
      TmpSortAcct.acct = cAcctCanDo.
/*  END. */
  END.  

  DO k = 1 TO NUM-ENTRIES(pAcct2Add) :
    /* добавляем новую маску, если ее нет */
    IF NOT CAN-DO(cAcctCanDo, ENTRY(k, pAcct2Add)) THEN DO:
      CREATE TmpSortAcct.
      TmpSortAcct.acct = ENTRY(k, pAcct2Add).
    END.
  END.  

  /* проходим по отсортированной таблице и получаем отсортированный список */
  DEF VAR cAcctsList AS CHAR NO-UNDO.
  cAcctsList = "".
  FOR EACH TmpSortAcct:
    cAcctsList = cAcctsList + ',' + TmpSortAcct.acct.
  END.

  IF LENGTH (cAcctsList) > 1	/* удаляем первую запятую */
    THEN cAcctsList = SUBSTR(cAcctsList, 2).
  RETURN cAcctsList.
END. /* FUNCTION Add2SortCanDo */

/* добавляет к списку маску, если она не проходит по CAN-DO и сортирует список масок */
FUNCTION CountColAccts RETURNS INTEGER
   (  INPUT pAcctsCanDo AS CHARACTER	/* список масок счетов 	*/
) :
  DEF VAR vColAccts AS INT NO-UNDO.
  SELECT COUNT(*) INTO vColAccts
    FROM acct
    WHERE CAN-DO(pAcctsCanDo, acct.acct).
  RETURN vColAccts.
END. /* FUNCTION CountColAccts */

/* разбиваем по строкам длиной до STR_LENGTH символов */
PROCEDURE ShowAcctsByLength.
  DEF INPUT PARAM pdrOldValue AS CHARACTER.
  DEF INPUT PARAM pSTR_LENGTH AS INT.
  DO WHILE     LENGTH(pdrOldValue) > pSTR_LENGTH /* строка длиннее чем влазит на экран */
         AND R-INDEX(pdrOldValue, ',') > 0	 /* и есть возможность разбивать */
  :
    DEF VAR dr AS CHAR NO-UNDO.
    dr = SUBSTR(pdrOldValue, 1, pSTR_LENGTH).
    dr = SUBSTR(dr, 1, R-INDEX(dr, ',')).

    pdrOldValue = REPLACE (pdrOldValue, dr, "").

    PUT UNFORMATTED dr SKIP.
  END.
  
  PUT UNFORMATTED pdrOldValue SKIP.
END. /* PROCEDURE CountColAccts. */
