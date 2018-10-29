{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-chng-acctname.p
      Comment: Переименование счетов в соответсвии с требованиями 302-п
   Parameters: Входные параметры через "/" : 
		Первый - режим работы (1 - отчет переименованных счетов и само переименование, 2 - отчет по НЕпереименованным счетам )
		Втророй - номера счетов 2-го порядка через запятую. По ним будет делаться выборка. 
			Это чтобы можно было переименовывать частями одной процедурой
       Launch: КД - Разное - СМЕНА НАИМЕНОВАНИЙ СЧЕТОВ
         Uses:
      Created: Sitov S.A., 24.07.2012
	Basis: #1125 
     Modified: Sitov S.A., 08.08.2012 - #1191, добален отчет по непереименованным счетам
*/
/* ========================================================================= */



{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека моих собственных функций */
{intrface.get i254}



/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

DEF INPUT PARAM iParam AS CHAR NO-UNDO.

DEF VAR iAcctList AS CHAR NO-UNDO.
DEF VAR iCode     AS CHAR NO-UNDO.


DEF VAR cNewDet AS CHAR NO-UNDO.   /*новое наименование счета */ 

   /* Кредитный договор */
DEF VAR cKlName AS CHAR NO-UNDO.
DEF VAR cKDnum  AS CHAR NO-UNDO.
DEF VAR cKDzakl AS CHAR NO-UNDO.
DEF VAR cKDsrok AS CHAR NO-UNDO.
DEF VAR cKDkk   AS CHAR NO-UNDO.
DEF VAR cKDrate AS CHAR NO-UNDO.

   /* Договор обеспечения */
DEF VAR cDOSurr AS CHAR NO-UNDO.
DEF VAR cDONum  AS CHAR NO-UNDO.
DEF VAR cDOZakl AS CHAR NO-UNDO.
DEF VAR cDONumPP  AS CHAR  NO-UNDO.
DEF VAR cDOVidDog AS CHAR NO-UNDO.
DEF VAR cDOKlName AS CHAR NO-UNDO.
DEF VAR cDOKl   AS CHAR NO-UNDO.

DEF VAR lnacct AS LOGICAL NO-UNDO.

DEF VAR i        AS INT INIT 0 NO-UNDO.
DEF VAR ibad     AS INT INIT 0 NO-UNDO.
DEF VAR tbalacct AS INT INIT 0 NO-UNDO .

   /* Временная таблица для отобранных счетов, которые будут переименованы */
DEF TEMP-TABLE repacct NO-UNDO
	FIELD balacct  AS INT
	FIELD acct     AS CHAR
	FIELD olddetls AS CHAR
	FIELD newdetls AS CHAR
	INDEX balacct acct
.

   /* Временная таблица для счетов, которые НЕ будут переименованы */
DEF TEMP-TABLE repbadacct NO-UNDO
	FIELD balacct  AS INT
	FIELD acct     AS CHAR
	FIELD olddetls AS CHAR
	FIELD ln-acct  AS CHAR
	INDEX balacct acct
.

DEF BUFFER bloan FOR loan.



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

IF NUM-ENTRIES(iParam,"/") > 1 THEN	
    DO:
	iCode = ENTRY(1,iParam,"/").
	iAcctList = ENTRY(2,iParam,"/").
    END.
ELSE
    DO:
	MESSAGE "Неверно заданы параметры процедуры. Выходим!" VIEW-AS ALERT-BOX.
	RETURN.
    END.



FOR EACH acct
	WHERE  acct.close-date = ?
	AND CAN-DO(iAcctList,STRING(acct.bal-acct))
NO-LOCK:

/* если по какой-то причине данные не будут найдены, то это хотя бы будет заметно */
  cNewDet = "" .	cKlName = "______" .	cKDzakl = "__" .
  cKDnum  = "____" .	cKDkk   = "__" .	cKDrate = "___" .

  cDOSurr = "".		cDONum = "__" .		cDOZakl = "__" .
  cDONumPP = "__" .	cDOVidDog = "__" .	cDOKlName = "__" .
  cDOKl = "__" .

  lnacct = no .


  FOR FIRST loan-acct 
	WHERE loan-acct.acct EQ acct.acct 
	AND   loan-acct.currency EQ acct.currency
	AND   loan-acct.contract  EQ "кредит"
  NO-LOCK,
  FIRST loan 
	WHERE loan.contract EQ "кредит"
	AND loan.cont-code EQ  loan-acct.cont-code
	/* AND loan.cust-id EQ acct.cust-id */
  NO-LOCK:
    IF AVAIL loan-acct THEN
    DO:

	lnacct = yes .

	IF NUM-ENTRIES(loan-acct.cont-code,' ') > 1 THEN    
	  cKDnum = ENTRY(1,loan-acct.cont-code,' ') .
	ELSE 
	  cKDnum = loan-acct.cont-code .

        FIND FIRST bloan WHERE bloan.cont-code = cKDnum NO-LOCK NO-ERROR.

	cKlName = GetLoanInfo_ULL(bloan.contract, bloan.cont-code, "client_short_name", false) .
	cKDzakl = GetXattrValueEx("loan",STRING(bloan.contract + "," + bloan.cont-code),"ДатаСогл","__") .

/* по договоренности с Бажиновой О. убрал
	IF NOT(cKDnum BEGINS "КЛ") AND NOT(cKDnum BEGINS "ПК")  THEN
*/
	  cKDnum = "КД " + cKDnum .

    END.
  END.

 IF lnacct = YES THEN
 DO:
  i = i + 1 .
  CASE acct.bal-acct :
    WHEN 45201 OR WHEN 45202 OR WHEN 45203 OR WHEN 45204 OR WHEN 45205 OR WHEN 45206 OR WHEN 45207 OR WHEN 45208 OR WHEN 45209 OR WHEN 45502 OR WHEN 45503 OR WHEN 45504 OR WHEN 45505 OR WHEN 45506 OR WHEN 45507 OR WHEN 45508 OR WHEN 45701 OR WHEN 45702 OR WHEN 45703 OR WHEN 45704 OR WHEN 45705 OR WHEN 45706 OR WHEN 45707 OR WHEN 45709 THEN DO:

	FIND LAST comm-rate 
		WHERE comm-rate.commission BEGINS "%Рез" 
		AND comm-rate.kau = bloan.contract + ',' + bloan.cont-code
		AND comm-rate.currency = bloan.currency
		AND comm-rate.since <= bloan.open-date 
	NO-LOCK NO-ERROR.
    
	  IF AVAILABLE(comm-rate) THEN 
		cKDkk = string(re_history_risk(ENTRY(1,comm-rate.kau), ENTRY(2,comm-rate.kau), comm-rate.since,1)) .
	  ELSE
        	cKDkk = "__".

	cKDrate = STRING(GetCredLoanCommission_ULL(bloan.cont-code, "%Кред", bloan.open-date, false) * 100 ,"99.99" ) .

	cKDsrok = " с " + STRING(bloan.open-date,"99/99/9999") + " по " + STRING(bloan.end-date,"99/99/9999") .

	cNewDet = cKlName + " ссудный счет по " + cKDnum + " от " + cKDzakl + cKDsrok + "; на момент выдачи к/к - " + cKDkk  + ", % ставка - " + cKDrate.
    END.
    WHEN 45509 OR WHEN 45708 THEN DO:
	cKDrate = STRING(GetCredLoanCommission_ULL(bloan.cont-code, "%Кред", bloan.open-date, false) * 100 ,"99.99" ) .
	cNewDet = cKlName + " ссудный счет по " + cKDnum + " от " + cKDzakl + ", % ставка - " + cKDrate.
    END.
    WHEN 45812 OR WHEN 45815 OR WHEN 45817 THEN DO:
	cNewDet = cKlName + " просроченная ссуда по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 45912 OR WHEN 45915 THEN DO:
	cNewDet = cKlName + " просроченные % по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 47427 THEN DO:
	cNewDet = cKlName + " требования по получению % по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 45215 OR WHEN 45515  THEN DO:
	cNewDet = cKlName + " резерв по ссуде по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 47425 THEN DO:
       IF lnacct = YES THEN 
       DO:
	IF loan-acct.acct-type = "КредРезВб" THEN
		cNewDet = cKlName + " РВП на неиспользованный лимит по " + cKDnum + " от " + cKDzakl .
	IF loan-acct.acct-type = "КредРезП" OR loan-acct.acct-type = "КредРезПени" THEN
		cNewDet = cKlName + " РВП на требования по получению % по " + cKDnum + " от " + cKDzakl .
	IF NOT(loan-acct.acct-type = "КредРезП" OR loan-acct.acct-type = "КредРезВб") THEN
	 DO:
	  ibad =  ibad + 1 .
	  CREATE repbadacct .
	  ASSIGN
		repbadacct.balacct = acct.bal-acct
		repbadacct.acct = acct.acct
		repbadacct.olddetls = acct.details
		repbadacct.ln-acct = "привязан"
	  .
	 END.
       END.  /* IF lnacct = YES */
    END.
    WHEN 45818 THEN DO:
	cNewDet = cKlName + " резерв по просроченной ссуде по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 45918 THEN DO:
	cNewDet = cKlName + " резерв на просроченные % по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 91316 THEN DO:
	cNewDet = cKlName + " неисп.лимит выдачи по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 91317 THEN DO:
	cNewDet = cKlName + " неисп.лимит задолженности по " + cKDnum + " от " + cKDzakl .
    END.
    WHEN 91604 THEN DO:
       IF lnacct = YES THEN 
       DO:
	IF loan-acct.acct-type = "КредТВ" THEN
		cNewDet = cKlName + " начисленные % по " + cKDnum + " от " + cKDzakl .
	IF loan-acct.acct-type = "КредПр%В" THEN
		cNewDet = cKlName + " просроченные % по " + cKDnum + " от " + cKDzakl .
	IF NOT(loan-acct.acct-type = "КредТВ" OR loan-acct.acct-type = "КредПр%В") THEN
	 DO:
	  ibad =  ibad + 1 .
	  CREATE repbadacct .
	  ASSIGN
		repbadacct.balacct = acct.bal-acct
		repbadacct.acct = acct.acct
		repbadacct.olddetls = acct.details
		repbadacct.ln-acct = "привязан"
	  .
	 END.
       END.  /* IF lnacct = YES */
    END.

    WHEN 91311 OR WHEN 91312 OR WHEN 91414 THEN DO:

	  /*** Находим договор (залога, поручительства, ...) обеспечения и нужную инфу по нему ***/

	FOR EACH term-obl 
		WHERE term-obl.contract EQ bloan.contract
	  	AND term-obl.cont-code  EQ bloan.cont-code
		AND term-obl.idnt       EQ 5
	NO-LOCK:

	  cDOSurr = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) + "," 
		    + STRING(term-obl.end-date) + "," + STRING(term-obl.nn) .

	  cDONumPP  = GetXAttrValueEx ("term-obl", cDOSurr,"НомерПП", "") .
	  cDOVidDog = GetXAttrValueEx ("term-obl", cDOSurr, "ВидДогОб", "") .

	  cDOVidDog = cDOVidDog + (IF cDONumPP NE "0" THEN cDONumPP ELSE "") .

		/*** Ищем (вид договора + номер) EQ роли счета ***/
          IF loan-acct.acct-type EQ cDOVidDog THEN 
	  DO:	

		cDONum  = ENTRY(1, GetXAttrValueEx("term-obl", cDOSurr, "НомДогОб", ""), "____").
		cDOZakl = STRING(term-obl.fop-date,"99/99/9999") .
		cDOKl   = GetXAttrValueEx ("term-obl", cDOSurr,"CustSurr","") .
				
		IF ENTRY(1,cDOKl) = "Ч" THEN
		DO:
		  FIND FIRST person WHERE person.person-id = INT(ENTRY(2,cDOKl)) NO-LOCK NO-ERROR.
		  cDOKlName = person.name-last + " " + person.first-name .
		END. 

		IF ENTRY(1,cDOKl) = "Ю" THEN
		DO:
		  FIND FIRST cust-corp WHERE cust-corp.cust-id = INT(ENTRY(2,cDOKl)) NO-LOCK NO-ERROR.
		  cDOKlName = cust-corp.name-short .
		END. 

		LEAVE.

	  END. /* end_if loan-acct.acct-type EQ cDOVidDog */
       
	END. /* for_each */ 


	IF acct.bal-acct = 91311 THEN
		cNewDet = "ДЗ " + cDOnum + " от " + cDOZakl + " ценных бумаг " + cDOKlName + " по " + cKDnum + " от " + cKDzakl + " " + cKlName . 
	IF acct.bal-acct = 91312 THEN
		cNewDet = "ДЗ " + cDOnum + " от " + cDOZakl + " " + cDOKlName + " по " + cKDnum + " от " + cKDzakl + " " + cKlName . 
	IF acct.bal-acct = 91414 THEN
		cNewDet = "ДП " + cDOnum + " от " + cDOZakl + " " + cDOKlName + " по " + cKDnum + " от " + cKDzakl + " " + cKlName . 

    END.

    WHEN 61301 THEN DO:
       IF lnacct = YES THEN 
       DO:
	IF loan-acct.acct-type = "КредБудПроц" THEN
	  cNewDet = cKlName + " доходы будущих периодов по " + cKDnum + " от " + cKDzakl .
	ELSE
	 DO:
	  ibad =  ibad + 1 .
	  CREATE repbadacct .
	  ASSIGN
		repbadacct.balacct = acct.bal-acct
		repbadacct.acct = acct.acct
		repbadacct.olddetls = acct.details
		repbadacct.ln-acct = "привязан"
	  .
	 END.
       END.  /* IF lnacct = YES */
    END.

  END CASE.

  CREATE repacct .
  ASSIGN
	repacct.balacct = acct.bal-acct
	repacct.acct = acct.acct
	repacct.olddetls = acct.details
	repacct.newdetls = cNewDet
  .

 END. /* if lnacct =yes then */
 ELSE /* т.е. lnacct = NO */ 	/*** СЧЕТА, КОТОРЫЕ НЕ БУДУТ ПЕРЕИМЕНОВАНЫ ***/
 DO:

  ibad =  ibad + 1 .

  CREATE repbadacct .
  ASSIGN
	repbadacct.balacct = acct.bal-acct
	repbadacct.acct = acct.acct
	repbadacct.olddetls = acct.details
	repbadacct.ln-acct = ""
  .

 END. /* if lnacct = no then */


END. /* end_for_each */ 



{setdest.i}



/***** ================================================================= *****/
/***   ЗАПУСК С ПАРАМЕТРОМ 1 - отчет переим-х счетов и само переименование ***/
/***** ================================================================= *****/

IF iCode = "1" THEN 
DO:

  tbalacct = 0 .

  PUT UNFORM    "         ОТЧЕТ ПО СЧЕТАМ, КОТОРЫЕ БУДУТ ПЕРЕИМЕНОВАНЫ     "  SKIP(1) .

  FOR EACH repacct BY repacct.balacct :
  
    IF tbalacct <> repacct.balacct THEN
  	DO:
  	PUT UNFORM SKIP(1).
  	PUT UNFORM "   --- " repacct.balacct " " FILL("-",100) SKIP(1).
  	tbalacct = repacct.balacct .
  	END.
  	
    PUT UNFORM 
  	repacct.acct  FORMAT "X(20)" " | " repacct.olddetls FORMAT "X(140)" " | " 
    SKIP.
    PUT UNFORM 
  			FILL(' ',20) " | " repacct.newdetls FORMAT "X(140)" " | " 
    SKIP.
  
  END.
  
  PUT UNFORM "    ВСЕГО: " i SKIP.  
  
  {preview.i}
  
  
  MESSAGE "Произвести смену наименования ?" 
  	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.
  
  IF mChange NE ? THEN 
   DO:
    IF mChange = YES THEN
      DO:
  
  	/********* СМЕНА НАИМЕНОВАНИЯ СЧЕТА ***********/
  
  	FOR EACH repacct BY repacct.balacct :
  
  	FIND FIRST acct WHERE acct.acct EQ repacct.acct EXCLUSIVE-LOCK .
  
  	IF AVAIL acct THEN
  		acct.details = repacct.newdetls .
  
  	END.
  
  	MESSAGE " Смена наименования произошла!" VIEW-AS ALERT-BOX.
  
      END.
    ELSE
       MESSAGE " Смена наименования не произошла!" VIEW-AS ALERT-BOX.
   END.

END.  /* IF iCode = "1" THEN  */ 


/***** ================================================================= *****/
/***        ЗАПУСК С ПАРАМЕТРОМ 2 - отчет по НЕпереименованным счетам      ***/
/***** ================================================================= *****/

IF iCode = "2" THEN 
DO:

	/*** ШАПКА ОТЧЕТА ***/
  PUT UNFORM    "         ОТЧЕТ ПО НЕ ПЕРЕИМЕНОВАННЫМ СЧЕТАМ     "  SKIP(1) .
  PUT UNFORM   	"Номер счета" FORMAT "X(20)" " | " "Наименование" FORMAT "X(140)" "| "  FILL(" ",8) "|"  SKIP(1).

  tbalacct = 0 .

  FOR EACH repbadacct BY repbadacct.balacct :
  
    IF tbalacct <> repbadacct.balacct THEN
  	DO:
  	PUT UNFORM SKIP(1).
  	PUT UNFORM "   --- " repbadacct.balacct " " FILL("-",100) SKIP(1).
  	tbalacct = repbadacct.balacct .
  	END.
  	
    PUT UNFORM 
  	repbadacct.acct  FORMAT "X(20)" " | " repbadacct.olddetls FORMAT "X(140)" "| "  repbadacct.ln-acct FORMAT "X(8)" "|"
    SKIP.
  
  END.

  PUT UNFORM "    ВСЕГО: " ibad SKIP.  
  
  {preview.i}

END.  /* IF iCode = "2" THEN  */   
