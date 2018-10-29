/***** ================================================================= *****/
/*** 	Работа с журналом заявок на выдачу наличных по кассе (классификатор PirStatCash)
	Запуск в параметром:
	0 - отчет по жураналу заявок на дату
	1 - ввод операционистом заявки с последующей печатью всего журнала
	2 - редактирование заявок (утверждение/запрет) сотрудником ПодФТ
	3 - режим для редактирования У10-1 
	4 - режим для редактирования заявки
	5 - создание заявки по документу (онлайн заявка)
	6 - режим утверждения заявки членами правления
	Место запуска                                                      ***/
/***** ================================================================= *****/



{intrface.get tmess} 
{globals.i}
{pir-statcash.i}


/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/


DEF INPUT PARAMETER vCode as CHAR.

DEF VAR cOpDate AS DATE NO-UNDO.
DEF VAR cAcct   AS CHAR format "x(20)" NO-UNDO.
DEF VAR cSum    AS DEC /*INT*/  NO-UNDO.
DEF VAR cDetls  AS CHAR format "x(20)" NO-UNDO.
DEF VAR cOnlnInitr AS CHAR INIT "" NO-UNDO.
DEF VAR newcOpDate AS DATE NO-UNDO.

DEF VAR strOpDate	AS CHAR INIT "" NO-UNDO.
DEF VAR CdCode		AS CHAR INIT "" NO-UNDO.
DEF VAR CdName		AS CHAR INIT "" NO-UNDO.
DEF VAR CdVal 		AS CHAR INIT "" NO-UNDO.
DEF VAR ResStCash 	AS INT  INIT 0  NO-UNDO.


cOpDate = gend-date .


/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ   0  -   отчет по классификатору заявок     ***/
/***** ================================================================= *****/

IF vcode = "0" THEN 
DO:

	FORM
	   cOpDate
	      FORMAT "99/99/9999"
	      LABEL  "Дата"  
	      HELP   "Дата журанала заявок"

	WITH FRAME fSet0 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ ДАТУ ЖУРНАЛА ЗАЯВОК ]".


	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.
	
	PAUSE 0.
	
	UPDATE
	   cOpDate
        WITH FRAME fSet0.
	
        HIDE FRAME fSet0 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.
	
	strOpDate = CreateStrOpDtStCash(cOpDate) .

	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

END. /* IF vcode = "0" */ 





/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ   1  -   режим ввода для операциониста      ***/
/***** ================================================================= *****/

IF vcode = "1" THEN 
DO:
	
	FORM
	   cOpDate
		FORMAT "99/99/9999"	LABEL  "Дата ОД"	HELP   "Дата журанала заявок"
	   cAcct	
		FORMAT "X(20)"		LABEL  "Счет"		HELP   "Введите номер счета F1 - браузер счетов)"
	   cSum
		FORMAT ">>>>>>>>9" 	LABEL  "Сумма"		HELP   "Сумма"
	   cDetls
		FORMAT "X(40)"		LABEL  "Вид расхода"	HELP   "Введите вид расхода"


	WITH FRAME fSet1 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ ДАННЫЕ ЗАЯВКИ ]".


  /*** Дата ОД ***/
	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.

  /*** Счет ***/ 
	ON "F1" OF cAcct IN FRAME fSet1
	DO:
	   DO TRANSACTION:
	      RUN browseld.p ("acct",
                      "RetRcp" + CHR(1) + "RetFld",
                      STRING(cAcct:HANDLE IN FRAME fSet1) + CHR(1) + "acct",
                      ?,
                      "5").
	   END.
	END.
	
	ON "LEAVE" OF cAcct IN FRAME fSet1
	DO:
	   ASSIGN
	      cAcct 
	   .
	END.

  /*** Сумма ***/ 
	ON LEAVE OF cSum IN FRAME fSet1
	DO:
	   ASSIGN
	      cSum 
	   .
  	END.
	
  /*** Вид расхода ***/
	ON F1 OF cDetls DO:
	  /* RUN currbrw.p */
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.


	ON "ENTER" OF FRAME fSet1 ANYWHERE 
	DO:
	    APPLY "TAB" TO SELF. 
	END.


	ON "GO" OF FRAME fSet1 ANYWHERE 
	DO:
	   ASSIGN
	      cOpDate 
	      cAcct
	      cSum
	      cDetls
	   .
	

	   IF NOT CAN-FIND(FIRST acct WHERE acct.acct EQ cAcct ) THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "Счет " + STRING(cAcct ) + " не существует.").
	      APPLY "Entry" TO cAcct  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	   IF (cSum = 0 OR  cSum = ?) THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "Сумма неверно задана!").
	      APPLY "Entry" TO cSum  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	   IF (cDetls = ? OR cDetls = "") THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "Вид расчета неверно задан!").
	      APPLY "Entry" TO cDetls  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	END.  
/*
	MESSAGE "vcode = 1 ; cSum = " cSum "cAcct = " cAcct "cOpDate = " cOpDate "cDetls  = " cDetls VIEW-AS ALERT-BOX.
*/
  /*** Поехалллиииии ***/ 		
	DO TRANSACTION
	  ON ERROR  UNDO, RETRY 
	  ON ENDKEY UNDO, RETURN 
	  WITH FRAME fSet1 :

	   PAUSE 0.

	   UPDATE 
	      cOpDate
	      cAcct 
	      cSum
	      cDetls
	   .

	   strOpDate = CreateStrOpDtStCash(cOpDate) .
	   CdCode    = CreateCdCodeStCash(cAcct,strOpDate) .
	   CdName    = CreateCdNameStCash(cAcct,STRING(cSum),cDetls,cOnlnInitr) .
	   CdVal     = CreateCdValStCash("не контролировали","","") .

	   ResStCash = CreateReqstStCash(strOpDate, CdCode, CdName, CdVal ) .

	   IF ResStCash = 1 THEN
	   DO:	
		MESSAGE "Завка заведена" VIEW-AS ALERT-BOX.
		 /* Запуск процедуры печати классификатора заявок */
           	 /* MESSAGE "ЗАПУСК ПЕЧАТИ "  strOpDate VIEW-AS ALERT-BOX. */
	   	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.
	   END.	
 
	END.  /*** Приехали ***/
	
	HIDE FRAME fSet1 NO-PAUSE.

  
END. /* IF vcode = "1" */ 





/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ   2  -   режим для редактирования ПодФТ     ***/
/*** 	                         3  -   режим для редактирования У10-1     ***/
/*** 	                         4  -   режим для редактирования заявки    ***/
/*** 	                         6  -   режим для редактирования заявки    ***/
/***** ================================================================= *****/

IF vcode = "2" OR vcode = "3" OR vcode = "4" OR vcode = "6" THEN 
DO:

	FORM
	   cOpDate
	      FORMAT "99/99/9999"
	      LABEL  "Дата"  
	      HELP   "Дата журанала заявок"

	WITH FRAME fSet2 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ ДАТУ ЖУРНАЛА ЗАЯВОК ]".


	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.
	
	PAUSE 0.
	
	UPDATE
	   cOpDate
        WITH FRAME fSet2.
	
        HIDE FRAME fSet2 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.
	
	strOpDate = CreateStrOpDtStCash(cOpDate) .

		 /* MESSAGE "ЗАПУСК РЕЖИМА РЕДАКТИРОВАНИЯ ПОДФТ pir-statcash-podft.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "2" THEN
        	RUN VALUE( STRING("pir-statcash-podft.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

		 /* MESSAGE "ЗАПУСК РЕЖИМА РЕДАКТИРОВАНИЯ У10-1 pir-statcash-u101.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "3" THEN
        	RUN VALUE( STRING("pir-statcash-u101.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.

		 /* MESSAGE "ЗАПУСК РЕЖИМА РЕДАКТИРОВАНИЯ ЗАЯВКИ ВСЕМИ pir-statcash-ed.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "4" THEN
        	RUN VALUE( STRING("pir-statcash-ed.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.
		 /* MESSAGE "ЗАПУСК РЕЖИМА УТВЕРЖДЕНИЯ ЧЛЕНАМИ ПРАВЛЕНИЯ pir-statcash-edruk.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "6" THEN
        	RUN VALUE( STRING("pir-statcash-edruk.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.



	 /* MESSAGE "ЗАПУСК ПЕЧАТИ " strOpDate VIEW-AS ALERT-BOX. */
	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

END. /* IF vcode = "2" OR vcode = "3" OR vcode = "4" OR vcode = "6" */ 





/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ   5  -   создание заявки по документу      ***/
/***** ================================================================= *****/

IF vcode = "5" THEN 
DO:

  MESSAGE "Завести заявку в журнале заявок на выдачу наличных через кассу ?" 
	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.

  IF mChange = ? OR mChange = NO THEN 
  DO:
	MESSAGE "Заявка не заведена! Выходим!" VIEW-AS ALERT-BOX.
	RETURN .
  END.

	/* Собираем данные по документу */ 

  {tmprecid.def}
  FOR FIRST tmprecid NO-LOCK,
  FIRST op WHERE RECID(op) = tmprecid.id 
  NO-LOCK:

    cAcct = "" . 

    FOR EACH op-entry OF op NO-LOCK:

	IF op-entry.currency = "" THEN
	  cSum = cSum + op-entry.amt-rub . 
	ELSE 
	  cSum = cSum + op-entry.amt-cur . 

	IF cAcct = "" THEN 
	  cAcct = op-entry.acct-db  .
	ELSE 
	DO: 
	  IF cAcct <> op-entry.acct-db  THEN
		DO: 
		  MESSAGE "Заявка не заведена! В проводках разные счета! Выходим!" VIEW-AS ALERT-BOX.
		  RETURN.
		END.
	END.
    END.

    cOpDate = op.op-date .
    cDetls  = TRIM(REPLACE(op.details,",",""))    .

  END.
  {empty tmprecid}

	/* Кто разрешил завести онлайн заявку */ 
  RUN browseld.p ("code",
		"class" + CHR(1) +
		"parent",  /* Поля для предустановки. */
	        "PirSightOP" + CHR(1) + 
		"Visa9OnlnInit",   /* Список значений полей. */
	        ?,  /* Поля для блокировки. */
	        "5" /* Строка отображения фрейма. */
		).
  FOR FIRST tmprecid ,
  FIRST code
	WHERE tmprecid.id = recid(code)
  NO-LOCK:
	cOnlnInitr = code.name .
  END.
/*
  MESSAGE "vcode = 5 ; cSum = " cSum " cAcct = " cAcct " cOpDate = " cOpDate " cDetls  = " cDetls " cOnlnInitr= " cOnlnInitr VIEW-AS ALERT-BOX.
*/
  IF cOnlnInitr = "" THEN
  DO:
	MESSAGE "Заявка не заведена! Выходим!" VIEW-AS ALERT-BOX.
	RETURN .
  END.

  IF ( cSum - TRUNCATE(cSum,0) ) > 0 THEN
    cSum = cSum + 1 .

  strOpDate = CreateStrOpDtStCash(cOpDate) .
  CdCode    = CreateCdCodeStCash(cAcct,strOpDate) .
  CdName    = CreateCdNameStCash(cAcct,STRING(cSum),cDetls,cOnlnInitr) .
  CdVal     = CreateCdValStCash("не контролировали","","") .

  ResStCash = CreateReqstStCash(strOpDate, CdCode, CdName, CdVal ) .

  IF ResStCash = 1 THEN
	DO:
	  MESSAGE "Завка заведена" VIEW-AS ALERT-BOX.
		/* рассылаются уведомления о заведении заявки */ 
	  RUN pir-statcash-mail.p (INPUT CdCode)  NO-ERROR.
	END.
 
END. /* IF vcode = "5" */ 




/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ   7  -   режим для редактирования ПодФТ     ***/
/***** ================================================================= *****/

IF vcode = "7"  THEN 
DO:

	FORM
	   cOpDate
	   FORMAT "99/99/9999"	LABEL  "Дата журнала заявок (источник)"  HELP   "Дата журнала заявок (источник)"
	   newcOpDate
	   FORMAT "99/99/9999"	LABEL  "В какую дату копируем"		 HELP   "В какую дату копируем"
	WITH FRAME fSet7 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ В КАКУЮ ДАТУ КОПИРУЕМ ? ]".


	ON F1 OF newcOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.

	PAUSE 0.
	
	UPDATE
	   cOpDate
	   newcOpDate
        WITH FRAME fSet7.
	
        HIDE FRAME fSet7 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.


		 /* MESSAGE "ЗАПУСК ПРОЦЕДУРЫ КОПИРОВАНИЯ pir-statcash-copy.p " VIEW-AS ALERT-BOX. */
	IF vcode = "7" THEN
        	RUN VALUE( STRING("pir-statcash-copy.p") )( INPUT CreateStrOpDtStCash(cOpDate) + "," + CreateStrOpDtStCash(newcOpDate) ) )  NO-ERROR.

END. /* IF vcode = "7" */ 



{preview.i}
