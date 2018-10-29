/* ------------------------------------------------------
     File: $RCSfile: pir_leg_anal_601.p,v $ $Revision: 1.1 $ $Date: 2008-02-20 13:50:08 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Экспортирует данные в файл в формате XML:Excel для анализа 601 формы
     Как работает: Запрашивает у пользователя дату (далее - Текущая дата). Обрабатывает 
                   данные с начала года, которому соответствует Текущая дата, до последнего 
                   месяца, дата окончания которого меньше или равна Текущей дате. Собирает 
                   информацию во временную таблицу. После сбора информация экспортируется в
                   файл. В конце работы на экран выдается сообщение с именем файла, куда 
                   был произведен экспорт.
     Параметры: 
     Место запуска: Меню печати класса данных f601t
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */


/** Дополнительное описание процедуры

Структура отчета довольно сложная. Стоит отметить, что она не соответствует реляционной модели.
Из этого следует, что реализация процедуры требует двойной ясности, в целях простоты сопровождения.
Подход при разработке следующий:
	1. данные собираются во временную таблицу, которая содержит поля-массивы. Таких полей 8. 
	   Размерность всех массивов одинакова и равна 13. 12 - данные по месяцам Текущего года, 13 - данные за 
	   декабрь прошлого года.
	2. всего записей в таблице будет 4. Каждая запись имеет id = {1,2,3,4}. По id будем искать нужную запись. Все 
	   записи заранее создаются до процесса заполнения временной таблицы.
*/

{globals.i}

/** Функции для работы с форматом XML:Excel */
{uxelib.i}

/** 0. Определения */

DEFINE TEMP-TABLE ttReport
	FIELD id AS INTEGER
	FIELD buyUSD AS DECIMAL EXTENT 13
	FIELD buyUSD_RUR AS DECIMAL EXTENT 13
	FIELD buyEUR AS DECIMAL EXTENT 13
	FIELD buyEUR_RUR AS DECIMAL EXTENT 13
	FIELD saleUSD AS DECIMAL EXTENT 13
	FIELD saleUSD_RUR AS DECIMAL EXTENT 13
	FIELD saleEUR AS DECIMAL EXTENT 13
	FIELD saleEUR_RUR AS DECIMAL EXTENT 13
	.
	
DEF VAR fileName AS CHAR. /** Имя файла для экспорта */	
DEF VAR periodBegin AS DATE.
DEF VAR periodEnd AS DATE.	
DEF VAR i AS INTEGER.
DEF VAR xmlCode AS CHAR.
DEF VAR xmlCodeTmpl AS CHAR EXTENT 10.

fileName = "/home/bis/quit41d/imp-exp/users/" + LC(USERID) + "/leg_anal_601.xml".

{getdate.i}

/** Сразу захватываем декабрь прошлого года */
periodBegin = DATE(12, 01, YEAR(end-date) - 1).
periodEnd = end-date.

/** Подготавливаем временную таблицу */
CREATE ttReport. ttReport.id = 1.
CREATE ttReport. ttReport.id = 2.
CREATE ttReport. ttReport.id = 3.
CREATE ttReport. ttReport.id = 4.

/** 1. Сбор данных */
FOR EACH DataBlock WHERE
    DataBlock.DataClass-Id = "f601t"
    AND
    DataBlock.beg-date >= periodBegin
    AND
    DataBlock.end-date <= periodEnd
    NO-LOCK,
    EACH DataLine OF DataBlock NO-LOCK
  :
  	
  	/** Теперь проверяем каждую строку блока данных. */
  	
  	/** Найдем индекс месяца. Далее будем использовать его как индек массивов */
  	IF YEAR(DataBlock.beg-date) = YEAR(periodBegin) THEN
  		i = 13.
  	ELSE 
  		i = MONTH(DataBlock.beg-date).
  	
  	/** Купленно банком */
  	IF CAN-DO("2.0,3.0", DataLine.sym1) THEN DO:
  		IF DataLine.sym2 = "840" THEN	DO:
		  		FIND FIRST ttReport WHERE ttReport.id = 1.
  				ttReport.buyUSD[i] = ttReport.buyUSD[i] + DataLine.val[1].
  				ttReport.buyUSD_RUR[i] = ttReport.buyUSD_RUR[i] + DataLine.val[3].
  		END.
  		IF DataLine.sym2 = "978" THEN DO:
		  		FIND FIRST ttReport WHERE ttReport.id = 2.
  				ttReport.buyEUR[i] = ttReport.buyEUR[i] + DataLine.val[1].
  				ttReport.buyEUR_RUR[i] = ttReport.buyEUR_RUR[i] + DataLine.val[3].
  		END.
  	END.
  	
  	/** Проданно банком */
  	IF CAN-DO("4.0,5.0", DataLine.sym1) THEN DO:
  		IF DataLine.sym2 = "840" THEN	DO:
  				FIND FIRST ttReport WHERE ttReport.id = 3.
	 				ttReport.saleUSD[i] = ttReport.saleUSD[i] + DataLine.val[1].
  				ttReport.saleUSD_RUR[i] = ttReport.saleUSD_RUR[i] + DataLine.val[3].
  		END.
  		IF DataLine.sym2 = "978" THEN DO:
		  		FIND FIRST ttReport WHERE ttReport.id = 4.
  				ttReport.saleEUR[i] = ttReport.saleEUR[i] + DataLine.val[1].
  				ttReport.saleEUR_RUR[i] = ttReport.saleEUR_RUR[i] + DataLine.val[3].
  		END.
  	END.
END.

/** 2. Экспорт */

OUTPUT TO VALUE(fileName).

PUT UNFORMATTED CreateExcelWorkbook(
									CreateExcelStyle("Center", "Center", 2, "t1") +
				          CreateExcelStyle("Right", "Center", 1, "c1")
								).

PUT UNFORMATTED CreateExcelWorksheet("Анализ 601").

/** Задаем ширину столбцов. Первые три задаем индивидуально, остальные в цикле */
PUT UNFORMATTED SetExcelColumnWidth(1,50) +	SetExcelColumnWidth(2,50)	+	SetExcelColumnWidth(3,50).
DO i = 1 TO 48:
	PUT UNFORMATTED SetExcelColumnWidth(3 + i, 60).
END.

/** Заголовок */						
PUT UNFORMATTED	CreateExcelRow( CreateExcelCell("String", "", "Анализ отчетности по форме N0409601") ) +
								CreateExcelRow( CreateExcelCell("String", "", STRING(YEAR(periodEnd), ">>>>") + "г.    тыс.руб.    данные отчетной Ф.0409601") ).

/** Названия столбцов */							
PUT UNFORMATTED	CreateExcelRow(
									CreateExcelCellEx2(0, 2, 0, "String", "t1", "", "Данные по") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Янв") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Янв/Дек " + STRING(YEAR(periodEnd) - 1) + "г., %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Фев") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Фев/Янв, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Март") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Март/Фев, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Апр") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Апр/Март, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Май") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Май/Апр, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Июнь") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Июнь/Май, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Июль") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Июль/Июнь, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Авг") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Авг/Июль, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Сент") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Сень/Авг, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Окт") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Окт/Сент, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Нояб") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Нояб/Сент, %") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Дек") +
									CreateExcelCellEx2(0, 1, 0, "String", "t1", "", "Дек/Нояб, %")
								).
								
/** Такой заголовок будет повторно использован, поэтому сохраним его */
xmlCodeTmpl[1] = CreateExcelCell("String", "t1", "Номер п/п") +
          			 CreateExcelCell("String", "t1", "Код валюты") +
          			 CreateExcelCell("String", "t1", "Наименование валюты").
          			 
xmlCodeTmpl[2] = CreateExcelCell("String", "t1", "1") +
          			 CreateExcelCell("String", "t1", "2") +
          			 CreateExcelCell("String", "t1", "3").
          			 
xmlCodeTmpl[3] = CreateExcelCell("String", "t1", "1") +
          			 CreateExcelCell("String", "t1", "840") +
          			 CreateExcelCell("String", "t1", "Доллар США").
          			 
xmlCodeTmpl[4] = CreateExcelCell("String", "t1", "2") +
          			 CreateExcelCell("String", "t1", "978") +
          			 CreateExcelCell("String", "t1", "Евро").

DO i = 1 TO 24:
	xmlCodeTmpl[5] = xmlCodeTmpl[5] +
	                 CreateExcelCell("String", "t1", "Куплено банком") +
	          			 CreateExcelCell("String", "t1", "Уплачено банком").
	          				
	xmlCodeTmpl[6] = xmlCodeTmpl[6] +
	                 CreateExcelCell("String", "t1", "тыс. ед. ивалют") +
	          			 CreateExcelCell("String", "t1", "тыс. руб.").
	
	xmlCodeTmpl[7] = xmlCodeTmpl[7] +
	                 CreateExcelCell("String", "t1", "Продано банком") +
	          			 CreateExcelCell("String", "t1", "Получено банком").

	xmlCodeTmpl[8] = xmlCodeTmpl[8] +
	                 CreateExcelCell("String", "c1", "X") +
	                 CreateExcelCellEx(0, "Number", "c1", "=SUM(R[-2]C[0]:R[-1]C[0])", "0").
END.


/** Выводим построчно */
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[1] + xmlCodeTmpl[5]).
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[2] + xmlCodeTmpl[6]).

{pir_leg_anal_601.i &id=1 &type=buy &cur=USD}
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[3] + xmlCode).

{pir_leg_anal_601.i &id=2 &type=buy &cur=EUR}
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[4] + xmlCode).

PUT UNFORMATTED CreateExcelRow(
									CreateExcelCellEx(3, "String", "t1", "", "Итого") +
									xmlCodeTmpl[8]
								).
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[1] + xmlCodeTmpl[7]).
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[2] + xmlCodeTmpl[6]).

{pir_leg_anal_601.i &id=3 &type=sale &cur=USD}
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[3] + xmlCode).

{pir_leg_anal_601.i &id=4 &type=sale &cur=EUR}
PUT UNFORMATTED CreateExcelRow(xmlCodeTmpl[4] + xmlCode).

PUT UNFORMATTED CreateExcelRow(
									CreateExcelCellEx(3, "String", "t1", "", "Итого") +
									xmlCodeTmpl[8]
								).


PUT UNFORMATTED CloseExcelTag("Worksheet").
PUT UNFORMATTED CloseExcelTag("Workbook").    

OUTPUT CLOSE.

MESSAGE "Данные экспортированы в файл " + fileName VIEW-AS ALERT-BOX.