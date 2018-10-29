/*** #2905 Sitov S.A. - проверка необходимости обновления анкеты клиента (ЮЛ,ФЛ,Б) ***/

{globals.i}

DEF INPUT  PARAM iClass		AS CHAR NO-UNDO.
DEF INPUT  PARAM iSurrogate	AS CHAR NO-UNDO.
DEF OUTPUT PARAM oFlInfo	AS LOGICAL INIT no NO-UNDO. /* 	no - т.е. не о чем информировать */

DEF VAR  drAnktUpdated		AS  DATE  NO-UNDO .
DEF VAR  drAnktLevelRisk	AS  CHAR  NO-UNDO .
DEF VAR  vDateStartInfo		AS  DATE  NO-UNDO .

DEF BUFFER bfperson    FOR person .
DEF BUFFER bfcust-corp FOR cust-corp .
DEF BUFFER bfbanks     FOR banks .


CASE iClass:
  WHEN "person" THEN DO:
     FIND FIRST bfperson WHERE STRING(bfperson.person-id) = iSurrogate NO-LOCK NO-ERROR.
  END.
  WHEN "cust-corp" THEN DO:
     FIND FIRST bfcust-corp WHERE STRING(bfcust-corp.cust-id) = iSurrogate NO-LOCK NO-ERROR.
  END.
  WHEN "banks" THEN DO:
     FIND FIRST bfbanks WHERE STRING(bfbanks.bank-id) = iSurrogate NO-LOCK NO-ERROR.
  END.
END CASE.


drAnktUpdated    = DATE(GetTempXAttrValueEx(iClass, iSurrogate, "ДатаОбнАнкеты", TODAY ,"")) .
drAnktLevelRisk  = GetTempXAttrValueEx(iClass, iSurrogate, "РискОтмыв", TODAY ,"") .


IF drAnktUpdated = ? OR drAnktLevelRisk = "" THEN
  RETURN .


IF drAnktLevelRisk = "низкий"  THEN 
  vDateStartInfo = drAnktUpdated + 3 * 365 - 10 .
IF drAnktLevelRisk = "средний" THEN 
  vDateStartInfo = drAnktUpdated + 2 * 365 - 10 .
IF drAnktLevelRisk = "повышенный" THEN 
  vDateStartInfo = drAnktUpdated + 1 * 365 - 10 .


IF  TODAY >= vDateStartInfo  THEN
  oFlInfo = YES .

/*
MESSAGE 
   " iClass	= " iClass	
   " iSurrogate = " iSurrogate
   " drAnktUpdated   = " drAnktUpdated   
   " drAnktLevelRisk = " drAnktLevelRisk
   " vDateStartInfo  = " vDateStartInfo
   " TODAY = "  TODAY
   " oFlInfo = "  oFlInfo
VIEW-AS ALERT-BOX.
*/
