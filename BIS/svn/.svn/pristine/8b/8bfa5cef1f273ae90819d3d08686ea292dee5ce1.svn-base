{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirdps120.p
      Comment: Распоряжение на частичное изъятие вклада 
   Parameters: 
       Launch: ЧВ->Операции->Документы дня->Отмечаем документ, Ctrl+G-> Распоряжение на частичное изъятие вклада
         Uses:
      Created: Sitov S.A., 11.04.2012
	Basis: Заявка #907  (запрос от Маршевой Е.М.)
     Modified: 
*/
/* ========================================================================= */



{globals.i}
{ulib.i}
{getdate.i}
{tmprecid.def}        /** Используем информацию из броузера */
{wordwrap.def}
{get-bankname.i}

DEF INPUT PARAM iParam AS CHAR.

DEF VAR ClientName   AS CHAR NO-UNDO.
DEF VAR ClientAcct   AS CHAR NO-UNDO.
DEF VAR LoanNum      AS CHAR NO-UNDO.
DEF VAR LoanOpenDate AS DATE NO-UNDO.
DEF VAR LoanAcct     AS CHAR NO-UNDO.
DEF VAR SumOpEntry   AS DEC  NO-UNDO.
DEF VAR SumOpEntryStr AS CHAR NO-UNDO.
DEF VAR AmtStr AS CHAR EXTENT 2  NO-UNDO.
DEF VAR tmpStr AS CHAR EXTENT 10 NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.

  /* подписи в распоряжении */
DEF VAR pirbosdps AS CHAR NO-UNDO.	/* Руководитель */
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR NO-UNDO.	/* Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).




/* ==================   РЕАЛИЗАЦИЯ   ====================================== */

FOR FIRST tmprecid 
NO-LOCK,
FIRST op WHERE RECID(op) EQ tmprecid.id 
NO-LOCK, 
FIRST op-entry OF op
NO-LOCK:

  IF AVAIL(op-entry) THEN
    DO:

	ClientAcct = op-entry.acct-cr .
	LoanAcct   = op-entry.acct-db .

	IF op-entry.currency = "" THEN
	  SumOpEntry = op-entry.amt-rub .
	ELSE 
	  SumOpEntry = op-entry.amt-cur .

	RUN x-amtstr.p(SumOpEntry,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
	SumOpEntryStr = AmtStr[1] + ' ' + AmtStr[2] .
	SUBSTR(SumOpEntryStr,1,1) = Caps(SUBSTR(SumOpEntryStr,1,1)).


	FIND FIRST loan-acct WHERE loan-acct.contract = "dps"
	    AND loan-acct.acct = LoanAcct
	NO-LOCK NO-ERROR.

	FIND FIRST loan OF loan-acct NO-LOCK NO-ERROR.

	IF AVAIL(loan) THEN
	  DO:
	    LoanNum = loan.cont-code .
	    LoanOpenDate = loan.open-date .
	    
	    FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
	    ClientName = person.name-last + " " + person.first-names.
	  END.
    END.
  ELSE
     MESSAGE "Error!! Op-entry not found! " VIEW-AS ALERT-BOX.

END.




/* =====================   ПЕЧАТЬ РАСПОРЯЖЕНИЯ  ============================ */

{setdest.i}


PUT UNFORMATTED
	SPACE(50) "В Департамент 3" SKIP(1)
	SPACE(50) cBankName SKIP(3)
	SPACE(50) "Дата: " op.op-date FORMAT "99/99/9999" SKIP(5)
	SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP(3)
.


   /* Текст распоряжения с разбивкой по строкам */

tmpStr[1] = "Согласно заявления от " + STRING(end-date,"99/99/99") + "г. (" + ClientName + ") и условий " +
	"Договора банковского вклада №" + LoanNum + " от " + STRING(LoanOpenDate,"99/99/99") + "г. осуществить " +
	"частичный возврат суммы вклада в размере" +
	STRING(SumOpEntry,">>>,>>>,>>9.99") + " (" + SumOpEntryStr + ") " +
	"со счета №" + LoanAcct + " на счет №" + ClientAcct + " (" + ClientName + ") " +
	"в " + cBankName + "."  
	.

{wordwrap.i &s=tmpStr &n=10 &l=80}

tmpStr[1] = '   ' + tmpStr[1] .

DO i = 1 TO 10 :
  IF tmpStr[i] <> "" THEN
	PUT UNFORMATTED tmpStr[i] SKIP.
END.


   /* Подписи в распоряжении */
PUT UNFORMATTED SKIP(3).
PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(60 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(2).
IF pirbosdps <> "," THEN 
	PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(60 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(2).
IF fioSpecDPS <> "" then
	PUT UNFORMATTED 'Ведущий специалист Депозитного отдела' SPACE(60 - LENGTH('Ведущий специалист Депозитного отдела')) fioSpecDPS SKIP.



{preview.i}
