/*********************
 * Если договор, валютный,
 * выполняем шаблон.
 *********************/
{globals.i}

DEFINE INPUT PARAMETER iRidTempl AS RECID NO-UNDO. /* recid - шаблона*/
DEFINE INPUT PARAMETER iRidLoan  AS RECID NO-UNDO. /* recid - договора */
DEFINE INPUT PARAMETER iOpDate   AS DATE  NO-UNDO. /* дата */

FIND FIRST loan WHERE RECID(loan) = iRidLoan NO-LOCK NO-ERROR.

IF AVAILABLE loan  
   AND loan.class-code EQ "loan_allocat" 
   AND loan.currency   NE  "810" AND loan.currency NE ""
 THEN RETURN.

RETURN "NEXT".