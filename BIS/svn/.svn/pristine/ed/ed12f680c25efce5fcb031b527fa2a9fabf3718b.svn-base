/*
Осуществляет выборку депозитных договоров на дату
Бакланов А.В. 27.09.2013
*/

{globals.i}
{norm.i}

DEF OUTPUT PARAMETER iRes AS INTEGER INIT 0 NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iVal AS CHARACTER NO-UNDO. /*ВАЛ*/

IF iVal = "810" THEN iVal = "".

FOR EACH loan WHERE loan.cont-code BEGINS "ДЮ" AND (loan.close-date = ? OR loan.close-date >= iEndDate) AND loan.contract EQ 'Депоз'
	AND loan.currency = iVal AND loan.open-date <= iEndDate
	NO-LOCK:
	iRes = iRes + 1.
   END.
FOR EACH loan WHERE loan.cont-type BEGINS "Сро" AND (loan.close-date = ? OR loan.close-date >= iEndDate) AND loan.contract EQ 'dps'
	AND loan.currency = iVal AND loan.open-date <= iEndDate
	NO-LOCK:
	iRes = iRes + 1.
   END.
      
RETURN "".

