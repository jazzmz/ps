/* ------------------------------------------------------
     File: $RCSfile: pir_valvip.p,v $ $Revision: 1.5 $ $Date: 2009-05-26 10:14:19 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: -
     Причина: Без ТЗ, на основании письма от Гамана В.В. в марте 2009
     Что делает: формирует выписку по валютным операциям, которые 
                 поступили из систем iBank2 и SWIFT. Данные экспортируются в 
                 файл формата XML:EXCEL
     Как работает: по выбранным в броузере документов записям, процедура 
                   заполняет временную таблицу, собирая необходимые данные.
                   В основном, данные для отчета хранятся в дополнительных реквизитах
                   сообщения (класс: msg-impexp), которое связанно с документом
     Параметры: <каталог_экспорта>
     Место запуска: броузер документов
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.4  2009/05/25 14:46:08  Buryagin
     Изменения: Added option for div or not div data by client's page
     Изменения:
     Изменения: Revision 1.2  2009/04/01 10:11:25  Buryagin
     Изменения: Fix the Benef and Order information for the transit operations. Added the origin details of operation into last column.
     Изменения:
     Изменения: Revision 1.1  2009/03/25 08:47:06  Buryagin
     Изменения: For PODFT and Currency Department
     Изменения:
------------------------------------------------------ */

/** Глобальные системные определения */
{globals.i}

/** библиотека для создания XML:EXCEL файла */
{uxelib.i}
{ulib.i}
{get-bankname.i}
/** используем информацию из броузера */
{tmprecid.def}
/* Определение структуры динамического фильтра. */
{flt-val.i}

DEFINE INPUT PARAM iParam AS CHAR.
DEFINE VAR saveDir AS CHAR NO-UNDO.
DEFINE VAR clientAcctMask AS CHAR NO-UNDO.
DEFINE VAR corsAcctMask AS CHAR NO-UNDO.
DEFINE VAR transAcctMask AS CHAR NO-UNDO.
DEFINE VAR flag AS logical NO-UNDO init false.

DEFINE TEMP-TABLE ttReport
	FIELD id AS INT
	FIELD direct AS CHAR /** in, out */
	FIELD ourClientID AS CHAR /** для группировки */
	FIELD ourClientName AS CHAR 
	/** платежный документ */
	FIELD docNum AS CHAR
	FIELD docDate AS CHAR
	FIELD docAmount AS CHAR /* формат: 999999,99 */
	FIELD docCurrency AS CHAR 
	FIELD docAmountRUR AS CHAR 
	FIELD docDetails AS CHAR
	FIELD docOrigDetails AS CHAR /** назначение платежа из документа SWIFT */
	/** банк-плательщик */
	FIELD bankOutBic AS CHAR
	FIELD bankOutName AS CHAR
	FIELD bankOutStrana AS CHAR
	/** клиент-плательщик */
	FIELD clientOutName AS CHAR
	FIELD clientOutInn AS CHAR
	FIELD clientOutAcct AS CHAR
	FIELD clientOutStrana AS CHAR
	/** банк-получатель */
	FIELD bankInBic AS CHAR
	FIELD bankInName AS CHAR
	FIELD bankInStrana AS CHAR
	/** клиент-получатель */
	FIELD clientInName AS CHAR
	FIELD clientInStrana AS CHAR
	FIELD clientInInn AS CHAR
	FIELD clientInAcct AS CHAR
	FIELD codeVO AS CHAR
	
	/** теги 
	    формат: <litera>=<value>|<litera>=<value>|...|<litera>=<value> 
	*/
	FIELD tag32 AS CHAR /** сумма операции. но реально сумму берем из проводки */
	FIELD tag50 AS CHAR /** номер счета плательщика для входящих док.*/
	FIELD tag52 AS CHAR /** банк-отправителя */
	FIELD tag59 AS CHAR /** номер счета получателя для исходящих док. */
	FIELD tag70 AS CHAR /** оригинальное назначение платежа */
.

DEFINE TEMP-TABLE t_tmprecid
	FIELD t_id AS INT
.
/** плательщик или получатель */
DEF BUFFER bfrClient FOR cust-role.
/** банк плательщика или банк получателя */
DEF BUFFER bfrBank FOR cust-role.
/** сумма операции */
DEF BUFFER bfrOpEntry FOR op-entry.

DEF VAR i AS INTEGER NO-UNDO INIT 0.
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO.

clientAcctMask = GetParamByName_ULL(iParam, "clientAcctMask", ".", ";").
corsAcctMask = GetParamByName_ULL(iParam, "corsAcctMask", ".", ";").
transAcctMask = GetParamByName_ULL(iParam, "transAcctMask", ".", ";").
/** обработка выбранных документов */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry WHERE op-entry.op = op.op
                     AND (CAN-DO(clientAcctMask, op-entry.acct-db) OR
                          CAN-DO(transAcctMask, op-entry.acct-db) OR 
                          CAN-DO(clientAcctMask, op-entry.acct-cr) OR
                          CAN-DO(transAcctMask, op-entry.acct-cr)
                         )
                     NO-LOCK,
    /** сумму операции ищем в проводке с корреспонденцией корс-счета */
    FIRST bfrOpEntry WHERE bfrOpEntry.op = op.op
                       AND (CAN-DO(corsAcctMask, op-entry.acct-db) OR CAN-DO(corsAcctMask, op-entry.acct-cr))
                       NO-LOCK
  :
  	i = i + 1.
	CREATE t_tmprecid.
	t_tmprecid.t_id = tmprecid.id. 
  	CREATE ttReport.
  	ttReport.id = i.
  	
	FIND FIRST msg-impexp WHERE msg-impexp.object-id = STRING(op.op) NO-LOCK NO-ERROR.
	IF AVAIL msg-impexp THEN DO:	
  		ttReport.tag32 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift32", "").
  		ttReport.tag50 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift50", "").
  		/** на будущее 
  		ttReport.tag52 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift70", "").
  		*/
  	
  		ttReport.tag59 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift59", "").
  	
  		/** "=" поумолчанию потому, что 70 тег не дополняется буквами и значение д.р. будет
  	    	похоже на "=<значение>" 
  		*/
  		ttReport.tag70 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift70", "=").
  
  	END.
  	
  	/** документ: номер и дата */
  	ttReport.docNum = op.doc-num.
  	ttReport.docDate = STRING(op.op-date, "99.99.9999").
  	
  	/** сумма операции из SWIFT
  	tmpStr = "". tmpStr = GetParamByName_ULL(ttReport.tag32, "A", "", "|").
  	ttReport.docAmount = SUBSTR(tmpStr, 10).
  	*/
  	
  	/** сумма операции из проводки */ 
  	ttReport.docAmount = REPLACE(STRING(bfrOpEntry.amt-cur), ",", ".").
  	ttReport.docCurrency = bfrOpEntry.currency.
  	ttReport.docAmountRUR = REPLACE(STRING(bfrOpEntry.amt-rub), ",", ".").

  	/** назначение платежа из документа и из SWIFT */
  	ttReport.docDetails = op.details.
  	ttReport.docOrigDetails = ENTRY(2, ttReport.tag70, "=").
	tmpStr = GetXAttrValueEx("op", STRING(op.op), "КодОпВал117", "").
  	ttReport.codeVO = "VO" + ENTRY(1, tmpStr).
  	IF NUM-ENTRIES(ttReport.docDetails, "\}") = 2 THEN DO:
  	  	ttReport.codeVO = ENTRY(1, ENTRY(2, ENTRY(1, ttReport.docDetails, "\}"), "\{"), ",").
  	END. 
  	
  	
  	FIND FIRST bfrClient WHERE bfrClient.file-name = "op" 
                      AND bfrClient.surrogate = STRING(op.op)
                      AND CAN-DO("Order-Cust,Benef-Cust", bfrClient.Class-code)
                      NO-LOCK NO-ERROR.
    FIND FIRST bfrBank WHERE bfrBank.file-name = "op"
                    AND bfrBank.surrogate = STRING(op.op)
                    AND CAN-DO("Order-Inst,Benef-Inst", bfrBank.Class-code)
                    NO-LOCK NO-ERROR.  	
  	
  	/** определяем направление платежа */
  	IF AVAIL bfrClient AND bfrClient.class-code = "Order-Cust" THEN ttReport.direct = "in".
  	IF AVAIL bfrClient AND bfrClient.class-code = "Benef-Cust" THEN ttReport.direct = "out".

  	/** плательщик */
  	IF ttReport.direct = "in" THEN DO:
  		IF AVAIL bfrBank THEN do:
			ttReport.bankOutBic = bfrBank.cust-code.
  			ttReport.bankOutName = bfrBank.cust-name.
                        ttReport.bankOutStrana = bfrBank.country-id.
		end.
  		IF AVAIL bfrClient THEN do:
			ttReport.clientOutName = bfrClient.cust-name.
			ttReport.clientOutStrana = bfrClient.country-id.
		end.
  		ttReport.clientOutInn = "".
  		tmpStr = GetParamByName_ULL(ttReport.tag50, "F", "", "|") + GetParamByName_ULL(ttReport.tag50, "K", "", "|").
  		ttReport.clientOutAcct = ENTRY(2, ENTRY(1, tmpStr, CHR(126)), "/").
  	END.
  	/* получатель */
  	IF ttReport.direct = "out" THEN DO:
  		IF AVAIL bfrBank THEN do:
			ttReport.bankInBic = bfrBank.cust-code.
  			ttReport.bankInName = bfrBank.cust-name.
			ttReport.bankInStrana = bfrBank.country-id.
		end.
  		IF AVAIL bfrClient THEN do:
			ttReport.clientInName = bfrClient.cust-name.
			ttReport.clientInStrana = bfrClient.country-id.
		end.
  		ttReport.clientInInn = "".
  		ttReport.clientInAcct = ENTRY(2, ENTRY(1, ENTRY(2, ttReport.tag59, "="), CHR(126)), "/").
  	END.
  	
  	IF ttReport.direct = "in" THEN DO:
  	
  		/** информация, которая относится именно к нашему клиенту,
  		    даже если платеж транзитный. Например, наш клиент - банк.
  		    Клиенты нашего клиента совершают платежи, которые мы 
  		    будем группировать по ID нашего клиента 
  		*/
  		ttReport.ourClientID = GetAcctClientId_ULL(op-entry.acct-cr, false).
  		ttReport.ourClientName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
  	
		/** если наш банк является транзитным (платеж проходит через
		    корссчет), то данные клиента-получателя
		    читаем из swift, данные банка-получателя берем по транзитному счету, 
		    
		    если платеж не транзитный, то читаем их из настроек */
		    
		if (CAN-DO(transAcctMask, op-entry.acct-db) OR 
		    CAN-DO(transAcctMask, op-entry.acct-cr))
		then 
			do:
				/** банк-получателя */
		  		ttReport.bankInBic = GetClientInfo_ULL(ttReport.ourClientID, "bank-code:bic;МФО-9", false).
				ttReport.bankInName = ttReport.ourClientName.
				ttReport.bankInStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
				
				/** счет и наименование получателя */
				tmpStr = ttReport.tag59.
  				
  				ttReport.clientInAcct = ENTRY(2, ENTRY(1, ENTRY(2, ttReport.tag59, "="), CHR(126)), "/").
  			
  				tmpStr2 = "".
  				DO i = 2 TO NUM-ENTRIES(tmpStr, CHR(126)) :
  					if tmpStr2 <> "" then tmpStr2 = tmpStr2 + CHR(13) + CHR(10).
  					tmpStr2 = tmpStr2 + ENTRY(i, tmpStr, CHR(126)).
  				END.
  				ttReport.clientInName = tmpStr2.
  				ttReport.clientInStrana = "".
			end.
		else
			do:
		  		ttReport.bankInBic = FGetSetting("БанкМФО", "", "").
  				ttReport.bankInName = cBankName.
  				ttReport.bankInStrana = "RUS".
		  		ttReport.clientInAcct = op-entry.acct-cr.
  				ttReport.clientInName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
		  		ttReport.clientInInn = GetClientInfo_ULL(ttReport.ourClientID, "inn", false).
  				ttReport.clientInStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
		  	end.
  	END.

  	/* плательщик */
	IF ttReport.direct = "out" THEN DO:
		
  		/** информация, которая относится именно к нашему клиенту,
  		    даже если платеж транзитный. Например, наш клиент - банк.
  		    Клиенты нашего клиента совершают платежи, которые мы 
  		    будем группировать по ID нашего клиента 
  		*/
  		ttReport.ourClientID = GetAcctClientId_ULL(op-entry.acct-db, false).
  		ttReport.ourClientName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).

		/** если наш банк является транзитным (платеж проходит через
		    корссчет), то данные клиента-плательщика
		    читаем из swift, данные банка-плательщика берем по транзитному счету, 
		    
		    если платеж не транзитный, то читаем их из настроек */
		    
		if (CAN-DO(transAcctMask, op-entry.acct-db) OR 
		    CAN-DO(transAcctMask, op-entry.acct-cr))
		then 
			do:
				/** банк-плательщика */
		  		ttReport.bankOutBic = GetClientInfo_ULL(ttReport.ourClientID, "bank-code:bic;МФО-9", false).
				ttReport.bankOutName = ttReport.ourClientName.
				ttReport.bankOutStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
				
				/** счет и наименование плательщика */
				tmpStr = GetParamByName_ULL(ttReport.tag50, "F", "", "|") + GetParamByName_ULL(ttReport.tag50, "K", "", "|").
  				
  				ttReport.clientOutAcct = ENTRY(2, ENTRY(1, tmpStr, CHR(126)), "/").
  				/** но реальный счет плательщика может следовать за транзитным (формат ПИРбанка из БИФИТ) 
  				    хотя код можно было написать и короче, но менее понятно */
  				if num-entries(ENTRY(1, tmpStr, CHR(126)), "/") = 3 then do:
  					ttReport.clientOutAcct = ENTRY(3, ENTRY(1, tmpStr, CHR(126)), "/").
  				end.
  			
  				tmpStr2 = "".
  				DO i = 2 TO NUM-ENTRIES(tmpStr, CHR(126)) :
  					if tmpStr2 <> "" then tmpStr2 = tmpStr2 + CHR(13) + CHR(10).
  					tmpStr2 = tmpStr2 + ENTRY(i, tmpStr, CHR(126)).
  				END.
  				ttReport.clientOutName = tmpStr2.
  				ttReport.clientOutStrana = "".
			end.
		else
			do:
			  	ttReport.bankOutBic = FGetSetting("БанкМФО", "", "").
  				ttReport.bankOutName = cBankName.
  				ttReport.bankOutStrana = "RUS".
		  		ttReport.clientOutAcct = op-entry.acct-db.
		  		ttReport.clientOutName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
		  		ttReport.clientOutInn = GetClientInfo_ULL(ttReport.ourClientID, "inn", false).
				ttReport.clientOutStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
			end.
  		
  	END.
  	
END.
/** сбор данных закончен */

/** Формирование XML:EXCEL файла */
pause 0.

saveDir = GetParamByName_ULL(iParam, "saveDir", "./users/" + LC(USERID), ";").
DEFINE VAR fileName AS CHAR NO-UNDO LABEL "Имя файла"  FORMAT "x(65)".
DEFINE VAR divPage AS LOGICAL NO-UNDO LABEL "Каждому клиенту свой лист?" FORMAT "Да/Нет" INIT "Да".
DEFINE VAR Strana AS CHAR format 'x(450)' VIEW-AS FILL-IN SIZE 45 by 1 init '*' no-undo.
fileName = GetParamByName_ULL(iParam, "fileName", "valvip.xml", ";").
fileName = saveDir + "/" + fileName.
/*UPDATE filename SKIP divPage WITH FRAME tmpFrame OVERLAY CENTERED.
HIDE FRAME tmpFrame.
*/
form
    "Имя файла:" fileName no-label skip
    "Каждому клиенту свой лист? :" divPage no-label skip
    "Список стран(выбор по F1)  :" Strana no-label skip
     with frame wow OVERLAY ROW 10 SIDE-LABELS TITLE
          COLOR bright-white "[ Данные по формированию ведомости ]".

pause 0.

   
do transaction with frame wow:
	update fileName divPage Strana editing: readkey.
	        if lastkey eq keycode('F1') AND (frame-field EQ 'Strana') then do:
       		       RUN browseld.p ('country',
                                  '',
                                  '',
                                  ?,
                                  1) NO-ERROR.
				if lastkey eq 10 then do:
/*				disp pick-value @ Strana. */
                                Strana = "".
				for each tmprecid NO-LOCK, FIRST country WHERE RECID(country) = tmprecid.id NO-LOCK:
					Strana = Strana + country.country-id + ",".
				end.
                                Strana = substring(Strana,1,LENGTH(Strana) - 1).
				disp Strana @ Strana. 
			end.
	        end.
	        else do: apply lastkey.
		end.
 	end.
    end.

    HIDE FRAME wow NO-PAUSE.
    if lastkey eq 27 then do:
       HIDE FRAME wow.
       return.
end.  


DEF VAR styleXmlCode AS CHAR NO-UNDO.
DEF VAR cnt AS INTEGER NO-UNDO. 

OUTPUT TO VALUE(fileName).

	/** задаем стили */
	styleXmlCode = CreateExcelStyle("Center", "Center", 2, "title1") +
	               CreateExcelStyle("Left", "Center", 1, "cell1") +
	               CreateExcelStyle("Right", "Center", 1, "cell2") +
	               CreateExcelStyle("Right", "Center", 2, "total1").
	/** задаем книгу */
	PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
	/** выводим данные */
	
	FOR EACH ttReport where can-do(Strana,ttReport.bankOutStrana) or can-do(Strana,ttReport.clientOutStrana)
		or can-do(Strana,ttReport.bankInStrana) or can-do(Strana,ttReport.clientInStrana)	
		BREAK BY ttReport.ourClientID:
		flag = true.
		IF (FIRST-OF(ttReport.ourClientID) AND divPage) OR (FIRST(ttReport.ourClientID) AND NOT divPage) THEN DO: 
			
			cnt = 0.
			
			/** задаем лист */
			IF divPage THEN 
				PUT UNFORMATTED CreateExcelWorksheet(SUBSTRING(LoopReplace_ULL(ttReport.ourClientName, '"', ""), 1, 15)).
			ELSE
				PUT UNFORMATTED CreateExcelWorksheet(SUBSTRING(LoopReplace_ULL("Все", '"', ""), 1, 15)).
	
			PUT UNFORMATTED 
			
			/** Задаем ширину столбцов */ 
			SetExcelColumnWidth(1, 50) +
			SetExcelColumnWidth(2, 70) + 
			SetExcelColumnWidth(3, 100) +
			SetExcelColumnWidth(4, 200) +
			SetExcelColumnWidth(5, 70) +
			SetExcelColumnWidth(6, 200) +
			SetExcelColumnWidth(7, 70) +
			SetExcelColumnWidth(8, 100) +
			SetExcelColumnWidth(9, 200) +
			SetExcelColumnWidth(10, 100) +
			SetExcelColumnWidth(11, 200) +
			SetExcelColumnWidth(12, 70) +
			SetExcelColumnWidth(13, 200) +
			SetExcelColumnWidth(14, 70) +
			SetExcelColumnWidth(15, 100) +
			SetExcelColumnWidth(16, 200) +
			SetExcelColumnWidth(17, 70) +
			SetExcelColumnWidth(18, 40) +
			SetExcelColumnWidth(19, 70) +
			SetExcelColumnWidth(20, 400) +								
			SetExcelColumnWidth(21, 400) + 
			SetExcelColumnWidth(22, 100)							
			/** Выводим название отчета */ 
			CreateExcelRow(
				CreateExcelCell("String", "", "Приходные и расходные операции " + (IF divPage THEN ttReport.ourClientName ELSE "") + " за период с " + GetFltVal("op-date1") + " по " + GetFltVal("op-date2"))
			) +
						
			/** Выводим заголовки отчета */
			CreateExcelRow(
				CreateExcelCell("String", "title1", "Номер п/п") +
				CreateExcelCell("String", "title1", "Дата совершения операции") +
				CreateExcelCell("String", "title1", "БИК банка-плательщика") +
				CreateExcelCell("String", "title1", "Наименование банка-плательщика") +
				CreateExcelCell("String", "title1", "Код страны регистрации банка-плательщика") +
				CreateExcelCell("String", "title1", "Наименование плательщика") +
				CreateExcelCell("String", "title1", "Код страны регистрации плательщика") +
				CreateExcelCell("String", "title1", "ИНН плательщика") +
				CreateExcelCell("String", "title1", "Номер счета плательщика") +
				CreateExcelCell("String", "title1", "БИК банка-получателя") +
				CreateExcelCell("String", "title1", "Наименование банка-получателя") +
				CreateExcelCell("String", "title1", "Код страны регистрации банка-получателя") +
				CreateExcelCell("String", "title1", "Наименование получателя") +
				CreateExcelCell("String", "title1", "Код страны регистрации получателя") +
				CreateExcelCell("String", "title1", "ИНН получателя") +
				CreateExcelCell("String", "title1", "Номер счета получателя") +
				CreateExcelCell("String", "title1", "Сумма операции") +
				CreateExcelCell("String", "title1", "Валюта операции") + 
				CreateExcelCell("String", "title1", "Сумма операции (руб)") +
				CreateExcelCell("String", "title1", "Назначение платежа") +
				CreateExcelCell("String", "title1", "Содержание операции (в БИС)") +
				CreateExcelCell("String", "title1", "Код валютного контроля")
			).
			
		END. /* новый лист */
				
		PUT UNFORMATTED CreateExcelRow(
			CreateExcelCell("String", "cell1", ttReport.docNum) +
			CreateExcelCell("String", "cell1", ttReport.docDate) +
			CreateExcelCell("String", "cell1", ttReport.bankOutBic) +
			CreateExcelCell("String", "cell1", ttReport.bankOutName) +
			CreateExcelCell("String", "cell1", ttReport.bankOutStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientOutName) +
			CreateExcelCell("String", "cell1", ttReport.clientOutStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientOutInn) +
			CreateExcelCell("String", "cell1", ttReport.clientOutAcct) +
			CreateExcelCell("String", "cell1", ttReport.bankInBic) +
			CreateExcelCell("String", "cell1", ttReport.bankInName) +
			CreateExcelCell("String", "cell1", ttReport.bankInStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientInName) +
			CreateExcelCell("String", "cell1", ttReport.clientInStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientInInn) +
			CreateExcelCell("String", "cell1", ttReport.clientInAcct) +
			CreateExcelCell("Number", "cell2", ttReport.docAmount) +
			CreateExcelCell("Number", "cell1", ttReport.docCurrency) +
			CreateExcelCell("Number", "cell2", ttReport.docAmountRUR) +
			CreateExcelCell("String", "cell1", ttReport.docOrigDetails) +
			CreateExcelCell("String", "cell1", ttReport.docDetails) +
			CreateExcelCell("String", "cell1", ttReport.codeVO)
		). 
		
		/** счетчик документов. нужен для формулы итога */
		cnt = cnt + 1.

	IF (LAST-OF(ttReport.ourClientID) AND divPage) OR 
	   (LAST(ttReport.ourClientID) AND NOT divPage) THEN DO:

		/** итоговая строка. суммируем колонку "сумма документа" */
		PUT UNFORMATTED CreateExcelRow(
			CreateExcelCellEx(17, "Number", "total1", "=SUM(R[-" + STRING(cnt) + "]C[0]:R[-1]C[0])", "0") +
			CreateExcelCellEx(19, "Number", "total1", "=SUM(R[-" + STRING(cnt) + "]C[0]:R[-1]C[0])", "0")
		). 
	
		PUT UNFORMATTED CloseExcelTag("Worksheet").
	END.

	END.
				
	PUT UNFORMATTED CloseExcelTag("Workbook").

OUTPUT CLOSE.

for each tmprecid no-lock:
	delete tmprecid.
end.

for each t_tmprecid no-lock:
	create tmprecid.
	tmprecid.id = t_tmprecid.t_id.
end.

if flag then do:
	MESSAGE "Данные экспортированы в файл " + fileName VIEW-AS ALERT-BOX.
end.
else do:
	MESSAGE "Данные по фильтру не найдены. Нужно изменить данные фильтрации" VIEW-AS ALERT-BOX.
end.
