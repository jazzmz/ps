{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirlegbank.p,v $ $Revision: 1.5 $ $Date: 2007-10-31 10:44:13 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Приказ №64 от 03.10.2007
     Что делает: Экспортирует данные в формате XML со структурой Excel об 
                 операциях клиентов Банка с клиентами других банков, у ктороых отозвана лицензия.
     Как работает: После запуска запрашивает у пользователя период.
                   Для выбранного из справочника банка делает выборку документов, которые:
                       а) Являются внешними и в банковских реквизитах присутствует БИК выбранного банка
                       б) Являются внутренними, а по Дб или Кр указан счет НОСТРО выбранного банка.
                       
                   Выбранные данные сохраняются во временную таблицу.
                   После сбора информации она экспортируется в формате XML: Excel
                   
     Параметры: имя файла экспорта
     Место запуска: Справочник банков. 
     Автор: $Author: buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.4  2007/10/31 09:29:37  buryagin
     Изменения: Added output the client's INN code.
     Изменения:
     Изменения: Revision 1.3  2007/10/18 07:42:23  anisimov
     Изменения: no message
     Изменения:
     Изменения: Revision 1.2  2007/10/16 07:28:57  buryagin
     Изменения: Added new column 'Info about the bank'. It is useful for the consolidated report.
     Изменения: The name of the worksheet is not be longer then 31 characters.
     Изменения:
------------------------------------------------------ */

{globals.i}
{tmprecid.def}
{uxelib.i}

DEF INPUT PARAM iParam AS CHAR.

/** Переменые для построения отчета */
DEF VAR reportXmlCode AS CHAR  NO-UNDO.
DEF VAR sheetXmlCode AS CHAR NO-UNDO.
DEF VAR rowsXmlCode AS CHAR NO-UNDO.
DEF VAR cellsXmlCode AS CHAR NO-UNDO.
DEF VAR styleXmlCode AS CHAR NO-UNDO. 

/** Здесь храним результат выборки */
DEF TEMP-TABLE ttReport NO-UNDO
	FIELD cust-cat AS CHAR
	FIELD cust-id AS INTEGER
	FIELD acctDbName AS CHAR
	FIELD acctCrName AS CHAR
	FIELD acctDb AS CHAR
	FIELD acctCr AS CHAR
	FIELD opDetails AS CHAR
	FIELD opAmtCur AS DECIMAL
	FIELD opAmtRub AS DECIMAL
	FIELD uid AS CHAR
	FIELD opDate AS DATE
	FIELD recipientName AS CHAR
	FIELD recipientAcct AS CHAR
	FIELD recipientInn AS CHAR
	.

DEF TEMP-TABLE ttRow NO-UNDO
	FIELD id AS INTEGER
	FIELD cells AS CHAR.

DEF BUFFER bfrAcctDb FOR acct.
DEF BUFFER bfrAcctCr FOR acct.
DEF BUFFER bfrBank FOR banks.
DEF BUFFER bfrRegnBankCode FOR banks-code.
DEF BUFFER bfrRegnFBanksCode FOR banks-code.

DEF VAR i AS INTEGER INIT 0  NO-UNDO.
DEF VAR summa AS DECIMAL EXTENT 2 NO-UNDO.
DEF VAR fileName AS CHAR NO-UNDO.

/** Переменные для выборки данных */


/** Запрашиваем период */
{getdates.i}

fileName = "/home/bis/quit41d/imp-exp/users/" + lc(userid) + "/" + ENTRY(1, iParam).
OUTPUT TO VALUE(fileName).

styleXmlCode = CreateExcelStyle("Center", "Center", 2, "t1") +
							 CreateExcelStyle("Right", "Center", 2, "t2") +
							 CreateExcelStyle("Right", "Center", 1, "s2") + 
               CreateExcelStyle("Left", "Center", 1, "s1").
PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).


/** Возьмем первый выбранный в справочнике банк и все его филиалы/головные офисы */
FOR EACH tmprecid NO-LOCK,
	  FIRST bfrBank WHERE RECID(bfrBank) = tmprecid.id NO-LOCK,
	  FIRST bfrRegnBankCode WHERE bfrRegnBankCode.bank-id = bfrBank.bank-id AND bfrRegnBankCode.bank-code-type = "REGN" NO-LOCK,
	  EACH  bfrRegnFBanksCode WHERE bfrRegnFBanksCode.bank-code-type = bfrRegnBankCode.bank-code-type 
	        AND bfrRegnFBanksCode.bank-code BEGINS ENTRY(1, bfrRegnBankCode.bank-code, "/") NO-LOCK,
	  FIRST banks WHERE banks.bank-id = bfrRegnFBanksCode.bank-id NO-LOCK,
    FIRST banks-code WHERE banks-code.bank-id = banks.bank-id AND banks-code.bank-code-type = "МФО-9" NO-LOCK
	  
	:
		{empty ttRow}
		{empty ttReport}
		summa[1] = 0. summa[2] = 0.
		i = 0.
		
		/** 1. Выбираем все документы, в банковских реквизитах которых есть бик выбранного банка */
		FOR EACH op-bank WHERE op-bank.bank-code-type = banks-code.bank-code-type 
		    		AND op-bank.bank-code = banks-code.bank-code NO-LOCK,
				EACH op OF op-bank WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
		    FIRST op-entry OF op NO-LOCK,
		    FIRST bfrAcctDb WHERE bfrAcctDb.acct = op-entry.acct-db NO-LOCK,
		    FIRST bfrAcctCr WHERE bfrAcctCr.acct = op-entry.acct-cr NO-LOCK
		  :
		  	CREATE ttReport.
		  	ttReport.acctDbName = bfrAcctDb.details.
		  	ttReport.acctDb = bfrAcctDb.acct.
		  	ttReport.acctCrName = bfrAcctCr.details.
		  	ttReport.acctCr = bfrAcctCr.acct.
		  	ttReport.opDetails = op.details.
		  	ttReport.opAmtRub = op-entry.amt-rub.
		  	ttReport.opAmtCur = op-entry.amt-cur.
		  	ttReport.uid = op.user-id.
		  	ttReport.opDate = op.op-date.
		  	ttReport.recipientName = op.name-ben.
		  	ttReport.recipientAcct = op.ben-acct.
		  	ttReport.recipientInn = op.inn.
		  	IF bfrAcctDb.cust-cat <> "В" THEN 
		  		DO:
		  			ttReport.cust-cat = bfrAcctDb.cust-cat.
		  			ttReport.cust-id = bfrAcctDb.cust-id.
		  		END.
		  	ELSE IF bfrAcctCr.cust-cat <> "В" THEN 
		  		DO:
		  			ttReport.cust-cat = bfrAcctCr.cust-cat.
		  			ttReport.cust-id = bfrAcctCr.cust-id.
		  		END.
		END.		
		
		/** 2. Выбираем все документы, дебет или кредит которых является счетом "ностро" выбранного банка */
		
		FOR EACH acct WHERE acct.cust-cat = "Б" AND acct.cust-id = banks.bank-id
		                AND acct.contract = "Ностро" AND acct.open-date LE end-date 
		                AND (close-date GE beg-date OR close-date = ?) NO-LOCK,
		    EACH op-entry WHERE (op-entry.acct-db = acct.acct OR op-entry.acct-cr = acct.acct)
		                    AND op-entry.op-date GE beg-date AND op-entry.op-date LE end-date NO-LOCK,
		    FIRST op OF op-entry NO-LOCK,
		    FIRST bfrAcctDb WHERE bfrAcctDb.acct = op-entry.acct-db NO-LOCK,
		    FIRST bfrAcctCr WHERE bfrAcctCr.acct = op-entry.acct-cr NO-LOCK
		    
		  :
		  	
		  	CREATE ttReport.
		  	ttReport.acctDbName = bfrAcctDb.details.
		  	ttReport.acctDb = bfrAcctDb.acct.
		  	ttReport.acctCrName = bfrAcctCr.details.
		  	ttReport.acctCr = bfrAcctCr.acct.
		  	ttReport.opDetails = op.details.
		  	ttReport.opAmtRub = op-entry.amt-rub.
		  	ttReport.opAmtCur = op-entry.amt-cur.
		  	ttReport.uid = op.user-id.
		  	ttReport.opDate = op.op-date.
		  	ttReport.recipientName = op.name-ben.
		  	ttReport.recipientAcct = op.ben-acct.
		  	IF bfrAcctDb.acct <> acct.acct THEN 
		  		DO:
		  			ttReport.cust-cat = bfrAcctDb.cust-cat.
		  			ttReport.cust-id = bfrAcctDb.cust-id.
		  		END.
		  	ELSE 
		  		DO:
		  			ttReport.cust-cat = bfrAcctCr.cust-cat.
		  			ttReport.cust-id = bfrAcctCr.cust-id.
		  		END.
		  	
		END.
		
				
		/** Если есть данные для экспорта */
		
		IF CAN-FIND(FIRST ttReport) THEN DO:
		
			/** Заголовок */


			cellsXmlCode = CreateExcelCell("String", "t1", "Наименование счета дебета в ПИРБанке")
             + CreateExcelCell("String", "t1", "Наименование счета кредита в ПИРБанке")
             + CreateExcelCell("String", "t1", "Дебет счета в ПИРБанке")
             + CreateExcelCell("String", "t1", "Кредит счета в ПИРБанке")
             + CreateExcelCell("String", "t1", "Содержание операции")
             + CreateExcelCell("String", "t1", "Сумма в иностранной валюте")
             + CreateExcelCell("String", "t1", "Сумма в национальной валюте")
             + CreateExcelCell("String", "t1", 'Способ передачи данных (реквизит "сотрудиник")')
             + CreateExcelCell("String", "t1", 'Дата')
             + CreateExcelCell("String", "t1", 'Наименование клиента в анализируемом банке')
             + CreateExcelCell("String", "t1", 'Номер счета клиента в анализируемом банке')
             + CreateExcelCell("String", "t1", 'ИНН клиента')
             + CreateExcelCell("String", "t1", 'Данные относятся к Банку').

			CREATE ttRow. ttRow.cells = SetExcelColumnWidth(1, 200) 
						+ SetExcelColumnWidth(2, 200)
						+ SetExcelColumnWidth(3, 110)
						+ SetExcelColumnWidth(4, 110)
						+ SetExcelColumnWidth(5, 300)
						+ SetExcelColumnWidth(9, 70)
						+ SetExcelColumnWidth(10, 200)
						+ SetExcelColumnWidth(11, 200)
						+ SetExcelColumnWidth(12, 70)
						+ SetExcelColumnWidth(13, 200)
						+ CreateExcelRow(CreateExcelCell("String", "", 'Отчетная форма по операциям клиента Банка с клиентами банка с отозванной лицензией (по основаниям, в том числе, ПОДФТ): ' + banks.name + ' (c )'))
						+ CreateExcelRow(CreateExcelCell("String", "", 'Период выборки: с ' + STRING(beg-date, "99.99.9999") + ' по ' + STRING(end-date, "99.99.9999")))
						+ CreateExcelRow(cellsXmlCode).


			FOR EACH ttReport:
	
				cellsXmlCode = CreateExcelCell("String", "s1", ttReport.acctDbName)
             + CreateExcelCell("String", "s1", ttReport.acctCrName)
             + CreateExcelCell("String", "s1", ttReport.acctDb)
             + CreateExcelCell("String", "s1", ttReport.acctCr)
             + CreateExcelCell("String", "s1", ttReport.opDetails)
             + CreateExcelCell("Number", "s2", STRING(ttReport.opAmtCur))
             + CreateExcelCell("Number", "s2", STRING(ttReport.opAmtRub))
             + CreateExcelCell("String", "s1", ttReport.uid)
             + CreateExcelCell("String", "s1", STRING(ttReport.opDate, "99.99.9999"))
             + CreateExcelCell("String", "s1", ttReport.recipientName)
             + CreateExcelCell("String", "s1", ttReport.recipientAcct)
             + CreateExcelCell("String", "s1", ttReport.recipientInn)
             + CreateExcelCell("String", "s1", banks.short-name).

				CREATE ttRow.
				i = i + 1.
				ttRow.id = i.
				ttRow.cells = CreateExcelRow(cellsXmlCode).
				summa[1] = summa[1] + ttReport.opAmtCur.
				summa[2] = summa[2] + ttReport.opAmtRub. 
		
			END.

			IF i > 0 THEN DO:
				CREATE ttRow.
				ttRow.cells = CreateExcelRow(
								CreateExcelCellEx(6, "Number", "t2", "=SUM(R[-" + STRING(i) + "]C:R[-1]C)", STRING(summa[1])) +
								CreateExcelCellEx(7, "Number", "t2", "=SUM(R[-" + STRING(i) + "]C:R[-1]C)", STRING(summa[2]))
							).
			END.


			/** Экспорт листа. Название листа = рег.номер банка + короткое наименование */
			PUT UNFORMATTED CreateExcelWorksheet(SUBSTRING(REPLACE(bfrRegnFBanksCode.bank-code,"/","-") + " " + banks.short-name, 1, 31)).

			FOR EACH ttRow:
				PUT UNFORMATTED ttRow.cells.
			END.

			PUT UNFORMATTED CloseExcelTag("Worksheet").
		
		END. /* Если есть данные для экспорта */

END.
	  

PUT UNFORMATTED CloseExcelTag("Workbook").

OUTPUT CLOSE.

MESSAGE "Данные экспортированы в файл " + fileName VIEW-AS ALERT-BOX.
