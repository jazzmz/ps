{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: 
      Comment: Ввод курсов по наличной валюте 840,978
   Parameters:
         Uses:
      Used by:
      Created: 
     Modified: 
*/

{globals.i}

{intrface.get instrum}
{intrface.get rights}

/** Входящий параметр: <код_подразделения> */
DEFINE INPUT PARAM iParam AS CHAR.
DEF VAR iParam1 AS CHAR NO-UNDO.
DEF VAR iStep   AS INT  NO-UNDO.

DEFINE VARIABLE mBegDate AS DATE      NO-UNDO.
 /* дата курса */

DEFINE VARIABLE mEndDate AS DATE      NO-UNDO.
DEFINE VARIABLE currDate AS DATE      NO-UNDO.
 /* дата курса */

def var mh11 as int init 0  no-undo.
def var mm11 as int init 0 no-undo.
def var ms11 as int init 0 no-undo.

DEFINE VARIABLE mClass1   AS CHARACTER NO-UNDO.
 /* код валюты */
DEFINE VARIABLE mPokVal1  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal1   AS DECIMAL NO-UNDO.
DEFINE VARIABLE mBasePokVal1  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mBasePrVal1   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mClass2   AS CHARACTER NO-UNDO.
 /* код валюты */
DEFINE VARIABLE mPokVal2  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal2   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mBasePokVal2  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mBasePrVal2   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mTable   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mField   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mUser    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDetails AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mTmp     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mNum     AS INTEGER   NO-UNDO.
DEF VAR oTKurs AS TKurs NO-UNDO.


DEFINE NEW SHARED VARIABLE list-id AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE txattr NO-UNDO
   FIELD record AS RECID. /* Содержит recid реквизитов */

DEFINE NEW GLOBAL SHARED TEMP-TABLE tclass NO-UNDO
   FIELD record AS RECID.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tmethod NO-UNDO
   FIELD record AS RECID.


{empty txattr}

ASSIGN
   iParam1 = ENTRY(1, iParam)
   iStep   = (IF NUM-ENTRIES(iParam,",") >= 2 THEN INT(ENTRY(2, iParam)) ELSE 0)
   mEndDate = gend-date
   mClass1      = "840"
   mPokVal1     = FindRateSimple("НалПок"  + iParam1,mClass1, mEndDate)
   mPrVal1      = FindRateSimple("НалПр"   + iParam1,mClass1, mEndDate)
   mBasePrVal1  = FindRateSimple("НалБПр"  + iParam1,mClass1, mEndDate)
   mBasePokVal1 = FindRateSimple("НалБПок" + iParam1,mClass1, mEndDate)

   mClass2      = "978"
   mPokVal2     = FindRateSimple("НалПок"  + iParam1,mClass2, mEndDate)
   mPrVal2      = FindRateSimple("НалПр"   + iParam1,mClass2, mEndDate)
   mBasePrVal2  = FindRateSimple("НалБПр"  + iParam1,mClass2, mEndDate)
   mBasePokVal2 = FindRateSimple("НалБПок" + iParam1,mClass2, mEndDate)
   
.

currDate = mEndDate + iStep.

FORM
   mEndDate
      FORMAT "99/99/9999"
      LABEL  "Дата"  
      HELP   "Дата ввода курсов"
      "            Курс: USD"
   mPokVal1
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mPrVal1
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"
      "            Курс: EUR"
   mPokVal2
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mPrVal2
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"
        "  Базовый курс: USD"
   mBasePokVal1
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mBasePrVal1
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"
        "  Базовый курс: EUR"
   mBasePokVal2
      FORMAT "99.9999" 
      LABEL  "Курс покупки"  
      HELP   "Курс покупки валюты по наличному расчету"
   mBasePrVal2
      FORMAT "99.9999" 
      LABEL  "Курс продажи"  
      HELP   "Курс продажи валюты по наличному расчету"


      
      

WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 5 TITLE "[ ВВЕДИТЕ КУРС ]".


ON F1 OF mEndDate DO:
   RUN calend.p.
   IF    (   LASTKEY EQ 13 
          OR LASTKEY EQ 10) 
      AND pick-value NE ?
   THEN FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.



PAUSE 0.

UPDATE
   mEndDate
   mPokVal1
   mPrVal1
   mPokVal2
   mPrVal2
   mBasePokVal1
   mBasePrVal1
   mBasePokVal2
   mBasePrVal2

WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT ( KEYFUNC(LASTKEY) EQ "GO" OR KEYFUNC(LASTKEY) EQ "RETURN") THEN LEAVE.
     

     FIND FIRST _user WHERE _user._userid = userid("bisquit") NO-LOCK.
  
     /**
      * Проверка на право работы с курсом.
      **/

     IF (NOT CAN-DO (GetXAttrValueEx("_user", _user._userid, "ТипыКурсов", ""),"НалПок" + iParam1)) OR (NOT CAN-DO (GetXAttrValueEx("_user", _user._userid, "ТипыКурсов", ""),"НалПр" + iParam1)) THEN
       DO:
        MESSAGE COLOR WHITE/RED "Нет прав для установки курса!" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #658]".
        RETURN.
       END.

    
     oTKurs = new Tkurs().

     /**
      * Проверка на наличие курса ЦБ
      **/
     IF (oTKurs:getCBRKurs(840,currDate) = ?) OR (oTKurs:getCBRKurs(978,currDate) = ?) THEN 
      DO:
        MESSAGE COLOR WHITE/RED "Не установлен курс ЦБ на" currDate "!" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
        DELETE OBJECT oTKurs NO-ERROR.
        RETURN.
      END.


     IF mPokVal1 > oTKurs:getCBRKurs(840,currDate) OR mPrVal1 < oTKurs:getCBRKurs(840,currDate) OR mPokVal2 > oTKurs:getCBRKurs(978,currDate) OR mPrVal2 < oTKurs:getCBRKurs(978,currDate) THEN 
          DO:
            MESSAGE COLOR WHITE/RED "ОШИБКА УСТАНОВКИ КУРСА" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
            DELETE OBJECT oTKurs NO-ERROR.
            RETURN.
          END.


     IF mPokVal1  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалПок" + iParam1,
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
                "НалПр" + iParam1,
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
                "НалПок" + iParam1,
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
                "НалПр" + iParam1,
	        mClass2,
		mEndDate,
		mPrVal2,
		1.0 ,
		YES
		).
        END.	

        /*****************************
         * Запрашиваем базовые курсы.
         *****************************
         * Автор : Маслов Д. А. Maslov D. A.
         * Заявка: #1280
         * Дата  : 26.11.12
         *****************************/
     IF mBasePokVal1 ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалБПок" + iParam1,
	        mClass1,
		mEndDate,
		mBasePokVal1,
		1.0 ,
		YES
		).
        END.	

     IF mBasePrVal1 ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалБПр" + iParam1,
	        mClass1,
		mEndDate,
		mBasePrVal1,
		1.0 ,
		YES
		).
        END.	

     IF mBasePokVal2 ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалБПок" + iParam1,
	        mClass2,
		mEndDate,
		mBasePokVal2,
		1.0 ,
		YES
		).
        END.	

     IF mBasePrVal2 ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "НалБПр" + iParam1,
	        mClass2,
		mEndDate,
		mBasePrVal2,
		1.0 ,
		YES
		).
        END.	

/* Отправка курсов на табло */
{pir-kurs_tboard.p}
message TBoard_Set_Rates (mPokVal1,mPrVal1,mPokVal2,mPrVal2,"PirTBoard") view-as alert-box.
/* Конец отправки курсов на табло */

/* Отправка курсов на сайт */
{pir-kurs_web.i}
Web_Set_Rates(mPokVal1,mPrVal1,mPokVal2,mPrVal2).
/* Конец отправки курсов на сайт */

MESSAGE "Ввод курсов закончен." VIEW-AS ALERT-BOX INFO BUTTONS OK.

DELETE OBJECT oTKurs NO-ERROR.