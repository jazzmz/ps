{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cXL   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iI    AS INTEGER   NO-UNDO.

DEFINE BUFFER loan-acct-pk FOR loan-acct.
DEFINE BUFFER loan-pk      FOR loan.
DEFINE TEMP-TABLE ttDog   NO-UNDO
   FIELD cDog AS CHARACTER
   FIELD dBeg AS DATE
   FIELD cKl  AS CHARACTER
   FIELD cPK  AS CHARACTER
   FIELD dEnd AS DATE
   FIELD cVal AS CHARACTER
   FIELD dLim AS DECIMAL
   FIELD dAmt AS DECIMAL
   FIELD IDNT AS INTEGER
   FIELD dSin AS DATE
.

{getdate.i}

{pir_exf_exl.i}
cXL = "/home2/bis/quit41d/imp-exp/doc/LimitOV.xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create}
   LEAVE.
END.

/******************************************* Реализация */
PUT UNFORMATTED XLHead(STRING(end-date, "99.99.9999"), "ICDCCDCN", "25,110,72,250,122,105,52,105").

cXL = XLCell("N")
    + XLCell("Номер договора")
    + XLCell("От")
    + XLCell("Клиент")
    + XLCell("ПК")
    + XLCell("Срок окончания")
    + XLCell("Валюта")
    + XLCell("Лимит овердрафта")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

FOR EACH loan
   WHERE (loan.class-code EQ "l_agr_with_per")
     AND ((loan.close-date EQ ?)
       OR (loan.close-date GE end-date))
   NO-LOCK,
   FIRST person
      WHERE (person.person-id    EQ loan.cust-id)
   NO-LOCK,
   LAST loan-acct
      WHERE (loan-acct.contract  EQ loan.contract)
        AND (loan-acct.cont-code EQ loan.cont-code)
        AND (loan-acct.currency  EQ loan.currency)
        AND ((loan-acct.acct BEGINS "40817")
          OR (loan-acct.acct BEGINS "40820"))
        AND (loan-acct.since     LE end-date)
   NO-LOCK,
   FIRST loan-acct-pk
      WHERE (loan-acct-pk.contract  EQ "card-pers")
        AND (loan-acct-pk.acct      EQ loan-acct.acct)
        AND (loan-acct-pk.currency  EQ loan-acct.currency)
   NO-LOCK,
   FIRST loan-pk
      WHERE (loan-pk.contract         EQ "card")
        AND (loan-pk.parent-cont-code EQ loan-acct-pk.cont-code)
        AND (loan-pk.parent-contract  EQ "card-pers")
        AND (loan-pk.loan-status      EQ "АКТ")
        AND (loan-pk.loan-work)
   NO-LOCK:

   FOR LAST loan-cond
      WHERE (loan-cond.contract  EQ loan.contract)
        AND (loan-cond.cont-code EQ loan.cont-code)
        AND (loan-cond.since     LE end-date)
      NO-LOCK
      BY loan-cond.since:

      FIND LAST term-obl OF LOAN
         WHERE (term-obl.idnt     EQ 2)
           AND (term-obl.end-date LE loan-cond.since)
      NO-LOCK NO-ERROR.

      IF NOT AVAILABLE term-obl
      THEN
         FIND FIRST term-obl OF loan
            WHERE (term-obl.idnt EQ 2)
         NO-LOCK NO-ERROR.

      CREATE ttDog.
      ASSIGN
         ttDog.cDog = loan.doc-ref
         ttDog.dBeg = loan.open-date
         ttDog.cKl  = person.name-last + " " + person.first-names
         ttDog.cPK  = loan-pk.doc-num
         ttDog.dEnd = loan.end-date
         ttDog.cVal = (IF (loan.currency EQ "") THEN "810" ELSE loan.currency)
         ttDog.dLim = term-obl.amt
         NO-ERROR.
   END.
END.

iI = 0.
FOR EACH ttDog
   NO-LOCK
   BY ttDog.cVal
   BY ttDog.dLim DESCENDING
   BY ttDog.cDog:

   iI  = iI + 1.
   cXL = XLNumCell(iI)
       + XLCell(ttDog.cDog)
       + XLDateCell(ttDog.dBeg)
       + XLCell(ttDog.cKl)
       + XLCell(ttDog.cPK)
       + XLDateCell(ttDog.dEnd)
       + XLCell(ttDog.cVal)
       + XLNumCell(ttDog.dLim)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
END.

PUT UNFORMATTED XLEnd().

{intrface.del}
