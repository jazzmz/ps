/* ------------------------------------------------------
     File: $RCSfile: spr-nal.p,v $ $Revision: 1.6 $ $Date: 2010-01-19 08:31:58 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Справку в налоговую (печатная форма) 
     Как работает: 
     Параметры:  
     Место запуска: БМ - Печать  
     Автор: $Author: borisov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.5  2008/08/25 08:04:05  Buryagin
     Изменения: Added the correspond account of Bank
     Изменения:
------------------------------------------------------ */

{pirsavelog.p}

/* Modifyed by Setpanov S.V. 17/06/1999 - выбор лицевого счета из списка */

{globals.i}
def var v-acct like acct.acct no-undo.
def var nam as character no-undo.
def var tip as character no-undo.
def var cli as character no-undo.

PAUSE 0.
DO TRANSACTION ON ERROR UNDO, LEAVE /* ON ENDKEY UNDO, LEAVE */ WITH FRAME dateframe2:
  UPDATE
    v-acct LABEL "Лицевой счет" HELP "Введите номер счета или нажмите F1"
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS 1 COL
           COLOR MESSAGES TITLE "[ ЗАДАЙТЕ ЛИЦЕВОЙ СЧЕТ ]"
    EDITING:
       READKEY.
       IF LASTKEY = 301 THEN DO:
           RUN "acct.p"("b", 3) .
           IF (LASTKEY = 13 OR lastkey = 10) AND pick-value <> ? THEN
             DISPLAY ENTRY(1, pick-value) @ v-acct.
       END.
       ELSE
         APPLY LASTKEY.
    END.
  IF INPUT v-acct  <> ? THEN DO:
    FIND FIRST acct WHERE acct.acct = v-acct NO-LOCK NO-ERROR.
    IF NOT AVAIL acct THEN DO:
     {message "Нет такого счета"}
     UNDO,RETRY.
    END.
  END.
END.
HIDE FRAME dateframe2 NO-PAUSE.

if acct.cust-cat ne "Ю" then do:
        message "Этот счет - не счет юридического лица.".
        return.
end.

if acct.currency ne "" then
	nam = " валютного счета ".
else
	nam = " рублевого счета ".

IF acct.close-date ne ? then
  do:
	tip = " о закрытии " + string(acct.close-date).
	cli = "клиента ".
	end.
else
	do:
  tip = " об открытии " + string(acct.open-date).
  cli = "клиенту ".
  end.
IF /*ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "ДогОткрЛС",""),",") eq ?  or 
	 ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "ДогОткрЛС",""),",") eq "" or*/
	 NUM-ENTRIES(GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "ДогОткрЛС","")) ne 2
  then 
      do:
         MESSAGE "Неправильно заполнен доп. реквизит ДогОткрЛС на счете!" skip
         VIEW-AS ALERT-BOX.
         RETURN.
      end.

{setdest.i}
find cust-corp of acct no-lock.
put unformatted
skip(2)
"Исх. N ______" skip
"От __________" skip(2)
"                       УВЕДОМЛЕНИЕ БАНКА "  name-bank FORMAT "X(70)" skip
"                          КЛИЕНТУ " cust-corp.name-short skip
"                        " + CAPS(substring(tip,2,11)) + " РАСЧЕТНОГО СЧЕТА" skip(2)
"       Банк " name-bank + ", имеющий данные регистрационного учета" skip
"БИК: "FGetSetting("БанкМФО",?,"") + " К/С: " + FGetSetting("КорСч",?,"") + " ИНН: " + substring(FGetSetting("ИНН",?,""),1,10) + " КПП: " FGetSetting("БанкКПП",?,"") + " ОГРН: "  FGetSetting("ОГРН",?,"")skip
"уведомляет" + tip + " расчетного счета № " + acct.acct skip
cli  cust-corp.name-short /* format "x(40)" */ skip
"с регистрационными данными: ИНН/КИО: " + cust-corp.inn + "/" + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ИИН", "") +  " КПП: " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "КПП", "") skip(2)
/* "о заключении " ENTRY(1,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "ДогОткрЛС",""),",") 
+ " договора банковского счета" skip
"за N: " +  ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "ДогОткрЛС",""),",")
+ tip nam acct.acct skip(2)*/
"                                                   Телефон (495) 974-20-78  " skip(3)
        
"Должностное лицо банка   ________________ " ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")) skip      
"                            Подпись" skip
"                                     М.П." skip        
.
/* {signatur.i}*/
{preview.i}
