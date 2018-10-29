{bislogin.i}
{globals.i}
{intrface.get loan}


DEF VAR oClient  AS TClient              NO-UNDO.
DEF VAR oTable   AS TTable               NO-UNDO.
DEF VAR currDate AS DATE INIT 01/13/2012 NO-UNDO.
DEF VAR dSum     AS DECIMAL INIT 0       NO-UNDO.
DEF VAR dR254    AS DECIMAL INIT 0       NO-UNDO.
DEF VAR dPrG     AS DECIMAL INIT 0       NO-UNDO.
DEF VAR dRPrG    AS DECIMAL INIT 0       NO-UNDO.

DEF VAR dPrB     AS DECIMAL INIT 0       NO-UNDO.
DEF VAR dRPrB    AS DECIMAL INIT 0       NO-UNDO.

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

oTable = new TTable(7).

FOR EACH loan WHERE loan.contract EQ "Кредит"
/*                    AND loan.cont-code BEGINS "ПК"*/
                    AND CAN-DO("loan_trans_diff",loan.class-code)
		    AND loan.open-date <= currDate
                    AND (loan.close-date > currDate OR loan.close-date = ?)
		    AND loan.currency <> ""
                    NO-LOCK BREAK BY ENTRY(1,loan.cont-code," ") /*BY INTEGER(ENTRY(2,cont-code," "))*/:

	dSum = dSum + ABS(getParam(loan.cont-code,0,currDate)) + getParam(loan.cont-code,2,currDate) + getParam(loan.cont-code,7,currDate).
	dR254 = dR254 + ABS(getParam(loan.cont-code,21,currDate)) + ABS(getParam(loan.cont-code,46,currDate)).
	dPrG  = dPrG  + ABS(getParam(loan.cont-code,33,currDate)) - ABS(getParam(loan.cont-code,35,currDate)).
	dRPrG = dRPrG + ABS(getParam(loan.cont-code,350,currDate)).

	dPrB = dPrB + ABS(getParam(loan.cont-code,10,currDate)).
	dRPrB = dRPrB + ABS(getParam(loan.cont-code,351,currDate)).
/*
	oTable:addRow().
	oTable:addCell(loan.cont-code).
	oTable:addCell(ABS(getParam(loan.cont-code,0,currDate)) + getParam(loan.cont-code,2,currDate)).
	oTable:addCell(ABS(getParam(loan.cont-code,7,currDate))).
	oTable:addCell(ABS(getParam(loan.cont-code,21,currDate))).
	oTable:addCell(ABS(getParam(loan.cont-code,46,currDate))).
*/
	IF LAST-OF(ENTRY(1,loan.cont-code," ")) THEN DO:
		oTable:addRow().
		oTable:addCell(ENTRY(1,loan.cont-code," ")).
		oTable:addCell(dSum).		
		oTable:addCell(dR254).
		oTable:addCell(dPrG).	
		oTable:addCell(dRPrG).					
		oTable:addCell(dPrB).	
		oTable:addCell(dRPrB).	
		dSum  = 0.
		dR254 = 0.
		dPrG  = 0.
		dRPrG = 0.
		dPrB  = 0.
		dRPrB = 0.
	END.
END.

oTable:showItog = TRUE.

{setdest.i}
oTable:show().
{preview.i}
DELETE OBJECT oTable.