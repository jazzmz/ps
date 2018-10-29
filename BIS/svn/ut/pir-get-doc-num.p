{globals.i}
{tmprecid.def}
{intrface.get count}
{intrface.get xclass}


FUNCTION GetCount RETURNS INTEGER.
DEF VAR iCurrOut  AS INTEGER NO-UNDO.
iCurrOut = GetCounterCurrentValue("AllBankDoc",TODAY). 	/* Получили текущий номер счетчика */

IF iCurrOut EQ ? THEN DO:
	MESSAGE "Не запущен сервер автонумерации!\n" VIEW-AS ALERT-BOX.
/*RETURN "ERROR".*/
END.
SetCounterValue("AllBankDoc",?,TODAY).			/* Тут же его инкрементировали */
RETURN iCurrOut.
END FUNCTION.

def var temp-num as char no-undo.

for each tmprecid,
  first op where tmprecid.id = RECID(op):
      if SUBSTRING(userid("bisquit"),1,5) = SUBSTRING(op.user-id,1,5) OR CAN-DO("ADM*",userid("bisquit")) THEN 
         DO:
             temp-num = STRING(GetCount()).
             op.doc-num = temp-num.
             UpdateSigns("op", STRING(op.op), "ПИРКнигаРег", "yes", ?).
             MESSAGE "Документу присвоен номер " temp-num VIEW-AS ALERT-BOX.
         END.
         ELSE
         MESSAGE "Нельзя изменять номер документа, созданного пользователем другого подразделения" VIEW-AS ALERT-BOX.
END.

{intrface.del}
