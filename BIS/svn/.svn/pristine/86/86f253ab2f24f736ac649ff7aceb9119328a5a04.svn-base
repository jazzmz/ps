{pirsavelog.p}

/**	
 * Печать реестра взноса наличных через кассу на пластиковый счет
 * Бурягин Е.П.
 * 04.07.2006 15:59
 */
 
 DEFINE INPUT PARAMETER iParam AS CHAR NO-UNDO.
 
 /**
  * Программа получает в качестве параметра маску кодов транзакций. 
  * Обрабатывает, выбранные в броузере документы, отбирая те, что созданны
  * указанными транзакциями. 
  */	
 
/** Глобальные определения */
{globals.i} 

/** Библиотека работы с договорами, счетам и пр. */
{ulib.i} 

/** Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/** Строки отчета */
DEFINE TEMP-TABLE tt-report
	FIELD clientNameStr AS CHAR
	FIELD clientName AS CHAR EXTENT 5
	FIELD loanNo AS CHAR
	FIELD currency AS CHAR
	FIELD summa AS DECIMAL
	INDEX client clientNameStr ASCENDING.

DEF VAR i AS INTEGER.
DEF VAR repDate AS DATE.
DEF VAR monthList AS CHAR EXTENT 12.
ASSIGN 
	monthList[1] = "января"
	monthList[2] = "февраля"
	monthList[3] = "марта"
	monthList[4] = "апреля"
	monthList[5] = "мая"
	monthList[6] = "июня"
	monthList[7] = "июля"
	monthList[8] = "августа"
	monthList[9] = "сентября"
	monthList[10] = "октября"
	monthList[11] = "ноября"
	monthList[12] = "декабря".
	
/** Дата распоряжения */
repDate = TODAY.
FOR FIRST tmprecid NO-LOCK,
	  FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK
:
	repDate = op.op-date.
END.

/** 
 * Для всех выделенных записей, отбираем документы созданные транзакциями 
 * из параметра iParam и с корреспонденцией 20202* - 408*.
 */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE 
    	RECID(op) = tmprecid.id 
    	AND
    	CAN-DO(iParam, op.op-kind)
    	NO-LOCK,
    FIRST op-entry OF op NO-LOCK
:
		/** Если корреспонденция счетов соответствует 20202* - 408*, то */
		IF op-entry.acct-db BEGINS "20202" AND op-entry.acct-cr BEGINS "408" THEN DO:
			/** Найдем договор */
			FIND FIRST loan-acct WHERE 
				loan-acct.acct = op-entry.acct-cr
				AND
				loan-acct.contract = "Депоз"
				AND
				loan-acct.acct-type = "ДепСейфПлКрт"
				NO-LOCK NO-ERROR.
			IF AVAIL loan-acct THEN DO:
				FIND FIRST loan WHERE
					loan.contract = loan-acct.contract
					AND
					loan.cont-code = loan-acct.cont-code
					NO-LOCK NO-ERROR.
				IF AVAIL loan THEN DO:
						CREATE tt-report.
						ASSIGN
							tt-report.loanNo = GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "SafePlastLNum","")
							tt-report.summa = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur)
							tt-report.currency = op-entry.currency
							tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE)
							tt-report.clientNameStr = tt-report.clientName[1].
						/** Кое-какие действия по форматированию */
						{wordwrap.i &s=tt-report.clientName &l=20 &n=5}
				END.
			END.
		END.    
END.

/** Вывод отчета в preview */

{get-bankname.i}

{setdest.i}

/** Шапка */
/*PUT UNFORMATTED SPACE(70) "В Управление Пластиковых Карт" SKIP
                SPACE(70) cBankName SKIP(3)
                SPACE(35) 'РАСПОРЯЖЕНИЕ' SKIP
                SPACE(20) 'О СПИСАНИИ ДОПОЛНИТЕЛЬНЫХ ДЕНЕЖНЫХ СРЕДСТВ' SKIP
                SPACE(18) 'ЗА АРЕНДУ СЕЙФА ПОСЛЕ ЗАЯВЛЕННОГО СРОКА АРЕНДЫ' SKIP 
                SPACE(32) '"' STRING(DAY(repDate),"99") '" ' monthList[MONTH(repDate)] ' ' STRING(YEAR(repDate)) ' г.' SKIP(3).
*/
/** Заголовки */
PUT UNFORMATTED 
	 	"┌────────────────────┬────────────┬────────────┬───────────────────┐" SKIP
		"│Ф.И.О.              │Валюта      │№           │Сумма              │" SKIP
		"│                    │пополнения  │дог         │                   │" SKIP
	 	"├────────────────────┼────────────┼────────────┼───────────────────┤" SKIP.

/** Тело */
FOR EACH tt-report :
	PUT UNFORMATTED
	 "│" tt-report.clientName[1] FORMAT "x(20)"
	 "│" tt-report.currency FORMAT "x(12)"
	 "│" tt-report.loanNo FORMAT "x(12)"
   "│" tt-report.summa FORMAT "->>>,>>>,>>>,>>9.99"
   "│" SKIP.
  DO i = 2 TO 5 :
  	IF tt-report.clientName[i] <> "" THEN
			PUT UNFORMATTED
	 			"│" tt-report.clientName[i] FORMAT "x(20)"
		 		"│" SPACE(12)
		 		"│" SPACE(12)
   			"│" SPACE(19)
   			"│" SKIP.
  END.
	PUT UNFORMATTED
	 	"├────────────────────┼────────────┼────────────┼───────────────────┤" SKIP.

END.
/** Итоги */
	PUT UNFORMATTED
		"└────────────────────┴────────────┴────────────┴───────────────────┘" SKIP.

/** Подвал */
/*
PUT UNFORMATTED
	SPACE(5) 'Зам. Председателя правления Начальник Д' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP(3)
	SPACE(5) 'Ответственный сотрудник (исполнитель) отдела' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP.
*/	
{preview.i}
 