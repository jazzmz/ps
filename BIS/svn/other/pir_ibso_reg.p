{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pir_ibso_reg.p,v $ $Revision: 1.5 $ $Date: 2008-04-08 05:41:22 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: ТЗ от 05.07.2007
     Что делает: Формирует Реестр недополученного дохода по ИБС
     Как работает: Запрашивает у пользователя дату отчета. Выбирает все незакрытые договора,
                   дата окончания которых меньше введенной даты. При этом, статус договора не имеет значения.
                   В процессе обработки договоров заполняется временная таблица, которая после используется 
                   для формироваия результирующего отчета.
     Параметры: Через запятую: 1) Код пользователя контролера
                               2) код пользователя исполнителя 
     Место запуска: Запускается из модуля АХД -> Печать 
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.4  2008/04/08 05:36:46  Buryagin
     Изменения: undo the last fix
     Изменения:
     Изменения: Revision 1.2  2007/10/18 07:42:21  anisimov
     Изменения: no message
     Изменения:
     Изменения: Revision 1.1  2007/07/19 09:31:36  buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */


/** Параметры */
DEF INPUT PARAM iParam AS CHAR.

/** Таблица отчета */
DEFINE TEMP-TABLE ttReport  NO-UNDO
	FIELD id AS INTEGER
	FIELD acct AS CHAR
	FIELD agreeInfo AS CHAR EXTENT 3
	FIELD endDate AS DATE
	FIELD amtPrevPer AS DECIMAL
	FIELD amtKvart AS DECIMAL EXTENT 4
	/** Следующие поля не выводятся на печать, но используются в служебных целях */
	FIELD lastAmount AS DECIMAL /** Сумма аренды за последний срок с учетом НДС */
	FIELD amountForDay AS DECIMAL /** Сумма аренды без НДС за 1 день */
	INDEX id id.
		

/** Функция вычисления суммы аренды за период */
FUNCTION GetAmountForPeriod RETURNS DECIMAL (INPUT condEndDate AS DATE,
                                        INPUT periodBegDate AS DATE,
                                        INPUT periodEndDate AS DATE,
                                        INPUT amtForDay AS DECIMAL).
                                        
	
	/** Если договор закончился в текущем периоде, то расчет ведем от даты окончания договора */
	IF condEndDate > periodBegDate THEN periodBegDate = condEndDate + 1.
	
	/** Нужно вернуть неотрицательное значение */
	RETURN MAX(amtForDay * (periodEndDate - periodBegDate + 1), 0).
	
	                                        
END FUNCTION.

/** Глобальные определения */
{globals.i}

/** Мои процеДурки */
/** подключение "inrtface.get date" уже осуществлено в ulib.i */
{ulib.i}

/** Перенос по словам */
{wordwrap.def}


/** Итератор */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR repDate AS DATE NO-UNDO.
/** Сумма аренды с учетом НДС по последнему условию договора */
DEF VAR amount AS DECIMAL NO-UNDO.
/** Сумма аредны за один день по последнему условию */
DEF VAR amountDay AS DECIMAL NO-UNDO.

/** Даты, которые используются для расчета сумм по кварталам */
DEF VAR begPeriod AS DATE NO-UNDO.
DEF VAR endPeriod AS DATE NO-UNDO.
DEF VAR days AS DATE NO-UNDO.

DEF VAR totalPrevPer AS DECIMAL NO-UNDO.
DEF VAR totalCurrPer AS DECIMAL NO-UNDO.
DEF VAR totalKvart AS DECIMAL EXTENT 4 NO-UNDO.

/** Наименование нашего банка */
DEF VAR bankName AS CHAR NO-UNDO.
DEF VAR bankSity AS CHAR NO-UNDO.

DEF VAR ctrlName AS CHAR NO-UNDO.
DEF VAR ctrlPost AS CHAR NO-UNDO.
DEF VAR execName AS CHAR NO-UNDO.
DEF VAR execPost AS CHAR NO-UNDO.

/** Проверка входных параметров */
IF NUM-ENTRIES(iParam) < 1 THEN DO:
	MESSAGE "Параметры процедуры заданы неверно! Смотри описание (F1)." VIEW-AS ALERT-BOX.
	RETURN.
END.

/** Запрашиваем у пользователя дату отчета */
{getdate.i}
repDate = end-date.
{get-bankname.i}
bankName = cBankName.
bankSity = FGetSetting("БанкГород", "", "").

i = 1.

/** Выборка договоров АХД ИБС */
FOR EACH loan WHERE 
			loan.contract = "АХД" 
			AND 
			loan.cont-type = "001"
			AND
			loan.close-date = ?
			AND 
			loan.end-date < repDate
			NO-LOCK,
			
		LAST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK
			
	:
			/** Новая запись в отчет */
			CREATE ttReport.
			ttReport.id = i.
			ttReport.acct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "АХДБудДох", repDate, false).
			
			ttReport.agreeInfo[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code,"client_name", false) 
					+ " Дог. " + loan.doc-num + " от " + STRING(loan.open-date, "99.99.9999").
			{wordwrap.i	 &s=ttReport.agreeInfo &l=30 &n=3}		
			
			ttReport.endDate = loan.end-date.
			
			/** Расчитаем сумму за аренду за один день с вычетом НДС */
			amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, repDate, false).
			amount = amount - amount * GetCommRate_ULL("НДСвтч", "", 0, "", 0, repDate, false).
			amountDay = amount / (loan.end-date - loan-cond.since + 1).
			
			ttReport.lastAmount = amount.
			ttReport.amountForDay = amountDay.
			
			/** Начало текущего месяца */
			begPeriod = kvart_beg(repDate).
			/** Конец текущего месяца */
			endPeriod = kvart_end(repDate).

			/** Расчитаем суммы для всех периодов */
			DO WHILE YEAR(repDate) = YEAR(endPeriod) :
				
				ttReport.amtKvart[ INT(MONTH(endPeriod) / 3) ] = GetAmountForPeriod(loan.end-date, begPeriod, endPeriod, ttReport.amountForDay).
				
				endPeriod = begPeriod - 1.
				begPeriod = kvart_beg(endPeriod).
				
			END.
			
			/** На начало текущего налогового периода (что-то вроде за прошедший наловый период) */
			ttReport.amtPrevPer = GetAmountForPeriod(loan.end-date, loan.end-date + 1, endPeriod, ttReport.amountForDay).
			
			i = i + 1.
END.

/** Вывод в PreView */
{setdest.i}

/** Шапка отчета */

PUT UNFORMATTED 
   SPACE(145) "Приложение 26 к УП" SKIP
   bankName SKIP
   bankSity SKIP(1)
   SPACE(10) "Регистр недополученного дохода по индивидуальным ячейкам на " STRING(repDate, "99.99.9999") " (конец отчетного периода)" SKIP(1)
   "Единица измерения: руб." SKIP
   "┌────┬─────────────────────────┬──────────────────────────────┬──────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┐" SKIP
	 "│№ пп│Основание/номер счета БУ │ФИО клиента, номер и дата     │Уплачено  │Сумма долга   │Сумма долга   │Сумма долга   │Сумма долга   │Сумма долга   │Сумма долга   │" SKIP
	 "│    │61304                    │договора                      │до        │на начало     │за I квартал  │за II квартал │за III квартал│за IV квартал │за текущий    │" SKIP
	 "│    │                         │                              │          │текущего нал. │              │              │              │              │налоговый     │" SKIP
	 "│    │                         │                              │          │периода       │              │              │              │              │период        │" SKIP
	 "├────┼─────────────────────────┼──────────────────────────────┼──────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┤" SKIP.        	

/** Тело отчета */
FOR EACH ttReport :
	
	DO i = 1 TO 4 :
		totalKvart[i] = totalKvart[i] + ttReport.amtKvart[i].
	END.
	totalCurrPer = totalCurrPer + ttReport.amtKvart[1] + ttReport.amtKvart[2] + ttReport.amtKvart[3] + ttReport.amtKvart[4].
	totalPrevPer = totalPrevPer + ttReport.amtPrevPer.
	
	
	PUT UNFORMATTED "│"
			ttReport.id FORMAT ">>>>" "│"
			ttReport.acct FORMAT "x(25)" "│"
	    ttReport.agreeInfo[1] FORMAT "x(30)" "│"
	    ttReport.endDate FORMAT "99/99/9999" "│"
	    ttReport.amtPrevPer FORMAT ">>>,>>>,>>9.99" "│"
	    ttReport.amtKvart[1] FORMAT ">>>,>>>,>>9.99" "│"
	    ttReport.amtKvart[2] FORMAT ">>>,>>>,>>9.99" "│"
	    ttReport.amtKvart[3] FORMAT ">>>,>>>,>>9.99" "│"
	    ttReport.amtKvart[4] FORMAT ">>>,>>>,>>9.99" "│"
	    
	    (ttReport.amtKvart[1] + ttReport.amtKvart[2] + ttReport.amtKvart[3] + ttReport.amtKvart[4]) FORMAT ">>>,>>>,>>9.99" "│"
	    
	    /**
	    ttReport.lastAmount FORMAT ">>>,>>>,>>9.99" "!"
	    ttReport.amountForDay FORMAT ">>>,>>>,>>9.99" "!"
	    */
	    SKIP.
	    
	DO i = 2 TO 3 :
		IF ttReport.agreeInfo[i] <> "" THEN DO:
			PUT UNFORMATTED "│"
			SPACE(4) "│"
			SPACE(25) "│"
	    ttReport.agreeInfo[i] FORMAT "x(30)" "│"
	    SPACE(10) "│"
	    SPACE(14) "│"
	    SPACE(14) "│"
	    SPACE(14) "│"
	    SPACE(14) "│"
	    SPACE(14) "│"
 			SPACE(14) "│"
	    SKIP.
			
		END.
	END. 

END.

/** Итоги */

FIND FIRST _user WHERE (_user._userid = ENTRY(1,iParam)) NO-LOCK NO-ERROR.
IF AVAIL _user THEN DO:
	execName = _user._user-name.
	execPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
END.


PUT UNFORMATTED 
   "├────┼─────────────────────────┼──────────────────────────────┼──────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┤" SKIP
   "│    │                         │ИТОГО:                        │          │"
   totalPrevPer FORMAT ">>>,>>>,>>9.99" "│"
   totalKvart[1] FORMAT ">>>,>>>,>>9.99" "│"
   totalKvart[2] FORMAT ">>>,>>>,>>9.99" "│"
   totalKvart[3] FORMAT ">>>,>>>,>>9.99" "│"
   totalKvart[4] FORMAT ">>>,>>>,>>9.99" "│"
   totalCurrPer FORMAT ">>>,>>>,>>9.99" "│" SKIP
   "└────┴─────────────────────────┴──────────────────────────────┴──────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┘" SKIP(2)
   "Ответственный исполнитель:                                                   " execName SKIP
   "Дата: " STRING(repDate, "99.99.9999") SKIP(2).
   IF NUM-ENTRIES(iParam) >= 2 THEN DO:
			FIND FIRST _user WHERE (_user._userid = ENTRY(2,iParam)) NO-LOCK NO-ERROR.
			IF AVAIL _user THEN DO:
				ctrlName = _user._user-name.
				ctrlPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
			END.
   		PUT UNFORMATTED
   			"Контролер " STRING(ctrlPost + ":", "x(67)") ctrlName SKIP.
	 END.

{preview.i}