{pirsavelog.p}

/*
                Банковская интегрированная система БИСквит
    Copyright: (C) КБ "Пpоминвестрасчет"
     Filename: pir-pfkntrl.p
      Comment: Печать реестра документов на контроле ПОДФТ
      Created: 09/11/2010 Borisov
*/
/******************************************************************************/
{globals.i}
{repinfo.i}
{norm.i NEW}
{wordwrap.def}
{get-bankname.i}
{intrface.get xclass}
{intrface.get strng}
{leg207p.def}
{leg161p.fun}

/*============================================================================*/
DEFINE VARIABLE cPlName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPlTlf  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPlINN  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPlAcct AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPlBank AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPoName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPoTlf  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPoINN  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPoAcct AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPoBank AS CHARACTER NO-UNDO.

DEFINE VARIABLE cNazn   AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE VARIABLE cKbeg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKend   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKsrok  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKontr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iDelDat AS INTEGER   NO-UNDO.

{pir-pfkntrl.frm}
/* ----------------------------------------------------- */
{setdest.i &cols=275}

PUT UNFORMATTED
   "Реестр сведений об операциях на контроле ПОДФТ за "
   IF (daBeg EQ daEnd)
   THEN (STRING(daEnd, "99.99.9999"))
   ELSE ("период с " + STRING(daBeg, "99.99.9999") + " по " + STRING(daEnd, "99.99.9999"))
   SKIP
   "(условие выборки: "
   IF (iVar = 1) THEN "все операции, поставленные на контроль"
                 ELSE ""
   IF (iVar = 2) THEN "все операции, не снятые с контроля"
                 ELSE ""
   IF (iVar = 3) THEN ("все операции, со сроком " + (IF lLG1 THEN "< " ELSE ">= ") + STRING(iSrok1) + " дней до окончания контроля")
                 ELSE ""
   IF (iVar = 4) THEN ("все операции, со сроком " + (IF lLG2 THEN "< " ELSE ">= ") + STRING(iSrok2) + " дней от начала контроля")
                 ELSE ""
   ")" SKIP(1)
   "┌───────────┬──────────┬──────────────────────────────┬───────────────┬────────────┬────────────────────┬───────────────────────────┬─────────────────┬────────────────────────────────────────────────────────┬───────────┬───────────┬──────────┬──────┐  " SKIP
   "│   Номер   │   Дата   │         Наименование         │    Телефон    │    ИНН     │        N р/с       │             Банк          │       Сумма     │                                                        │Дата начала│Дата снятия│   Срок   │Прошло│" SKIP
   "│ проводки  │ проводки │         плательщика          │  плательщика  │плательщика │     плательщика    │         плательщика       │     операции    │                                                        │ контроля  │с контроля │ контроля │ дней │" SKIP
   "├───────────┼──────────┼──────────────────────────────┼───────────────┼────────────┼────────────────────┼───────────────────────────┼─────────────────┤                   Назначение платежа                   ├───────────┴───────────┴──────────┴──────┤" SKIP
   "│Коды 'Подоз│Код валюты│         Наименование         │    Телефон    │    ИНН     │        N р/с       │             Банк          │       Сумма     │                                                        │             Причина контроля            │" SKIP
   "│ Документ' │ операции │          получателя          │   получателя  │ получателя │     получателя     │          получателя       │   в нац.валюте  │                                                        │                                         │" SKIP
.

FOR EACH op
   WHERE (op.op-date GE daBeg)
     AND (op.op-date LE daEnd)
   NO-LOCK:

   cKbeg  = GetXAttrValue("op", STRING(op.op), "PIRKbegDate").
   cKend  = GetXAttrValue("op", STRING(op.op), "PIRKendDate").
   cKsrok = GetXAttrValue("op", STRING(op.op), "PIRKsrok").

   IF (cKbeg EQ "")
   THEN NEXT.

   IF (iVar EQ 2) AND (cKend  NE "")
   THEN NEXT.

   IF (iVar EQ 3) AND (cKsrok EQ "")
   THEN NEXT.

   IF    (iVar = 3)
   THEN DO:
      iDelDat = DATE(cKsrok) - daEnd.
      IF    (     lLG1  AND (iDelDat GE iSrok1))
         OR ((NOT lLG1) AND (iDelDat LT iSrok1))
      THEN NEXT.
   END.

   IF    (iVar = 4)
   THEN DO:
      iDelDat = daEnd - DATE(cKbeg).
      IF    (     lLG2  AND (iDelDat GE iSrok2))
         OR ((NOT lLG2) AND (iDelDat LT iSrok2))
      THEN NEXT.
   END.

   FOR FIRST op-entry OF op
      NO-LOCK:

      RUN OneAcct(op-entry.acct-db, OUTPUT cPlName, OUTPUT cPlTlf, OUTPUT cPlINN, OUTPUT cPlAcct, OUTPUT cPlBank).
      RUN OneAcct(op-entry.acct-cr, OUTPUT cPoName, OUTPUT cPoTlf, OUTPUT cPoINN, OUTPUT cPoAcct, OUTPUT cPoBank).

      cNazn[1] = op.details.
      {wordwrap.i &s=cNazn &n=5 &l=56}

      cKontr = GetXAttrValue("op", STRING(op.op), "PIRKontrol").

      PUT UNFORMATTED SKIP
         "╞═══════════╪══════════╪══════════════════════════════╪═══════════════╪════════════╪════════════════════╪═══════════════════════════╪═════════════════╪════════════════════════════════════════════════════════╪═══════════╤═══════════╤══════════╤══════╡" SKIP
         "│" op.doc-num FORMAT "x(11)"
         "│" op.op-date FORMAT "99.99.9999"
         "│" SUBSTRING(cPlName, 1, 30)    FORMAT "x(30)"
         "│" cPlTlf     FORMAT "x(15)"
         "│" cPlINN     FORMAT "x(12)"
         "│" cPlAcct    FORMAT "x(20)"
         "│" SUBSTRING(cPlBank, 1, 27)    FORMAT "x(27)"
         "│" STRING(IF (op-entry.amt-cur NE 0.0) THEN op-entry.amt-cur ELSE op-entry.amt-rub, ">>,>>>,>>>,>>9.99")
         "│" cNazn[1]   FORMAT "x(56)"
         "│ " REPLACE(cKbeg,  "/", ".") FORMAT "x(10)"
         "│ " REPLACE(cKend,  "/", ".") FORMAT "x(10)"
         "│"  REPLACE(cKsrok, "/", ".") FORMAT "x(10)"
         "│ " (daEnd - DATE(cKbeg)) FORMAT ">>>9"
        " │" SKIP
         "│           │          "
         "│" SUBSTRING(cPlName, 31, 30)    FORMAT "x(30)"
         "│               │            │                    "
         "│" SUBSTRING(cPlBank, 28, 27)    FORMAT "x(27)"
         "│                 "
         "│" cNazn[2]   FORMAT "x(56)"
         "│           │           │          │      │" SKIP
         "├───────────┼──────────┼──────────────────────────────┼───────────────┼────────────┼────────────────────┼───────────────────────────┼─────────────────┤"
             cNazn[3]   FORMAT "x(56)"
         "├───────────┴───────────┴──────────┴──────┤" SKIP
         "│" GetXAttrValue("op", STRING(op.op), "ПодозДокумент") FORMAT "x(11)"
         "│   " op-entry.currency FORMAT "x(3)"
     "    │" SUBSTRING(cPoName, 1, 30)    FORMAT "x(30)"
         "│" cPoTlf     FORMAT "x(15)"
         "│" cPoINN     FORMAT "x(12)"
         "│" cPoAcct    FORMAT "x(20)"
         "│" SUBSTRING(cPoBank, 1, 27)    FORMAT "x(27)"
         "│" STRING(IF (op-entry.amt-cur NE 0.0) THEN op-entry.amt-rub ELSE 0.0, ">>,>>>,>>>,>>9.99")
         "│" cNazn[4]   FORMAT "x(56)"
         "│" SUBSTRING(cKontr, 1, 41) FORMAT "x(41)"
         "│" SKIP
         "│           │          "
         "│" SUBSTRING(cPoName, 31, 30)    FORMAT "x(30)"
         "│               │            │                    "
         "│" SUBSTRING(cPoBank, 28, 27)    FORMAT "x(27)"
         "│                 "
         "│" cNazn[5]   FORMAT "x(56)"
         "│" SUBSTRING(cKontr, 42, 41) FORMAT "x(41)"
         "│" SKIP
      .
   END.
END.

PUT UNFORMATTED SKIP
   "╘═══════════╧══════════╧══════════════════════════════╧═══════════════╧════════════╧════════════════════╧═══════════════════════════╧═════════════════╧════════════════════════════════════════════════════════╧═════════════════════════════════════════╛" SKIP
.

{signatur.i &user-only = yes}
{preview.i}

/*************************************************/
PROCEDURE OneAcct:
DEFINE INPUT  PARAMETER inAcct AS CHARACTER.
DEFINE OUTPUT PARAMETER ioName AS CHARACTER.
DEFINE OUTPUT PARAMETER ioTlf  AS CHARACTER.
DEFINE OUTPUT PARAMETER ioINN  AS CHARACTER.
DEFINE OUTPUT PARAMETER ioAcct AS CHARACTER.
DEFINE OUTPUT PARAMETER ioBank AS CHARACTER.

DEFINE VARIABLE daLast  AS DATE       NO-UNDO.
DEFINE VARIABLE cKl     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTlf    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cINN    AS CHARACTER  NO-UNDO.

   CASE inAcct:
      WHEN ? THEN
         ASSIGN
            ioName = ""
            ioTlf  = ""
            ioINN  = ""
            ioAcct = ""
            ioBank = ""
            NO-ERROR.
      WHEN "30102810900000000491" THEN DO:
         IF {assigned op.name-ben}
         THEN DO:

            ASSIGN
               ioName = op.name-ben
               ioTlf  = ""
               ioINN  = ""
               ioAcct = op.ben-acct
               NO-ERROR.

            FIND FIRST op-bank
               WHERE (op-bank.op             EQ op.op)
                 AND (op-bank.op-bank-type   EQ "")
                 AND (op-bank.bank-code-type EQ "МФО-9")
               NO-LOCK NO-ERROR.

            IF AVAILABLE(op-bank)
            THEN DO:
               FIND FIRST banks-code OF op-bank
                  NO-ERROR.
               FIND FIRST banks OF banks-code
                  NO-ERROR.
               ioBank = banks.name.
            END.
            ELSE
               ioBank = "".
         END.
         ELSE
            ASSIGN
               ioName = cBankName
               ioTlf  = "(495)742-0505"
               ioINN  = "7708031739"
               ioAcct = inAcct
               ioBank = cBankName
               NO-ERROR.
      END.
      OTHERWISE DO:
         FIND FIRST acct
            WHERE (acct.acct EQ inAcct)
            NO-LOCK NO-ERROR.

         IF (AVAIL acct)
         THEN DO:
            CASE acct.cust-cat:
               WHEN "Ю" THEN DO:
                  FIND FIRST cust-corp
                     WHERE cust-corp.cust-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp
                  THEN
                     ASSIGN
                        ioName = cust-corp.name-short
                        ioTlf  = GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "tel")
                        ioINN  = cust-corp.inn
                        NO-ERROR.
               END.
               WHEN "Ч" THEN DO:
                  FIND FIRST person
                     WHERE person.person-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL person
                  THEN
                     ASSIGN
                        ioName = person.name-last + " " + person.first-names
                        ioTlf  = GetXAttrValue("person", STRING(person.person-id), "tel")
                        ioINN  = person.inn
                        NO-ERROR.
               END.
               WHEN "Б" THEN DO:
                  FIND FIRST banks
                     WHERE banks.bank-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL banks
                  THEN
                     ASSIGN
                        ioName = banks.name
                        ioTlf  = GetXAttrValue("banks", STRING(banks.bank-id), "tel")
                        ioINN  = banks.inn
                        NO-ERROR.
               END.
               WHEN "В" THEN
                  ASSIGN
                     ioName = acct.Details
                     ioTlf  = ""
                     ioINN  = ""
                     NO-ERROR.
            END CASE.
         END.
         ELSE
            ASSIGN
               ioName = ""
               ioTlf  = ""
               ioINN  = ""
               NO-ERROR.

         ASSIGN
            ioAcct = inAcct
            ioBank = cBankName
            NO-ERROR.
      END.
   END CASE.
END PROCEDURE.
