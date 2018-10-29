/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir-statcash.i
      Comment: Функции для работа с журналом заявок на выдачу наличных 
		по кассе (классификатор PirStatCash)
      Created: Sitov S.A., 30.11.2012 
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}                       	


/* ========================================================================= */
/** Функция: сгенерировать поле code.parent (это strOpDate) для заведения заявки
    Входные параметры: 
*/
FUNCTION CreateStrOpDtStCash RETURNS CHARACTER
  (INPUT iOpDate  AS DATE 
  ): 

  DEF VAR Result	AS CHAR NO-UNDO.


  Result = STRING(YEAR(iOpDate)) 
	 + STRING(MONTH(iOpDate),"99") 
	 + STRING(DAY(iOpDate),"99") .
/*
MESSAGE
  " RUN CreateStrOpDtStCash " 
  " iOpDate  "  iOpDate
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.




/* ========================================================================= */
/** Функция: сгенерировать поле code.code для заведения заявки
    Входные параметры: 
*/
FUNCTION CreateCdCodeStCash RETURNS CHARACTER
  (INPUT iAcct  AS CHARACTER ,
   INPUT istrOpDate  AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR NO-UNDO.


  FIND FIRST acct WHERE acct.acct EQ iAcct NO-LOCK NO-ERROR.

  Result = STRING(acct.cust-id) + "_" + 
	   SUBSTRING(acct.acct,6,3) + "_" + 
	   acct.cust-cat  + "_" + 
	   SUBSTRING(iAcct,17,4) + "_" + 
	   istrOpDate + "_" + 
	   STRING(TIME)
	   .              
/*
MESSAGE
  " RUN CreateCdCodeStCash " 
  " iAcct    "  iAcct
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.




/* ========================================================================= */
/** Функция: сгенерировать поле code.name для заведения заявки
    Входные параметры: 
*/
FUNCTION CreateCdNameStCash RETURNS CHARACTER
  (INPUT iAcct  AS CHARACTER ,
   INPUT iSum   AS CHARACTER ,
   INPUT iDetls AS CHARACTER ,
   INPUT iOnlnInitr AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR NO-UNDO.


  Result = iAcct + ";" + iSum + ";" + TRIM(REPLACE(iDetls,",","")) + ";" + ";" + iOnlnInitr + ";" .
/*
MESSAGE
  " RUN CreateCdNameStCash " 
  " iAcct    "  iAcct
  " iSum     "  iSum
  " iDetls   "  iDetls
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.




/* ========================================================================= */
/** Функция: сгенерировать поле code.val для заведения заявки
    Входные параметры: 
*/
FUNCTION CreateCdValStCash RETURNS CHARACTER
  (INPUT iVisaPodft  AS CHARACTER ,
   INPUT iCause      AS CHARACTER ,
   INPUT iAutor      AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR NO-UNDO.


  Result = iVisaPodft + ";" + iCause + ";" + iAutor + ";"  .
/*
MESSAGE
  " RUN CreateCdNameStCash " 
  " iVisaPodft "  iVisaPodft 
  " iCause     "  iCause     
  " iAutor     "  iAutor     
  " Result     "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.





/* ========================================================================= */
/** Функция: создать заявку в журнале заявок на выдачу наличных по кассе
    Входные параметры: 
*/
FUNCTION CreateReqstStCash RETURNS INTEGER
  (INPUT istrOpDate  AS CHARACTER , 
   INPUT iCdCode     AS CHARACTER , 
   INPUT iCdName     AS CHARACTER , 
   INPUT iCdVal      AS CHARACTER 
  ): 

  DEF VAR Result 	AS INT  NO-UNDO.
  DEF BUFFER bfrcode  FOR code.
  DEF BUFFER bfrcode2 FOR code.
  DEF BUFFER bfrcode3 FOR code.

  /* #3783 */
  DEF VAR ik		AS INT  NO-UNDO.
  DEF VAR vAcctVal	AS CHAR NO-UNDO.
  DEF VAR vSum		AS DEC  NO-UNDO.
  DEF VAR vMaxSum	AS DEC  NO-UNDO.

  vAcctVal = SUBSTRING( ENTRY(1,iCdName,";"), 6,3) .
  vSum     = DECIMAL( ENTRY(2,iCdName,";") ) .
  
  ik = IF vAcctVal = '810' THEN 1 ELSE (IF vAcctVal = '840' THEN 2 ELSE 3) .

  FIND FIRST bfrcode3 WHERE bfrcode3.class =  "PirSightOP"
	AND  bfrcode3.code = "Visa9MaxSum" 
  NO-LOCK NO-ERROR.

  IF AVAIL bfrcode3 THEN 
	vMaxSum = DECIMAL( ENTRY(ik,bfrcode3.val,";") ) .
  ELSE
  DO:
	MESSAGE "В классификаторе Visa9MaxSum не заданы пороговые значения сумм! Обратитесь к администратору АБС!"  VIEW-AS ALERT-BOX.
	Result = 0 . /* заявка не заведена */
	RETURN Result.
  END.

  IF vSum < vMaxSum THEN
  DO:
	MESSAGE "Такая заявка не должна попадать в журнал заявок, т.к. заданная сумма меньше порогового значения: " vMaxSum  VIEW-AS ALERT-BOX.
	Result = 0 . /* заявка не заведена */
	RETURN Result.
  END.


	  /*** Поехалллиииии ***/ 		
  DO TRANSACTION :

    FIND FIRST bfrcode 
	WHERE bfrcode.class = "PirStatCash" 
	AND bfrcode.parent  = "PirStatCash"
	AND bfrcode.code = istrOpDate
    NO-LOCK NO-ERROR. 
  
    IF NOT AVAILABLE bfrcode THEN
	DO:
	  /* message "if delaetsa 1!" VIEW-AS ALERT-BOX.  */
	  CREATE code.
	  ASSIGN 
		code.class  = "PirStatCash"
		code.parent = "PirStatCash"
		code.code = istrOpDate
		code.name = "Журнал заявок"
		code.val = ""
		code.misc[1] = ""
	  .
	END.

    PAUSE 0.  
/*
    MESSAGE  " iCdCode =  " iCdCode  VIEW-As ALERT-BOX.
*/
    FIND FIRST bfrcode2 
	WHERE bfrcode2.class = "PirStatCash" 
	AND bfrcode2.parent  = istrOpDate
	AND ENTRY(1,bfrcode2.code,"_") = ENTRY(1,iCdCode,"_")
	AND ENTRY(2,bfrcode2.code,"_") = ENTRY(2,iCdCode,"_")
	AND ENTRY(3,bfrcode2.code,"_") = ENTRY(3,iCdCode,"_")
	AND ENTRY(4,bfrcode2.code,"_") = ENTRY(4,iCdCode,"_")
	AND ENTRY(5,bfrcode2.code,"_") = ENTRY(5,iCdCode,"_")
	AND ENTRY(2,bfrcode2.description[1],";") = "ACT"
    NO-LOCK NO-ERROR. 

    IF NOT AVAILABLE bfrcode2 THEN
	DO:
	  /*  message "if delaetsa 2!" VIEW-AS ALERT-BOX.  */
	  CREATE code.
	  ASSIGN 
		code.class  = "PirStatCash"
		code.parent = istrOpDate
		code.code = iCdCode
		code.name = iCdName
		code.val  = iCdVal
		code.description[1] = "0" + ";" + "ACT" +  ";;"  
		/* code.misc[1] = "" */
	  .
	  Result = 1 . /* заявка заведена */
	END.
    ELSE
	DO:
	  MESSAGE "Уже существует активная заявка с таким кодом!!! " iCdCode " Счет: " ENTRY(1,iCdName,";")  VIEW-AS ALERT-BOX.
	  Result = 0 . /* заявка не заведена */
	END.
  END.  /*** Приехали ***/
/*
MESSAGE
  " RUN CreateReqstStCash " 
  " istrOpDate "  istrOpDate
  " iCdCode    "  iCdCode   
  " iCdName    "  iCdName   
  " iCdVal     "  iCdVal    
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.




/* ========================================================================= */
/** Функция: в заявка в поле code.name ставим признак изменения (MOD,DEL,PODFT)
    Входные параметры: 
*/
FUNCTION EditCdNameStCash RETURNS CHARACTER
  (INPUT iCdName  AS CHARACTER ,
   INPUT iType    AS CHARACTER ,
   INPUT iCause1  AS CHARACTER ,
   INPUT iCause2  AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR INIT "" NO-UNDO.
  DEF BUFFER bfrcode3 FOR code.

  /* #3783 */
  DEF VAR ik		AS INT  NO-UNDO.
  DEF VAR vAcctVal	AS CHAR NO-UNDO.
  DEF VAR vSum		AS DEC  NO-UNDO.
  DEF VAR vMaxSum	AS DEC  NO-UNDO.

  vAcctVal = SUBSTRING( ENTRY(1,iCdName,";"), 6,3) .
  vSum     = DECIMAL( iCause1 ) .
  
  ik = IF vAcctVal = '810' THEN 1 ELSE (IF vAcctVal = '840' THEN 2 ELSE 3) .

  FIND FIRST bfrcode3 WHERE bfrcode3.class =  "PirSightOP"
	AND  bfrcode3.code = "Visa9MaxSum" 
  NO-LOCK NO-ERROR.

  IF AVAIL bfrcode3 THEN 
	vMaxSum = DECIMAL( ENTRY(ik,bfrcode3.val,";") ) .
  ELSE
  DO:
	MESSAGE "В классификаторе Visa9MaxSum не заданы пороговые значения сумм! Обратитесь к администратору АБС!"  VIEW-AS ALERT-BOX.
	Result =  iCdName .
	RETURN Result.
  END.


  IF iType  = "MOD"  THEN
  DO:
	IF vSum < vMaxSum THEN
	DO:
	  MESSAGE "Такая заявка не должна попадать в журнал заявок, т.к. заданная сумма меньше порогового значения: " vMaxSum " Редактирование отменяется!" VIEW-AS ALERT-BOX.
	  Result =  "" .
	  RETURN Result.
	END.

	Result =  ENTRY(1,iCdName,";") + ";"           
		+ iCause1 + ";"                    
		+ TRIM(REPLACE(iCause2,",","")) + ";"     
		+ iType + ";"
		+ ENTRY(5,iCdName,";") + ";" 
		.  
  END.

  IF iType  = "DEL" OR  iType  = "PODFT" OR iType  = "RUK" OR iType  = "KAS" THEN
	Result =  ENTRY(1,iCdName,";") + ";" 
		+ ENTRY(2,iCdName,";") + ";" 
		+ ENTRY(3,iCdName,";") + ";" 
		+ iType + ";" 
		+ ENTRY(5,iCdName,";") + ";" 
		.

/*
MESSAGE
  " RUN EditCdNameStCash " 
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
  IF Result = "" THEN
    DO:
	MESSAGE "В функцию неверно переданы параметры" VIEW-AS ALERT-BOX.        
    END.
  ELSE
	RETURN Result.

END FUNCTION.



/* ========================================================================= */
/** Функция: в заявке в поле code.val 
    Входные параметры: 
*/
FUNCTION EditCdValStCash RETURNS CHARACTER
  (INPUT iVisa    AS CHARACTER ,
   INPUT iCause   AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR INIT "" NO-UNDO.


  Result = iVisa + ";" 
	 + REPLACE(iCause,",","") + ";" 
	 + USERID("bisquit") + " " +  STRING(TODAY, "99/99/99") + " " + STRING(TIME, "HH:MM:SS") + ";" 
	 .
/*
MESSAGE
  " RUN EditCdValStCash " 
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
  IF Result = "" THEN
    DO:
	MESSAGE "В функцию неверно переданы параметры" VIEW-AS ALERT-BOX.        
    END.
  ELSE
	RETURN Result.

END FUNCTION.



/* ========================================================================= */
/** Функция: просмотр журнала изменений по заявке
    Входные параметры: 
*/
PROCEDURE ViewHstBrwStCash:
DEFINE INPUT PARAMETER iCode AS CHARACTER NO-UNDO.

   RUN browseld.p 
	("history",
	"file-name" + CHR(1) +
	"field-ref" ,			/* Поля для предустановки. */
	"code" + CHR(1) + 
	"PirStatCash," + iCode ,	/* Список значений полей. */
	?,	/* Поля для блокировки. */
	"5"	/* Строка отображения фрейма. */
	) .

END PROCEDURE.




/* ========================================================================= */
/** Функция: получить наименование клиента по заявке
    Входные параметры: 
*/
FUNCTION GetKlntNameStCash RETURNS CHARACTER
  (INPUT iCode  AS CHARACTER 
  ): 

  DEF VAR Result	AS CHAR INIT "Клиент не найден!" NO-UNDO.

  IF ENTRY(3,iCode,"_") = "Ч" THEN
  DO:

	FIND FIRST person WHERE STRING(person.person-id) = ENTRY(1,iCode,"_") NO-LOCK NO-ERROR.

	IF AVAIL person THEN
	  Result = STRING(person.name-last + " " + person.first-name) .
  END.
  ELSE
  DO:
	FIND FIRST cust-corp WHERE STRING(cust-corp.cust-id) = ENTRY(1,iCode,"_") NO-LOCK NO-ERROR.

	IF AVAIL cust-corp THEN
	  Result = cust-corp.name-short  . 
  END.

/*
MESSAGE
  " RUN GetKlntNameStCash " 
  " iCode    "  iCode
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/
RETURN Result.

END FUNCTION.




/* ========================================================================= */
/** Функция: создать заявку в журнале заявок на выдачу наличных по кассе
    Входные параметры: 
*/
FUNCTION Copy2ReqstStCash RETURNS CHARACTER
  (INPUT istroldOpDate    AS CHARACTER , 
   INPUT istrnewOpDate    AS CHARACTER ,
   INPUT ioldCdCode       AS CHARACTER 
  ): 

  DEF VAR Result AS CHAR INIT "0" NO-UNDO.

  DEF BUFFER bfrsrccode FOR code.
  DEF BUFFER bfrcode  FOR code.
  DEF BUFFER bfrcode2 FOR code.

  DEF VAR newCdCode	AS CHAR NO-UNDO.
  DEF VAR newCdName	AS CHAR NO-UNDO.
  DEF VAR newCdVal	AS CHAR NO-UNDO.

	/* находим оригинал заявки */
  FIND FIRST bfrsrccode 
	WHERE bfrsrccode.class = "PirStatCash" 
	AND bfrsrccode.parent  = istroldOpDate
	AND bfrsrccode.code = ioldCdCode
  NO-LOCK NO-ERROR. 
/*
  IF NOT AVAIL bfrsrccode THEN
	RETURN Result. /* выходим */
*/

	/* Создаем новую заявку */
  newCdCode = ENTRY(1,bfrsrccode.code,"_") 
	+ "_" + ENTRY(2,bfrsrccode.code,"_") 
	+ "_" + ENTRY(3,bfrsrccode.code,"_") 
	+ "_" + ENTRY(4,bfrsrccode.code,"_") 
	+ "_" + istrnewOpDate
	+ "_" + STRING(TIME)
	.
  newCdName = ENTRY(1,bfrsrccode.name,";") 
	+ ";" + ENTRY(2,bfrsrccode.name,";") 
	+ ";" + ENTRY(3,bfrsrccode.name,";") 
	+ ";" + "COPY" 
	+ ";" + ENTRY(5,bfrsrccode.name,";") 
	+ ";" .
  newCdVal  = bfrsrccode.val .


	  /*** Поехалллиииии ***/ 		
  DO TRANSACTION :

    FIND FIRST bfrcode 
	WHERE bfrcode.class = "PirStatCash" 
	AND bfrcode.parent  = "PirStatCash"
	AND bfrcode.code = istrnewOpDate
    NO-LOCK NO-ERROR. 
  
    IF NOT AVAILABLE bfrcode THEN
	DO:
	  /* message "if delaetsa 1!" VIEW-AS ALERT-BOX.  */
	  CREATE code.
	  ASSIGN 
		code.class  = "PirStatCash"
		code.parent = "PirStatCash"
		code.code = istrnewOpDate
		code.name = "Журнал заявок"
		code.val = ""
		code.misc[1] = ""
	  .
	END.

    PAUSE 0.  
/*  MESSAGE  " iCdCode =  " iCdCode  VIEW-As ALERT-BOX. */

	/* тут уже с новым кодом */ 
    FIND FIRST bfrcode2 
	WHERE bfrcode2.class = "PirStatCash" 
	AND bfrcode2.parent  = istrnewOpDate
	AND ENTRY(1,bfrcode2.code,"_") = ENTRY(1,newCdCode,"_")
	AND ENTRY(2,bfrcode2.code,"_") = ENTRY(2,newCdCode,"_")
	AND ENTRY(3,bfrcode2.code,"_") = ENTRY(3,newCdCode,"_")
	AND ENTRY(4,bfrcode2.code,"_") = ENTRY(4,newCdCode,"_")
	AND ENTRY(5,bfrcode2.code,"_") = ENTRY(5,newCdCode,"_")
	AND ENTRY(2,bfrcode2.description[1],";") = "ACT"
    NO-LOCK NO-ERROR. 

    IF NOT AVAILABLE bfrcode2 THEN
	DO:
	  /*  message "if delaetsa 2!" VIEW-AS ALERT-BOX.  */
	  CREATE code.
	  ASSIGN 
		code.class  = "PirStatCash"
		code.parent = istrnewOpDate
		code.code = newCdCode
		code.name = newCdName
		code.val  = newCdVal
		code.description[1] = "0" + ";" + "ACT" +  ";;"  
		/* code.misc[1] = "" */
	  .
	  Result = newCdCode . /* заявка заведена */
	END.
    ELSE
	DO:
	  /*MESSAGE "Уже существует активная заявка с таким кодом!!! " newCdCode " Счет: " ENTRY(1,iCdName,";")  VIEW-AS ALERT-BOX.*/
	  Result = "0" . /* заявка не заведена */
	END.
  END.  /*** Приехали ***/

/*
MESSAGE
  " RUN CopyReqstStCash " 
  " istrOpDate "  istroldOpDate
  " istrnewOpDate "  istrnewOpDate
  " ioldCdCode    "  ioldCdCode   
  " newCdCode = " newCdCode
  " newCdName = " newCdName
  " newCdVal = " newCdVal
  " Result   "  Result
VIEW-AS ALERT-BOX.
*/

RETURN Result .

END FUNCTION.
