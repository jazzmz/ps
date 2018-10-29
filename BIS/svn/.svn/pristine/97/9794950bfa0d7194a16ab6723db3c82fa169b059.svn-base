DEF INPUT PARAMETER cFileName AS CHARACTER NO-UNDO.
DEF VAR oAcct AS TAcct NO-UNDO.
/********************************
 *                              *
 *  Алгоритм работы отчета очень*
 * медленный. Так как бежим по  *
 * таблице счетов, быстрее      *
 * будет бежать по таблице      *
 * доп.реквизитов и в случае    *
 * совпадения искать счет.      *
 * Но....                       *
 * 1. Быстрый сервер нам это    *
 * прощает.                     *
 * 2. Код очень понятен, и      *
 * фактически повторяет действия*
 * человека.                    *
 ********************************
 *                              *
 * Автор: Маслов Д. А.          *
 * Дата создания: 24.03.11      *
 * Заявка: #529                 *
 *                              *
 ********************************/
OUTPUT TO VALUE(cFileName).

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик счетов */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество счетов */
DEF VAR oTable      AS TTable  NO-UNDO.


oTable = new TTable(3).
oTable:colsWidthList="20,10,35".
oTable:addRow().
oTable:addCell("Счет").
oTable:addCell("Дата открытия").
oTable:addCell("Наименование счета").
oTable:setAlign(1,1,"center").
oTable:setAlign(2,1,"center").
oTable:setAlign(3,1,"center").

FOR EACH acct WHERE acct.close-date = ? AND (contr-acct = ? OR contr-acct = "") AND acct MATCHES '*' NO-LOCK:
  ACCUMULATE acct.acct (COUNT).
END. /* FOR EACH */
 vLnTotalInt = ACCUM COUNT acct.acct.

{init-bar.i "Обработка счетов"}
FOR EACH acct WHERE acct.close-date = ? AND (contr-acct = ? OR contr-acct = "") AND acct MATCHES '*' NO-LOCK:
  oAcct = new TAcct(acct.acct).
    IF oAcct:getXAttr("СКонСальдо") = "Предупреждение" THEN 
    DO:   

/*     PUT UNFORMATTED oAcct:acct "|" oAcct:open-date "|" oAcct:name-short SKIP.*/

     oTable:addRow().
       oTable:addCell(oAcct:acct).
       oTable:addCell(oAcct:open-date).
       oTable:addCell(oAcct:name-short).

    END.
     {move-bar.i vLnCountInt vLnTotalInt}
     vLnCountInt = vLnCountInt + 1.

  DELETE OBJECT oAcct.
END.
oTable:show().
DELETE OBJECT oTable.
OUTPUT CLOSE.
MESSAGE "Файл выгружен в " + cFileName VIEW-AS ALERT-BOX.