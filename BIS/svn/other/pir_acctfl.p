{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                по просьбе Бадосовой Е.Н.*/

/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

{intrface.get tmess}
{intrface.get pbase}
{intrface.get acct}

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cTmpStr  AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE cAcc     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dCr      AS DATE                  NO-UNDO.
DEFINE VARIABLE dDb      AS DATE                  NO-UNDO.
DEFINE VARIABLE iAcc     AS INTEGER               NO-UNDO.

{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{getdate.i}
{exp-path.i &exp-filename = "'acctfl.xls'"}

/******************************************* Реализация */
PUT UNFORMATTED XLHead("acct", "CCND", "").

cTmpStr = XLCell("Счет") +
          XLCell("Название счета") +
          XLCell("Остаток") +
          XLCell("Дата последнего движения").

PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

iAcc = 0.
FOR EACH tmprecid NO-LOCK ,
   FIRST acct WHERE RECID (acct) = tmprecid.id NO-LOCK:

   cAcc = acct.acct.
   put screen col 1 row 24 cAcc.
   RUN acct-pos IN h_base (cAcc, acct.currency, end-date, end-date, CHR(251)).

   cTmpStr = XLCell(cAcc) +
             XLCell(acct.Details) +
             XLNumCell(- sh-bal).

   FIND LAST op-entry
       WHERE (op-entry.acct-cr = cAcc)
         AND (op-entry.op-date <= end-date)
       NO-LOCK NO-ERROR.

   IF AVAIL op-entry THEN dCr = op-entry.op-date.
                     ELSE dCr = DATE(1, 1, 2099).

   FIND LAST op-entry
       WHERE (op-entry.acct-db = cAcc)
         AND (op-entry.op-date <= end-date)
       NO-LOCK NO-ERROR.

   IF AVAIL op-entry THEN dDb = op-entry.op-date.
                     ELSE dDb = DATE(1, 1, 2099).

   IF dDb < dCr THEN dCr = dDb.

   IF dCr < DATE(1, 1, 2099) THEN
      cTmpStr = cTmpStr + XLDateCell(dCr).

   PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

   iAcc = iAcc + 1.

END.

cTmpStr = XLCell("Итого: " + STRING(iAcc) + " шт.").

PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .
PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
