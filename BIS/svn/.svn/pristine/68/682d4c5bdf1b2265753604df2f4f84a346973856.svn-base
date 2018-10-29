{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
Сделана А.Борисовым.
Делает вспомогательные расчеты по переоценке "Валютная переоценка для ОДДС"
Используется ежегодно. Заказывается Резчиковой.
*/

/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE INPUT PARAMETER cP AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cXL      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE n840     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n978     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n826     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n1S840   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n1S978   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n1S826   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n2S840   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n2S978   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE n2S826   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iYear    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iKv      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAcc     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSym     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCol     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAcc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSAcc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDay     AS INTEGER  EXTENT 4 INITIAL [31, 30, 30, 31] NO-UNDO.
DEFINE VARIABLE beg-date AS DATE       NO-UNDO.
DEFINE VARIABLE end-date AS DATE       NO-UNDO.

DEFINE TEMP-TABLE ttItog    NO-UNDO
   FIELD tiSym       AS INTEGER
   FIELD tcCurr      AS CHARACTER
   FIELD tiKv        AS INTEGER
   FIELD tiAcc       AS INTEGER
   FIELD tnAmt       AS DECIMAL
.

iCol  = INTEGER(ENTRY(1, cP, ";")) + 1.
cAcc  = ENTRY(2, cP, ";").
cSAcc = ENTRY(3, cP, ";") + "|Prochie".

cXL = "!7*".
DO iAcc = 1 TO (iCol - 1):
   cXL = cXL + ",!" + REPLACE(ENTRY(iAcc, cAcc, "|"), ",", ",!").
END.
cAcc = cAcc + "|" + TRIM(cXL, ",") + ",*".


RUN g-prompt.p("integer", "Год", "9999", "2010",
               "", "", "", "", ?,?,OUTPUT cXL).
IF (cXL EQ ?)
THEN RETURN.
ELSE iYear = INTEGER(cXL).

{pir_exf_exl.i}
{exp-path.i &exp-filename = "'Kursovaya.xls'"}

/******************************************* Реализация */
DO iKv = 1 TO 4:

   beg-date = DATE((iKv - 1) * 3 + 1,         1, iYear).
   end-date = DATE((iKv - 1) * 3 + 3, iDay[iKv], iYear).

   DO iAcc = 1 TO iCol:

      put screen col 1 row 24 "Обрабатывается " + STRING(iKv) + " кв. - " + STRING(iAcc, ">9") + "/" + STRING(iCol, ">9").
      n840 = 0.0.
      n978 = 0.0.
      n826 = 0.0.

      FOR EACH op-entry
         WHERE CAN-DO("7*15102..", op-entry.acct-cr)
           AND CAN-DO(ENTRY(iAcc, cAcc, "|"), op-entry.acct-db)
           AND op-entry.op-date GE beg-date
           AND op-entry.op-date LE end-date
           AND op-entry.op-status GE '√'
         NO-LOCK:

         IF op-entry.currency = "840" THEN n840 = n840 + op-entry.amt-rub.
         IF op-entry.currency = "978" THEN n978 = n978 + op-entry.amt-rub.
         IF op-entry.currency = "826" THEN n826 = n826 + op-entry.amt-rub.
      END.
      /* вычитаем проводки сторно */
      FOR EACH op-entry
         WHERE CAN-DO("7*15102..", op-entry.acct-db)
           AND CAN-DO(ENTRY(iAcc, cAcc, "|"), op-entry.acct-cr)
           AND op-entry.op-date GE beg-date
           AND op-entry.op-date LE end-date
           AND op-entry.op-status GE '√'
         NO-LOCK:

         IF op-entry.currency = "840" THEN n840 = n840 - op-entry.amt-rub.
         IF op-entry.currency = "978" THEN n978 = n978 - op-entry.amt-rub.
         IF op-entry.currency = "826" THEN n826 = n826 - op-entry.amt-rub.
      END.

      n1S840 = n1S840 + n840.
      n1S978 = n1S978 + n978.
      n1S826 = n1S826 + n826.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 1
         ttItog.tcCurr = "840"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n840
         NO-ERROR.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 1
         ttItog.tcCurr = "978"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n978
         NO-ERROR.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 1
         ttItog.tcCurr = "826"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n826
         NO-ERROR.

      n840 = 0.0.
      n978 = 0.0.
      n826 = 0.0.

      FOR EACH op-entry
         WHERE CAN-DO("7*24102..", op-entry.acct-db)
           AND CAN-DO(ENTRY(iAcc, cAcc, "|"), op-entry.acct-cr)
           AND op-entry.op-date GE beg-date
           AND op-entry.op-date LE end-date
           AND op-entry.op-status GE '√'
         NO-LOCK:

         IF op-entry.currency = "840" THEN n840 = n840 + op-entry.amt-rub.
         IF op-entry.currency = "978" THEN n978 = n978 + op-entry.amt-rub.
         IF op-entry.currency = "826" THEN n826 = n826 + op-entry.amt-rub.
      END.

      /* вычитаем проводки сторно */
      FOR EACH op-entry
         WHERE CAN-DO("7*24102..", op-entry.acct-cr)
           AND CAN-DO(ENTRY(iAcc, cAcc, "|"), op-entry.acct-db)
           AND op-entry.op-date GE beg-date
           AND op-entry.op-date LE end-date
           AND op-entry.op-status GE '√'
         NO-LOCK:

         IF op-entry.currency = "840" THEN n840 = n840 - op-entry.amt-rub.
         IF op-entry.currency = "978" THEN n978 = n978 - op-entry.amt-rub.
         IF op-entry.currency = "826" THEN n826 = n826 - op-entry.amt-rub.
      END.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 2
         ttItog.tcCurr = "840"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n840
         NO-ERROR.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 2
         ttItog.tcCurr = "978"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n978
         NO-ERROR.

      CREATE ttItog.
      ASSIGN
         ttItog.tiSym  = 2
         ttItog.tcCurr = "826"
         ttItog.tiKv   = iKv
         ttItog.tiAcc  = iAcc
         ttItog.tnAmt  = n826
         NO-ERROR.

   END.

END.

/******************************************* Реализация */
PUT UNFORMATTED XLHead("PR", "CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
                       "60, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110").

cXL = XLRow(0)
    + XLCell(cAcc)
    + XLCell("Всего")
    .
DO iAcc = 1 TO iCol:
   cXL = cXL
       + XLCell(ENTRY(iAcc, cSAcc, "|"))
       + XLEmptyCell()
       + XLEmptyCell()
       .
END.
cXL = cXL
    + XLRowEnd()
    + XLRow(0)
    + XLEmptyCell()
    + XLEmptyCell()
    .
DO iAcc = 1 TO iCol:
   cXL = cXL
       + XLCell("USD")
       + XLCell("EUR")
       + XLCell("GBP")
       .
END.

PUT UNFORMATTED cXL XLRowEnd().

/******************************************* Реализация */
DO iSym = 1 TO 2:
   PUT UNFORMATTED XLRow(0) XLCell(IF (iSym EQ 1) THEN "15102" ELSE "24102") XLRowEnd() .

   DO iKv = 1 TO 4:

      cXL = XLCell(STRING(iKv) + "kv." + STRING(iYear))
          + XLFormulaCell("=SUM(RC[1]:RC[" + STRING(3 * iCol) + "])")
          .

      DO iAcc = 1 TO iCol:

         FIND FIRST ttItog
            WHERE (ttItog.tiSym  EQ iSym)
              AND (ttItog.tcCurr EQ "840")
              AND (ttItog.tiKv   EQ iKv)
              AND (ttItog.tiAcc  EQ iAcc)
            NO-ERROR.

	 if not avail (ttItog) then do: message "не могу найти 840" iSym iKv iAcc. pause. end.

         cXL = cXL + XLNumCell(ttItog.tnAmt).

         FIND FIRST ttItog
            WHERE (ttItog.tiSym  EQ iSym)
              AND (ttItog.tcCurr EQ "978")
              AND (ttItog.tiKv   EQ iKv)
              AND (ttItog.tiAcc  EQ iAcc)
            NO-ERROR.

	 if not avail (ttItog) then do: message "не могу найти 978" iSym iKv iAcc. pause. end.

         cXL = cXL + XLNumCell(ttItog.tnAmt).

         FIND FIRST ttItog
            WHERE (ttItog.tiSym  EQ iSym)
              AND (ttItog.tcCurr EQ "826")
              AND (ttItog.tiKv   EQ iKv)
              AND (ttItog.tiAcc  EQ iAcc)
            NO-ERROR.

	 if not avail (ttItog) then do: message "не могу найти 826" iSym iKv iAcc. pause. end.

         cXL = cXL + XLNumCell(ttItog.tnAmt).

      END.

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

   END.

   cXL = XLCell("Итого:").
   DO iAcc = 1 TO (iCol * 3 + 1):
      cXL = cXL + XLFormulaCell("=SUM(R[-4]C:R[-1]C)").
   END.

   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

   cXL = XLEmptyCell() + XLEmptyCell().
   DO iAcc = 1 TO iCol:
      cXL = cXL + XLFormulaCell("=R[-1]C+R[-1]C[1]+R[-1]C[2]") + XLEmptyCell() + XLEmptyCell().
   END.

   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

END.


PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").
{intrface.del}
