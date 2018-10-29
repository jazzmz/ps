{pirsavelog.p}

/**	
 * Печать распоряжения по оплате за дополнительный день аренды после заявленного срока.
 * Бурягин Е.П.
 * 27.03.2006 9:00
 */
 
 DEFINE INPUT PARAMETER iParam AS CHAR NO-UNDO.
 
 /**
  * Программа получает в качестве параметра маску кодов транзакций. 
  * Обрабатывает, выбранные в броузере документы, отбирая документы, созданные
  * указанными транзакциями. Таких документов будет 2*n, где n - кол-во договоров.
  * Первый документ - сумма комиссии за аренду за период. Второй - сумма НДС.
  * Нужно найти два связанных документа (здесь по счету дебета), сложить их суммы.
  * Сначала ищем документы с корреспонденцией 42309 - 70107. Затем ищем их "пары".
  * В этих документах берется счет по дебету, и в таблице loan-acct ищем договор 
  * contract="Депоз", которому принадлежит данный счет. Затем, находим сам договор.
  * Дальше все просто, выбираем, подставляем, выводим в preview.
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
	FIELD loanNo AS CHAR
	FIELD clientName AS CHAR EXTENT 5
	FIELD acctDb AS CHAR 
	FIELD acctCr AS CHAR
	FIELD summa AS DECIMAL
	FIELD nds AS DECIMAL
	FIELD details AS CHAR EXTENT 5
	
	INDEX loan loanNo ASCENDING.

/** Буферы таблиц для поиска "пары" проводки */
DEFINE BUFFER bfr-op FOR op.
DEFINE BUFFER bfr-op-entry FOR op-entry.

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR totalSumma AS DECIMAL NO-UNDO.
DEF VAR totalNds AS DECIMAL NO-UNDO.
DEF VAR repDate AS DATE NO-UNDO.
DEF VAR monthList AS CHAR EXTENT 12 NO-UNDO.
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
 * из параметра iParam и с корреспонденцией 42* - 701*.
 */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE 
    	RECID(op) = tmprecid.id 
    	AND
    	CAN-DO(iParam, op.op-kind)
    	NO-LOCK,
    FIRST op-entry OF op NO-LOCK,
    /** Это наша "пара" для проводки */
    FIRST bfr-op-entry WHERE
     	bfr-op-entry.acct-db = op-entry.acct-db
     	AND
     	bfr-op-entry.op <> op-entry.op
     	AND
     	bfr-op-entry.op-date = op-entry.op-date
     	NO-LOCK
:
		/** Если корреспонденция счетов соответствует 42* - 701*, то */
		IF op-entry.acct-db BEGINS "42" AND op-entry.acct-cr BEGINS "701" THEN DO:
			/** Найдем договор */
			FIND FIRST loan-acct WHERE 
				loan-acct.acct = op-entry.acct-db
				AND
				loan-acct.contract = "Депоз"
				AND
				loan-acct.acct-type = "ДепСейфНСОст"
				NO-LOCK NO-ERROR.
			IF AVAIL loan-acct THEN DO:
				FIND FIRST loan WHERE
					loan.contract = loan-acct.contract
					AND
					loan.cont-code = loan-acct.cont-code
					NO-LOCK NO-ERROR.
				IF AVAIL loan THEN DO:
					/** Найдем последнее на дату операции условие договора */
					FIND LAST loan-cond WHERE
						loan-cond.contract = loan.contract
						AND
						loan-cond.cont-code = loan.cont-code
						AND
						loan-cond.since LT op.op-date
						NO-LOCK NO-ERROR.
					IF AVAIL loan-cond THEN DO:
						/** Собраны все данные */
						/** Заполняем строку отчета */
						CREATE tt-report.
						ASSIGN
							tt-report.loanNo = loan.cont-code
							tt-report.acctDb = op-entry.acct-db
							tt-report.acctCr = op-entry.acct-cr
							tt-report.summa = op-entry.amt-rub + bfr-op-entry.amt-rub
							tt-report.nds = bfr-op-entry.amt-rub
							tt-report.details[1] = op.details.
						tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", FALSE).
						/** Кое-какие действия по форматированию */
						{wordwrap.i &s=tt-report.clientName &l=20 &n=5}
						{wordwrap.i &s=tt-report.details &l=30 &n=5}
					END.
				END.
			END.
		END.    
END.

/** Вывод отчета в preview */

{get-bankname.i}

{setdest.i}

/** Шапка */
PUT UNFORMATTED SPACE(70) "В Управление Пластиковых Карт" SKIP
                SPACE(70) cBankName SKIP(3)
                SPACE(35) 'РАСПОРЯЖЕНИЕ' SKIP
                SPACE(20) 'О СПИСАНИИ ДОПОЛНИТЕЛЬНЫХ ДЕНЕЖНЫХ СРЕДСТВ' SKIP
                SPACE(18) 'ЗА АРЕНДУ СЕЙФА ПОСЛЕ ЗАЯВЛЕННОГО СРОКА АРЕНДЫ' SKIP 
                SPACE(32) '"' STRING(DAY(repDate),"99") '" ' monthList[MONTH(repDate)] ' ' STRING(YEAR(repDate)) ' г.' SKIP(3).

/** Заголовки */
PUT UNFORMATTED 
	 	"┌──────────┬────────────────────┬────────────────────┬────────────────────┬───────────────────┬───────────┬──────────────────────────────┐" SKIP
		"│№         │Ф.И.О.              │Счет                │Счет                │Сумма списания     │НДС        │Назначение                    │" SKIP
		"│дог       │                    │дебета              │кредита             │с НДС              │           │платежа                       │" SKIP
	 	"├──────────┼────────────────────┼────────────────────┼────────────────────┼───────────────────┼───────────┼──────────────────────────────┤" SKIP.

/** Тело */
FOR EACH tt-report :
	PUT UNFORMATTED
	 "│" tt-report.loanNo FORMAT "x(10)"
	 "│" tt-report.clientName[1] FORMAT "x(20)"
   "│" tt-report.acctDb FORMAT "x(20)"
   "│" tt-report.acctCr FORMAT "x(20)"
   "│" tt-report.summa FORMAT "->>>,>>>,>>>,>>9.99"
   "│" tt-report.nds FORMAT "->>>,>>9.99"
   "│" tt-report.details[1] FORMAT "x(30)" 
   "│" SKIP.
  DO i = 2 TO 5 :
  	IF tt-report.clientName[i] <> "" OR tt-report.details[i] <> "" THEN
			PUT UNFORMATTED
		 		"│" SPACE(10)
	 			"│" tt-report.clientName[i] FORMAT "x(20)"
		   	"│" SPACE(20)
   			"│" SPACE(20)
   			"│" SPACE(19)
   			"│" SPACE(11)
   			"│" tt-report.details[i] FORMAT "x(30)" 
   			"│" SKIP.
  END.
	PUT UNFORMATTED
	 	"├──────────┼────────────────────┼────────────────────┼────────────────────┼───────────────────┼───────────┼──────────────────────────────┤" SKIP.
	ASSIGN 
		totalSumma = totalSumma + tt-report.summa
		totalNds = totalNds + tt-report.nds.

END.
/** Итоги */
	PUT UNFORMATTED
 		"│ ИТОГО    " 
		"│" SPACE(20)
   	"│" SPACE(20)
		"│" SPACE(20)
		"│" totalSumma FORMAT "->>>,>>>,>>>,>>9.99"
		"│" totalNds FORMAT "->>>,>>9.99"
		"│" SPACE(30)
		"│" SKIP
	 	"└──────────┴────────────────────┴────────────────────┴────────────────────┴───────────────────┴───────────┴──────────────────────────────┘" SKIP(2).

/** Подвал */
PUT UNFORMATTED
	SPACE(5) 'Зам. Председателя правления Начальник Д' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP(3)
	SPACE(5) 'Ответственный сотрудник (исполнитель) отдела' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP.
	
{preview.i}
 