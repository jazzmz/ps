{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: i56p21.p
      Comment: Выбор процедур печати
   Parameters:
         Uses:
      Used by:
      Created: 12/17/2002 Gunk
     Modified:
*/

DEFINE INPUT  PARAMETER iDataID LIKE DataBlock.Data-ID  NO-UNDO.

DEFINE VARIABLE vSrok AS CHAR VIEW-AS RADIO-SET HORIZONTAL SIZE 25 BY 1 RADIO-BUTTONS "5","05","75","75" LABEL "Срок хранения, лет"  NO-UNDO INIT "05".
DEFINE VARIABLE vRub  AS CHAR VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Рублевая","r","Валютная","v" LABEL "Вид справки" NO-UNDO INIT "r".
DEFINE VARIABLE vNumPril AS INTEGER VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "199-П",18,"56",21 LABEL "Печатать номер приложения по" NO-UNDO INIT 18.

DEFINE VARIABLE vFlName AS CHARACTER  NO-UNDO.

DEFINE FRAME fFr
   vSrok AT 11 SKIP
   vRub  AT 18 SKIP
   vNumPril
   WITH SIDE-LABELS CENTERED OVERLAY TITLE COLOR brigth-white "[ Введите параметры печати ]".

ON "RETURN":U OF vSrok, vRub  IN FRAME fFr APPLY "TAB":U TO SELF.
ON "RETURN":U OF vNumPril IN FRAME fFr APPLY "GO":U.

DO ON ENDKEY UNDO, LEAVE:
   UPDATE vSrok vRub vNumPril WITH FRAME fFr.
END.
HIDE FRAME fFr NO-PAUSE.
IF KEYFUNC (LASTKEY) EQ "end-error" THEN RETURN.

vFlName = "pir21" + vRub + vSrok.
IF SEARCH (vFlName + ".r") EQ ? AND SEARCH (vFlName + ".p") EQ ? THEN
   MESSAGE "Не найдена процедура " vFlName + ".p"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE
   RUN VALUE (vFlName + ".p") (iDataID,string(vNumPril)).




