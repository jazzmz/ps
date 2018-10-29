CLASS TBank INHERITS TBase:
	/*******************************************************
	 * Класс для отображения информации по банку *
	 *******************************************************/

{set-prop.i &aa="bic" &bb="cbic" &cc="CHARACTER"}		 	/* БИК БАНКА */
{set-prop.i &aa="corr-acct" &bb="ccorr-acct" &cc="CHARACTER"}		/* Корсчет банка */
{set-prop.i &aa="bank-name" &bb="cbank-name" &cc="CHARACTER"}	        /*Название банка */
{set-prop.i &aa="short-name" &bb="cshort-name" &cc="CHARACTER"}		/*Название банка */
{set-prop.i &aa="law-address" &bb="claw-address" &cc="CHARACTER"}	/*Название банка */
{set-prop.i &aa="town" &bb="ctown" &cc="CHARACTER"}			/*Город банка */
{set-prop.i &aa="town-type" &bb="ctown-type" &cc="CHARACTER"}		/*Город банка */
{set-prop.i &aa="mail-index" &bb="cmail-index" &cc="CHARACTER"}		/* Индекс Банка */
{set-prop.i &aa="currDate"                      &cc="DATE"}

CONSTRUCTOR TBank():

END CONSTRUCTOR.

CONSTRUCTOR TBank(INPUT iBic AS CHARACTER):
 findBank(iBic).
END CONSTRUCTOR.

CONSTRUCTOR TBank(INPUT iBic AS CHAR,INPUT dDate AS DATE):
      currDate = dDate.
      findBank(iBic).
END CONSTRUCTOR.

METHOD PRIVATE VOID findBank(INPUT iBic AS CHAR):

		/************************************
		 * Инициализируем по Бику       *
		 ************************************/
FIND FIRST banks-code WHERE bank-code = iBic NO-LOCK NO-ERROR.
  IF AVAILABLE(banks-code) THEN
	DO:
		/*******************************************
		 *								*
		 * Банк с данным Биком существует.  *
		 * 								*
		 *******************************************/

		bic = banks-code.bank-code.

		FIND FIRST banks WHERE banks.bank-id = banks-code.bank-id NO-LOCK NO-ERROR.
		IF AVAILABLE(banks) THEN
			DO:
					/**********************************
					 * Найдена информация по банку   *
					 * Заполняем свойства		 *
					 **********************************/
					FIND FIRST banks-corr WHERE banks-corr.bank-corr=banks.bank-id NO-LOCK NO-ERROR.

					IF AVAILABLE(banks-corr) THEN corr-acct = banks-corr.corr-acct.
											  ELSE corr-acct = "".

					initByBuffer(BUFFER banks:HANDLE).
					/********
					   Определяем коррсчет
					********/

			END.		

	END.

END METHOD.


METHOD PRIVATE VOID initByBuffer(INPUT bBank AS HANDLE):
					/************************************
					 * Инициализируем свойства объекта    *
					 *************************************/


        ASSIGN
           ClassType = "banks"
           Surrogate = STRING(bBank::bank-id)
           ClassCode = bBank::class-code
        .


	ASSIGN        
          bank-name   = getXAttrWDef("name",currDate,bBank::name)
          short-name  = getXAttrWDef("short-name",currDate,bBank::short-name)
          law-address = bBank::law-address
          town        = bBank::town
          town-type   = bBank::town-type
	.
		/* БИС не хранит индекс в отдельном поле. Приходиться парсить почтовый адрес */
		mail-index = TRIM(ENTRY(1,bBank::mail-address,",")).
END METHOD.

METHOD PUBLIC LOGICAL isValidBIC(INPUT cBic AS INTEGER):
					/*********************************************
					* Проверяет существания банка с таким Биком  *
					**********************************************/

END METHOD.

METHOD PUBLIC CHARACTER getNostroAcct():
					/***************************************
					 * 				       *
					 * Метод возвращает счет Nostro.       *
					 * Если такой у нас открыт.	       *					
					 *				       *
					 ****************************************/
		FIND FIRST c-nostro WHERE c-nostro.corr-acct = corr-acct NO-LOCK NO-ERROR.
		IF AVAILABLE(c-nostro) THEN RETURN c-nostro.acct. ELSE RETURN ?.
END METHOD.

/**
 * Метод возвращает наш корсчет.
 **/
METHOD PUBLIC STATIC CHAR getNostroCbr():
   DEF VAR cCorrAcct AS CHAR NO-UNDO.

   cCorrAcct = "30102810900000000491".    

   RETURN cCorrAcct.
END METHOD.

METHOD PUBLIC CHARACTER getNostroAcct(INPUT cAcct AS CHARACTER):
					/****************************************
					 * 							   *
					 * Метод возвращает счет Nostro.  *
					 * Если такой у нас открыт.		   *					
					 *							   *
					 *****************************************/
		FIND FIRST c-nostro WHERE c-nostro.corr-acct = cAcct NO-LOCK NO-ERROR.
		IF AVAILABLE(c-nostro) THEN RETURN c-nostro.acct. ELSE RETURN ?.
END METHOD.


END CLASS.