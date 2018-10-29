/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: anksec.p
      Comment: Процедура печати анкеты ценной бумаги
   Parameters: in-sec-code - код ценной бумаги
         Uses:
      Used by:
      Created: 23.03.99 Lera
     Modified: 23.03.99 Lera
*/
{globals.i}
{intrface.get seccd}    /* Библиотека для работы с ЦБ. */

DEFINE INPUT PARAMETER iGroup AS CHARACTER NO-UNDO.  /* Если "Yes" - групповая печать*/
DEFINE INPUT PARAMETER iRecid AS RECID     NO-UNDO.
   
DEFINE VARIABLE licence   AS CHARACTER NO-UNDO FORMAT "x(40)".
DEFINE VARIABLE address   AS CHARACTER NO-UNDO.
DEFINE VARIABLE NAME      AS CHARACTER NO-UNDO.
DEFINE VARIABLE tit1      AS CHARACTER NO-UNDO FORMAT "x(40)".
DEFINE VARIABLE nomer-vip AS CHARACTER NO-UNDO.
DEFINE VARIABLE mHand     AS HANDLE    NO-UNDO.

FIND FIRST sec-code WHERE
     RECID(sec-code) EQ iRecid NO-LOCK NO-ERROR.
IF NOT AVAILABLE sec-code THEN DO:
   MESSAGE "Эту ЦБ уже кто-то удалил!"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN.
END.

FIND FIRST dept NO-LOCK.

ASSIGN 
   nomer-vip = GetXattrValue("sec-code",sec-code.sec-code,"issue_ser").                       
   tit1      = "АНКЕТА ВЫПУСКА ЦЕННОЙ БУМАГИ: " +  sec-code.sec-code.
.

mHand = SecEmitInfo(sec-code.sec-code).
IF VALID-HANDLE(mHand) THEN DO:
   ASSIGN 
      licence = mHand:BUFFER-FIELD("lic-emit")    :BUFFER-VALUE
      address = mHand:BUFFER-FIELD("emit-address"):BUFFER-VALUE
      NAME    = mHand:BUFFER-FIELD("name-emit")   :BUFFER-VALUE
  .
END.

FIND LAST instr-rate WHERE 
          instr-rate.instr-cat  EQ "sec-code" 
      AND instr-rate.rate-type  EQ "Номинал" 
      AND instr-rate.since      LE TODAY 
      AND instr-rate.instr-code EQ sec-code.sec-code NO-LOCK NO-ERROR.  /* нашли номинал для данной бумаги */


IF iGroup NE "Yes" THEN DO:
   {setdest.i}
END.

DO WITH FRAME prn 
ON ERROR UNDO,RETRY 
ON ENDKEY UNDO,RETURN:

   FORM HEADER 
      CAPS(dept.name-bank) FORMAT "x(55)"   AT 5
      PAGE-NUMBER          FORMAT "Листzz9" TO 82 SKIP(1)
      tit1                                  AT 5  SKIP
   WITH WIDTH 85 NO-BOX COL 3.
   DISP " ".
   IF PAGE-SIZE - LINE-COUNTER LT 10 
   THEN PAGE.
   PUT  UNFORMATTED  
      "Номер гос.регистрации ЦБ"      AT 2 
      ":"                             AT 30 
      sec-code.reg-num                AT 32 SKIP

      "Вид ЦБ "                       AT 2 
      ":"                             AT 30 
      TRIM(sec-code.NAME)             AT 32 SKIP

      "Номинал "                      AT 2 
      ":"                             AT 30                      
      (IF AVAIL instr-rate 
       THEN STRING(instr-rate.rate-instr) 
       ELSE "")                       AT 32 SKIP

      "Эмитент "                      AT 2 
      ":"                             AT 30 
      NAME                            AT 32 SKIP
                   
      "Адрес эмитента "               AT 2 
      ":"                             AT 30 
      address                         AT 32 SKIP

      "Свидетельство о регистрации"   AT 2 
      ":"                             AT 30 
      licence                         AT 32

      "Номер выпуска ЦБ"              AT 2 
      ":"                             AT 30 
      nomer-vip                       AT 32 SKIP 
   .
   IF iGroup NE "Yes" THEN DO:
      {preview.i} 
   END.
END.

{intrface.del}          /* Выгрузка инструментария. */ 

