/* ------------------------------------------------------
     File: $RCSfile: pir_leg_anal_202.p,v $ $Revision: 1.3 $ $Date: 2008-04-15 10:47:56 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Экспортирует данные в формате XML:Excel для анализа формы 202
     Как работает: Запрашивает у пользователя дату.
     							 Для всех месячных блоков данных класса f20x, существующих 
                   от начала года, заданного датой, до текущей даты.
                   Выбирает все значения сумм оборотов по символам и для каждого месяца
                   сохраняет их во временную таблицу. Значение суммы оборота по конкретному месяцу
                   года можно найти по индексу поля ttReport.val. Индекс соответствует номеру месяца.
                   Например, val[1] - январские обороты, val[2] - февральские, 
                   а val[13] - Декабрьские обороты прошлого года.
     Параметры: 
     Место запуска: Меню печати класса f20x
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2008/04/10 15:27:45  Buryagin
     Изменения: Update the searching of cash symbol in the "code" DB-table
     Изменения:
     Изменения: Revision 1.1  2008/02/20 13:50:08  Buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */

{globals.i}

/** Функции для создания XML:Excel файлов */
{uxelib.i}

DEFINE TEMP-TABLE ttReport
	FIELD symbol AS CHAR
	FIELD side AS CHAR
	FIELD val AS DECIMAL EXTENT 13
	INDEX defidx side symbol 
	.

DEF VAR periodBegin AS DATE.
DEF VAR periodEnd AS DATE.	
DEF VAR fileName AS CHAR.
DEF VAR i AS INTEGER.
DEF VAR xmlCode AS CHAR.

fileName = "/home/bis/quit41d/imp-exp/users/" + lc(userid) + "/leg_anal_202.xml".

{getdate.i}

periodBegin = DATE(12, 01, YEAR(end-date) - 1).
periodEnd = end-date.

/** Сбор данных */
FOR EACH DataBlock WHERE
    DataBlock.DataClass-Id = "f202t"
    AND
    DataBlock.beg-date >= periodBegin
    AND
    DataBlock.end-date <= periodEnd
    AND
    DataBlock.beg-date <> DataBlock.end-date
    NO-LOCK,
    EACH DataLine OF DataBlock NO-LOCK
  :
  	FIND FIRST ttReport WHERE symbol = DataLine.sym1 NO-LOCK NO-ERROR.
  	
  	/** Если в отчете еще нет символа */
  	IF NOT AVAIL ttReport THEN
  		DO:
  			FIND FIRST code WHERE
  			  code.class = "КасСимволы"
  			  AND
  			  code.code = DataLine.sym1 NO-LOCK NO-ERROR.
  			IF NOT AVAIL code THEN DO: 
  			  MESSAGE "Кассовый символ " + DataLine.sym1 + " не найден в классификаторе КасСимволы!" VIEW-AS ALERT-BOX.
  			  RETURN.
  			END.
  			/** создать запись о символе */
  			CREATE ttReport.
  			ttReport.symbol = TRIM(code.code).
  			ttReport.side = code.val.
  		END.
  		
  	IF YEAR(DataBlock.beg-date) < YEAR(periodEnd) THEN
  		ttReport.val[13] = DataLine.val[1].
  	ELSE
  		ttReport.val[ MONTH(DataBlock.beg-date) ] = DataLine.val[1].
END.

/** Экспорт в файл */

OUTPUT TO VALUE(fileName).

PUT UNFORMATTED CreateExcelWorkbook(
									CreateExcelStyle("Center", "Center", 2, "t1") +
				          CreateExcelStyle("Right", "Center", 1, "c1")
								).

PUT UNFORMATTED CreateExcelWorksheet("Анализ 202").

PUT UNFORMATTED SetExcelColumnWidth(1,50) +	SetExcelColumnWidth(2,50)	+	SetExcelColumnWidth(3,50) +
								SetExcelColumnWidth(4,50)	+	SetExcelColumnWidth(5,50)	+ SetExcelColumnWidth(6,50) +
								SetExcelColumnWidth(7,50)	+ SetExcelColumnWidth(8,50) +	SetExcelColumnWidth(9,50) +
								SetExcelColumnWidth(10,50) + SetExcelColumnWidth(11,50) +	SetExcelColumnWidth(12,50) +
								SetExcelColumnWidth(13,50) + SetExcelColumnWidth(14,50) +	SetExcelColumnWidth(15,50) +
								SetExcelColumnWidth(16,50) + SetExcelColumnWidth(17,50) +	SetExcelColumnWidth(18,50) +
								SetExcelColumnWidth(19,50) + SetExcelColumnWidth(20,50)	+	SetExcelColumnWidth(21,50) +
								SetExcelColumnWidth(22,50) + SetExcelColumnWidth(23,50) +	SetExcelColumnWidth(24,50) +
								
								CreateExcelRow( CreateExcelCell("String", "", "Анализ отчетности по форме N0409202") ) +
								CreateExcelRow( CreateExcelCell("String", "", STRING(YEAR(periodEnd), ">>>>") + "г.    тыс.руб.    данные отчетной Ф.0409202") ) +
								CreateExcelRow(
									CreateExcelCell("String", "t1", "Символ") +
									CreateExcelCell("String", "t1", "Янв") +
									CreateExcelCell("String", "t1", "Янв/Дек " + STRING(YEAR(periodEnd) - 1) + "г., %") +
									CreateExcelCell("String", "t1", "Фев") +
									CreateExcelCell("String", "t1", "Фев/Янв, %") +
									CreateExcelCell("String", "t1", "Март") +
									CreateExcelCell("String", "t1", "Март/Фев, %") +
									CreateExcelCell("String", "t1", "Апр") +
									CreateExcelCell("String", "t1", "Апр/Март, %") +
									CreateExcelCell("String", "t1", "Май") +
									CreateExcelCell("String", "t1", "Май/Апр, %") +
									CreateExcelCell("String", "t1", "Июнь, %") +
									CreateExcelCell("String", "t1", "Июнь/Май, %") +
									CreateExcelCell("String", "t1", "Июль, %") +
									CreateExcelCell("String", "t1", "Июль/Июнь, %") +
									CreateExcelCell("String", "t1", "Авг, %") +
									CreateExcelCell("String", "t1", "Авг/Июль, %") +
									CreateExcelCell("String", "t1", "Сент, %") +
									CreateExcelCell("String", "t1", "Сент/Авг, %") +
									CreateExcelCell("String", "t1", "Окт, %") +
									CreateExcelCell("String", "t1", "Окт/Сент, %") +
									CreateExcelCell("String", "t1", "Нояб, %") +
									CreateExcelCell("String", "t1", "Нояб/Окт, %") +
									CreateExcelCell("String", "t1", "Дек, %") +
									CreateExcelCell("String", "t1", "Дек/Нояб, %")
								).	


FOR EACH ttReport USE-INDEX defidx NO-LOCK BREAK BY ttReport.side:
	
	IF FIRST-OF(ttReport.side) THEN 
		PUT UNFORMATTED CreateExcelRow( CreateExcelCell("String", "c1", ttReport.side) ).
	
	xmlCode = CreateExcelCell("String", "c1", ttReport.symbol).
	
	DO i = 1 TO 12:
		xmlCode = xmlCode + CreateExcelCell("Number", "c1", STRING(ttReport.val[i])).
		IF i = 1 THEN 
			xmlCode = xmlCode + CreateExcelCell("Number", "c1", STRING(ROUND(ttReport.val[i] / ttReport.val[13] * 100, 2))).
		ELSE
		  xmlCode = xmlCode + CreateExcelCell("Number", "c1", STRING(ROUND(ttReport.val[i] / ttReport.val[i - 1] * 100, 2))).
	END.

	PUT UNFORMATTED	CreateExcelRow( xmlCode ).
		
END.

PUT UNFORMATTED CloseExcelTag("Worksheet").
PUT UNFORMATTED CloseExcelTag("Workbook").    

OUTPUT CLOSE.

MESSAGE "Данные экспортированны в файл " + fileName VIEW-AS ALERT-BOX.