/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2011 ПИР
     Filename: pir-dacct-cr.p
      Comment: сделана по аналогии dacct-cr.p но носит запретительный характер
		1.закрытие счета, имеющего парный, но выбрано "не закрывать парный" 
		2.открытие счета, который должен иметь парный, но при открытии выбрано "не открывать парный" 
   Parameters: rec-acct AS RECID
         Uses:
      Used by:
      Created: 12.08.2011 SStepanov Открытие парных счетов
     Modified: 21.11.2011 переход на D73 и с заявкой Маслова 
		rec-acct -> surr-acct

*/
{globals.i}
{intrface.get tmess}   
{intrface.get xclass}  
{intrface.get acct} 

/* было до заявки Маслова DEFINE INPUT PARAMETER rec-acct AS RECID NO-UNDO. */
DEFINE INPUT PARAMETER surr-acct AS CHARACTER NO-UNDO. /* стало */

DEF BUFFER bAcct-contr 	FOR acct.
DEF BUFFER bAcct	FOR acct.
DEFINE VARIABLE c_return-value    AS CHARACTER NO-UNDO.

/* RUN dacct-cr.p (rec-acct). 21.11.2011 переход на D73 и с заявкой Маслова rec-acct -> surr-acct */
RUN dacct-cr.p (surr-acct).
/* MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX. */

c_return-value = return-value.

FIND FIRST bAcct
	/* WHERE RECID(bAcct) = rec-acct 21.11.2011 переход на D73 и с заявкой Маслова rec-acct -> surr-acct */
	WHERE bAcct.acct 	= ENTRY(1, surr-acct)
	  AND bAcct.currency 	= ENTRY(2, surr-acct)
	NO-LOCK.

IF {assigned bacct.contr-acct} THEN DO:
  FIND FIRST bAcct-contr
	WHERE bAcct-contr.acct = bAcct.contr-acct NO-LOCK.
  IF AVAIL bAcct-contr THEN DO:		/* есть парный счет */
    IF bacct-contr.close-date <> ? THEN DO:	/* и он закрыт */
      MESSAGE "Парный счет " bacct-contr.contr-acct " должен быть открыт!\n Нельзя открыть счет с закрытым парным счета"
	VIEW-AS ALERT-BOX ERROR.
      c_return-value = "Error".
    END.
  END.
END.
ELSE DO:
  FIND FIRST CODE
    WHERE code.class = "Dual-bal-acct" AND 
          (code.code EQ STRING(bacct.bal-acct) OR
           code.val  EQ STRING(bacct.bal-acct))
    NO-LOCK NO-ERROR.

  IF AVAIL(CODE) THEN DO:
      MESSAGE "Парный счет должен быть открыт для такого балансового счета 2го порядка!"
	VIEW-AS ALERT-BOX ERROR.
      c_return-value = "Error".
  END.
END.

RETURN c_return-value.
