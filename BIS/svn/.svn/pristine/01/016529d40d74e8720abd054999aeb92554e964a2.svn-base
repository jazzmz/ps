/*********************************************
 * Отчет по резервам.			     *
 * Включает в себя:			     *
 *  1. Резерв на срочную задолженность;      *
 *  2. Резерв на неисп. линию;               *
 *  2. Резерв на нач. %.                     *
 *                                           *
 *********************************************
 *                                           *
 * Автор: Маслов Д. А. Maslov D. A.          *
 * Дата создания: 19.01.2012                 *
 * Заявка:                                   *
 *                                           *
 *********************************************/

{globals.i}
{intrface.get loan}
{intrface.get i254}
{intrface.get bag}
{intrface.get tmess}

DEF INPUT PARAMETER param1 AS CHARACTER NO-UNDO.

DEF VAR oTableRur    AS TTable    NO-UNDO.
DEF VAR oTableUsd    AS TTable    NO-UNDO.
DEF VAR oTableEur    AS TTable    NO-UNDO.
DEF VAR oTableAcct   AS TTable    NO-UNDO.
DEF VAR oTableOvp   AS TTable    NO-UNDO.

DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oClient   AS TClient   NO-UNDO.

DEF VAR p0       AS DECIMAL NO-UNDO.
DEF VAR p2       AS DECIMAL NO-UNDO.
DEF VAR p7       AS DECIMAL NO-UNDO.
DEF VAR p10      AS DECIMAL NO-UNDO.
DEF VAR p21      AS DECIMAL NO-UNDO.
DEF VAR p19      AS DECIMAL NO-UNDO.
DEF VAR p88      AS DECIMAL NO-UNDO.
DEF VAR p33      AS DECIMAL NO-UNDO.
DEF VAR p35      AS DECIMAL NO-UNDO.
DEF VAR p46      AS DECIMAL NO-UNDO.
DEF VAR p350     AS DECIMAL NO-UNDO.
DEF VAR p351     AS DECIMAL NO-UNDO.
DEF VAR line     AS DECIMAL NO-UNDO.

DEF VAR kr       AS DECIMAL INIT 0.015 NO-UNDO.
DEF VAR posName  AS CHARACTER 	       NO-UNDO.

DEF VAR currDate AS DATE 		 NO-UNDO.
DEF VAR GoodDebtReserv AS DECIMAL INIT 0 NO-UNDO.
DEF VAR GoodPrReserv   AS DECIMAL INIT 0 NO-UNDO.

DEF VAR BadDebtReserv  AS DECIMAL  INIT 0 NO-UNDO.
DEF VAR BadPrReserv    AS DECIMAL  INIT 0 NO-UNDO.


DEF VAR kEur     AS DECIMAL NO-UNDO.
DEF VAR kUsd     AS DECIMAL NO-UNDO.


DEF VAR debt          AS DECIMAL NO-UNDO.
DEF VAR baddebt       AS DECIMAL NO-UNDO.
DEF VAR pr            AS DECIMAL NO-UNDO.
DEF VAR badpr         AS DECIMAL NO-UNDO.
DEF VAR rcalc         AS DECIMAL NO-UNDO.

DEF VAR oa AS TAArray NO-UNDO.
DEF VAR itog AS INT INIT 1 NO-UNDO.

DEF VAR oAcct AS TAcct NO-UNDO.
DEF VAR vFlag AS LOGICAL NO-UNDO.

DEF VAR cVariants AS CHAR INIT "Охватывающий,Транш" NO-UNDO.
DEF VAR classes   AS CHAR                           NO-UNDO.

posName = param1.

{getdate.i}
currDate = end-date.

oa = new TAArray().


{tmprecid.def}
{tpl.create}

FUNCTION getParam RETURNS DECIMAL(INPUT loanNum AS CHARACTER,INPUT p AS INT,INPUT dDate AS DATE):

	DEF VAR vRes     AS DECIMAL NO-UNDO.
	DEF VAR vDbOpDec AS DECIMAL NO-UNDO.
	DEF VAR vCrOpDec AS DECIMAL NO-UNDO.

RUN STNDRT_PARAM (
        "Кредит",                 /* Назначение договора */
        loanNum,                  /* Номер договора */
        p,                        /* Код параметра  */
        dDate,                    /* Значение параметра на дату состояния договора */
        OUTPUT vRes,              /* Значение параметра без loan.interest[i] */
        OUTPUT vDbOpDec,          /* Е дб операций (не используется) */
        OUTPUT vCrOpDec).         /* Е кр операций (не используется) */

  RETURN vRes.
END FUNCTION.

/*******************
 * Заполняет пустыми столбцами
 * поля таблицы.
 *******************/
FUNCTION fillRow RETURNS LOGICAL(INPUT oTable AS TTable,INPUT iCols AS INTEGER):

	DEF VAR i AS INTEGER NO-UNDO.

	DO i = 1 TO iCols:
		oTable:addCell("").
	END.

END FUNCTION.

oSysClass = new TSysClass().

oTableRur    = new TTable(17).
oTableUsd    = new TTable(17).
oTableEur    = new TTable(17).
oTableAcct   = new TTable(3).

oTableUsd:colsVisibleList="1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1".

/***************************
 * Получаем курсы.         *
 ***************************/
kUsd = oSysClass:getCBRKurs(840,currDate).
kEur = oSysClass:getCBRKurs(978,currDate).

RUN Fill-SysMes IN h_tmess ("","",3,"Выберите тип договоров|" + cVariants).

classes = ENTRY(INT(pick-value),cVariants,",").

CASE classes:
   WHEN "Охватывающий" THEN DO:
     classes = "l_agr_with_diff".
   END.
   WHEN "Транш" THEN DO:
     classes = "loan_trans_diff".
   END.
END CASE.


FOR EACH loan WHERE loan.contract = "Кредит" AND loan.class-code = classes 
	        AND (loan.close-date >= currDate OR loan.close-date = ?) NO-LOCK,
 LAST term-obl WHERE term-obl.contract EQ "Кредит" 
		 AND term-obl.cont-code EQ loan.cont-code 
		 AND term-obl.idnt EQ 128 
		 AND term-obl.end-date <= currDate 
		 AND (term-obl.sop-date >= currDate OR term-obl.sop-date = ?) 
		 AND term-obl.lnk-cont-code EQ posName
		NO-LOCK BREAK BY term-obl.lnk-cont-code BY ENTRY(1,loan.cont-code," ") BY ENTRY(1,loan.cont-code," "):


   kr = LnRsrvRate("Кредит",loan.cont-code,currDate) / 100.

   oClient = new TClient(loan.cust-cat,loan.cust-id).

/* Линия */
        p19 = getParam(loan.cont-code,19,currDate).
        p88 = ABS(getParam(loan.cont-code,88,currDate)).
	line = p19.

/* Срочная задолженность */
	p0   = getParam(loan.cont-code,0,currDate).
	p2   = getParam(loan.cont-code,2,currDate).
        p21  = ABS(getParam(loan.cont-code,21,currDate)).
	debt = p0 + p2.

/* Проценты */
        p33  = getParam(loan.cont-code,33,currDate).
        p35  = getParam(loan.cont-code,35,currDate).
        p350 = ABS(getParam(loan.cont-code,350,currDate)).
        pr   = p33 + p35.

/* Просроченная ссуда */
       p7      = getParam(loan.cont-code,7,currDate).
       p46     = ABS(getParam(loan.cont-code,46,currDate)).
       baddebt = p7.

/* Просроченные % */
       p10   = getParam(loan.cont-code,10,currDate).
       p351  = ABS(getParam(loan.cont-code,351,currDate)).
       badpr = p10.


CASE loan.currency:
   WHEN "840" THEN DO:
	oTableUsd:addRow().
	oTableUsd:addCell(loan.cont-code).
	oTableUsd:addCell(oClient:name-short).

	line  = ROUND(line * kUsd,2).
	rcalc = ROUND(line * kr,2).

	oTableUsd:addCell(line).
	oTableUsd:addCell(p88).
	oTableUsd:addCell(rcalc).

	debt  = ROUND(debt * kUsd,2).
	rcalc = ROUND(debt * kr,2).
	oTableUsd:addCell(debt).
	oTableUsd:addCell(p21).
	oTableUsd:addCell(rcalc).
        GoodDebtReserv = GoodDebtReserv + rcalc.

	pr  = ROUND(pr * kUsd,2).
	rcalc = ROUND(pr * kr,2).
	oTableUsd:addCell(pr).
	oTableUsd:addCell(p350).
	oTableUsd:addCell(rcalc).
        GoodPrReserv = GoodPrReserv + rcalc.

	baddebt = ROUND(baddebt * kUsd,2).
	rcalc   = ROUND(baddebt * kr,2).
	oTableUsd:addCell(baddebt).
	oTableUsd:addCell(p46).
	oTableUsd:addCell(rcalc).
	BadDebtReserv = BadDebtReserv + rcalc.

	badpr   = ROUND(badpr * kUsd,2).
	rcalc   = ROUND(badpr * kr,2).
	oTableUsd:addCell(badpr).
	oTableUsd:addCell(p351).
	oTableUsd:addCell(rcalc).
	BadPrReserv = BadPrReserv + rcalc.
   END.
   WHEN "978" THEN DO:

	oTableEur:addRow().
	oTableEur:addCell(loan.cont-code).
	oTableEur:addCell(oClient:name-short).

	line  = ROUND(line * kEur,2).
	rcalc = ROUND(line * kr,2).

	oTableEur:addCell(line).
	oTableEur:addCell(p88).
	oTableEur:addCell(rcalc).

	debt  = ROUND(debt * kEur,2).
	rcalc = ROUND(debt * kr,2).
	oTableEur:addCell(debt).
	oTableEur:addCell(p21).
	oTableEur:addCell(rcalc).
        GoodDebtReserv = GoodDebtReserv + rcalc.

	pr  = ROUND(pr * kEur,2).
	rcalc = ROUND(pr * kr,2).
	oTableEur:addCell(pr).
	oTableEur:addCell(p350).
	oTableEur:addCell(rcalc).
        GoodPrReserv = GoodPrReserv + rcalc.

	baddebt = ROUND(baddebt * kEur,2).
	rcalc   = ROUND(baddebt * kr,2).
	oTableEur:addCell(baddebt).
	oTableEur:addCell(p46).
	oTableEur:addCell(rcalc).
	BadDebtReserv = BadDebtReserv + rcalc.

	badpr   = ROUND(badpr * kUsd,2).
	rcalc   = ROUND(badpr * kr,2).
	oTableEur:addCell(badpr).
	oTableEur:addCell(p351).
	oTableEur:addCell(rcalc).
	BadPrReserv = BadPrReserv + rcalc.

   END.
   OTHERWISE DO:
	oTableRur:addRow().
	oTableRur:addCell(loan.cont-code).
	oTableRur:addCell(oClient:name-short).

	rcalc = ROUND(line * kr,2).
	oTableRur:addCell(line).
	oTableRur:addCell(p88).
	oTableRur:addCell(rcalc).

	rcalc = ROUND(debt * kr,2).
	oTableRur:addCell(debt).
	oTableRur:addCell(p21).
	oTableRur:addCell(rcalc).
        GoodDebtReserv = GoodDebtReserv + rcalc.

	rcalc = ROUND(pr * kr,2).
	oTableRur:addCell(pr).
	oTableRur:addCell(p350).
	oTableRur:addCell(rcalc).
        GoodPrReserv = GoodPrReserv + rcalc.

	rcalc   = ROUND(baddebt * kr,2).
	oTableRur:addCell(baddebt).
	oTableRur:addCell(p46).
	oTableRur:addCell(rcalc).
        BadDebtReserv = BadDebtReserv + rcalc.

	rcalc   = ROUND(badpr * kr,2).
	oTableRur:addCell(badpr).
	oTableRur:addCell(p351).
	oTableRur:addCell(rcalc).
        BadPrReserv = BadPrReserv + rcalc.
   END.
END CASE.

DELETE OBJECT oClient.
itog = itog + 1.
END. /* for tmprecid */

RUN GetAcctByPos (loan.contract,loan.cont-code,currDate,posName,(TEMP-TABLE ttPosAcct:HANDLE),NO,OUTPUT vFlag).

FOR EACH ttPosAcct:
oTableAcct:addRow().
oTableAcct:addCell(ttPosAcct.acct-type).
oTableAcct:addCell(ttPosAcct.acct).

oAcct = new TAcct(ttPosAcct.acct).
	oTableAcct:addCell(oAcct:getLastPos2Date(currDate)).
DELETE OBJECT oAcct.
END.

/*
IF oTableRur:height=0 AND oTableUsd:height=0 AND oTableEur:height=0 THEN DO:
  oTpl:addAnchorValue("TABLE1","*** ПОРТФЕЛЬ ПУСТ ***").
  oTpl:addAnchorValue("TABLE2","*** ПОРТФЕЛЬ ПУСТ ***").
  oTpl:addAnchorValue("TABLE3","*** ПОРТФЕЛЬ ПУСТ ***").
END.
 ELSE DO:
*/
	oTpl:addAnchorValue("kUsd",kUsd).
	oTpl:addAnchorValue("kEur",kEur).
	oTpl:addAnchorValue("TABLE1",oTableRur).
	oTpl:addAnchorValue("TABLE2",oTableUsd).
	oTpl:addAnchorValue("TABLE3",oTableEur).

	oTpl:addAnchorValue("currDate",currDate).

	oTpl:addAnchorValue("itog",itog).
	oTpl:addAnchorValue("kr",kr).
	oTpl:addAnchorValue("posName",posName).
	oTableRur:showItog = TRUE.
	oTableUsd:showItog = TRUE.
	oTableEur:showItog = TRUE.
	oTpl:addAnchorValue("acct",oTableAcct).
/*
END.*/

	oTpl:addAnchorValue("GoodDebtReserv",GoodDebtReserv).
	oTpl:addAnchorValue("GoodPrReserv",GoodPrReserv).
	oTpl:addAnchorValue("BadDebtReserv",BadDebtReserv).
	oTpl:addAnchorValue("BadPrReserv",BadPrReserv).


{setdest.i}
{tpl.show}
DELETE OBJECT oSysClass.
DELETE OBJECT oTableRur.
DELETE OBJECT oTableUsd.
DELETE OBJECT oTableEur.
DELETE OBJECT oTableAcct.
DELETE OBJECT oa.
DELETE OBJECT oAcct.
{tpl.delete}
{intrface.del}