USING Progress.Lang.*.
CLASS TAcctBal INHERITS TAcct:

DEF PRIVATE VAR dDateState     AS DATE NO-UNDO.
DEF PRIVATE VAR dDateStateLast AS DATE NO-UNDO.

DEF PROTECTED VAR dBlockSum  AS DECIMAL INITIAL 0  LABEL "Блокированная сумма" NO-UNDO.
DEF PROTECTED VAR dArrestSum AS DECIMAL INITIAL 0  LABEL "Арестованная сумма"  NO-UNDO.

DEF PROTECTED VAR lisFullBlock  AS LOGICAL INITIAL FALSE LABEL "Счет полностью заблокирован, возможно с исключениями по оч."  NO-UNDO.
DEF PROTECTED VAR lisPartBlock  AS LOGICAL INITIAL FALSE LABEL "Счет заблокирован на сумму, возможно с исключениями на сумму" NO-UNDO.
DEF PROTECTED VAR lisFullArrest AS LOGICAL INITIAL FALSE LABEL "У счета полный арест"          NO-UNDO.
DEF PROTECTED VAR lisPartArrest AS LOGICAL INITIAL FALSE LABEL "У счета есть частичный арест"  NO-UNDO.


DEF PROTECTED VAR cExcludeBlockList AS CHARACTER INITIAL "" LABEL "Очередности платежа исключаемые из блокировки"  NO-UNDO.

/*
Дата на которую буду производиться все
расчеты по счету.
*/

DEFINE PUBLIC PROPERTY dateState AS DATE
	GET:												
		RETURN dDateState.
	END GET.
        SET (INPUT cProp AS DATE):

		IF cProp <> dDateState THEN
                  DO:
		       dDateStateLast = dDateState.
		       dDateState = cProp.
		  END.

	END SET.

CONSTRUCTOR TAcctBal(INPUT cAcct AS CHARACTER):
	    SUPER(cAcct).
	    dDateStateLast = TODAY - 1.
        dateState = TODAY.
END CONSTRUCTOR.

METHOD PROTECTED LOGICAL isDateStateChange():
						/*****************************************
						 * Изменили дату счета					 *
						 *****************************************/

		IF dDateState <> dDateStateLast THEN RETURN TRUE.
									  ELSE RETURN FALSE.
END METHOD.

/********************************************************************************
 * Блокировки/аресты.								  							*
 * Располагаются в таблице blockobject.					  							*
 * Различие между блокировкой и арестом заключается     							*
 * в следующем:										  							*
  * Блокировка выставляется налоговой;				  							*
  * При блокировке можно проплачивать налоги.		  							*
  * Арест выставляется судебным приставом;			  							*
  * Любая проплата со счета запрещена.					  							*
  * Ограничение действий со счетом бывает				 							*
  * трех типов:																	*
  *  1. Арест.  Установлена сумма и нет очередности платежа. 
  * Остаток суммы на счете  > Суммы блокировки. (установлена блокировка, и нет очередностей);		*
  *  2. Полная блокировка  (установлена блокировка, но и указана очередность разрешенная к списанию    *
  * Остаток на сумме может быть меньше суммы блокировки, если к такой сумме его приводят
  * документы разрешенной очередности.
  *  3. Частичный запрет (на сумму) (в поле сумма установлено значение);				*
  *  4. На сумму операции.															*
  * Исходим из того что в таблице blockobject в поле 									*
  * txt[1] храниться список очередностей документов для								*
  * исключения из контроля														*
*********************************************************************************/

METHOD PUBLIC DECIMAL getBlockSum():
				/***********************************************
				 * Метод возвращает сумму блокировки по счету    *
				 * на текущую дату.							     *
				 * Примечание:								     *
				 * Запись считаем блокировкой, если в			     *
				 * поле txt[1] указаны исключения.				     *
				 ***********************************************/
	calcBlockAndArrest2Date().
	RETURN ABS(dBlockSum).
END METHOD.


METHOD PUBLIC DECIMAL getArrestSum():
			      /*************************************************
			       * Метод возвращает сумму ареста по счету 		       *
			       * на текущую дату.							       *
				*************************************************/
	calcBlockAndArrest2Date().
	RETURN ABS(dArrestSum).
END METHOD.

METHOD PUBLIC LOGICAL isFullBlock():
				/*************************************************
				 * Возвращает TRUE если 				 		 	 *
				 * на счете установлена полная блокировка			 *
				 * и нет разрешений по списанию опр. очередностей   *
				 *************************************************/	
calcBlockAndArrest2Date().
RETURN lisFullBlock.
END METHOD.

METHOD PUBLIC LOGICAL isFullArrest():
				/*************************************************
				 * Возвращает TRUE если 				 		 	 *
				 * на счете установлена полный арест			         *
				 *************************************************/	
calcBlockAndArrest2Date().
RETURN lisFullArrest.
END METHOD.

METHOD PUBLIC LOGICAL isPartBlock():
				/**************************************************
				 * Возвращает TRUE если 							   *
				 * на счете установлена полная блокировка			   *
				 * но разрешено списывать документ по очередностям *
				 **************************************************/	
calcBlockAndArrest2Date().
RETURN lisPartBlock.
END METHOD.

METHOD PUBLIC LOGICAL isPartArrest():
				/**************************************************
				 * Возвращает TRUE если 							   *
				 * на счете установлена полная блокировка			   *
				 * но разрешено списывать документ по очередностям *
				 **************************************************/	
calcBlockAndArrest2Date().
RETURN lisPartArrest.
END METHOD.

METHOD PUBLIC CHARACTER getExcludeBlockList():
				/*************************************************
				 * Возвращает TRUE если документ можно 		 	 *
				 * на счете установлена полная блокировка			 *
				 *************************************************/	
calcBlockAndArrest2Date().
RETURN cExcludeBlockList.
END METHOD.

METHOD PUBLIC LOGICAL canTake(INPUT oDocument AS TDocument):
				/*************************************************
				 * Возвращает TRUE если документ можно 		 	  *
				 * провести по счету								  *
				 * Возмжна ошибка, если oDocument уже введен в БД  *
				 **************************************************/
			DEFINE VARIABLE dPos2Date AS DECIMAL.
			DEFINE VARIABLE dSumNotLimit AS DECIMAL LABEL "Сумма с которой в реальности можно работать".
			DEFINE VARIABLE dSumDiff AS DECIMAL LABEL "Сумма после списания".
			DEFINE VARIABLE oSysClass AS TSysClass.			/* */	
			DEFINE VARIABLE i AS INTEGER INITIAL 0.

				calcBlockAndArrest2Date().

				IF isFullBlock() THEN 
					DO:
						/*    На счете установлена
						       полная блокировка.
						       Любые операции запрещены.
						*/
					     RETURN FALSE.				
					END.
					ELSE
					  DO:
						/*
							На счете если и установлены, 
							то блокировки и аресты на сумму.
							То есть: В случае блокировки возможно списание,
							для документов с очередностью платежа 1-4.
							При аресте списывание невозможно.
						*/
							
						dPos2Date = getLastPos2Date(dateState).			/* !!! ЗДЕСЬ БУДЕТ ОШИБКА, В СЛУЧАЕ ЕСЛИ ДОКУМЕНТ УЖЕ ВВЕДЕН В БД!!!	*/
						dSumNotLimit = dPos2Date - getArrestSum().		/* С оставшейся суммой можно реально работать */

						IF dSumNotLimit > 0 THEN
										DO:

											IF INDEX(cExcludeBlockList,STRING(oDocument:order-pay)) <> 0  THEN
												DO:
													/* Документ является налоговым и допускается к списанию 
													   Рассчитываем сумму.
													*/
													dSumDiff = dSumNotLimit.
													oSysClass = new TSysClass().
													DO i = 0 TO oDocument:OpEntryCount:
															/* По всем проводкам в документе 
															    !!! СИЛЬНОЕ ДУБЛИРОВАНИЕ !!!
																НАДО ИСПРАВЛЯТЬ
															*/
															IF oDocument:getOpEntry(i):acct-db = acct THEN dSumDiff = dSumDiff + oSysClass:op-entry-sign("ДБ",activity) * oDocument:getOpEntry(i):rusSum.
															IF oDocument:getOpEntry(i):acct-cr = acct THEN dSumDiff = dSumDiff + oSysClass:op-entry-sign("КР",activity) * oDocument:getOpEntry(i):rusSum.																
														END.
														IF dSumDiff >= 0 THEN RETURN TRUE.
												 END.
												 ELSE
													DO:
													  dSumNotLimit = dSumNotLimit - getBlockSum().			/* Сумма с которой можно работать без ограничений */
 													  dSumDiff = dSumNotLimit.
													  /*
														Рассчитываем сумму
													 */
														IF dSumDiff >= 0 THEN RETURN TRUE.
													END.
								
										END.										
			
						
						
					  END.
RETURN FALSE.
END METHOD.

METHOD PROTECTED VOID calcBlockAndArrest2Date():
			     /****************************************************
			       * Метод производит рассчет блокировок и арестов         *
			       * на дату											    *
				* 												    *
			       ****************************************************/	
		DEF VAR dtmpBlockSum AS DECIMAL INITIAL 0.

IF isDateStateChange() THEN
   DO:
	/* 
		Была изменена дата рассчета.
		Функция неправильно себя поведет если 
		    Создаем объект;
		    Рассчитываем блокировку за дату X;
		    Устанавливаем блокировку;
		    В этом же объекте получаем блокировку еще раз;
        */
		
	/*
	    Очищаем поля от результатов
	    состояния на предыдущую дату
	*/

	dArrestSum = 0.
	dBlockSum = 0.

	lisFullBlock = FALSE.
	lisPartBlock = FALSE.

        lisFullArrest = FALSE.
        lisPartArrest = FALSE.



		 FOR EACH blockobject WHERE blockobject.class-code='BlockAcct'  
							                 AND blockobject.surrogate = Surrogate 
									 AND blockobject.beg-datetime<=DATETIME(dDateState) AND ( DATETIME(dDateState)<blockobject.end-datetime OR blockobject.end-datetime=?)  
									NO-LOCK:
									        	/* По всем действующим блокировкам */

										cExcludeBlockList = TRIM(blockobject.txt[1]).									/* Перечень исключаемых очередностей платежа */
										dtmpBlockSum = blockobject.val[3].										/* Сумма блокировки */
																
										IF dtmpBlockSum = 0 THEN
										     DO:

											IF cExcludeBlockList <> "" THEN 
											     DO:
												 lisFullBlock = TRUE.		/* Счет блокирован с налоговыми исключениями */
											     END. /* Конец полная блокировка */
											     ELSE
												 DO:
													lisFullArrest = TRUE.  /* На счете установлена блокировка для любых операций */
												 END.
										

										    	END. /* Конец если полная блокировка/арест */
											ELSE
											   DO:
											      /* Установлена сумма блокировки */
											      IF cExcludeBlockList = "" THEN 
																		DO:
																			lisPartArrest = TRUE.
																			dArrestSum = dArrestSum + blockobject.val[3].	/* Сумма ареста по счету */
																		END.
	 				        				              ELSE
													DO:
														  lisPartBlock = TRUE.
														  dBlockSum   =  dBlockSum + blockobject.val[3].						        /* Сумма блокировки по счету */																	
													END.
											  END. /* Конец если частичная блокировка/арест */ 


									  END. /* Конец найдена какая-то блокировка */
END. /* Конец дата статуса другая */

END METHOD.


/**********************************************
* @var CHARACTER cCommName код комиссии.      *
* @var DATE      dDate     Дата на которую    *
* интересует значение комиссии.               *
* @var DECIMAL dSum Сумма с которой           *
* предполагается удержание комиссии.          *
* @return DECIMAL                             *
*                                             *
* Метод возвращает СТАВКУ ТАРИФА              *
***********************************************/
METHOD DECIMAL getCommRate(INPUT cCommName AS CHARACTER,INPUT dDate AS DATE,INPUT dSum AS DECIMAL):

     &SCOPED-DEFINE baseCommMark 0

    FIND LAST comm-rate WHERE  dDate >= comm-rate.since
                                                            AND (comm-rate.acct = acct OR comm-rate.acct = "{&baseCommMark}")
                                                            AND dSum >= comm-rate.min-value
                                                            AND comm-rate.commission EQ cCommName 
                                                            AND comm-rate.currency EQ (IF val = 810 THEN "" ELSE STRING(val))
                                                    NO-LOCK NO-ERROR.

        IF AVAILABLE(comm-rate) THEN
            DO:
                            /***************************************
                             *                                                                        *
                             * Доступна индивидуальная комиссия.    *
                             *                                                                        *
                             ***************************************/                        
                             RETURN comm-rate.rate-comm.

            END.

END METHOD.

METHOD DECIMAL calComm(INPUT cCommName AS CHARACTER,INPUT dDate AS DATE,INPUT dSum AS DECIMAL):
                        /******************************************
                         *                                                                               *
                         * Считаю абсолютное значение комиссии с   *
                         * суммы dSum.                                                      *
                         *                                                                               *
                        *******************************************/


END METHOD.


/*******************
 * @return CHARACTER
 * Возвращает номер договора
 * овердрафта.
 *******************/
METHOD PUBLIC CHAR getLnkOverLoan(INPUT currDate AS DATE):

     DEF VAR loans      AS TAArray     NO-UNDO.

     DEF VAR key        AS CHAR        NO-UNDO.
     DEF VAR val        AS CHAR        NO-UNDO.

     DEF VAR transhMask AS CHAR        NO-UNDO.

     DEF VAR lRes       AS CHAR INIT ? NO-UNDO.

     DEF VAR oSysClass AS TSysClass    NO-UNDO.

     oSysClass = new TSysClass().

	 /************************
          * Здесь сомнительный участок 
	  * кода, так классы по овердрафту
	  * вшиты, а по идее должны иметь
	  * или маркер или НП.
          *************************
          * Начиная с 72ого патча,
          * Бис ввел НП, где хранятся
          * списки классов овердрафта.
          * НП имеет следующую структуру:
          * <охватывающие_классы_через_зпт>|<транши_через_зпт>
          * Для нас вообщем-то без разницы охват это или транш.
          * 09.01.12
	  *************************/
         transhMask = oSysClass:getSetting("ОверКлассТранз","КлОхватТранш").
	 transhMask = REPLACE(transhMask,"|",",").


	 loans = getLnkLoans(currDate).
	 
         {foreach loans key val}
            IF CAN-DO(transhMask,val) THEN DO:
		lRes = key.
	    END.    
         {endforeach loans}

	DELETE OBJECT loans.
        DELETE OBJECT oSysClass.
   RETURN lRes.

END METHOD.

/***************************
 * @return logical 	   *
 * Определяет привязан ли  *
 * договор к овердрафту.   *
 ***************************
 * По заявке #1338, необходимо
 * учитывать дату действия транша.
 ***************************/
METHOD PUBLIC LOGICAL isLnkOverLoan(INPUT currDate AS DATE):
 IF getLnkOverLoan(currDate) <> ? THEN RETURN TRUE.
 RETURN FALSE.
END METHOD.

METHOD PUBLIC LOGICAL isLnkOverLoan():
 IF getLnkOverLoan(01/01/1900) <> ? THEN RETURN TRUE.
 RETURN FALSE.

END METHOD.

/*********************************
 * Метод возвращает договора     *
 * к которому привязан           *
 * счет.                         *
 *********************************
 * Полагаю, что привязки
 * присущи и внебалансу. Таким
 * образом думаю, что здесь должен
 * родиться еще один класс.
 *********************************
 *
 *        !!! ВНИМАНИЕ !!!!
 *
 * ПОСЛЕ ИСПОЛЬЗОВАНИЯ МЕТОДА УБЕЙ
 *           РЕЗУЛЬТАТ!!!
 *
 *   ИНАЧЕ БУДЕТ УТЕЧКА ПАМЯТИ!!!
 *
 ***********************************/
METHOD PROTECTED TAArray getLnkLoans():
  RETURN getLnkLoans(01/01/1900).
END METHOD.

/**
 * Возвращает перечень договоров овердрафта,
 * действующие на дату currDate
 * @param DATE currDate Дата действия договора
 * @return TAArray
 *
 *********************************
 *
 *        !!! ВНИМАНИЕ !!!!
 *
 * ПОСЛЕ ИСПОЛЬЗОВАНИЯ МЕТОДА УБЕЙ
 *           РЕЗУЛЬТАТ!!!
 *
 *   ИНАЧЕ БУДЕТ УТЕЧКА ПАМЯТИ!!!
 **********************************/

METHOD PROTECTED TAArray getLnkLoans(INPUT currDate AS DATE):

         DEF VAR loans AS TAArray NO-UNDO.
	 loans = new TAArray().

        /**
         * Четко в индекс не попадаю,
         * поэтому сделал как у БИСов.
         **/

         FOR EACH loan-acct WHERE loan-acct.acct     = acct
                              AND loan-acct.currency = (IF val = 810 THEN "" ELSE STRING(val)) 
                              AND loan-acct.since   <= currDate NO-LOCK,
            FIRST loan WHERE loan.contract = loan-acct.contract AND loan.cont-code = loan-acct.cont-code 
                             AND (loan.close-date >= currDate OR loan.close-date = ?) NO-LOCK:
		loans:setH(STRING(loan.doc-ref),STRING(loan.class-code)).
	 END.

  RETURN loans.
END METHOD.

/**
 * Метод возвращает счет алиас с которого произодится
 * списание комиссии.
 * @param DATE dDate Дата на которую ищем алиас
 * @return CHAR
 *
 **/

METHOD PUBLIC CHAR getAlias40821(INPUT dDate AS DATE):

  DEF VAR cAcctKom AS CHAR NO-UNDO.

  IF CAN-DO("40821*",THIS-OBJECT:acct) THEN DO:

                      cAcctKom = THIS-OBJECT:getXAttrWDef("PirAcctCom",?).
                   
                     /** 
                      * Если в допнике есть Значение,
                      * то берем его.
                      **/                       


		      IF cAcctKom <> ? THEN DO:
                            RETURN cAcctKom.
                      END.

	              FIND FIRST acct WHERE acct.acct BEGINS "40702" 
				        AND acct.cust-id = THIS-OBJECT:cust-id
				        AND acct.open-date <= dDate AND (acct.close-date >= dDate OR acct.close-date = ?) 
                                        NO-LOCK NO-ERROR.

		      IF AVAILABLE(acct) THEN DO:
		        RETURN acct.acct.
		      END.

  	              FIND FIRST acct WHERE acct.acct BEGINS "40802" 
  				        AND acct.cust-id = THIS-OBJECT:cust-id
				        AND acct.open-date <= dDate 
				        AND (acct.close-date >= dDate OR acct.close-date = ?) 
                                       NO-LOCK NO-ERROR.

		      IF AVAILABLE(acct) THEN DO:
		         RETURN acct.acct.
		      END.


  MESSAGE COLOR WHITE/RED "НЕ НАЙДЕМ СЧЕТ ДЛЯ СПИСАНИЯ КОМИССИИ!!!" VIEW-AS ALERT-BOX.
  END.

  RETURN THIS-OBJECT:acct.	
END METHOD.


END CLASS.