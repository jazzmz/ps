/*
   Формирование ведомости.
   Параметры:

   Modified: 30/10/2001 NIK Выравнивание кода, исключение find signs...
                            Неверная 8 колонка
     Modified: 27.01.2004 kraw (0022373)
     Modified: 04.04.2005 kraw (0042443) Очередное изменение алгоритма формирования номера и даты договора
     Modified: 19.08.2005 anisimov  - подгонка под требования отдела по открытию счетов
*/

DEF VAR oSysClass AS TSysClass    NO-UNDO.
DEF VAR cName     AS CHAR         NO-UNDO.
DEF VAR cDetails  AS CHAR INIT "" NO-UNDO.
DEF VAR oClient   AS TClient      NO-UNDO.

DEF VAR oTable    AS TTable2      NO-UNDO.

oSysClass = new TSysClass().

oTable = NEW TTable2().
oTable:setDraw(NEW TCSVDraw("|")).

/*
oTable:colsWidthList = "10,10,10,20,35".
*/
/*
oTable:colsHeaderList = "Номер NN,Дата открытия счета,Номер и дата договора об открытии счета,
Наименование клиентов счета,Номер лицевого счета,Назначение счет,
Порядок и периодичность выдачи выписок,Дата сообщения налогвым органам об открытии счета,
Дата закрытия счета,Дата сообщения о закрытии,Примечание".
*/

oTable:addRow().
oTable:addCell("Номер NN").
oTable:addCell("Дата открытия счета").
oTable:addCell("Дата и номер договора об открытии счета").
oTable:addCell("Наименование клиента").
oTable:addCell("Номер лицевого счета").
oTable:addCell("Вид счета").
oTable:addCell("Порядок и периодичность выдачи выписок").
oTable:addCell("Дата сообщения налоговым органам об открытии счета").
oTable:addCell("Дата закрытия счета").
oTable:addCell("Дата сообщения налоговым органам о закрытии счета").
oTable:addCell("Примечание").
oTable:addCell("Балансовый счет").


oTable:addRow().
oTable:addCell("1").
oTable:addCell("2").
oTable:addCell("3").
oTable:addCell("4").
oTable:addCell("5").
oTable:addCell("6").
oTable:addCell("7").
oTable:addCell("8").
oTable:addCell("9").
oTable:addCell("10").
oTable:addCell("11").
oTable:addCell("12").

ppnum = 0.

FOR EACH bal-acct WHERE CAN-DO(mAcct, string(bal-acct.bal-acct)) NO-LOCK,
   EACH acct OF bal-acct WHERE acct.cust-cat BEGINS mSewMode
                           AND open-date LE end-date
                           AND (close-date GT end-date OR close-date EQ ?)
                           AND acct.user-id BEGINS access
                           AND acct.acct-cat EQ "b"
                           AND CAN-DO(list-id,acct.user-id)
                           AND acct.cust-cat BEGINS mSewMode  /* юр,физ,банк,все */
        NO-LOCK
   BREAK BY bal-acct.bal-acct 
         BY acct.currency 
         BY SUBSTRING(acct.acct,10,11) WITH FRAME fr{1}:

   mCustCat2 = GetXAttrValueEx("bal-acct",STRING(acct.bal-acct),"ПрКл","Внутренний").
   ppnum = ppnum + 1.

/*************************
 * ОПРЕДЕЛЯЕМ ЦЕЛЬ СЧЕТА *
 **************************/
col5 = getXAttrValue("acct",acct.acct + "," + acct.currency,"ЦельСч").

    /*********** ЗДЕСЬ СМОТРИМ НАИМЕНОВАНИЕ СЧЕТА КЛИЕНТА ****************/
    /************
     * Проверяем:
     * Если счет принадлежит маске
     * !3*,!4*,*, 
     * то наименование СЧЕТА, должно
     * стоять в графе примечание, а наименование
     * клиента должно быть пустым.
     * По диалогу с Кирносовой О. А. и Жуковой И.
     * в начале апреля 2011.
     ************/
       IF CAN-DO("!3*,!4*,*",acct.acct) OR CAN-DO("Внутр*",col5) THEN DO:
	      ASSIGN
	        name[1] = ""
                cDetails = acct.details
              .
	 cDetails = REPLACE(cDetails,CHR(10),"").
	 cDetails = REPLACE(cDetails,CHR(13),"").
	END.
	ELSE
	DO:
	   /* Если счет явно клиентский, то ставим реквизиты его владельца */
	   IF acct.cust-cat EQ 'Ю' OR  acct.cust-cat EQ 'Ч' THEN
        	 DO:
	           oClient = new TClient(acct.acct).

			 ASSIGN
	                   name[1] = oClient:name-short
	                   cDetails = ""
                          .

	            DELETE OBJECT oClient.
         	   END.
         	   ELSE
            	     DO:
			/* Если счет банка, то ставим наименование счета */
		 	IF acct.cust-cat EQ "Б" THEN DO:
			   ASSIGN
			    name[1]=acct.details
			    cDetails=""
			    .
			END.
		        ELSE DO:
                       		name[1] = "".
	                       cDetails = acct.details.
        	        END.
		END.
           IF name[1] EQ "" THEN cDetails = acct.details.
	END.

/*** Конец заполнения граф наименования ***/

cName = name[1].

IF name[1] <> "" THEN cName = TRIM(oSysClass:REPLACE_ASCII(name[1],10,"-")).
IF cName <> ""   THEN cName = TRIM(oSysClass:REPLACE_ASCII(cName,13,"-")).


col1[1] = getXAttrValue("acct",acct.acct + "," + acct.currency,"ДогОткрЛС").

col1[1] = REPLACE(col1[1],CHR(10),"").
col1[1] = REPLACE(col1[1],CHR(13),"").

col4[1] = "". /* В этой книге нет закрытых счетов */
col6 = getXAttrValue("acct",acct.acct + "," + acct.currency,"ДатаСообщЗак").



/* Нахождение последнего действующего договора для счета */
/*
 Значит в таблице не может быть двух записей для одного и того же договора.
 contract eq "" or can-find(contract of loan-acct)
*/

IF col1[1] = "" AND col1[1] NE "01/01/1900,00" THEN
DO:
 /* Если не указан номер и дата договора на в доп. реках счета */

 FIND FIRST loan-acct OF acct WHERE loan-acct.since LE end-date 
						      AND (loan-acct.contract EQ "Кредит" 
							   OR loan-acct.contract EQ "Депоз" 
							   OR loan-acct.contract EQ "dps" 
							   OR loan-acct.contract EQ "card-c"
                                                          ) NO-LOCK NO-ERROR.

 IF AVAILABLE(loan-acct) THEN
   DO:
		FIND FIRST loan  OF loan-acct NO-LOCK NO-ERROR.
		IF AVAILABLE(loan) THEN col1[1] = STRING(loan.open-date,"99/99/9999") + ",". 

		IF {assigned loan.doc-ref} THEN col1[1] = col1[1] + loan.doc-ref.
		ELSE
			DO:
				IF {assigned loan.doc-num} THEN col1[1] = col1[1] +  loan.doc-num.
				ELSE IF {assigned loan.cont-code} THEN col1[1] = col1[1] + loan.cont-code.
			 END.

     END.

END. 

/* Конец определения договора */
IF col1[1] EQ "01/01/1900,00" THEN col1[1] = "".


   IF col5 EQ "Внутренний" OR col5 EQ "Депозитный" OR col5 EQ "Ссудный" THEN 
								DO:
								   ASSIGN
								     col2[1] = "Не требуется"
								     col3 = "Не требуется"
								     col6 = "Не требуется"
                                                                    .
								END.	
					          ELSE  
							DO:
								col2[1] = getXAttrValue("acct",acct.acct + "," + acct.currency,"ПорВыдВыпис").
 							        col3 = getXAttrValue("acct",acct.acct + "," + acct.currency,"ДатаСообщЛС").

								/* 
								 Если дата закрытия, больше искомого интервала
								 или счет вообще открыт, то на доп. реквизит не смотрим
								 */
								col6 = getXAttrValue("acct",acct.acct + "," + acct.currency,"ДатаСообщЗак").

								IF NOT CAN-DO("Не тр*",col6) THEN
									DO:						
										IF acct.close-date >= end-date OR acct.close-date EQ ?  THEN col6 = "".
									END.
								
							END.


   
   /* разбиваем длинные наименования на несколько строк */

oTable:addRow().

oTable:addCell(ppnum).			            /* №1 */
oTable:addCell(acct.open-date).	        /* №2 */
oTable:addCell(col1[1]).			            /* №3 */
oTable:addCell(cName).			            /* №4 */
oTable:addCell(acct.acct).			            /* №5 */
oTable:addCell(col5).	                            /* №6 Тип счета */
oTable:addCell(col2[1]).                       /* №7  Порядок выдачи выписок */
oTable:addCell(col3).                            /* №8  Дата сообщения об открытии */
oTable:addCell(col4[1]).	                    /* №9  Дата закрытия */
oTable:addCell(col6).                           /* №10 Дата сообщения о закрытии */
oTable:addCell(cDetails).                    /* №11 Примечание */
oTable:addCell(bal-acct.bal-acct).       /* №12 Балансовый счет*/

END.

oTable:SAVE-TO(filePath + "/book-" + STRING(YEAR(end-date)) + STRING(MONTH(end-date)) + STRING(DAY(end-date)) + ".txt").


/*
{setdestp.i &cols=200}
oTable:show().
{preview.i}
*/

DELETE OBJECT oTable.
DELETE OBJECT oSysClass.
