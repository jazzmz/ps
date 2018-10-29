{pirsavelog.p}

/**
 * Распоряжение на безакцептное списание с расчетного счета суммы в счет погашения процентов по договору
 * 
 * Бурягин Е.П., 03.03.2007 15:31
 *
 * Запускается из броузера кредитных договоров.
 *
 * Запрашивает период расчета процентов. Расчитывает сумму процентов и одновременно
 * формирует печатную таблицу расчета процентов, сохраняя ее в сроковую переменную.
 * Эта строковая переменная отображается в момент формирования всего документа.
 * В расчете процентов учитывается сумма ранее погашенных процентов. Итог "к оплате" 
 * (отображаемый внизу таблицы) равен разнице между суммой расчитанных процентов
 * за период минус сумма ранее погашенных процентов. Итог есть значение, 
 * которое выводится в тексте распоряжения "в размере...".
 */

/** Глобальные переменные и определения */
{globals.i}
/** Моя Библиотека функций */
{ulib.i}
/** Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
/** Объявление переменных */


/** Номер договора */
def var Loan as char  NO-UNDO.

/***********************************
 * Автор: Маслов Д. А.(Maslov D. A.)
 * Заявка (Event): #607
 * Идентификатор договора.
 ***********************************/

DEF VAR cDocID AS CHARACTER NO-UNDO.

/*** Конец #607 ***/

/** Валюта договора */
def var LoanCur as char NO-UNDO.
/** "Рисунок" таблицы */
def var StrTable as char NO-UNDO.
/** Остаток по ссудному счету */
def var Balance as decimal NO-UNDO.
def var NewBalance as decimal NO-UNDO.
/** Расчетные суммы */
/** Сумма процентов за подпериод */
def var Summa as decimal NO-UNDO.
/** Cумма процентов за весь период начисления процентов */
def var TotalSumma as decimal NO-UNDO.
/** Сумма процентов, выносимая на просрочку = TotalSumma - PrePaySumma */
def var WriteOffSumma as decimal NO-UNDO.
def var SummaStr as char extent 2 NO-UNDO.
/** Сумма предварительно уплаченных процентов */
def var PrePaySumma as decimal NO-UNDO.
/** Период начисления процентов */
def var beg_date as date NO-UNDO.
def var end_date as date NO-UNDO.
/** Подпериоды, используемые для расчета процентов */
def var PeriodBegin as date NO-UNDO.
def var PeriodEnd as date NO-UNDO.
/** Длина подпериода в днях */
def var Period as integer NO-UNDO.
/** Длина глобального периода в днях */
def var PeriodBase as integer initial 365 NO-UNDO.
/** Процентная ставка */
def var Rate as decimal NO-UNDO.
def var NewRate as decimal NO-UNDO.
/** Счета, участвющие в формировании распоряжения */
/** Расчетный счет */
def var LoanAcct as char NO-UNDO.
/** Счет учета оплаченных процентов */
def var IncomingAcct as char NO-UNDO.
/** Флаг отладки функций библиотеки ulib.i */
def var ULLShowErrorMsg as logical initial false  NO-UNDO.
/** Вместо SKIP для "рисунка" таблицы */
def var cr as char no-undo.
cr = CHR(10).
/** Итератор */
def var idate as date NO-UNDO.
def var i as integer NO-UNDO.
/** Текс распоряжения. Должен быть красивым :). Для этого используем технологию переноса слов */
def var MainText as char extent 10 NO-UNDO.
/** Информация по договору. Формат: <дата_открытия>,<клиент> */
def var LoanInfo as char NO-UNDO.
/** Дата распоряжения */
def var orderDate as date NO-UNDO.
/** Подписи */
def var ExecFIO as char no-undo.
/** Наименование банка */
def var bankname as char NO-UNDO.
/** Основание */
DEF VAR evidence AS CHAR 
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7  NO-UNDO.

def var PIRbosloan as char no-undo.
PIRbosloan = FGetSetting("PIRboss","PIRbosloan","").
find first _user where _user._userid = userid no-lock no-error.
if avail _user then
	ExecFIO = _user._user-name.
else
	ExecFIO = "-".

bankname = cBankName.

/** Поиск выделенного договора */
FOR FIRST tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
    :
		/** Присвоение номера и валюты договора */
		assign 		
			  Loan = loan.cont-code		
			  LoanCur = (if loan.currency = "" then "810" else loan.currency)
		          LoanInfo = GetLoanInfo_ULL("Кредит",Loan,"open_date,client_short_name", ULLShowErrorMsg)
			.

		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			cDocID = getMainLoanAttr("Кредит",Loan,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/
		
		/** Запрашиваем дату распоряжения */
		/** Запрашиваем период начисления процентов по договору */
		/** Запрос текста основания */
		orderDate = TODAY. 
		pause 0.
		UPDATE orderDate LABEL "Дата распоряжения" SKIP
		    beg_date LABEL "С" end_date LABEL "По" SKIP
		    evidence WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

		/** Счета, участвующие в формировании распоряжения */
		LoanAcct = GetLoanAcct_ULL("Кредит",Loan,"КредРасч",end_date, ULLShowErrorMsg).
		IncomingAcct = GetLoanAcct_ULL("Кредит",Loan,"КредПроц",end_date, ULLShowErrorMsg).
		
		/** Корректировка глобального периода */
		def var cur_year as integer.
		cur_year = YEAR(end_date).
		if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
			PeriodBase = 366.
		else
			PeriodBase = 365.

		
				
		/** 
		 * Расчет процентов.
		 * Сохраним "рисунок" таблицы в переменную. Расчет производим в цикле по дням.
		 * Следим за изменеиями суммы ссудной задолженности, процентной ставки и наступлением последнего дня месяца. 
		 */
					StrTable =        "                                  РАСЧЕТ  ПРОЦЕНТОВ" + cr
													+ "                             С  " + STRING(beg_date,"99/99/9999") 
													+ "  ПО  " + STRING(end_date, "99/99/9999") + cr
													+ "                                   (в валюте - " + LoanCur + ")" + cr
													+ "    ┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
													+ "    │ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
													+ "    │ задолженности    ├──────────┬──────────┤ дней   │        │ процентов        │" + cr
													+ "    │                  │     С    │    ПО    │        │        │                  │" + cr
													+ "    ├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.

					/** Найдем входящий остаток на счете за период и подпериоды начисления */
					Balance = GetLoanParamValue_ULL("Кредит",Loan, 0, beg_date - 1, ULLShowErrorMsg).
					PeriodBegin = beg_date.
					PeriodEnd = end_date.
					/** Процентная ставка по кредитру на дату начала периода расчета процентов */
					Rate = GetLoanCommission_ULL("Кредит",Loan,"%Кред",beg_date, ULLShowErrorMsg).
					/** Сумма ранее уплаченных процентов (есть ни что иное, как параметр 6) */
					PrePaySumma = abs(GetLoanParamValue_ULL("Кредит", Loan, 6, end_date, ULLShowErrorMsg)).
					
					/** Основной цикл расчета процентов от первого до предпоследнего дня */
					DO idate = PeriodBegin TO PeriodEnd - 1:
							NewBalance = GetLoanParamValue_ULL("Кредит", Loan, 0, idate, ULLShowErrorMsg).
							NewRate = GetLoanCommission_ULL("Кредит",Loan, "%Кред", idate + 1, ULLShowErrorMsg).
							IF Balance <>  NewBalance	OR Rate <> NewRate OR (DAY(iDate + 1) = 1) THEN
								/** 
								 * Если изменилось сумма ссудной задолжености, процентная ставка по кредиту или 
								 * день является последним днем месяца 
								 */
								DO:
									ASSIGN
										PeriodEnd = idate
										Period = PeriodEnd - PeriodBegin + 1
										Summa = round(Balance * Rate / PeriodBase * Period, 2)
										TotalSumma = TotalSumma + Summa
										StrTable = StrTable + "    │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
												+ "│" + STRING(PeriodBegin,"99/99/9999") 
												+ "│" + STRING(PeriodEnd,"99/99/9999") 
												+ "│" + STRING(Period,">>>>>>>>")
												+ "│" + STRING(Rate * 100,">>>9.99%")
												+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr
										PeriodBegin = PeriodEnd + 1
										PeriodEnd = end_date
										Balance = NewBalance
										Rate = NewRate.
								END.
					END.
					/** Последний день периода расчета процентов */
					ASSIGN
						Period = PeriodEnd - PeriodBegin + 1
						Summa = round(Balance * Rate / PeriodBase * Period, 2)
						TotalSumma = TotalSumma + Summa
						WriteOffSumma = TotalSumma - PrePaySumma
						StrTable = StrTable + "    │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
							+ "│" + STRING(PeriodBegin,"99/99/9999") 
							+ "│" + STRING(PeriodEnd,"99/99/9999") 
							+ "│" + STRING(Period,">>>>>>>>")
							+ "│" + STRING(Rate * 100,">>>9.99%")
							+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr
					StrTable = StrTable + "    └──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
					 	                  + "                                            Начислено процентов:" + STRING(TotalSumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                                 Ранее погашено:" + STRING(PrePaySumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                      ИТОГО (проценты к оплате):" + STRING(WriteOffSumma,">>>,>>>,>>>,>>9.99") + cr.
		
		/** Формирование и печать распоряжения */
		
		/* Сумма прописью */
		Run x-amtstr.p(WriteOffSumma, loan.currency, true, true, output SummaStr[1], output SummaStr[2]).
  	SummaStr[1] = SummaStr[1] + ' ' + SummaStr[2].
		Substr(SummaStr[1],1,1) = Caps(Substr(SummaStr[1],1,1)).
 
		/** Текс распоряжения */
		MainText[1] = "Списать в безакцептном порядке со счета №" + LoanAcct + " с последующим зачислением "
		            + "на счете №" + IncomingAcct + " сумму в размере "
		            + TRIM(STRING(WriteOffSumma,">>>,>>>,>>>,>>9.99")) + "(" + SummaStr[1] + ")"
		            + " в счет погашения процентов за пользование кредитом с " 
		            + STRING(beg_date, "99/99/9999") + " по " + STRING(end_date, "99/99/9999") + " включительно "
		            + "по кредитному договору №"  + cDocID 
		            + ', заключенному между ' + bankname + ' и ' + ENTRY(2, LoanInfo) + ".".

		{wordwrap.i &s=MainText &l=74 &n=10}
		
		{setdest.i}
		
		put unformatted 
								SPACE(60) "В Департамент 3" SKIP
								SPACE(60) "В Департамент 4" SKIP
								SPACE(60) bankname SKIP(3)
								SPACE(60) "Дата: " orderDate FORMAT "99/99/9999" SKIP(5)
								SPACE(30) "Р А С П О Р Я Ж Е Н И Е" SKIP(3).
		
		DO i = 1 TO 10:
			if MainText[i] <> "" then do:
				if i = 1 then		put unformatted "        ". else put unformatted "".
				 
				put unformatted MainText[i] skip.
			end.
		END.
		
	  PUT UNFORMATTED "        Основание: " evidence SKIP.
	   
	  put unformatted ' ' SKIP(2) StrTable SKIP(4)
		
		"    " ENTRY(1, PIRbosloan) SPACE(70 - LENGTH(ENTRY(1, PIRbosloan))) ENTRY(2, PIRbosloan) SKIP(4)
		"    Исполнитель: " ExecFIO SKIP(4)
		"    Отметка Департамента 3:" SKIP
.
		
		{preview.i}			

END. /** FOR FIRST tmprecid ... */