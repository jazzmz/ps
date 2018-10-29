{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
      Выписка ПОДФТ по счету
      Борисов А.В.
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{ulib.i}
{sh-defs.i}

/******************************************* Определение переменных и др. */
DEF VAR cXL   AS CHAR     NO-UNDO.
DEF VAR iI    AS INTEGER  NO-UNDO.

{pir_exf_exl.i}
{getdates.i}
{exp-path.i &exp-filename = "'AcctPODFT.xls'"}
{get-bankname.i}

/******************************************* Реализация */
PUT UNFORMATTED XLHead("op", "ICDCCCCCCNNNNC", "28,70,71,200,78,150,200,71,34,110,110,110,110,200").

FOR EACH tmprecid
   NO-LOCK,
   FIRST acct
      WHERE (RECID(acct) EQ tmprecid.id)
        AND ((acct.close-date EQ ?)
          OR (acct.close-date GE beg-date))
      NO-LOCK:

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, cXL).

   cXL = XLRow(2) + XLRowEnd() + XLRow(0)
       + XLCell("Выписка по счету " + acct.acct + " за период с "
                + STRING(beg-date, "99.99.9999") + " по " + STRING(end-date, "99.99.9999"))
       + XLRowEnd() + XLRow(0)
       + XLCell(GetAcctClientName_UAL(acct.acct, NO))
       + XLEmptyCells(6)
       + XLCell("Входящий остаток на счете:") + XLEmptyCells(3)
       + XLNumECell(IF (acct.currency NE "") THEN ABS(sh-in-val) ELSE 0)
       + XLNumCell(ABS(sh-in-bal))
       + XLRowEnd()
       .
   PUT UNFORMATTED cXL.
cXL = XLCell("N")
    + XLCell("Номер документа")
    + XLCell("Дата документа")

    + XLCell("Наименование контрагента")
    + XLCell("ИНН")
    + XLCell("Р/С контрагента")
    + XLCell("Банк контрагента")
    + XLCell("БИК банка контрагента")

    + XLCell("Вал.")
    + XLCell("Сумма ДБ(вал)")
    + XLCell("Сумма ДБ(руб)")
    + XLCell("Сумма КР(вал)")
    + XLCell("Сумма КР(руб)")
    + XLCell("Назначение платежа")
    .

PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .

   iI = 0.

   FOR EACH op
      WHERE (op.op-date GE beg-date)
        AND (op.op-date LE end-date)
      NO-LOCK,
      EACH op-entry OF op
         WHERE (acct.acct EQ op-entry.acct-db)
            OR (acct.acct EQ op-entry.acct-cr)
         NO-LOCK
      BREAK BY op.op-date
            BY op.op:

      IF (FIRST-OF(op.op))
      THEN
         iI = iI + 1.


      cXL = XLNumCell(iI)
          + XLCell(op.doc-num)
          + XLDateCell(op.op-date)
          .
      IF (acct.acct EQ op-entry.acct-cr)
      THEN RUN OneAcct(op-entry.acct-db, INPUT-OUTPUT cXL).
      ELSE RUN OneAcct(op-entry.acct-cr, INPUT-OUTPUT cXL).

      cXL = cXL
          + XLCell(op-entry.currency)
          .
      IF (acct.acct EQ op-entry.acct-db)
      THEN
         cXL = cXL
             + XLNumECell(IF (op-entry.currency EQ "") THEN 0 ELSE op-entry.amt-cur)
             + XLNumCell(amt-rub)
             + XLEmptyCells(2)
             .
      ELSE
         cXL = cXL
             + XLEmptyCells(2)
             + XLNumECell(IF (op-entry.currency EQ "") THEN 0 ELSE op-entry.amt-cur)
             + XLNumCell(amt-rub)
             .

      cXL = cXL
          + XLCell(op.details)
          .
      PUT UNFORMATTED XLRow(IF FIRST(op.op-date) THEN 1 ELSE 0)
                      cXL XLRowEnd().
   END.

   cXL = XLRow(2)
       + XLCell("Итого :") + XLEmptyCells(6)
       + XLCell("Обороты :") + XLEmptyCell()
       + XLNumECell(IF (acct.currency NE "") THEN ABS(sh-vdb) ELSE 0)
       + XLNumCell(sh-db)
       + XLNumECell(IF (acct.currency NE "") THEN ABS(sh-vcr) ELSE 0)
       + XLNumCell(sh-cr)
       + XLRowEnd() + XLRow(0) + XLEmptyCells(7)
       + XLCell("Остаток на счете :")
       + XLEmptyCells(3)
       + XLNumECell(IF (acct.currency NE "") THEN ABS(sh-val) ELSE 0)
       + XLNumCell(ABS(sh-bal))
       + XLRowEnd()
       .
   PUT UNFORMATTED cXL.
END.

PUT UNFORMATTED XLEnd().

{intrface.del}

/*************************************************/
PROCEDURE OneAcct:
DEFINE INPUT        PARAMETER inAcct AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER ioXL   AS CHARACTER.

DEFINE VARIABLE daLast  AS DATE       NO-UNDO.
DEFINE VARIABLE cKl     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cINN    AS CHARACTER  NO-UNDO.
DEFINE BUFFER   ta      FOR acct.

   CASE inAcct:
      WHEN ? THEN DO:
         ioXL = ioXL
              + XLEmptyCells(5).
      END.
      WHEN "30102810900000000491" THEN DO:
         IF {assigned op.name-ben}
         THEN DO:

            ioXL = ioXL
                 + XLCell(op.name-ben)
                 + XLCell(op.inn)
                 + XLCell(op.ben-acct)
                 .
            FIND FIRST op-bank
               WHERE (op-bank.op EQ op.op)
                 AND (op-bank.op-bank-type   EQ "")
                 AND (op-bank.bank-code-type EQ "МФО-9")
               NO-LOCK NO-ERROR.

            IF AVAILABLE(op-bank)
            THEN DO:
               FIND FIRST banks-code OF op-bank
                  NO-ERROR.
               FIND FIRST banks OF banks-code
                  NO-ERROR.
               ioXL = ioXL
                    + XLCell(banks.name)
                    + XLCell(op-bank.bank-code)
                    .
            END.
            ELSE
               ioXL = ioXL
                    + XLEmptyCells(2).
         END.
         ELSE DO:
            ioXL = ioXL
                 + XLCell(cBankName)
                 + XLCell("")
                 + XLCell(inAcct)
                 + XLCell(cBankName)
                 + XLCell("044585491")
                 .
         END.
      END.
      OTHERWISE DO:

         FIND FIRST ta
            WHERE (ta.acct EQ inAcct)
            NO-LOCK NO-ERROR.

         IF (AVAIL ta)
         THEN DO:
            cKl  = "".
            cINN = "".

            CASE ta.cust-cat:
               WHEN "Ю" THEN DO:
                  FIND FIRST cust-corp
                     WHERE cust-corp.cust-id = ta.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp
                  THEN DO:
                     /** commented by Buryagin at 10/09/2010
                     cKl  = cust-corp.cust-stat + " " + cust-corp.name-corp.
                     */
                     cKl  = cust-corp.name-short.
                     cINN = cust-corp.inn.
                  END.
               END.
               WHEN "Ч" THEN DO:
                  FIND FIRST person
                     WHERE person.person-id = ta.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL person
                  THEN DO:
                     cKl  = person.name-LAST + " " + person.first-names.
                     cINN = person.inn.
                     cINN = IF (cINN EQ "0") OR (cINN EQ "000000000000") THEN "" ELSE cINN.
                  END.
               END.
               WHEN "Б" THEN DO:
                  FIND FIRST banks
                     WHERE banks.bank-id = ta.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL banks
                  THEN DO:
                     cKl  = banks.name.

                     FIND FIRST cust-ident
                        WHERE (cust-ident.cust-cat       EQ "Б")
                          AND (cust-ident.cust-id        EQ ta.cust-id)
                          AND (cust-ident.cust-code-type EQ "ИНН")
                        NO-LOCK NO-ERROR.
                     cINN = IF (AVAIL cust-ident) THEN cust-ident.cust-code ELSE "".
                  END.
               END.
               WHEN "В" THEN DO:
                  cKl  = ta.Details.
               END.
            END CASE.

            ioXL = ioXL
                 + XLCell(cKl)
                 + XLCell(cINN)
                 .
         END.
         ELSE
            ioXL = ioXL
                 + XLEmptyCells(2)
                 .

         ioXL = ioXL
              + XLCell(inAcct)
              + XLCell(cBankName)
              + XLCell("044585491")
              .
      END.
   END CASE.

END PROCEDURE.
