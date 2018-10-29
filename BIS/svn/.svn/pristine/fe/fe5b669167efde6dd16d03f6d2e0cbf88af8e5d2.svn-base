{pirsavelog.p}

/**	
 * Печать расчета по требованиям по средствам внесенным в послеоперационное время.
 * Ермилов В.Н.
 * 24.12.2010 9:05
 */
 
 DEFINE INPUT PARAMETER iParam AS CHAR NO-UNDO.
 
 /**
  * Программа получает в качестве параметра маску кодов транзакций, маску счетов, с которых производится
  * списание и адрес, куда отправляется распоряжение. 
  * Обрабатывает, выбранные в броузере документы, отбирая документы, созданные
  * указанными транзакциями. 
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
	FIELD loanNo AS CHAR EXTENT 5
	FIELD loan AS CHAR 
	FIELD clientName AS CHAR EXTENT 5
	FIELD acctDbBal AS CHAR
	FIELD acctDb AS CHAR 
	FIELD acctCr AS CHAR
	FIELD summa AS DECIMAL
	FIELD details AS CHAR EXTENT 5
	
	INDEX loan acctDbBal ASCENDING loan ASCENDING.

/** Буферы таблиц для поиска "пары" проводки 
DEFINE BUFFER bfr-op FOR op.
DEFINE BUFFER bfr-op-entry FOR op-entry.*/

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR totalSumma AS DECIMAL NO-UNDO.
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
	
IF NUM-ENTRIES(iParam, ";") <> 3 THEN DO:
	MESSAGE "Недостаточное кол-во параметров!" VIEW-AS ALERT-BOX.
	RETURN.
END.

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
    	CAN-DO(ENTRY(1, iParam, ";"), op.op-kind)
    	NO-LOCK,
    FIRST op-entry OF op WHERE 
    	CAN-DO(ENTRY(2, iParam, ";"), op-entry.acct-db)
    	NO-LOCK
:
			FIND FIRST loan-acct WHERE 
				loan-acct.acct = op-entry.acct-db
				/*AND
				loan-acct.contract = "Депоз"*/
				AND
				CAN-DO("ДепСейфНРасч",loan-acct.acct-type)
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
						loan-cond.since LE op.op-date
						NO-LOCK NO-ERROR.
					IF AVAIL loan-cond THEN DO:
						/** Собраны все данные */
						/** Заполняем строку отчета */
						CREATE tt-report.
						ASSIGN
							tt-report.loan = loan.cont-code
							tt-report.loanNo[1] = loan.cont-code
							tt-report.loanNo[2] = "от " + STRING(loan.open-date,"99/99/9999")
							tt-report.acctDbBal = SUBSTRING(op-entry.acct-db,1,5)
							tt-report.acctDb = op-entry.acct-db
							tt-report.acctCr = op-entry.acct-cr
							tt-report.summa = op-entry.amt-rub
							tt-report.details[1] = op.details.
							tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE).
						/** Кое-какие действия по форматированию */
						{wordwrap.i &s=tt-report.clientName &l=20 &n=5}
						{wordwrap.i &s=tt-report.details &l=30 &n=5}
					END.
				END.
			END.
END.


{get-bankname.i}

/** Вывод отчета в preview */
{setdest.i}

/** Шапка */
PUT UNFORMATTED SPACE(0) ENTRY(3,iParam,";") SKIP
                SPACE(0) cBankName SKIP
                SPACE(0) '"' STRING(DAY(repDate),"99") '" ' monthList[MONTH(repDate)] ' ' STRING(YEAR(repDate)) ' г.' SKIP(3)
                SPACE(35)  'РАСЧЕТ ПО НАЧИСЛЕНИЮ ТРЕБОВАНИЯ ОБ ОПЛАТЕ ЗА АРЕНДУ ИБС' SKIP
                SPACE(34) 'ПО ДЕНЕЖНЫМ СРЕДСТВАМ, ВНЕСЕННЫМ В ПОСЛЕОПЕРАЦИОННОЕ ВРЕМЯ' SKIP(4).
                
                

/** Заголовки */
PUT UNFORMATTED 
	 	"┌─────────────┬────────────────────┬────────────────────┬────────────────────┬───────────────────┬──────────────────────────────┐" SKIP
		"│№            │Ф.И.О.              │Счет                │Счет                │ Сумма требования  │Назначение                    │" SKIP
		"│дог          │                    │дебета              │кредита             │ (рубл.)           │платежа                       │" SKIP
	 	"├─────────────┼────────────────────┼────────────────────┼────────────────────┼───────────────────┼──────────────────────────────┤" SKIP.

/** Тело */
FOR EACH tt-report BREAK BY acctDbBal:
	PUT UNFORMATTED
	 "│" tt-report.loanNo[1] FORMAT "x(13)"
	 "│" tt-report.clientName[1] FORMAT "x(20)"
   "│" tt-report.acctDb FORMAT "x(20)"
   "│" tt-report.acctCr FORMAT "x(20)"
   "│" tt-report.summa FORMAT "->>>,>>>,>>>,>>9.99"
   "│" tt-report.details[1] FORMAT "x(30)" 
   "│" SKIP.
  DO i = 2 TO 5 :
  	IF tt-report.clientName[i] <> "" OR tt-report.details[i] <> "" OR tt-report.loanNo[i] <> "" THEN
			PUT UNFORMATTED
		 		"│" tt-report.loanNo[i] FORMAT "x(13)"
	 			"│" tt-report.clientName[i] FORMAT "x(20)"
		   	"│" SPACE(20)
   			"│" SPACE(20)
   			"│" SPACE(19)
   			"│" tt-report.details[i] FORMAT "x(30)" 
   			"│" SKIP.
  END.
	ASSIGN 
		totalSumma = totalSumma + tt-report.summa.
	
	IF LAST-OF(acctDbBal) THEN DO:
	/** Итоги */
	PUT UNFORMATTED
	 	"├─────────────┼────────────────────┼────────────────────┼────────────────────┼───────────────────┼──────────────────────────────┤" SKIP
 		"│ИТОГО   " acctDbBal FORMAT "x(5)" 
		"│" SPACE(20)
   	"│" SPACE(20)
		"│" SPACE(20)
		"│" totalSumma FORMAT "->>>,>>>,>>>,>>9.99"
		"│" SPACE(30)
		"│" SKIP.
	 	totalSumma = 0.
	
	END.
	
	IF LAST(acctDbBal) THEN
			PUT UNFORMATTED
			 	"└─────────────┴────────────────────┴────────────────────┴────────────────────┴───────────────────┴──────────────────────────────┘" SKIP(2).
	ELSE
			PUT UNFORMATTED
			 	"├─────────────┼────────────────────┼────────────────────┼────────────────────┼───────────────────┼──────────────────────────────┤" SKIP.


END.

/** Подвал */
PUT UNFORMATTED
	SPACE(5) 'Зам. Председателя правления Начальник Д' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP(3)
	SPACE(5) 'Ответственный сотрудник (исполнитель) отдела' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP.
	
{preview.i}
 