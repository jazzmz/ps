/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2013
     Filename: pir-i-ucssv.p
      Comment: Сверка остатков в АБС с данными r-файла из процессинга
		Является заменой внутреннего алгоритма транзакции "i-ucssv Сверка остатков с процессингом"		
		Запускается из транзакции i-ucssv
   Parameters: Один входной параметр, в котором через | указаны следующие данные:
		@__rdate - дата опер дня
		@__rfile_name - имя r-файла с остатками из ПЦ
		@__log_file   - имя log-файла
		@__jour_file  - имя файла отчета для пользователя (Выводится пользователю)
       Launch: ПК - ОпДень - INSERT - i-ucs ИМПОРТ UCS - i-ucs007 СВЕРКА ОСТАТКОВ - i-ucssv+ НОВАЯ Сверка остатков с процессингом
         Uses:
      Created: Sitov S.A., 25.01.2013
	Basis: #1260
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{sh-defs.i}
{intrface.get xclass}



DEF INPUT PARAM iParam	 AS CHAR.

DEF VAR  irdate		AS DATE NO-UNDO.
DEF VAR  impFName	AS CHAR NO-UNDO.
DEF VAR  outLogFile	AS CHAR NO-UNDO.
DEF VAR  outRepFile	AS CHAR NO-UNDO.

irdate     = DATE(ENTRY(1,iParam,"|")) .
impFName   = ENTRY(2,iParam,"|") .
outLogFile = ENTRY(3,iParam,"|") .
outRepFile = ENTRY(4,iParam,"|") .

/*
MESSAGE 
   " Процедура получила входные параметры: " chr(10)
   " irdate= "       irdate chr(10)	  
   " impFName="      impFName  chr(10)
   " outLogFile="    outLogFile chr(10)
   " outRepFile="    outRepFile 
VIEW-AS ALERT-BOX TITLE "Сообщение из процедуры обработки" .
*/


DEFINE STREAM iStream.
DEFINE STREAM sLog.
DEFINE STREAM sRep.

DEF VAR  mTxtLine	AS CHAR NO-UNDO.
DEF VAR  mStrNum	AS INT64 NO-UNDO.
DEF VAR  mErrorStr	AS CHAR NO-UNDO.
DEF VAR  schetchik	AS INT64 INIT 0 NO-UNDO.


DEF VAR  CardOwner	AS CHAR NO-UNDO.
DEF VAR  CardStatus	AS CHAR NO-UNDO.  
DEF VAR  CardCurrency	AS CHAR NO-UNDO.
DEF VAR  SCSAcct	AS CHAR NO-UNDO.
DEF VAR  SCSAcctCurr	AS CHAR NO-UNDO.
DEF VAR  SCSAcctOst	AS DEC  NO-UNDO.
DEF VAR  OverAcct	AS CHAR NO-UNDO.
DEF VAR  OverAcctOst	AS DEC  NO-UNDO.
DEF VAR  CounterOver	AS INT64 NO-UNDO.
DEF VAR  OstAcctAll	AS DEC  NO-UNDO.
DEF VAR  Diff		AS DEC  NO-UNDO.
DEF VAR  OverDog	AS CHAR NO-UNDO.


DEFINE TEMP-TABLE ttRfile NO-UNDO
   FIELD mStrNum   AS INT64
   FIELD HoldName  AS CHAR
   FIELD CardNum   AS CHAR
   FIELD Currency  AS CHAR
   FIELD RashLim   AS DEC
   FIELD BlckSum   AS CHAR 
   FIELD DostSum   AS CHAR 
INDEX mStrNum CardNum .


DEFINE BUFFER card FOR loan.
DEFINE BUFFER scs-acct FOR loan-acct.
DEFINE BUFFER bloan FOR loan.
DEFINE BUFFER bloan-acct FOR loan-acct.
DEFINE BUFFER wloan-acct FOR loan-acct.


DEF VAR  RepBeg		AS CHAR NO-UNDO.
DEF VAR  RepEnd		AS CHAR NO-UNDO.
DEF VAR  TablSep	AS CHAR NO-UNDO.
DEF VAR  TablHead	AS CHAR NO-UNDO.




  /* --- Переменные для печатной формы отчета --- */

RepBeg = FILL(" ",20) + "НОВАЯ ПРОЦЕДУРА СВЕРКИ ОСТАТКОВ" + CHR(10) +
	 "ООО КБ ПРОМИНВЕСТРАСЧЕТ" + CHR(10) +  /*  cBankName */
	 "Файл с остатками из процессинга " + REPLACE(impFName,"/home/bis/quit41d/imp-exp/pcard/in/","") + CHR(10) +
	 "Остаток в АБС Бисквит на дату " + STRING(irdate,"99/99/9999") + " время: " + STRING(time,"hh:mm:ss") + CHR(10)
	.

RepEnd = GetCodeName("PirU11Podpisi", "Full_" + userid("bisquit") ) + CHR(10) + CHR(10) +
	 GetCodeName("PirU11Podpisi", "Full_04110bng" ) + CHR(10)
	.

TablSep  = FILL("-",233) .

TablHead = "|№ п/п" + " | " + "   Номер карты  " + " |" + "Статус" + "| " + "       Держатель    " + " | " + "   Номер счета      " + " | " + "     Владелец счета           " + " | " + "Вал" + " | " + " Остаток в ПЦ  " +	" | " + " Остаток на SCS" +	" | " + /*"      Счет 91317    " + " | " +*/ "Кредитный лимит" + " | " + " Остаток в АБС " + " | " + "    Разница    " +	" | " .




  /* --- ------------------------------------------------------ --- */
  /* --- Импорт файла остатков во временную таблицу TEMP-TABLE  --- */
  /* --- ------------------------------------------------------ --- */

{setdest.i	&stream = "STREAM sLog"		
		&filename = outLogFile
}

MESSAGE "ОБРАБАТЫВАЕМ ФАЙЛ: " impFName VIEW-AS ALERT-BOX TITLE "Сообщение из процедуры обработки" .

PUT STREAM sLog UNFORMATTED "ИМПОРТ ФАЙЛА ОСТАТКОВ" SKIP.
PUT STREAM sLog UNFORMATTED "Файл #" impFName  SKIP.
PUT STREAM sLog UNFORMATTED "Время загрузки: " STRING(irdate,"99/99/9999") + " " + STRING(time,"hh:mm:ss") SKIP.


INPUT STREAM iStream FROM VALUE(impFName) CONVERT SOURCE "1251"  .


MAIN:
DO TRANSACTION ON ERROR UNDO MAIN, RETRY MAIN:

   /* --- Обработка ошибок --- */
   IF RETRY THEN DO:
      ASSIGN mErrorStr = RETURN-VALUE                WHEN mErrorStr = "".
      ASSIGN mErrorStr = ERROR-STATUS:GET-MESSAGE(1) WHEN mErrorStr = "".
      ASSIGN mErrorStr = "Не определена"             WHEN mErrorStr = "".
      PUT STREAM sLog UNFORMATTED "ОШИБКА: " mErrorStr SKIP.
      LEAVE MAIN.
   END.


   /* --- Импорт файла в TEMP-TABLE --- */
   imp:
   REPEAT:

      IMPORT STREAM iStream UNFORMATTED mTxtLine.
      mStrNum = mStrNum + 1.
      PUT STREAM sLog UNFORMATTED "Импорт строки #" mStrNum " --------------------" SKIP.
      IF mStrNum = 1    /* первую строку пропускаем */
      THEN NEXT imp.

	      /* Вкачка одной записи */
      CREATE ttRfile.
      ASSIGN
         ttRfile.mStrNum  =  mStrNum
         ttRfile.HoldName =  TRIM(SUBSTRING(mTxtLine,1,60))
         ttRfile.CardNum  =  TRIM(SUBSTRING(mTxtLine,61,16))
         ttRfile.Currency =  TRIM(SUBSTRING(mTxtLine,93,3))  
         ttRfile.RashLim  =  DECIMAL(TRIM(SUBSTRING(mTxtLine,96,15))) 
         ttRfile.BlckSum  =  TRIM(SUBSTRING(mTxtLine,111,14))
         ttRfile.DostSum  =  TRIM(SUBSTRING(mTxtLine,123,17))
      NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:

         PUT STREAM sLog UNFORMATTED "Номер строки: " STRING(mStrNum) ". Некорректный формат файла. Загрузка прервана." SKIP.

         UNDO MAIN, LEAVE MAIN.
      END.

   END.

   PUT STREAM sLog UNFORMATTED "Импорт файла во временную таблицу завершен успешно. Начинаем обработку" SKIP.

END.


INPUT STREAM iStream CLOSE.

/*
{preview.i 	&stream = "STREAM sLog"
		&filename = outLogFile
}
*/





  /* --- ---------------------------------------------------------------------------- --- */
  /* --- Сверка остатков: по данным импортированным в TEMP-TABLE с данными в БИСКВИТЕ --- */
  /* --- ---------------------------------------------------------------------------- --- */

{setdest.i 	&stream = "STREAM sRep"
		&filename = outRepFile
}


PUT STREAM sRep UNFORM RepBeg    SKIP(2).
PUT STREAM sRep UNFORM TablHead  SKIP.
PUT STREAM sRep UNFORM TablSep   SKIP.


FOR EACH ttRfile 
  /* WHERE  ttRfile.CardNum = "4237390000040933" */
  BY ttRfile.CardNum BY CardOwner 
:

   ASSIGN
	CardOwner = ""		CardStatus = ""		CardCurrency = ""	               
	SCSAcct	= ""		SCSAcctCurr = ""	SCSAcctOst = 0	              
	OverAcct = ""		OverAcctOst = 0 	CounterOver = 0          
	OstAcctAll = 0 
	Diff = 0	OverDog = ""
   .

   /* --- Поиск договора по loan --- */
   FIND FIRST card 
	WHERE card.contract = 'card'
	AND   card.doc-num  = ttRfile.CardNum
	AND   card.loan-status <> 'ЗАКР'
	AND   card.loan-status <> CHR(251)
	AND   card.loan-status <> ''
   NO-LOCK NO-ERROR.

   IF AVAIL(card) THEN
   DO:	

	IF card.cust-cat = 'Ч' THEN
	DO:
	    FIND FIRST person WHERE person.person-id = card.cust-id NO-LOCK NO-ERROR.
	    CardOwner = person.name-last + " " + person.first-name .
	END.
	ELSE 
	DO:
	    FIND FIRST cust-corp WHERE cust-corp.cust-id = card.cust-id NO-LOCK NO-ERROR.
	    CardOwner = cust-corp.name-corp .
	END.

	CardStatus   = card.loan-status .
	CardCurrency = ENTRY(2,card.parent-cont-code,"/") .

	IF CardCurrency = "RUR" THEN	
	   SCSAcctCurr = "" .
	IF CardCurrency = "USD" THEN	
	   SCSAcctCurr = "840" .
	IF CardCurrency = "EUR" THEN	
	   SCSAcctCurr = "978" .


	FIND LAST scs-acct
	   WHERE scs-acct.contract  = card.parent-contract
	   AND   scs-acct.cont-code = card.parent-cont-code  
	   AND   scs-acct.acct-type = STRING("SCS@" + SCSAcctCurr)
	   AND   scs-acct.since <= irdate
	NO-LOCK NO-ERROR.

	IF AVAIL(scs-acct) THEN
	DO:
	    SCSAcct = scs-acct.acct .
	    RUN acct-pos IN h_base (SCSAcct, SCSAcctCurr, irdate, irdate, 'Ф' ) .		
	    IF SCSAcctCurr = "" THEN SCSAcctOst = ABS(sh-bal) . 
	    ELSE SCSAcctOst = ABS(sh-val) . 
	END.		


	   /* --- Поиск с ошибкой по loan-acct     --- */
	   /* --- (овердрафтных договоров ПК)      --- */
	   /* --- д.б. не больше одного открытого  --- */

	FOR EACH bloan-acct
		WHERE bloan-acct.acct = SCSAcct
		AND   bloan-acct.acct-type  = 'КредРасч'
        	AND   bloan-acct.cont-code BEGINS 'ПК' 
		AND   (NUM-ENTRIES(bloan-acct.cont-code,' ') = 1)
	NO-LOCK,
	FIRST bloan OF bloan-acct
		WHERE ( bloan.close-date >= irdate OR bloan.close-date = ? )
		AND   bloan.open-date <= irdate
		AND   bloan.cont-code = bloan-acct.cont-code
	NO-LOCK:
        
	  IF AVAIL(bloan-acct) THEN
	  DO:
	     CounterOver = CounterOver + 1 .
	     OverDog = bloan.cont-code .


		FIND FIRST /*LAST*/ wloan-acct
		   WHERE wloan-acct.cont-code = OverDog
		   AND   wloan-acct.acct BEGINS '91317' 
		   AND   wloan-acct.acct-type  = 'КредН'
		   AND   wloan-acct.since <= irdate  
		NO-LOCK NO-ERROR.
	
		IF AVAIL(wloan-acct) THEN
		DO:
		    OverAcct = wloan-acct.acct .
		    RUN acct-pos IN h_base (wloan-acct.acct, wloan-acct.currency, irdate, irdate, 'Ф' ) .		
        	    IF wloan-acct.currency = "" THEN 
			OverAcctOst = OverAcctOst + ABS(sh-bal) . 
		    ELSE 
			OverAcctOst = OverAcctOst + ABS(sh-val) . 
	       	END.


	  END.
	END.


	   /* --- Считаем кредитный лимит, только если    --- */
	   /* --- есть один открытый овердрафтный договор --- */
/***
	IF CounterOver = 1 THEN
	DO:	

		FIND FIRST /*LAST*/ wloan-acct
		   WHERE wloan-acct.cont-code = OverDog
		   AND   wloan-acct.acct BEGINS '91317' 
		   AND   wloan-acct.acct-type  = 'КредН'
		   AND   wloan-acct.since <= irdate  
		NO-LOCK NO-ERROR.
	
		IF AVAIL(wloan-acct) THEN
		DO:
		    OverAcct = wloan-acct.acct .
		    RUN acct-pos IN h_base (wloan-acct.acct, wloan-acct.currency, irdate, irdate, 'Ф' ) .		
        	    IF wloan-acct.currency = "" THEN OverAcctOst = ABS(sh-bal) . 
		    ELSE OverAcctOst = ABS(sh-val) . 
	       	END.
	
	END. /* end IF CounterOver = 1 */ 
***/	

	OstAcctAll = SCSAcctOst + OverAcctOst .
	Diff =  DECIMAL(ttRfile.RashLim) - OstAcctAll .

   END. /* end_IF AVAIL(card) THEN */ 


   IF Diff <> 0 THEN 
   DO:

      schetchik = schetchik + 1 .

	      /* --- ОТЧЕТ --- */
      PUT STREAM sRep UNFORM
	"|" schetchik FORMAT ">>>>9" 	" | "  
	ttRfile.CardNum FORMAT "X(16)"	" | "  
	CardStatus FORMAT "X(4)"	" | "  
	ttRfile.HoldName FORMAT "X(20)"	" | "   
	SCSAcct    FORMAT "X(20)"	" | " 
	CardOwner  FORMAT "X(30)"	" | " 
	CardCurrency  FORMAT "X(3)"	" | " 
        ttRfile.RashLim FORMAT "->>>,>>>,>>9.99"	" | " 
	SCSAcctOst  FORMAT "->>>,>>>,>>9.99" 		" | " 
	/* OverAcct    FORMAT "X(20)"			" | "  */
	OverAcctOst FORMAT "->>>,>>>,>>9.99" 		" | "          
	OstAcctAll  FORMAT "->>>,>>>,>>9.99" 		" | " 
	Diff        FORMAT "->>>,>>>,>>9.99" 		" | " 
	( IF CounterOver > 1 THEN "больше одного овера!" ELSE "" ) " | " 
	/* OverDog */
      SKIP.

   END.

END.



PUT STREAM sRep UNFORM TablSep   SKIP(2).
PUT STREAM sRep UNFORM RepEnd    SKIP.

{preview.i 	&stream = "STREAM sRep"
		&filename = outRepFile
}

