&IF DEFINED(get-bankname_i)=0 /* Avoid Multiple Redefinitions */
&THEN
   &GLOBAL-DEFINE get-bankname_i
DEFINE VARIABLE cBankName AS CHAR NO-UNDO.
DEFINE VARIABLE cBankNameS AS CHAR NO-UNDO.
DEFINE VARIABLE cBankNameSPlat AS CHAR NO-UNDO.
DEFINE VARIABLE cBankNameFull AS CHAR NO-UNDO.
DEFINE VARIABLE dDateToChange AS DATE NO-UNDO.

dDateToChange = DATE(FGetSetting("DateChangeName", "", "01/01/2013")).

if gend-date >= dDateToChange then 
  do:
     cBankName = FGetSetting("Банк", "", "").
     cBankNameS = FGetSetting("БанкС", "", "").
     cBankNameSPlat = FGetSetting("БанкСПлат", "", cBankNameS).
     cBankNameFull = FGetSetting("БанкПолное", "", "").
  end.
else
  do:
     cBankName = FGetSetting("БанкСтар", "", "").
     cBankNameS = FGetSetting("БанкССтар", "", "").
     cBankNameSPlat = FGetSetting("БанкСПлатСтар", "", cBankNameS).
     cBankNameFull = FGetSetting("БанкПолноеСтар", "", "").
  end.


&ENDIF