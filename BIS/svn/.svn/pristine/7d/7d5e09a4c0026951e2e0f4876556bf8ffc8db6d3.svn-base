/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2011 ПИР
     Filename: pir-dacct-del.p
      Comment: сделана по аналогии dacct-del.p но носит запретительный характер
		ЗАПРЕТ удаление даты закрытия счета (оживление счета), когда и парный закрыт. 
   Parameters: ic_Surr AS CHARACTER
         Uses:
      Used by:
      Created: 12.08.2011 SStepanov Открытие парных счетов
     Modified: 

*/
{globals.i}
{intrface.get tmess}   
{intrface.get xclass}  
{intrface.get acct} 

DEFINE INPUT PARAMETER ic_Surr AS CHARACTER NO-UNDO.

DEF BUFFER bAcct-contr 	FOR acct.
DEF BUFFER bAcct	FOR acct.
DEFINE VARIABLE c_return-value    AS CHARACTER NO-UNDO.

RUN dacct-del.p (ic_Surr).

c_return-value = return-value.

/* message "!!! pir-dacct-cr.p" view-as alert-box. */

/* FIND FIRST bAcct
	WHERE RECID(bAcct) = rec-acct NO-LOCK.
IF {assigned bacct.contr-acct} THEN DO:		/* есть парный счет */
  FIND FIRST bAcct-contr
	WHERE bAcct-contr.acct = bAcct.contr-acct NO-LOCK.
  IF AVAIL bAcct-contr THEN DO:
    IF bacct-contr.close-date = ? THEN DO:	/* ЕСЛИ он не закрыт */
      MESSAGE "Парный счет " bAcct.contr-acct " не закрыт!\n Нельзя закрыть без закрытия парного счета"
	VIEW-AS ALERT-BOX.
      c_return-value = "".			/* ТО возвращаем ошибку */
    END.
  END.
END.
*/

DEFINE VARIABLE mAcct AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mCurr AS CHARACTER   NO-UNDO.

DEFINE BUFFER acctc FOR acct.

ASSIGN
   mAcct = ENTRY (1, ic_Surr)
   mCurr = ENTRY (2, ic_Surr)
NO-ERROR.

{find-act.i
   &acct = mAcct
   &curr = mCurr
}

IF AVAIL(acct) AND {assigned acct.contr-acct} THEN 
   {find-act.i
      &bact  = acctc
      &acct  = acct.contr-acct
      &curr  = acct.currency}

IF AVAIL(acctc) AND acctc.close-date EQ ?  THEN DO:
  MESSAGE "Парный счет " acct.contr-acct " не закрыт!\n Нельзя закрыть без закрытия парного счета"
	VIEW-AS ALERT-BOX ERROR.
  c_return-value = "Error".	/* ТО возвращаем ошибку */
  RETURN ERROR c_return-value.
END.

RETURN c_return-value.
