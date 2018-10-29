/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-rasp-depos01.p
      Comment: Распоряжение на частичный возврат средств с депозита ЮЛ
		( работает по выбранным проводкам )
   Parameters: 
       Launch: КиД - ОпДень - Отмечаем проводки, ctrl+g - ДЕПОЗ Распоряжение на частичный возврат (ЮЛ)
      Created: Sitov S.A., 2013-09-16
	Basis: #3783
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{tmprecid.def}
{get-bankname.i}
{wordwrap.def}



DEF VAR vClName		AS  CHAR  NO-UNDO.
DEF VAR vLoanDateSogl	AS  CHAR  NO-UNDO.
DEF VAR vOpEntrSum	AS  DEC   NO-UNDO.
DEF VAR vLetterNum	AS  CHAR  NO-UNDO.

DEF VAR RaspDate	AS  DATE  NO-UNDO.
DEF VAR RaspShapka	AS CHAR NO-UNDO.
DEF VAR RaspPodpis	AS CHAR NO-UNDO.

DEF VAR s 		AS INT  NO-UNDO.
DEF VAR TmpStr 		AS CHAR EXTENT 20 NO-UNDO.
DEF VAR AmtStr 		AS CHAR EXTENT 2  NO-UNDO.
DEF VAR SumDig 		AS DEC  NO-UNDO.
DEF VAR SumStr 		AS CHAR NO-UNDO.



IF NOT CAN-FIND (FIRST tmprecid) THEN
DO:
    MESSAGE "Нет ни одного выбранного документа!" VIEW-AS ALERT-BOX.
    RETURN .
END.


FORM
   vLetterNum	FORMAT "X(20)"	LABEL  "Номер письма"	HELP   "Номер письма клиента"
WITH FRAME fSet0 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ НОМЕР ПИСЬМА КЛИЕНТА ]".

ON F1 OF vLetterNum DO:
   IF ( LASTKEY EQ 13  OR LASTKEY EQ 10)  AND pick-value NE ?  THEN 
	FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.

PAUSE 0.
UPDATE	vLetterNum   WITH FRAME fSet0.
HIDE FRAME fSet0 NO-PAUSE.
IF NOT ( KEYFUNC(LASTKEY) EQ "GO" OR KEYFUNC(LASTKEY) EQ "RETURN") THEN LEAVE.



{setdest.i}

FOR FIRST tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id 
NO-LOCK.

   FIND FIRST op-entry WHERE op-entry.op = op.op NO-LOCK NO-ERROR.

   IF AVAILABLE(op-entry) THEN
   DO:

       FIND FIRST loan-acct WHERE loan-acct.acct = op-entry.acct-db and loan-acct.acct-type = "Депоз"  AND  loan-acct.contract = "Депоз" NO-LOCK NO-ERROR.

       IF AVAILABLE(loan-acct) THEN 
       DO:

	   RaspDate = op.op-date .

           FIND FIRST loan WHERE loan.cont-code = loan-acct.cont-code and loan.contract = loan-acct.contract NO-LOCK NO-ERROR.

           IF loan.cust-cat = "Ч" THEN 
           DO:
              FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
              vClName = person.name-last + " " +  person.first-names.
           END.
           IF loan.cust-cat = "Ю" THEN
           DO:
              FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              vClName = cust-corp.name-short.
           END.

           vLoanDateSogl = GetXattrValueEx("loan",string(loan.contract + "," + loan.cont-code),"ДатаСогл","") .
           IF vLoanDateSogl = "" THEN  STRING(loan.open-date,"99/99/9999") .

           SumDig =  IF op-entry.currency = "" THEN op-entry.amt-rub  ELSE op-entry.amt-cur .

       END.
       ELSE MESSAGE COLOR WHITE/RED "СЧЕТ ПО ДЕБИТУ НЕ ПРИВЯЗАН К ДОГОВОРУ С РОЛЬЮ Депоз!" VIEW-AS ALERT-BOX TITLE "Ошибка".

   END.
   ELSE MESSAGE COLOR WHITE/RED "НЕ НАЙДЕНА ПРОВОДКА!" VIEW-AS ALERT-BOX TITLE "Ошибка".

END.



	/*** ПЕЧАТЬ РАСПОРЯЖЕНИЯ ***/

RaspShapka = FILL(" ",65) + "В Департамент 3" + CHR(10) + CHR(10) +
	     FILL(" ",65) + cBankName + CHR(10) + CHR(10) +
	     FILL(" ",65) + "Дата:" + STRING(RaspDate,"99/99/9999") + CHR(10) + CHR(10) + CHR(10) +
	     FILL(" ",28)  + "Р А С П О Р Я Ж Е Н И Е" + CHR(10) + CHR(10) + CHR(10) 
	     .

RUN x-amtstr.p( SumDig, op-entry.currency, true,true,output amtstr[1], output amtstr[2] ).
SumStr = AmtStr[1] + ' ' + AmtStr[2] .
SUBSTR(SumStr,1,1) = Caps(SUBSTR(SumStr,1,1)).
SumStr = TRIM(STRING(SumDig,"->>>,>>>,>>>,>>>,>>9.99")) + " (" + SumStr + ") " .

tmpStr[1] = "Согласно письма " + vClName + " № " + vLetterNum + " от " + STRING(RaspDate,"99/99/9999") + "г. и условий Договора банковского вклада "
	  + "№ " + loan.cont-code + " от " + vLoanDateSogl + "г. осуществить частичный возврат суммы вклада в размере "
	  + SumStr
	  + "со счета № " + op-entry.acct-db + " на счет № " + op-entry.acct-cr 
	  + " (" + vClName + ") в " + cBankName + "." .

RaspPodpis = CHR(10) + CHR(10) + CHR(10) +
	     "Начальник Казначейства                " + FILL(" ",18) + "________ Е.М. Маршева" + CHR(10) + CHR(10) +
	     "Ведущий специалист Депозитного отдела " + FILL(" ",18) + "________ С.В. Балан"   + CHR(10) + CHR(10)
	     .

PUT UNFORM RaspShapka SKIP.

{wordwrap.i &s=tmpStr &n=20 &l=83}
DO s = 1 TO 20 :
IF tmpStr[s] <> "" THEN
 	PUT UNFORM tmpStr[s] SKIP(1).
END.

PUT UNFORM RaspPodpis SKIP.

	/*** КОНЕЦ РАСПОРЯЖЕНИЯ ***/


{preview.i}