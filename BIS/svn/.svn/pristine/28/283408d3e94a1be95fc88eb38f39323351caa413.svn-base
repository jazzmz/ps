{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Отчет по просроченным овердрафтам.
   Борисов А.В., 10.09.2010
*/

{globals.i}           /* Глобальные определения */
{intrface.get i254}
{lshpr.pro}           /* Инструменты для расчета параметров договора */
{sh-defs.i}
{ulib.i}
{pir-gp.i}
/******************************************* Определение переменных и др. */

DEFINE VARIABLE dSumm     AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE dSRisk    AS DECIMAL   EXTENT  6 NO-UNDO INIT 0.
DEFINE VARIABLE grrisk    AS INT64   NO-UNDO.
DEFINE VARIABLE prrisk    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iI        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lProsr    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE daTmp     AS DATE      NO-UNDO.
DEFINE VARIABLE dT1       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dT2       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE daOtch    AS DATE      NO-UNDO.
DEFINE VARIABLE dP0       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP2       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP7       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP10      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP48      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP0    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP7    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP10   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP48   AS DECIMAL INIT 0 NO-UNDO.

DEF VAR dP29              AS DECIMAL   NO-UNDO.
DEF VAR dSumP29           AS DECIMAL   NO-UNDO.

DEF VAR oTable     AS TTable    NO-UNDO.
DEF VAR oTable2    AS TTable    NO-UNDO.

DEF VAR oSysClass AS TSysClass NO-UNDO.


oSysClass = new TSysClass().



DEFINE BUFFER   transh    FOR loan.

DEFINE TEMP-TABLE ttTr NO-UNDO
   FIELD cNDog    AS CHARACTER
   FIELD dSumm7   AS DECIMAL
   FIELD dSumm10  AS DECIMAL
   FIELD dSumm48  AS DECIMAL
   FIELD daKr    AS DATE
   FIELD daPr    AS DATE
.
DEFINE TEMP-TABLE ttPK NO-UNDO
   FIELD cNDog   AS CHARACTER
   FIELD cCurr   AS CHARACTER
   FIELD dProc   AS DECIMAL
   FIELD iGrRisk AS INTEGER
   FIELD dSumm0  AS DECIMAL
   FIELD dSumm7  AS DECIMAL
   FIELD dSumm10 AS DECIMAL
   FIELD dSumm48 AS DECIMAL
   FIELD cClName AS CHARACTER
   FIELD iClID   AS INTEGER
.

/*** Реализация ***/
{getdate.i}
daOtch   = end-date.
end-date = end-date - 1.

DO WHILE holiday(end-date):
   end-date = end-date - 1.
END.


{tpl.create}
/****************************************************** */

FUNCTION getAsterix RETURNS CHARACTER(INPUT cVal AS CHARACTER):

  CASE cVal:
     WHEN "USD" THEN RETURN "*".
     WHEN "840" THEN RETURN "*".

     WHEN "EUR" THEN RETURN "*".
     WHEN "978" THEN RETURN "*".
     OTHERWISE       RETURN "".
  END CASE.


END FUNCTION.

FUNCTION getFirstOper RETURNS DATE(INPUT id-d AS INT64,INPUT id-k AS INT64,INPUT cDoc-Ref AS CHARACTER):
	DEF BUFFER loan-int FOR loan-int.

         FIND FIRST loan-int
            WHERE (loan-int.cont-code EQ cDoc-Ref)
              AND (loan-int.contract  EQ 'Кредит')
              AND (loan-int.id-d      EQ id-d)
              AND (loan-int.id-k      EQ id-k)
            NO-LOCK NO-ERROR.

         RETURN	IF AVAILABLE(loan-int) THEN  loan-int.mdate ELSE ?.

END FUNCTION.

oTable  = new TTable(9).
oTable2 = new TTable(2).

FOR EACH loan
   WHERE loan.class-code  EQ "l_agr_with_diff"
     AND (loan.contract    EQ 'Кредит')
     AND (loan.doc-ref     NE "ПК-002/04")
     AND (loan.doc-ref     NE "ПК-025/05")
     AND (loan.open-date   LE end-date)
     AND ((loan.close-date GE end-date)
       OR (loan.close-date EQ ?))
   NO-LOCK:


   lProsr  = NO.
   dSumP0  = 0.0.
   dSumP7  = 0.0.
   dSumP10  = 0.0.
   dSumP48  = 0.0.

   FOR EACH transh
      WHERE transh.class-code  EQ "loan_trans_diff"
        AND (transh.contract    EQ 'Кредит')
        AND (transh.doc-ref     BEGINS loan.doc-ref)
        AND (transh.open-date   LE end-date)
        AND ((transh.close-date GE end-date)
          OR (transh.close-date EQ ?))
      NO-LOCK:



      dP0  = oSysClass:convert2rur(INT(transh.currency),getRsrvBase(transh.cont-code,end-date,"debt"),end-date).
      dP7  = oSysClass:convert2rur(INT(transh.currency),getRsrvBase(transh.cont-code,end-date,"baddebt"),end-date).
      dP10 = oSysClass:convert2rur(INT(transh.currency),getRsrvBase(transh.cont-code,end-date,"bad%"),end-date).
      dP48 = oSysClass:convert2rur(INT(transh.currency),getParam(transh.cont-code,48,end-date),end-date).

      dSump10 = dSump10 + dP10.
      dSumP0  = dSumP0  + dP0.
      dSumP7  = dSumP7  + dP7.

      /*******************
       * По заявке #896  *
       * Маслов Д. А.    *
       *******************/
      dSumP48 = dSumP48 + dP48.      


      IF (dP7 NE 0.0)
      THEN DO:

         lProsr = YES.
         CREATE ttTr.
         ASSIGN
            ttTr.cNDog  = transh.doc-ref
            ttTr.dSumm7 = dP7
	    ttTr.dSumm10 = dP10
	    ttTr.dSumm48 = dP48
            NO-ERROR.

               ttTr.daKr   = getFirstOper(0,3,transh.doc-ref).
               ttTr.daPr   = getFirstOper(7,0,transh.doc-ref).

      END.
   END.

   IF lProsr
   THEN DO:
      CREATE ttPK.

      FIND FIRST person
         WHERE (person.person-id EQ loan.cust-id)
         NO-LOCK NO-ERROR.


      ASSIGN
         ttPK.cNDog   = loan.doc-ref
         ttPK.cCurr   = loan.currency
         ttPK.iGrRisk = LnGetGrRiska(LnRsrvRate(loan.contract, loan.cont-code, end-date), end-date)
         ttPK.dProc   = GetCredLoanCommission_ULL(loan.doc-ref, "%Кред", end-date, NO) * 100
         ttPK.dSumm0  = dSumP0
         ttPK.dSumm7  = dSumP7
         ttPK.dSumm10 = dSumP10
         ttPK.dSumm48 = dSumP48
         ttPK.iClID   = loan.cust-id
         ttPK.cClName = IF AVAIL person
                        THEN (person.name-last + " "
                            + SUBSTRING(ENTRY(1, person.first-names, " "), 1, 1) + "."
                            + SUBSTRING(ENTRY(2, person.first-names, " "), 1, 1) + ".")
                        ELSE ""
         NO-ERROR.
   END.
END.


FOR EACH ttPK
   NO-LOCK
   BREAK BY ttPK.cCurr
   BY ttPK.cNDog:

   IF FIRST-OF(ttPK.cCurr)
   THEN DO:
      /*************************************
       * Обнуляем счетчики по каждой	   *
       * из валют.			   *
       *************************************
       * Автор: Маслов Д. А. Maslov D. A.  *
       * Заявка: #945			   *
       *************************************/

      iI      = 0.
      dSumP7  = 0.0.
      dSumP10 = 0.0.
      dSumP48 = 0.0.

        IF ttPk.cCurr EQ "840" THEN DO:

      /* При погашении Брызгаловым или Баймагамбетовым править суммы в 3-х местах:
         1. Транш, 2. Итого по клиенту, 3. Начальное значение dSumP7                 */


      oTable:addRow().
      oTable:addCell("1").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("29.08.2006").
      oTable:addCell(oSysClass:convert2rur(840,242.68,end-date)).
      oTable:addCell("13.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("13.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("30.08.2006").
      oTable:addCell(oSysClass:convert2rur(840,492.84,end-date)).
      oTable:addCell("14.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("16.10.2006").

      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("31.08.2006").
      oTable:addCell(oSysClass:convert2rur(840,391.41,end-date)).
      oTable:addCell("14.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("16.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("01.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,500.04,end-date)).
      oTable:addCell("16.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("16.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("04.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,812.01,end-date)).
      oTable:addCell("19.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("19.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("05.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,335.07,end-date)).
      oTable:addCell("20.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("20.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("06.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,10.37,end-date)).
      oTable:addCell("21.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("23.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("11.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,197.85,end-date)).
      oTable:addCell("26.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("26.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("14.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,59.62,end-date)).
      oTable:addCell("29.10.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("29.10.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("18.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,35.81,end-date)).
      oTable:addCell("02.11.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("02.11.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("19.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,210.33,end-date)).
      oTable:addCell("03.11.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("03.11.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("22.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,119,end-date)).
      oTable:addCell("06.11.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("07.11.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("25.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,26.38,end-date)).
      oTable:addCell("09.11.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("09.11.2006").


      oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("27.09.2006").
      oTable:addCell(oSysClass:convert2rur(840,122.92,end-date)).
      oTable:addCell("11.11.2006").
      oTable:addCell("5").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("13.11.2006").


	dSumP7 = oSysClass:convert2rur(840,242.68,end-date) 
		+ oSysClass:convert2rur(840,492.84,end-date)
		+ oSysClass:convert2rur(840,391.41,end-date)
	        + oSysClass:convert2rur(840,500.04,end-date)
	        + oSysClass:convert2rur(840,812.01,end-date)
	        + oSysClass:convert2rur(840,335.07,end-date)
	        + oSysClass:convert2rur(840,10.37,end-date)
	        + oSysClass:convert2rur(840,197.85,end-date)
	        + oSysClass:convert2rur(840,59.62,end-date)
	        + oSysClass:convert2rur(840,35.81,end-date)
	        + oSysClass:convert2rur(840,210.33,end-date)
	        + oSysClass:convert2rur(840,119,end-date)
	        + oSysClass:convert2rur(840,26.38,end-date)
	        + oSysClass:convert2rur(840,122.92,end-date).



        oTable:addRow().
	oTable:addCell(" ").
	oTable:addCell("Просроченная задолженность по клиенту Баймагамбетов А.Х. составляет").
	oTable:addCell(" ").
	oTable:addCell(dSumP7).
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").


        oTable:addRow().
	oTable:addCell(" ").
	oTable:addCell("Просроченные %% по клиенту Баймагамбетов А.Х. составляют").
	oTable:addCell(" ").
	oTable:addCell("0.00").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").


        oTable:addRow().
	oTable:addCell(" ").
	oTable:addCell("Срочная задолженность клиента Баймагамбетов А.Х. составляет").
	oTable:addCell(" ").
	oTable:addCell("0.00").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").



        iI = iI + 1.
        END.
   END.


                               

   iI      = iI + 1.
   dSumP7  = dSumP7  + ttPK.dSumm7.
   dSumP10 = dSumP10 + ttPK.dSumm10.
   dSumP48 = dSumP48 + ttPk.dSumm48.

   FOR EACH ttTr
      WHERE (ttTr.cNDog BEGINS ttPK.cNDog)
      NO-LOCK
      BREAK BY ttTr.cNDog:


      grrisk = ( IF LnInBagOnDate("Кредит",ttTr.cNDog,end-date) NE ? THEN PsGetGrRiska(LnRsrvRate("Кредит", ttTr.cNDog, end-date),"Ч",end-date) ELSE LnGetGrRiska(LnRsrvRate("Кредит", ttTr.cNDog, end-date), end-date)).

      oTable:addRow().
      oTable:addCell(IF FIRST(ttTr.cNDog) THEN STRING(iI, ">9") ELSE "  ").
      oTable:addCell(ttPK.cClName + getAsterix(ttPk.cCurr)).
      oTable:addCell(ttTr.daKr).
      oTable:addCell(ttTr.dSumm7).
      oTable:addCell(ttTr.daKr + 45).
      oTable:addCell(grrisk).
      oTable:addCell(ttTr.dSumm10).
      oTable:addCell(ttTr.dSumm48).
      oTable:addCell(ttTr.daPr).

   END.

    oTable:addRow().
      oTable:addCell("").
      oTable:addCell("Итого по " + ttPK.cClName + " составляет").
      oTable:addCell("").
      oTable:addCell(ttPK.dSumm7).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell(ttPk.dSumm10).
      oTable:addCell(ttPk.dSumm48).
      oTable:addCell("").





   IF LAST-OF(ttPK.cCurr)
   THEN DO:
      oTable2:addRow().
      oTable2:addCell("Итого 45915 по " + ttPk.cCurr).
      oTable2:addCell(dSumP10).

      oTable2:addRow().
        oTable2:addCell("Итого 45815 по " + ttPk.cCurr).
	oTable2:addCell(STRING(dSumP7)).

      oTable2:addRow().
        oTable2:addCell("Итого 91316 по " + ttPk.cCurr).
	oTable2:addCell(STRING(dSumP48)).

   END.

END.

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("TABLE2",oTable2).
oTpl:addAnchorValue("CURRDATE",daOtch).
{tpl.show}

DELETE OBJECT oTable.
DELETE OBJECT oTable2.
DELETE OBJECT oSysClass.
{tpl.delete}
{intrface.del}
