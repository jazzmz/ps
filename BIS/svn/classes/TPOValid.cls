CLASS TPOValid INHERITS TPaymentOrder:


  CONSTRUCTOR TPOValid(INPUT iRecId AS RECID):
	/*****************************
	 *
	 * 
	 * 
	 ******************************/
    SUPER(iRecId).
  END CONSTRUCTOR.


 METHOD PUBLIC VOID runNalogCheck():

        /***********************************
         *                                 *
	 * Проверка налоговых реквизитов.  *
	 *                                 *
         ************************************/

	DEF VAR oSysClass   AS TSysClass 		  NO-UNDO.
        DEF VAR cClassError AS CHARACTER INITIAL "Налог"  NO-UNDO.
	DEF VAR i           AS INTEGER 			  NO-UNDO. 				     /* i - 20 лет на рынке нумераторов */

	/*****************************************
	 *                                       *
	 * В случае если документ ставится       *
	 * на счет невыясненных поступлений,     *
	 * то проверять правильность заполнения  *
	 * налоговых платежей нет смысла.        *
	 *                                       *
	 *****************************************
         *                                       *
	 * Автор: Маслов Д. А.                   *
	 * Дата создания: 07.04.2011             *
	 * Заявка: #676                          *
         *					 *
	 *****************************************/
	oSysClass = new TSysClass().

	IF acct-cr NE oSysClass:getSetting("СчНПост") THEN 
          DO:
                                        /***********************************************
                                         * Если платеж налоговый, то обязательно
                                         * указание поля 101.
                                         ***********************************************/
                IF CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),acct-rec) AND NOT {assigned field101} THEN DO:
                           addError("1481","Платеж налоговый обязательно как минимум 101-ое поле",cClassError).          
                END.

					/***********************************************
					 * Если есть 101 поле, то
					 * должны быть заполнены поля 102-110.
					 * Проверка №4
					 ***********************************************/
		IF {assigned field101} THEN
			DO:
					     IF NOT ({assigned field102} AND
						     {assigned field103} AND
						     {assigned field104} AND
						     {assigned field105} AND
						     {assigned field106} AND
						     {assigned field107} AND
						     {assigned field108} AND
						     {assigned field109} AND
						     {assigned field110}) THEN
							DO:
								addError("654-2","Заполнено 101 поле. Поля 102-110 обязательные",cClassError).
						        END.
			END.
					/***********************************************************
					 *
					 * Если проставлено поле 101, а у клиента
					 * физ. лица нет ИНН, то в поле ИНН должен
					 * быть 0. 
					 * Другими словами, если проставлено поле
					 * 101, то должен быть ИНН или 0.
					 * Проверка №5
					 *
					 ************************************************************
                                         *
                                         * На всякий случай ужесточим проверку и дополним, если
                                         * платеж на счет налоговой и ИНН не проставлен, то ошибка.
                                         *
                                         ************************************************************
                                         * Автор         : Маслов Д. А. Maslov D. A.
                                         * Дата создания : 30.10.12
                                         * Заявка        : #1481
                                         *************************************************************/
                                        
	IF {assigned field101} OR CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),acct-rec) THEN
		DO:
			IF NOT {assigned inn-send} THEN 
				DO:
	 			  addError("654-3","Платеж налоговый. Обязателен ИНН плательщика",cClassError).
				END.
		END.

					/**********************************************************
					 * Если внешний не налоговый платеж без слова НДС,
					 * то ошибка.
					 * Проверка №6
					 **********************************************************/


	 /************************************************
	  * Любое платежное поручение(01),               *
	  * требование(02), инкассовое(015) и ордер(016) *
	  * должны содержать указание на НДС.            *
	  * Исключение составляет платежи                *
	  * в налоговую.                                 *
	  * По информации Судник Т.		         *
	  * 21.03.11				         *
	  ************************************************
          * По заявке: #702
          * Если документ пришел из вне, то проверять
          * на НДС не нужно. Это ошибка отправителя, и мы
          * не имеем права не принять этот документ.
	  ************************************************/
		

	 IF NOT CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),acct-rec) 
            AND CAN-DO("01*,02",doc-type) 
	    AND direct NE "in" THEN
			DO:
		          IF CAN-DO("!*НДС*,*",details) THEN 
			     DO:
			       addError("654-4","Нет ссылки на НДС",cClassError).
			     END.
			END.      

          END. /* END по acct-cr */

	/****************************************************************
	 *							        *
	 * Любое платежно поручение у которого заполнено поле           *
	 * 101 и это поле принимает значение 06, 07, 16, 17, то в поле  *
	 * 107 должны содержаться значение из 10 символов.		*
	 *								*
	 * Заявка: #716							*
	 ****************************************************************/

	IF CAN-DO(oSysClass:getSetting("ГНИ","Статус101ДК"),field101) THEN DO:
			IF LENGTH(field107) NE 8 THEN DO:
				addError("716","Поле 107 должно состоять из 8 знаков",cClassError).
			 END. /* IF LENGTH */

		       /* Считаем количество отличных от нуля символов */
			INT64(field107) NO-ERROR.

			IF ERROR-STATUS:ERROR THEN DO:
					addError("716-2","В поле 107 должны быть только цифры",cClassError).
		        END.
	END.

  DELETE OBJECT oSysClass.        	 
  END METHOD.



 METHOD PUBLIC VOID runNalogCheck2():

        /***********************************************************
	 * Проверка налоговых реквизитов - с типом ПРЕДУПРЕЖДЕНИЕ  *
         ***********************************************************/

	DEF VAR oSysClass   AS TSysClass 		  NO-UNDO.
        DEF VAR cClassError AS CHARACTER INITIAL "Налог2"  NO-UNDO.
	DEF VAR i           AS INTEGER 			  NO-UNDO.


	oSysClass = new TSysClass().

	IF acct-cr NE oSysClass:getSetting("СчНПост") THEN 
          DO:

                                        /***********************************************
                                         * #3004
                                         * Если платеж налоговый физ.лица, то обязательно в поле
                                         * Плательщик. Наименование укзание ФИО + // АдрПроп //
                                         ***********************************************/
                IF  CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),acct-rec)  
                    AND  LOGICAL(oSysClass:getSetting("PirChkOp","Pir3004","YES"))
                    AND  NOT(CAN-DO(oSysClass:getSetting("PirChkOp","Pir3004doctype",""), doc-type ))
                THEN
                DO:             
                    IF 	CAN-DO("40817*,40820*,42301*,42601*", THIS-OBJECT:getOpEntry4Order(1):acct-db)  THEN
                    DO:               

                       DEF VAR oClient  AS TClient NO-UNDO.
                       oClient = NEW TClient(THIS-OBJECT:getOpEntry4Order(1):acct-db).
	   		 
                       IF    NOT( {assigned field109} AND field109 <> "0" AND (name-send MATCHES STRING("*" + oClient:name-short + "*")) )  THEN  	/* # 3782*/
                       DO:
                           IF NOT( (name-send MATCHES STRING("*" + oClient:name-short + "*"))  AND  (name-send MATCHES "*//*//*") )
                           THEN 
                              addError("3004","Платеж налоговый физ.лица. Доп.реквизит <Наименование плательщика> должен быть равен: ФИО + // АдрПроп //",cClassError). 
                           ELSE
                           DO:
                              IF TRIM( SUBSTRING(name-send,INDEX(name-send,"//") + 2,R-INDEX(name-send,"//") - INDEX(name-send,"//") - 2 )) = ""
                              THEN
                                 addError("3004","Платеж налоговый физ.лица. Доп.реквизит <Наименование плательщика> должен быть равен: ФИО + // АдрПроп //. Причем <АдрПроп> не может быть пустым",cClassError). 
                           END.
                       END.

                       DELETE OBJECT oClient .

                    END.
                END.

          END.

  DELETE OBJECT oSysClass.        	 
  END METHOD.


/***********************************
 *                                 *
 * Метод валидации на корректность *
 * дат.                            *
 *                                 *
 ***********************************/

METHOD PUBLIC VOID runDateCheck():

DEF VAR oSysClass   AS TSysClass  		 NO-UNDO.
DEF VAR cClassError AS CHARACTER INITIAL "Дата"  NO-UNDO.

oSysClass = new TSysClass().

		/*****************************************************
		 *						     *
		 * Если документ платежка и его дата страше,         *
		 * чем текущая минус 10 дней, то считаем документ    *
		 * "плохим".                                         *
		 * Проверка №1			                     *
		 *                                                   *
		 *****************************************************
		 * Проверка вводилась по заявке #646, перенесена 
                 * в эту метод в рамках заявки #719.
		 *****************************************************/

 	         IF doc-type EQ "01" AND doc-date < DocDate - 10 THEN
		   DO:
		     addError("654-1","Истек срок документа",cClassError).
		   END.


	/*******************************
	 *
	 * Дата платежного документа
	 * должна быть больше даты Начального
	 * решения.
	 * Заявка #719
	 *
	 *******************************/

  	   IF doc-date LT DATE(oSysClass:getSetting("Дата_НР")) THEN DO:
		addError("719-1","Документ не может быть моложе банка",cClassError).
	   END.


	/***********************************
	 *                                *
	 *                                *
	 * Установка порядка для дат.     *
	 * Заявка: #719                   *
	 * Дата валютирования может       *
	 * быть меньше даты операционного *
	 * дня в случае, когда документ   *
	 * приходит из процессинга.	  *
	 * Таким образом дата валютирования
	 * завязана на дату создания докунта.
	 *                                *
	 ***********************************/
	 IF user-id NE "MCI" THEN DO:
	   IF NOT (doc-date<=ins-date AND doc-date <= op-date) THEN DO:
	     addError("719-2","Дата документа больше опер. дня или даты поступления",cClassError).
	   END.

	   IF NOT ins-date <= op-date THEN DO:
	     addError("719-3","Дата поступления больше опер. дня",cClassError).
	   END.
	END.

DELETE OBJECT oSysClass.

END METHOD.

          /*******************************
	   *
	   * Валидация номер документа.
	   * У Биса неправильно отрабатывают
	   * регулярки, поэтому делаем проверку
	   * здесь.
	   *
	   * Автор: Маслов Д. А.
	   * Заявка: #725
	   * Дата создания: 22.06.11
	   * 
	   *******************************/
METHOD PUBLIC VOID runMainAttrCheck():
	DEF VAR cClassError AS CHARACTER INITIAL "Основные"  NO-UNDO.

        DEF VAR oSysClass   AS TSysClass 		     NO-UNDO.
	DEF VAR cFullFormat AS CHARACTER INITIAL "*//*//*"   NO-UNDO.
	DEF VAR dLineSum    AS DECIMAL   INITIAL 15000       NO-UNDO.

	oSysClass = new TSysClass().

	cFullFormat = "*" + oSysClass:getSetting("PirChkOp","Pir2281UCDiv","//") + "*" + oSysClass:getSetting("PirChkOp","Pir2281UCDiv","//") + "*".
	dLineSum    = DECIMAL(oSysClass:getSetting("PirChkOp","Pir2281U","15000")).

	   IF doc-num = "0" OR doc-num ="" THEN addError("725-1","Запрещенный номер документа",cClassError).
	   IF details = ""  OR details = ? THEN addError("725-2","Запрещено пустое содержание",cClassError).


	/*****************************
	 * 			    *
	 * Валидация наименования,  *
	 * плательщика для случая   *
	 * больше 600 тыс. рублей.  *
	 *                          *
	 *****************************
	 *                          *
	 * Автор: Маслов Д. А.      *
         * Заявка: #732             *
	 * Дата создания: 07.09.11  *
	 *                          *
	 ****************************/

	IF direct = "out" AND inn-send = "0"
	   AND sum >= dLineSum 
	   AND NOT CAN-DO(cFullFormat,name-send) THEN DO:
		addError("732","Внешний платеж > " + STRING(dLineSum) + " руб. Формат плательщика 'ФИО //Адрес//'",cClassError).
	   END.

	/***********************************
	 * 
	 * Валидация длины содержания
	 * и наименования плательщика
	 *
	 ************************************
	 *
	 * Автор : Маслов Д. А. Maslov D. A.
	 * Заявка: #814
         * Дата создания: 23.11.11
	 *
	 ************************************/

	IF direct="out" AND LENGTH(details) > 210 THEN DO:
		addError("814","В содержании допускается только 210 знаков",cClassError).
	END.

	IF LENGTH(name-send) > 160 THEN DO:
		addError("814","Наименование плательщика должно быть < 160",cClassError).
	END.

 DELETE OBJECT oSysClass.
END METHOD.

/**
 * Проверяет допустимость использования
 * кассовых символов.
 **/
METHOD PUBLIC VOID runSymbolsCheck():
  DEF VAR i           AS INT      NO-UNDO.
  DEF VAR cClassError AS CHARACTER INITIAL "Символа"  NO-UNDO.


  DO i = 1 TO THIS-OBJECT:OpEntryCount:
    IF CAN-DO("20202*",THIS-OBJECT:getOpEntry4Order(i):acct-db) AND CAN-DO("40802*",THIS-OBJECT:getOpEntry4Order(i):acct-cr) AND THIS-OBJECT:getOpEntry4Order(i):kassSymbol <> "19" THEN DO:
     addError("991-1","С корреспонденцией 20202* - 40802* допускается только 19 символ.",cClassError).
    END.

    IF CAN-DO("40802*",THIS-OBJECT:getOpEntry4Order(i):acct-db) AND CAN-DO("20202*",THIS-OBJECT:getOpEntry4Order(i):acct-cr) AND THIS-OBJECT:getOpEntry4Order(i):kassSymbol <> "58" THEN DO:
     addError("991-2","С корреспонденцией 40802* - 20202* допускается только 58 символ.",cClassError).
    END.

  END.

END METHOD.

/**
 * Метод выполняет проверки 
 * связанные с бизнес процессом.
 **/
METHOD PUBLIC VOID runBusinessProcessCheck():

  DEF VAR i           AS INT                                NO-UNDO.
  DEF VAR cClassError AS CHARACTER INITIAL "БизнесПроцесс"  NO-UNDO.
  DEF VAR oAcct       AS TAcct                              NO-UNDO.
  DEF VAR permDate    AS DATE                               NO-UNDO.

 /********************************************
  * Если на одном из счетов документа
  * установлен ДР "ПирРазПровод" и значение
  * этого реквизита > текущей даты опер. дня,
  * то запрещаем проведения документа.
  ********************************************
  *
  * Автор   : Маслов Д. А. Maslov D. A.
  * Создан  : 30.10.12
  * Заявка  : #1606
  *
  ********************************************/
  DO i = 1 TO THIS-OBJECT:OpEntryCount:

      /**
       * Здесь лишние провоходы, но
       * если их убирать, то будут 
       * проблемы с очисткой мусора.
       **/

      oAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-db).
       permDate = DATE(oAcct:getXAttrWDef("ПирРазПровод","01/01/1900")).

       IF permDate > THIS-OBJECT:DocDate THEN DO:
          addError("1606-1","По счету " + oAcct:acct + " запрещено изменение остатка.\nДвижение разрешено с " + STRING(permDate) + ".",cClassError).
       END.

      DELETE OBJECT oAcct.
               

      oAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-cr).
       permDate = DATE(oAcct:getXAttrWDef("ПирРазПровод","01/01/1900")).

       IF permDate > THIS-OBJECT:DocDate THEN DO:
          addError("1606-2","По счету " + oAcct:acct + " запрещено изменение остатка.\nДвижение разрешено с " + STRING(permDate)  + ".",cClassError).
       END.

      DELETE OBJECT oAcct.


  END.
END METHOD.


/**
 * Метод проверяет корректность кода документа
 **/
METHOD PUBLIC VOID runChkCodeDocum():

   DEF VAR i           AS INT                                  NO-UNDO.
   DEF VAR cClassError AS CHAR INIT "ПроверкаКодаДокумента"    NO-UNDO.

  /********************************************
   * Ошибка в случае, если:
   * - документ с кодом 01* и в валюте
   * - документ с кодом 09, в ДБ или КР есть клиентский счет, и в содержании НЕТ слова "*сторно*"
   * - документ с кодом 17 и клиентского счета нет ни в ДБ, ни в КР
   ********************************************
   * Автор   : Sitov S.A.
   * Создан  : 10.04.13
   * Заявка  : #2621
   ********************************************/

   DO i = 1 TO THIS-OBJECT:OpEntryCount:
      IF CAN-DO("01*,09,17" , doc-type) THEN 
      DO:

         IF doc-type BEGINS '01'  AND  THIS-OBJECT:isValute() THEN
	    addError("2621", "Неверный код документа: валютный документ с кодом 01*", cClassError).

         IF doc-type = '09'  AND  NOT(THIS-OBJECT:isSTORNO())  
             AND  THIS-OBJECT:isDocumClientAcct()
         THEN
	    addError("2621", "Неверный код документа: документ с кодом 09, в ДБ или КР есть клиентский счет, в содержании нет СТОРНО", cClassError).

         IF doc-type = '17'  AND  NOT(THIS-OBJECT:isDocumClientAcct())  THEN
	    addError("2621", "Неверный код документа: документ с кодом 17 и клиентского счета нет ни в ДБ, ни в КР", cClassError).

      END.
   END.
	
END METHOD.


/**
 * Метод проверяет возможность снятия/внесения наличных денежных средств со счета физика лицом, у которого нет доверенности
 * Автор   : Sitov S.A.
 * Создан  : #1716  2013-04-10 Sitov S.A.
 * Модиф   : #3679  2013-08-18 Sitov S.A.
 **/
METHOD PUBLIC VOID runOperWithoutProxy():

   DEF VAR i           AS INT                                  NO-UNDO.
   DEF VAR cClassError AS CHAR INIT "ОперацияБезДоверенности"  NO-UNDO.
   DEF VAR cDover      AS CHAR INIT ""                         NO-UNDO.
   DEF VAR oAcct       AS TAcct                                NO-UNDO.
   DEF VAR oClient     AS TClient                              NO-UNDO.
   DEFINE BUFFER scust-role FOR cust-role .


   DO i = 1 TO THIS-OBJECT:OpEntryCount:
      IF     ( THIS-OBJECT:getOpEntry4Order(i):acct-db BEGINS "20202"   AND   THIS-OBJECT:getOpEntry4Order(i):acct-cr BEGINS "4"      AND  NOT(THIS-OBJECT:getOpEntry4Order(i):acct-cr BEGINS "47423"))  
	 OR  ( THIS-OBJECT:getOpEntry4Order(i):acct-db BEGINS "4"       AND   THIS-OBJECT:getOpEntry4Order(i):acct-cr BEGINS "20202"  AND  NOT(THIS-OBJECT:getOpEntry4Order(i):acct-db BEGINS "47423"))  
      THEN 
      DO:

         IF THIS-OBJECT:getOpEntry4Order(i):acct-db BEGINS "4" THEN
	         oAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-db).
         IF THIS-OBJECT:getOpEntry4Order(i):acct-cr BEGINS "4" THEN
	         oAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-cr).

	 oClient = NEW TClient(oAcct:acct).

         IF  oAcct:cust-cat = "Ч"  AND  name-ben <> ""  AND  name-ben <> ?
	     AND TRIM( oClient:name-short ) <> TRIM(name-ben)
         THEN 
         DO:
	    RUN pir-proxy-check.p( oAcct:acct , TRIM(name-ben) , op-date , OUTPUT cDover ) .  /* проверять нужно !*/
            IF cDover = "" THEN
		addError("3679", name-ben + " не имеет действующей доверенности на счет " + oAcct:acct, cClassError).
         END.

         DELETE OBJECT oAcct.
         DELETE OBJECT oClient.
      END.
   END.
	
END METHOD.


/**
 * Метод проверяет необходимость обновления анкеты клиента
 **/
METHOD PUBLIC VOID runChkUpdatedAnketa():

   DEF VAR i           AS INT				NO-UNDO.
   DEF VAR cClassError AS CHAR INIT "ОбновлениеАнкеты"	NO-UNDO.
   DEF VAR dbClient    AS TClient			NO-UNDO.
   DEF VAR crClient    AS TClient			NO-UNDO.

  /********************************************
   * Смотрим на владельца счета (по CUST-ID) 
   * Проверяем надо ли ему обновлять анкету
   * Проверяются только cust-corp и person 
   ********************************************
   * Автор   : Sitov S.A.
   * Создан  : 24.04.13
   * Заявка  : #2905
   ********************************************/
   DO i = 1 TO THIS-OBJECT:OpEntryCount:
      dbClient = NEW TClient(getOpEntry4Order(i):acct-db).
      crClient = NEW TClient(getOpEntry4Order(i):acct-cr).

      IF  dbClient:isClientUpdAnketa()  THEN 
	   addError("2905", "ВНИМАНИЕ!" + CHR(10) + "СРОК ОБНОВЛЕНИЯ АНКЕТЫ КЛИЕНТА! (счет " + getOpEntry4Order(i):acct-db + ")" + CHR(10) + "ПРИ ПОСЕЩЕНИИ КЛИЕНТОМ БАНКА ИНФОРМИРОВАТЬ У6 И У11", cClassError).
      IF  crClient:isClientUpdAnketa()  THEN 
	   addError("2905", "ВНИМАНИЕ!" + CHR(10) + "СРОК ОБНОВЛЕНИЯ АНКЕТЫ КЛИЕНТА! (счет " + getOpEntry4Order(i):acct-cr + ")" + CHR(10) + "ПРИ ПОСЕЩЕНИИ КЛИЕНТОМ БАНКА ИНФОРМИРОВАТЬ У6 И У11", cClassError).

      DELETE OBJECT dbClient.
      DELETE OBJECT crClient.
   END.
	
END METHOD.


/**
 * Запрет документов по кассе по пластиковым счетам, создаными операционистами 
 * Автор   : Sitov S.A.
 * Создан  : 23.05.13
 * Заявка  : #1717
 **/

METHOD PUBLIC VOID runBanCashCardDocum():

   DEF VAR i           AS INT  NO-UNDO.
   DEF VAR cClassError AS CHAR INIT "КассДокумПоПКОперациониста"  NO-UNDO.
   DEF VAR vAcctDb   AS CHAR   NO-UNDO.
   DEF VAR vAcctCr   AS CHAR   NO-UNDO.

   DO i = 1 TO THIS-OBJECT:OpEntryCount:

      vAcctDb = THIS-OBJECT:getOpEntry4Order(i):acct-db .
      vAcctCr = THIS-OBJECT:getOpEntry4Order(i):acct-cr .

      IF ( vAcctDb BEGINS "20202"  AND  SUBSTRING(vAcctCr,14,3) = "050" ) 
           OR
         ( SUBSTRING(vAcctDb,14,3) = "050"  AND  vAcctCr BEGINS "20202" ) 
      THEN
      DO:
         addError("1717", " Операционисту запрещено создавать документ по кассе по пластиковым счетам! " , cClassError).
      END.

   END.
	
END METHOD.


METHOD PUBLIC VOID runPermitKorr():
  DEF BUFFER code FOR code.

  DEF VAR vAcctDb AS CHAR NO-UNDO.
  DEF VAR vAcctCr AS CHAR NO-UNDO.

  DEF VAR i AS INT NO-UNDO.

  IF LOGICAL(TSysClass:getSetting2("PirChkOp","isPermitKorr","YES")) THEN DO:

  DO i = 1 TO THIS-OBJECT:OpEntryCount:
   ASSIGN
    vAcctDb = SUBSTR(THIS-OBJECT:getOpEntry4Order(i):acct-db,1,5)
    vAcctCr = SUBSTR(THIS-OBJECT:getOpEntry4Order(i):acct-cr,1,5)
    .

    IF CAN-FIND(FIRST code WHERE code.parent = "РазрешКоррСчетов"
                      AND code.misc[5] = "!"
                      AND CAN-DO(code.name,vAcctDb)
                      AND CAN-DO(code.val,vAcctCr)
                      AND CAN-DO(code.misc[6],SUBSTR(acct-send,1,5))
                      AND CAN-DO(code.misc[7],SUBSTR(acct-rec,1,5)) 
                      AND DATE(code.misc[3]) <= THIS-OBJECT:DocDate AND (DATE(code.misc[4]) > THIS-OBJECT:DocDate OR DATE(code.misc[4]) = ? OR code.misc[4] = "")
                ) THEN DO:
        THIS-OBJECT:addError("3032","Документ с указанной корреспонденцией запрещен!","3032").
     END.
   END.

  END.

END METHOD.

/**
 * Метод возвращает список методов, которые
 * содержат проверки. Даже в 10.2b рефлексия
 * недостаточно развита и поэтому какие методы
 * есть у класса понять невозможно.
 **/
METHOD STATIC CHAR getCheckMethods():
  RETURN "runPermitKorr".
END METHOD.

/**
 * Метод запускает все проверки в классе.
 **/
METHOD PUBLIC LOG validate():

  DEF VAR i AS INT NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(TPOValid:getCheckMethods()):
   DYNAMIC-INVOKE(THIS-OBJECT,ENTRY(i,TPOValid:getCheckMethods())).
  END.



 RETURN NOT THIS-OBJECT:isErrorState.
  
END METHOD.

/**
 * Метод выводит на экран все ошибки
 **/
METHOD PUBLIC VOID showErrors():


   MESSAGE COLOR WHITE/RED "ОБНАРУЖЕНЫ ОШИБКИ!" SKIP
			   "ДОКУМЕНТ №" + THIS-OBJECT:doc-num + " . На сумму: " + TRIM(STRING(THIS-OBJECT:sum,">>>,>>>,>>>,>>>,>>9.99")) SKIP
			    REPLACE(THIS-OBJECT:getListErrorDetails(),",",CHR(10)) SKIP
			 VIEW-AS ALERT-BOX TITLE "[ОШИБКА " + TRIM(THIS-OBJECT:getListErrorCode("*","#"),",") + "]".


END METHOD.

/**
 * Возвращает TRUE если метод-проверка включена (действие по-умолчанию),
 * FALSE если метод отключен (есть соответствующий НП со значением FALSE)
 * @param CHAR iMethodInfo Информация из PROGRAM-NAME(1) метода проверки.
 * @return LOG
 **/

METHOD PROTECTED LOG isCheckEnabled(INPUT iMethodInfo AS CHAR):
   DEF VAR vMethodName       AS CHAR NO-UNDO.
   DEF VAR vIsMethodEnabled  AS LOG  NO-UNDO.

   vMethodName      = ENTRY(1,iMethodInfo," ").
   vIsMethodEnabled = LOGICAL(TSysClass:getSetting2("PirCheckOp",vMethodName,"YES")).

  RETURN vIsMethodEnabled.
   
END METHOD.

/**
 *  Если по клиентскому счету
 * есть уменьшение остатка и этот счет
 * клиентский, то проверяем есть по нему документы
 * в статусе > "В", но меньше <= "Ф". Если такие есть,
 * то выдаем предупреждение.
 ***/

METHOD PUBLIC LOG runHasD2Move():

  DEF VAR i           AS INT            NO-UNDO.
  DEF VAR vOpEntry    AS TOpEntry       NO-UNDO.
  DEF VAR vAcct       AS TAcct          NO-UNDO.
  DEF VAR vRes        AS LOG INIT FALSE NO-UNDO.
  DEF VAR vDocExcLst  AS CHAR           NO-UNDO.

  vDocExcLst = STRING(THIS-OBJECT:surrogate).

  DO i = 1 TO THIS-OBJECT:OpEntryCount:

      vOpEntry = THIS-OBJECT:getOpEntry4Order(i).
      vAcct    = vOpEntry:getAcctDb().

       IF vAcct:isClient() THEN DO:
          IF vAcct:hasD2Move(THIS-OBJECT:DocDate,"К",CHR(251),vDocExcLst) THEN DO:
             vRes = TRUE.
          END.
       END.

     DELETE OBJECT vAcct.     
  END.
 
 RETURN vRes.

END METHOD.

METHOD PUBLIC VOID CheckPaytKind():
  DEF VAR oBank AS TBank NO-UNDO.
  DEF VAR iUer AS INT NO-UNDO.
  def var cTechPlat as char no-undo.
  def var cClassError as char init "Технология платежа" no-undo.
     IF THIS-OBJECT:direct = "out" THEN
        DO:
           oBank = new TBank(THIS-OBJECT:bank-bic-rec).
           cTechPlat = THIS-OBJECT:getOpEntry4Order(1):techPlat.
           iUer = INT(oBank:getXAttr("uer")).  
           if (iUer > 0) and cTechPlat <> "НЕ" and  cTechPlat <> "НС"  THEN /*если не участник электронных расчетов */
             DO:
                addError("3269", " Банк является участником МЭР или ВЭР, технология платежа должна быть НЕ" , cClassError).
             END.
           if (iUer = 0) and cTechPlat <> "НТ" and  cTechPlat <> "НМ" THEN 
             DO:
                addError("3269", " Банк не является участником МЭР или ВЭР, технология платежа должна быть НТ или НМ" , cClassError).
             END.
        END.


END METHOD.


END CLASS.