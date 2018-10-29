{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pir_credgraph.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: ТЗ от 23/03/2006 
     Что делает: Формирует график возвратов кредитов за период
     Как работает: Для всех выделенных в броузере договоров собирается информация, которая
                   сохраняется в двух временных таблицах. Временные таблицы имеют связь "Один ко многим"
                   через поля ttGraphMain.id - ttGraphPay.mainID. 
                   Таблица ttGraphPay заполняется большей частью значениями таблицы term-obl.
                   В term-obl записи, соответствующие оплате основного долга, в поле idnt имеют 
                   значение "3", а процентов - "1". Дата оплаты хранится в term-obl.end-date.
                   Заполнение таблицы ttGraphPay имеет особенность. Из-за "преобразования"
                   реляционной схемы данных, хранящихся в term-obl, в нереляционную схему таблицы ttGraphPay
                   приходится при переборе записей term-obl определять ряд условий создания или модификации 
                   записей ttGraphPay. Остальные комментарии по тексту программы.
                   После фазы сбора информации 
                   процедура формирует отчет, перебирая записи временных таблиц.
     Параметры: 
     Место запуска: Броузер кредитных договоров.
     Автор: $Author: anisimov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2007/07/19 09:31:12  buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */

/** Глобальные настройки */
{globals.i}

/** Мои процуДурки */
{ulib.i}

/** Перенос по словам */
{wordwrap.def}

/** Информация из броузера */
{tmprecid.def}


/** ОПРЕДЕЛЕНИЯ */


/** Главная таблица отчета */
DEFINE TEMP-TABLE ttGraphMain  NO-UNDO
	FIELD id AS INTEGER /** Идентификатор */
	FIELD clientName AS CHAR EXTENT 3 /** Наименование заемщика */
	FIELD loanNumber AS CHAR /** Номер договора */
	FIELD loanOpenDate AS DATE /** Дата открытия договора */
	.
	
/** Вспомогательная таблица отчета (подчиненная к главной 1..n) */	
DEFINE TEMP-TABLE ttGraphPay  NO-UNDO
	FIELD mainID AS INTEGER /** Внешний ключ */
	FIELD payDate AS DATE /** Дата платежа */
	FIELD currency AS CHAR /** Валюта */
	FIELD loanAmount AS DECIMAL /** Сумма платежа по основному долгу */
	FIELD persAmount AS DECIMAL /** Сумма платежа по процентам */
	.
	
DEF VAR currentID AS INTEGER NO-UNDO. /** Итератор */
DEF VAR tmpStr AS CHAR NO-UNDO. /** Для всяких нужд */
DEF VAR tmpI AS INTEGER NO-UNDO. /** Для всяких нужд */
DEF VAR i AS INTEGER NO-UNDO. /** Итератор... пригодится */


/** Решение с итогами плохое, но быстрое */
DEF VAR total810 AS DECIMAL EXTENT 2 NO-UNDO.
DEF VAR total840 AS DECIMAL EXTENT 2 NO-UNDO.
DEF VAR total978 AS DECIMAL EXTENT 2 NO-UNDO.


/** РЕАЛИЗАЦИЯ */


/** Запрос периода */
{getdates.i}

/** Фаза №1: сбор информации */

currentID = 1.
total810 = 0.
total840 = 0.
total978 = 0.

FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
  :
  	CREATE ttGraphMain.
  	ttGraphMain.id = currentID.
  	/** Получим наименование клиента и дату открытия договора */
  	tmpStr = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name,open_date", false).
  	ttGraphMain.clientName[1] = ENTRY(1, tmpStr).
  	
  	ttGraphMain.loanNumber = loan.cont-code.
  	ttGraphMain.loanOpenDate = DATE(ENTRY(2, tmpStr)).
  	
  	/** Найдем платежи */
  	FOR EACH term-obl WHERE term-obl.contract = loan.contract
  	                        AND 
  	                        term-obl.cont-code = loan.cont-code
  	                        AND (
  	                        	term-obl.idnt = 1
  	                        	OR
  	                        	term-obl.idnt = 3
  	                        )
  	                        AND
  	                     		term-obl.end-date GE beg-date
  	                     		AND
  	                     		term-obl.end-date LE end-date 
  	    USE-INDEX primary
  	    NO-LOCK
  		:
  			/** Поиск в ttGraphPay записи с датой, равной term-obl.end-date */
  			FIND FIRST ttGraphPay WHERE 
  						ttGraphPay.mainID = ttGraphMain.id 
  						AND
  						ttGraphPay.payDate = term-obl.end-date 
  						NO-LOCK NO-ERROR.
  						
  			IF NOT AVAIL ttGraphPay THEN 
  				DO:
  					CREATE ttGraphPay.
  					ttGraphPay.mainID = ttGraphMain.id.
  					ttGraphPay.payDate = term-obl.end-date.
  					ttGraphPay.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  				END.
				
				IF term-obl.idnt = 1 THEN DO: 
					ttGraphPay.persAmount = term-obl.amt-rub.
					IF ttGraphPay.currency = "810" THEN total810[2] = total810[2] + ttGraphPay.persAmount.
					IF ttGraphPay.currency = "840" THEN total840[2] = total840[2] + ttGraphPay.persAmount.
					IF ttGraphPay.currency = "978" THEN total978[2] = total978[2] + ttGraphPay.persAmount.
				END.
				IF term-obl.idnt = 3 THEN DO:
					ttGraphPay.loanAmount = term-obl.amt-rub. 
					IF ttGraphPay.currency = "810" THEN total810[1] = total810[1] + ttGraphPay.loanAmount.
					IF ttGraphPay.currency = "840" THEN total840[1] = total840[1] + ttGraphPay.loanAmount.
					IF ttGraphPay.currency = "978" THEN total978[1] = total978[1] + ttGraphPay.loanAmount.
				END.
  			
  	END.
  	
  	
  	/** следующий */
  	currentID = currentID + 1.
  	
END.

/** Фаза №2: вывод информации */
{setdest.i}

PUT UNFORMATTED "ГРАФИК ВОЗВРАТОВ КРЕДИТОВ" SKIP
                "в период с " STRING(beg-date, "99.99.9999") " по " STRING(end-date, "99.99.9999") SKIP(1).

PUT UNFORMATTED
	"┌────────────────────────────────────────┬─────────────────────┬──────────┬───┬─────────────────────────────────────┐" SKIP
	"│Наименование заемщика                   │Кредитный договор    │Дата      │Вал│            К погашению              │" SKIP
	"│                                        ├──────────┬──────────┤платежа   │   ├──────────────────┬──────────────────┤" SKIP
	"│                                        │Номер     │Дата      │          │   │Основной долг     │Проценты          │" SKIP
	"├────────────────────────────────────────┼──────────┼──────────┼──────────┼───┼──────────────────┼──────────────────┤" SKIP.
	

FOR EACH ttGraphMain NO-LOCK
	:
		/** Наименование клиента нужно перенести по словам */
		{wordwrap.i &s=ttGraphMain.clientName &l=40 &n=3}
		
		PUT UNFORMATTED 
			"│"
			ttGraphMain.clientName[1] FORMAT "x(40)" "│"
			ttGraphMain.loanNumber FORMAT "x(10)" "│"
			ttGraphMain.loanOpenDate FORMAT "99.99.9999" "│" 
			SPACE(10) "│"
			SPACE(3) "│"
			SPACE(18) "│"
			SPACE(18) "│"
			SKIP.
			
		/** Запомним, что первую строку наименования мы отпечатали */
		tmpI = 2.
		
		FOR EACH ttGraphPay WHERE ttGraphPay.mainID = ttGraphMain.id NO-LOCK
			:
				PUT UNFORMATTED 
					"│".
					
				IF (tmpI > 1 AND tmpI <= 3) THEN 
					PUT UNFORMATTED STRING(ttGraphMain.clientName[tmpI], "x(40)") "│".
				ELSE 
					PUT UNFORMATTED SPACE(40) "│".
				
				PUT UNFORMATTED	
					SPACE(10) "│"
					SPACE(10) "│"
					ttGraphPay.payDate FORMAT "99.99.9999" "│" 
					ttGraphPay.currency FORMAT "xxx" "│"
					ttGraphPay.loanAmount FORMAT ">>>,>>>,>>>,>>9.99" "│"
					ttGraphPay.persAmount FORMAT ">>>,>>>,>>>,>>9.99" "│" 
					SKIP.	
					
				tmpI = tmpI + 1.
		END.
		
		/** Добиваем строки clientName */
		DO i = tmpI TO 3 :
			IF ttGraphMain.clientName[i] <> "" THEN 
				PUT UNFORMATTED 
					"│"
					ttGraphMain.clientName[i] FORMAT "x(40)" "│"
					SPACE(10) "│"
					SPACE(10) "│" 
					SPACE(10) "│"
					SPACE(3)  "│"
					SPACE(18) "│"
					SPACE(18) "│"
					SKIP.
			
		END.
		
		PUT UNFORMATTED
			"├────────────────────────────────────────┼──────────┼──────────┼──────────┼───┼──────────────────┼──────────────────┤" SKIP.
			
END.

PUT UNFORMATTED
  "│                                        │          │          │Итого:    │810│" total810[1] FORMAT ">>>,>>>,>>>,>>9.99" "│" total810[2] FORMAT ">>>,>>>,>>>,>>9.99" "│" SKIP
  "│                                        │          │          │          │840│" total840[1] FORMAT ">>>,>>>,>>>,>>9.99" "│" total840[2] FORMAT ">>>,>>>,>>>,>>9.99" "│" SKIP
  "│                                        │          │          │          │978│" total978[1] FORMAT ">>>,>>>,>>>,>>9.99" "│" total978[2] FORMAT ">>>,>>>,>>>,>>9.99" "│" SKIP
  "└────────────────────────────────────────┴──────────┴──────────┴──────────┴───┴──────────────────┴──────────────────┘" SKIP.
{preview.i}