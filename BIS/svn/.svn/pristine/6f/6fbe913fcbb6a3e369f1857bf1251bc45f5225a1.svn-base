/*
Осуществляет выборку открытых счетов на дату
Бакланов А.В. 12.09.2013
*/

{globals.i}
{norm.i}

DEF OUTPUT PARAMETER iRes AS INTEGER INIT 0 NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iAccts AS CHARACTER NO-UNDO. /*ВАЛ*,*СЧЕТА*/

FOR EACH bal-acct WHERE CAN-DO(ENTRY(2,iAccts,";"), string(bal-acct.bal-acct,"99999"))
 	NO-LOCK,
    	EACH acct OF bal-acct WHERE acct.open-date = iEndDate AND acct.currency = ENTRY(1,iAccts,";"),
	FIRST op-entry WHERE op-entry.op-date = iEndDate AND (op-entry.acct-db = acct.acct OR op-entry.acct-cr = acct.acct)
	NO-LOCK:
	iRes = iRes + 1.
   END.
      
RETURN "".

