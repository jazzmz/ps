{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE INPUT PARAMETER iParam AS CHARACTER.

DEFINE VARIABLE cTmpStr  AS CHARACTER          NO-UNDO. 
DEFINE VARIABLE cSpod    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cSpodKod AS CHARACTER          NO-UNDO.
DEFINE VARIABLE nDb      AS DECIMAL            NO-UNDO.
DEFINE VARIABLE nCr      AS DECIMAL            NO-UNDO.
DEFINE VARIABLE cDocNum  AS CHARACTER          NO-UNDO.
DEFINE BUFFER  aop-entry FOR op-entry.

{pir_exf_exl.i}

cTmpStr = "osv-spod" + iParam + ".xls".
{exp-path.i &exp-filename = cTmpStr}

/******************************************* Реализация */
PUT UNFORMATTED XLHead("OSV", "CNNC", "150,165,165,300").

cTmpStr = XLCell("Счет")
        + XLCell("Оборот СПОД по дебету")
        + XLCell("Оборот СПОД по кредиту")
        + XLCell("Название счета")
        .
PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().

FOR EACH acct
/* WHERE (acct.bal-acct GE 70700)
     AND (acct.bal-acct LE 70799)
*/
   NO-LOCK:

   nCr = 0.0.
   nDb = 0.0.

   FOR EACH op-entry
      WHERE (op-entry.acct-db   EQ acct.acct)
        AND (op-entry.op-date   GE DATE("01.01." + iParam))
        AND (op-entry.op-date   LE DATE("01.06." + iParam))
        AND (op-entry.op-date   NE ?)
        AND (op-entry.op-status GE '√')
      NO-LOCK:

      IF (GetXAttrValue ("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "СПОД") EQ "Да")
      THEN DO:
         nDb = nDb + op-entry.amt-rub.
/*       cTmpStr = XLCell(acct.acct)
                 + XLNumCell(op-entry.amt-rub)
                 + XLNumCell(0)
                 + XLCell(STRING(op-entry.op-date) + "  " + op-entry.op-status)
                 .
         PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().
*/
      END.
   END.

   FOR EACH op-entry
      WHERE (op-entry.acct-cr   EQ acct.acct)
        AND (op-entry.op-date   GE DATE("01.01." + iParam))
        AND (op-entry.op-date   LE DATE("01.06." + iParam))
        AND (op-entry.op-date   NE ?)
        AND (op-entry.op-status GE '√')
      NO-LOCK:

      IF (GetXAttrValue ("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "СПОД") EQ "Да")
      THEN DO:
         nCr = nCr + op-entry.amt-rub.
/*       cTmpStr = XLCell(acct.acct)
                 + XLNumCell(0)
                 + XLNumCell(op-entry.amt-rub)
                 + XLCell(STRING(op-entry.op-date) + "  " + op-entry.op-status)
                 .
         PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().
*/
      END.
   END.

   IF ((nDb + nCr) GT 0)
   THEN DO:
      cTmpStr = XLCell(acct.acct)
              + XLNumCell(nDb)
              + XLNumCell(nCr)
              + XLCell(acct.Details)
              .
      PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().
   END.
END.

PUT UNFORMATTED XLEnd().
{intrface.del}