{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Баланс для ликвидности (Маршева).
                Борисов А.В., 28.08.2009
*/

{globals.i}           /** Глобальные определения */
{sh-defs.i}

{getdate.i}
{setdest.i}

DEFINE VARIABLE cListUl  AS  CHARACTER
   INIT "30109,40502,40602,40701,40702,40703,40802,40804,40805,40807,40814,40815,47405,47407,47416,42501" NO-UNDO.
DEFINE VARIABLE cListFl  AS  CHARACTER
   INIT "40813,40817,40820,42301,42309,42601,42609" NO-UNDO.
DEFINE VARIABLE iI       AS  INTEGER   NO-UNDO.
DEFINE VARIABLE dI       AS  DECIMAL   NO-UNDO.
DEFINE VARIABLE dItog    AS  DECIMAL  EXTENT 6  NO-UNDO.

/************************************************************/
FUNCTION acct-bal RETURNS DECIMAL
   (INPUT icBal AS INTEGER,
    INPUT icCur AS CHARACTER,
    INPUT idDat AS DATE):

   DEFINE VARIABLE dSumm AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE cTmp  AS CHARACTER NO-UNDO.

   dSumm = 0.0.
   FOR EACH acct
      WHERE (acct.bal-acct EQ icBal)
        AND (acct.currency EQ icCur)
      NO-LOCK:

      RUN acct-pos IN h_base(acct.acct, acct.currency, idDat, idDat, cTmp).
      dSumm = dSumm + ABS(IF (icCur EQ "") THEN sh-in-bal ELSE sh-in-val).
   END.

   RETURN dSumm.
END.

/************************************************************/

PUT UNFORMATTED
   "      " STRING(end-date, "99.99.9999")
   "           Рубли                  USD                  EUR" SKIP(1).

DO iI = 1 TO NUM-ENTRIES(cListUl):
   PUT UNFORMATTED
      (IF (iI EQ 1) THEN "Юрики    " ELSE "         ")
      ENTRY(iI, cListUl).
   dI = acct-bal(INTEGER(ENTRY(iI, cListUl)), "", end-date).
   dItog[1] = dItog[1] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99".

   dI = acct-bal(INTEGER(ENTRY(iI, cListUl)), "840", end-date).
   dItog[2] = dItog[2] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99".

   dI = acct-bal(INTEGER(ENTRY(iI, cListUl)), "978", end-date).
   dItog[3] = dItog[3] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99" SKIP.
END.

PUT UNFORMATTED
   "        Итого:"
   dItog[1] FORMAT ">>>>>>,>>>,>>>,>>9.99"
   dItog[2] FORMAT ">>>>>>,>>>,>>>,>>9.99"
   dItog[3] FORMAT ">>>>>>,>>>,>>>,>>9.99" SKIP(2).

DO iI = 1 TO NUM-ENTRIES(cListFl):
   PUT UNFORMATTED
      (IF (iI EQ 1) THEN "Физики   " ELSE "         ")
      ENTRY(iI, cListFl).
   dI = acct-bal(INTEGER(ENTRY(iI, cListFl)), "", end-date).
   dItog[4] = dItog[4] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99".

   dI = acct-bal(INTEGER(ENTRY(iI, cListFl)), "840", end-date).
   dItog[5] = dItog[5] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99".

   dI = acct-bal(INTEGER(ENTRY(iI, cListFl)), "978", end-date).
   dItog[6] = dItog[6] + dI.
   PUT UNFORMATTED
      dI FORMAT ">>>>>>,>>>,>>>,>>9.99" SKIP.
END.

PUT UNFORMATTED
   "        Итого:"
   dItog[4] FORMAT ">>>>>>,>>>,>>>,>>9.99"
   dItog[5] FORMAT ">>>>>>,>>>,>>>,>>9.99"
   dItog[6] FORMAT ">>>>>>,>>>,>>>,>>9.99" SKIP(2).

PUT UNFORMATTED
   "Баланс  Всего:"
   (dItog[1] + dItog[4]) FORMAT ">>>>>>,>>>,>>>,>>9.99"
   (dItog[2] + dItog[5]) FORMAT ">>>>>>,>>>,>>>,>>9.99"
   (dItog[3] + dItog[6]) FORMAT ">>>>>>,>>>,>>>,>>9.99" SKIP.

{preview.i}
