{pirsavelog.p}
/** 
   ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Отчет по просроченным овердрафтам.
   Борисов А.В., 10.09.2010
   16.01.2013 - добавила исключение овердравтов в ПОСе. теперь получилось Отчет по просроченным овердрафтам не в ПОС. #2182
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

DEFINE VARIABLE BaiMag    AS LOGICAL INIT NO NO-UNDO.

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

oTable  = new TTable(10).
oTable2 = new TTable(2).

      oTable:addRow().
      oTable:addCell("Номер п/п").
      oTable:addCell("Кредитный договор №, транш №").
      oTable:addCell("Наименование клиента").
      oTable:addCell("Дата выдачи транша").
      oTable:addCell("Дата погашения транша (плановая)").
      oTable:addCell("по основному долгу сч 45815, 45817").
      oTable:addCell("проценты, начисленные на балансе сч 45915, 45917").
      oTable:addCell("проценты, начисленные на внебалансе сч 91604").
      oTable:addCell("Категория качества").
      oTable:addCell("Дата вынесения на просрочку").
      oTable:setBorder(1,oTable:height,1,0,0,1).
      oTable:setBorder(2,oTable:height,1,0,0,1).
      oTable:setBorder(3,oTable:height,1,0,0,1).
      oTable:setBorder(4,oTable:height,1,0,0,1).
      oTable:setBorder(5,oTable:height,1,0,0,1).
      oTable:setBorder(9,oTable:height,1,0,0,1).
      oTable:setBorder(10,oTable:height,1,0,1,1).
      oTable:setAlign(1,1,"center").
      oTable:setAlign(2,1,"center").
      oTable:setAlign(3,1,"center").
      oTable:setAlign(4,1,"center").
      oTable:setAlign(5,1,"center").
      oTable:setAlign(6,1,"center").
      oTable:setAlign(7,1,"center").
      oTable:setAlign(8,1,"center").
      oTable:setAlign(9,1,"center").
      oTable:setAlign(10,1,"center").

FOR EACH loan
   WHERE loan.class-code  EQ "l_agr_with_diff"
     AND (loan.contract    EQ 'Кредит')
     AND (loan.doc-ref     NE "ПК-002/04")
     AND (loan.doc-ref     NE "ПК-025/05")
     AND (loan.open-date   LE end-date)
     AND ((loan.close-date GE end-date)
       OR (loan.close-date EQ ?))
   NO-LOCK:

   find first term-obl where term-obl.cont-code eq loan.cont-code and term-obl.idnt = 128 /*не ПОС*/ 
		and term-obl.contract eq "Кредит" and (term-obl.sop-date eq ? or term-obl.sop-date GT end-date) NO-LOCK no-error.
   if not avail (term-obl) then do:        

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
   end.
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

      dSumP7  = 0.0.
      dSumP10 = 0.0.
      dSumP48 = 0.0.

        IF (ttPk.cCurr EQ "840") OR (NOT CAN-FIND(first ttPk WHERE ttPk.cCurr EQ "840") and NOT BaiMag and LAST-OF(ttPK.cCurr)) THEN DO:

        BaiMag =  YES.

      /* При погашении Брызгаловым или Баймагамбетовым править суммы в 3-х местах:
         1. Транш, 2. Итого по клиенту, 3. Начальное значение dSumP7                 */

      iI = iI + 1.

      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 1").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("29.08.2006").
      oTable:addCell("13.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,242.68,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("13.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 2").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("30.08.2006").
      oTable:addCell("14.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,492.84,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("16.10.2006").

      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 3").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("31.08.2006").
      oTable:addCell("14.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,391.41,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("16.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 4").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("01.09.2006").
      oTable:addCell("16.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,500.04,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("16.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 5").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("04.09.2006").
      oTable:addCell("19.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,812.01,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("19.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 6").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("05.09.2006").
      oTable:addCell("20.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,335.07,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("20.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 7").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("06.09.2006").
      oTable:addCell("21.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,10.37,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("23.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 8").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("11.09.2006").
      oTable:addCell("26.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,197.85,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("26.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 9").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("14.09.2006").
      oTable:addCell("29.10.2006").
      oTable:addCell(oSysClass:convert2rur(840,59.62,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("29.10.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 10").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("18.09.2006").
      oTable:addCell("02.11.2006").
      oTable:addCell(oSysClass:convert2rur(840,35.81,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("02.11.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 11").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("19.09.2006").
      oTable:addCell("03.11.2006").
      oTable:addCell(oSysClass:convert2rur(840,210.33,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("03.11.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 12").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("22.09.2006").
      oTable:addCell("06.11.2006").
      oTable:addCell(oSysClass:convert2rur(840,119,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("07.11.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 13").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("25.09.2006").
      oTable:addCell("09.11.2006").
      oTable:addCell(oSysClass:convert2rur(840,26.38,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
      oTable:addCell("09.11.2006").


      oTable:addRow().
      oTable:addCell(string(iI)).
      oTable:addCell("ПК-025/05 14").
      oTable:addCell("Баймагамбетов А.Х.").
      oTable:addCell("27.09.2006").
      oTable:addCell("11.11.2006").
      oTable:addCell(oSysClass:convert2rur(840,122.92,end-date)).
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell("5").
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
	oTable:addCell(" ").
	oTable:addCell("Итого по клиенту   Баймагамбетов А.Х. составляет").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(dSumP7).
	oTable:addCell("0.00").
	oTable:addCell("0.00 ").
	oTable:addCell(" ").
	oTable:addCell(" ").

/*
        oTable:addRow().
	oTable:addCell(" ").
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
	oTable:addCell(" ").
	oTable:addCell("Срочная задолженность клиента Баймагамбетов А.Х. составляет").
	oTable:addCell(" ").
	oTable:addCell("0.00").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
	oTable:addCell(" ").
*/
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
      oTable:addCell(string(iI)).
      oTable:addCell(ttTr.cNDog).
      oTable:addCell(ttPK.cClName + getAsterix(ttPk.cCurr)).
      oTable:addCell(ttTr.daKr).
      oTable:addCell(ttTr.daKr + 45).
      oTable:addCell(ttTr.dSumm7).
      oTable:addCell(ttTr.dSumm10).
      oTable:addCell(ttTr.dSumm48).
      oTable:addCell(grrisk).
      oTable:addCell(ttTr.daPr).

   END.

    oTable:addRow().
      oTable:addCell("").
      oTable:addCell(" ").
      oTable:addCell("Итого по " + ttPK.cClName + " составляет").
      oTable:addCell("").
      oTable:addCell("").
      oTable:addCell(ttPK.dSumm7).
      oTable:addCell(ttPk.dSumm10).
      oTable:addCell(ttPk.dSumm48).
      oTable:addCell("").
      oTable:addCell("").
END.

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("CURRDATE",daOtch).
{setdest.i &cols=140}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oSysClass.
{tpl.delete}
{intrface.del}
