CLASS TEventLog INHERITS TDoc:
		/*****************************************
		 *
		 * Класс-провайдер доступа к системам
		 * регистрации событий/сообщений.
		 *
		 *****************************************/
&SCOPED-DEFINE typeEngineList curl,file,syslog

{set-prop.i &aa="engine"      &bb="cEngine"              &cc="CHARACTER" &init="\"http\""}			/* Куда производим запись события */
{set-prop.i &aa="eventid"     &bb="iEvent"                 &cc="INTEGER"}							/* Идентификатор события */
{set-prop.i &aa="eventnum" &bb="iEventNum"          &cc="INTEGER"}							/* Номер события */
{set-prop.i &aa="target"        &bb="cTarget"               &cc="CHARACTER"}						/* Адрес получаетеля события */
{set-prop.i &aa="eventtime"  &bb="dEventTime"       &cc="DATETIME"}						/* Дата время наступления события из программы */


{set-prop.i &aa="source-code-page"   &bb="csource-code-page" &cc="CHARACTER" &init="\"ibm866\""}				/* Исходная кодировка */
{set-prop.i &aa="target-code-page"   &bb="ctarget-code-page" &cc="CHARACTER" &init="\"utf-8\""}				/* */
{set-prop.i &aa="isEnable" 	     &bb="lisEnable" 	     &cc="LOGICAL"   &init="TRUE"}

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER):
		/*************************************
		 *
		 * Создает экземпляр по типу
		 * системы регистрации сообщений
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			END.

END CONSTRUCTOR.

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER, INPUT cTarget AS CHARACTER):
		/*************************************
		 *
		 * Создает экземпляр по типу
		 * системы регистрации сообщений
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			     Target = cTarget.
			END.

END CONSTRUCTOR.

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER, INPUT cTarget AS CHARACTER,INPUT cSourceEnc AS CHARACTER,INPUT cTargetSource AS CHARACTER):
		/*************************************
		 *
		 * Создает экземпляр по типу
		 * системы регистрации сообщений
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			     Target = cTarget.
			END.
	source-code-page = cSourceEnc.
	target-code-page   = cTargetSource.
END CONSTRUCTOR.

METHOD PUBLIC VOID fillInfo(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER,INPUT dDate AS DATE):
		/*************************************************
		 * Метод заполняет сообщение
		 **************************************************/
		details = cDetails.
		IF dDate EQ ? THEN DocDate = TODAY. ELSE DocDate = dDate.
		eventnum = iEventNum.
END METHOD.

METHOD PUBLIC VOID fillInfo(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER):

	fillInfo(iEventNum,cDetails,?).

END METHOD.

METHOD PUBLIC VOID send():
		/************************************************
		 * Метод производит отправку события
		 ************************************************/
DEF VAR oSysClass AS TSysClass NO-UNDO.

IF isEnable THEN DO:
oSysClass = new TSysClass().

CASE engine:

	WHEN "curl" THEN DO:
						/**************************************
						 * Отправляем через curl
						 **************************************/
						 OS-COMMAND SILENT VALUE('curl -d "id=' + STRING(eventnum) + '" -d "date=' + oSysClass:DATETIME2STR(DocDate,"%y-%m-%d") + '" -d "details=' + CODEPAGE-CONVERT(details,target-code-page,source-code-page) + '" ' + target).
					END.
	WHEN "syslog" THEN DO:
						/***************************************
						 * Отправляем через Syslog
						 ***************************************/
					      END.
	WHEN "file"	THEN DO:
						/**************************************
						 * Пишем в файл
						 **************************************/
						OUTPUT TO VALUE(target) APPEND.
							PUT UNFORMATTED oSysClass:DATETIME2STR(DocDate,"%y-%m-%d") "|" STRING(eventnum) "|" CODEPAGE-CONVERT(details,target-code-page,source-code-page) SKIP.
						OUTPUT CLOSE.
					   END.

END CASE.

DELETE OBJECT oSysClass.
END. /* isEnable */
END METHOD.

METHOD PUBLIC VOID send(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER):
						/**************************************************
						 *
						 * Метод отправляет событие по данным
						 *
						 **************************************************/
	fillInfo(iEventNum,cDetails).
	send().
END METHOD.

DESTRUCTOR TEventLog():
		/**************************************
		 *
		 * Я тебя породил, я тебя и убью!!!
		 *
		 ***************************************/

END DESTRUCTOR.

END CLASS.