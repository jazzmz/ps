{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: 
      Comment: Ввод курсов по наличной валюте
   Parameters:
         Uses:
      Used by:
      Created: 
     Modified: 
*/

{globals.i}

{intrface.get instrum}
{intrface.get rights}

DEFINE VARIABLE mBegDate AS DATE      NO-UNDO. /* дата курса */

DEFINE VARIABLE mEndDate AS DATE      NO-UNDO. /* дата курса */
DEFINE VARIABLE mClass   AS CHARACTER NO-UNDO. /* код валюты */
DEFINE VARIABLE mPokVal  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mTable   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mField   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mUser    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDetails AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mTmp     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mNum     AS INTEGER   NO-UNDO.

DEFINE NEW SHARED VARIABLE list-id AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE txattr NO-UNDO
   FIELD record AS RECID. /* Содержит recid реквизитов */

DEFINE NEW GLOBAL SHARED TEMP-TABLE tclass NO-UNDO
   FIELD record AS RECID.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tmethod NO-UNDO
   FIELD record AS RECID.


{empty txattr}

ASSIGN

   mEndDate = gend-date
   mClass   = "840"
   mPokVal  = FindRateSimple("НалПок",mClass, mEndDate)
   mPrVal   = FindRateSimple("НалПр",mClass, mEndDate)
.

FORM
   mEndDate
      FORMAT "99/99/9999"
      LABEL  "Дата"  
      HELP   "Дата ввода курсов"
   mClass
      FORMAT "x(3)" VIEW-AS FILL-IN SIZE 3 by 1
      LABEL  "Валюта"  
      HELP   "Код валюты"
   mPokVal
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mPrVal
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"
WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ КУРС ]".

ON F1 OF mEndDate DO:
   RUN calend.p.
   IF    (   LASTKEY EQ 13 
          OR LASTKEY EQ 10) 
      AND pick-value NE ?
   THEN FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.


ON LEAVE OF mClass do:
      mClass = input mClass.
/*      message mClass. pause.*/
      DISP  mClass @ mClass
      FindRateSimple("НалПок",mClass, mEndDate) @ mPokVal 
      FindRateSimple("НалПр", mClass, mEndDate) @ mPrVal 
      WITH FRAME frparam.
END.


ON F1 OF mClass DO:
   DO TRANSACTION:
      RUN currency.p ("Учетный",4).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ?
   THEN do:
	DISPLAY pick-value @ mClass  /* WITH FRAME frParam. */
	        FindRateSimple("НалПок",pick-value, mEndDate) @ mPokVal 
                FindRateSimple("НалПр", pick-value, mEndDate) @ mPrVal 
                with frame frParam.
        end.
  RETURN NO-APPLY.
END.



PAUSE 0.

UPDATE
   mEndDate
   mClass
   mPokVal
   mPrVal
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE. 


     IF mPokVal  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалПок",
	        mClass,
		mEndDate,
		mPokVal,
		1.0 ,
		YES
		).
        END.		
     IF mPrVal  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалПр",
	        mClass,
		mEndDate,
		mPrVal,
		1.0 ,
		YES
		).
        END.	
		
/*	CREATE instr-rate.
	 ASSIGN
	   instr-rate.instr-cat = "currency"
           instr-rate.rate-type = "НалПок"
	   instr-rate.instr-code = mClass
	   instr-rate.since = mEndDate
           instr-rate.rate-instr = mPokVal
	   instr-rate.per = 1.0 .
*/		

    

MESSAGE "Ввод курсов закончен."
   VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
