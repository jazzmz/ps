{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: 
      Comment: Ввод курсов по наличной валюте 840,978 для пластика
   Parameters:
         Uses:
      Used by
      Created: 
     Modified: 
*/

{globals.i}

{intrface.get instrum}
{intrface.get rights}

DEFINE VARIABLE mBegDate AS DATE      NO-UNDO. /* дата курса */

DEFINE VARIABLE mEndDate AS DATE      NO-UNDO. /* дата курса */

def var mh11 as int init 0  no-undo.
def var mm11 as int init 0 no-undo.
def var ms11 as int init 0 no-undo.

DEFINE VARIABLE mClass1   AS CHARACTER NO-UNDO. /* код валюты */
DEFINE VARIABLE mPokVal1  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal1   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mClass2   AS CHARACTER NO-UNDO. /* код валюты */
DEFINE VARIABLE mPokVal2  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal2   AS DECIMAL NO-UNDO.

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
   mEndDate = gend-date + 1
   mClass1   = "840"
   mPokVal1  = FindRateSimple("КартПок",mClass1, mEndDate)
   mPrVal1   = FindRateSimple("КартПр",mClass1, mEndDate)
   mClass2   = "978"
   mPokVal2  = FindRateSimple("КартПок",mClass2, mEndDate)
   mPrVal2   = FindRateSimple("КартПр",mClass2, mEndDate)
   
.

FORM
   mEndDate
      FORMAT "99/99/9999"
      LABEL  "Дата"  
      HELP   "Дата ввода курсов"
      "            Курс: USD"
/*   mClass1 
      FORMAT "x(3)" VIEW-AS FILL-IN SIZE 3 by 1
      LABEL  "Валюта"  
      HELP   "Код валюты"*/
   mPokVal1
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mPrVal1
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"
/*   mClass2
      FORMAT "x(3)" VIEW-AS FILL-IN SIZE 3 by 1
      LABEL  "Валюта"  
      HELP   "Код валюты"*/
      "            Курс: EUR"
   mPokVal2
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mPrVal2
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


/* ON LEAVE OF mClass1 do:
      mClass1 = input mClass1.
      DISP  mClass1 @ mClass1
      FindRateSimple("КартПок",mClass1, mEndDate) @ mPokVal1 
      FindRateSimple("КартПр", mClass1, mEndDate) @ mPrVal1 
      WITH FRAME frparam.
END.


ON F1 OF mClass1 DO:
   DO TRANSACTION:
      RUN currency.p ("Учетный",4).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ?
   THEN do:
	DISPLAY pick-value @ mClass1  /* WITH FRAME frParam. */
	        FindRateSimple("НалПок",pick-value, mEndDate) @ mPokVal1
                FindRateSimple("НалПр", pick-value, mEndDate) @ mPrVal1 
                with frame frParam.
        end.
  RETURN NO-APPLY.
END.
*/


PAUSE 0.

UPDATE
   mEndDate
/*   mClass1 */
   mPokVal1
   mPrVal1
/*   mClass2 */
   mPokVal2
   mPrVal2
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE.


     IF mPokVal1  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "КартПок",
	        mClass1,
		mEndDate,
		mPokVal1,
		1.0 ,
		YES
		).
        END.		
     IF mPrVal1  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "КартПр",
	        mClass1,
		mEndDate,
		mPrVal1,
		1.0 ,
		YES
		).
        END.	
     IF mPokVal2  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "КартПок",
	        mClass2,
		mEndDate,
		mPokVal2,
		1.0 ,
		YES
		).
        END.		
     IF mPrVal2  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "КартПр",
	        mClass2,
		mEndDate,
		mPrVal2,
		1.0 ,
		YES
		).
        END.	
		
MESSAGE " Ввод курсов закончен ! "
   VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
