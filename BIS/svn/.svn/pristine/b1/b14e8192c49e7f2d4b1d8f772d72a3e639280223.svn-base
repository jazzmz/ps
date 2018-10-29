{pirsavelog.p}

/*
**	Бурягин Е.П.
**	06.12.2005 12:11
**	Процедура формирования распоряжения по начислению процентов по ЧВ 
*/

{globals.i}
{ulib.i}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
def var ClientName as char no-undo.
def var Loan as char no-undo.
def var PrintLoan as char no-undo.
def var LoanDate as date no-undo.
def var PayAcct as char no-undo.
def var LoanAcct as char no-undo.
def var RateAcct as char no-undo.
def var LoanCur as char no-undo.
def var Amount as decimal no-undo.
def var AmountFuture as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var Rate as decimal no-undo.
def var PeriodBase as integer initial 365 no-undo. /* База начисления процентов 365/366 дней в году */

def var Summa as decimal no-undo.
def var PrePaySumma as decimal no-undo.
def var TotalSumma as decimal initial 0 no-undo.

def var Balance as decimal no-undo.

def var Period as integer no-undo.
def var PeriodBegin as date no-undo.
def var PeriodEnd as date no-undo.

def var StrTable as char no-undo.
def var Appendix0 as char no-undo.
def var Appendix1 as char no-undo.
def var cr as char no-undo.
cr = CHR(10).

def var beg_date as date no-undo.
def var beg_date_2 as date no-undo.
def var end_date as date no-undo.

def buffer bfr-op-entry for op-entry.
def buffer bfr-op for op.
def var isCloseLoan as logical initial "no" no-undo.

def var PIRbosU5 as char no-undo.
def var PIRbosU5FIO as char no-undo.
def var PIRbosdps as char no-undo.
def var PIRbosdpsFIO as char no-undo.
def var PIRbosD6 as char no-undo.
def var PIRbosD6FIO as char no-undo.

PIRbosD6 = ENTRY(1,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosD6FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosdps = ENTRY(1,FGetSetting("PIRboss","PIRbosdps","")).
PIRbosdpsFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosdps","")).

/* ========================================================================= */
find first _user where _user._userid = userid no-lock no-error.
if avail _user then
	ExecFIO = _user._user-name.
else
	ExecFIO = "-".


/* ========================================================================= */


FOR FIRST tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
:
	/* Проводка должна быть привязана по аналитике */
	if op-entry.kau-cr begins "dps," then
		do:
		if NUM-ENTRIES(op-entry.kau-cr) = 3 then
			do:
			if ENTRY(3,op-entry.kau-cr) begins "начпр" or ENTRY(3,op-entry.kau-cr) begins "ОстВкл" then
				do:
					

/* Предварительно вычислим даты периода */
beg_date = DATE(
		MONTH(DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1),
		1,
		YEAR(DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1)
).
end_date = DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1.

pause 0.

DISPLAY 
	"C  :" beg_date SKIP
	"По :" end_date SKIP(1)
	isCloseLoan VIEW-AS TOGGLE-BOX LABEL "Возврат вклада" SKIP
WITH FRAME frmGetDates OVERLAY CENTERED ROW 8 no-LABELS
TITLE COLOR BRIGTH-WHITE "[ Период и тип погашения ]".

SET 
	beg_date
	end_date
	isCloseLoan
WITH FRAME frmGetDates.
HIDE FRAME frmGetDates.

def var cur_year as integer  NO-UNDO.
cur_year = YEAR(end_date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	PeriodBase = 366.
else
	PeriodBase = 365.
	
	
	/* Сумма операции
		 Тут есть маленькая заковырка: если по аналитике это операция ОстВкл*, то данная проводка является только 
		 выплатой ранее начисленных процентов, следовательно нужно найти проводку по выплате доначисленных процентов */
	if op-entry.currency = "" then
		do:
			/* Рубли */
			Amount = op-entry.amt-rub.
		end.
	else
		do:
			/* Валюта */
			Amount = op-entry.amt-cur.
		end.
	
	for each bfr-op WHERE
						bfr-op.op-transaction = op.op-transaction 
						and
						bfr-op.op <> op.op 
						no-lock,
					first bfr-op-entry of bfr-op no-lock
				:
					if bfr-op-entry.acct-db begins "7" and bfr-op-entry.acct-cr begins "42" 
					  and ENTRY(2,bfr-op-entry.kau-cr) = ENTRY(2,op-entry.kau-cr)
					then
						if bfr-op-entry.currency = "" then
							Amount = Amount + bfr-op-entry.amt-rub.
						else
							Amount = Amount + bfr-op-entry.amt-cur.
	end.
				
	
	
	/* Сумма прописью */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	
	
					/*########################################### 																		Найдем договор */
					find first loan where 
							loan.contract = "dps"
							and
							loan.cont-code = ENTRY(2,op-entry.kau-cr)
							no-lock no-error.
					if avail loan then
						do:
							PrintLoan = loan.cont-code.
							Loan = loan.cont-code.
							LoanDate = loan.open-date.
						end.						
					else
						do:
							message "Договор, указанный в субаналитике, не найден!" view-as alert-box.
							return.
						end.
					
					/* Корректировка начальной даты */
					beg_date = maximum(beg_date, loan.open-date).
					
					/*########################################## 										Найдем клиента и его название/ФИО */
					if loan.cust-cat = "Ю" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
									ClientName = cust-corp.name-corp.
								end.
						end.
					if loan.cust-cat = "Ч" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								do:
									ClientName = person.name-last + " " + person.first-names.
								end.
						end.
					
					/*########################################## 																Найдем счета */
					PayAcct = op-entry.acct-db.
					LoanAcct = op-entry.acct-cr.
					/* Номер договора еще прописан в д.р. по вкладному счету */
					find first signs where 
							signs.code = "DogPlast"
							and	
							signs.file-name = "acct"
							and
							signs.surrogate begins LoanAcct
							no-lock no-error.
					if avail signs then
						PrintLoan = signs.xattr-value.
						
					find last loan-acct where 
							loan-acct.contract = "dps"
							and
							loan-acct.cont-code = Loan
							and 
							loan-acct.acct-type = "loan-dps-out"
							no-lock no-error.
					if avail loan-acct then
						PayAcct = loan-acct.acct.
					else	
						do:
							message "В картотеке счетов договра не найден счет для перечислений!" view-as alert-box.
							return.
						end.


					LoanCur = SUBSTRING(LoanAcct,6,3).
					
						
					/*##########################################					
					Перед выполнением дальнейших действий, нужно расчитать таблицу процентов за период, найти 
					итоговую сумму, чтобы затем сравнить ее с суммой из проводки, дабы определить, какую сумму нужно 
					учесть в счет следующего процентного периода */
					
					/* сохраним будущий рисунок таблицы в переменную */
					StrTable = "                 РАСЧЕТ  ПРОЦЕНТОВ  С  " + STRING(beg_date,"99/99/9999") 
													+ "  ПО  " + STRING(end_date, "99/99/9999") + cr
													+ "┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
													+ "│ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
													+ "│ на счете         ├──────────┬──────────┤ дней   │        │ процентов        │" + cr
													+ "│                  │     С    │    ПО    │        │        │                  │" + cr
													+ "├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.

	
					/* Найдем входящий остаток на счете за период и подпериоды начисления */
					if LoanCur = "810" then
						do:
									
									find last acct-pos where 
											acct-pos.acct = LoanAcct
											and
											acct-pos.since lt beg_date
											no-lock no-error.
									if avail acct-pos then
										do:
											Balance = acct-pos.balance.
										end.
									else
										do:
											Balance = 0.
										end.
									PeriodBegin = beg_date.
									PeriodEnd = end_date.

					/*##########################################                Процентная ставка по договору
					Условимся также, что процентная ставка по договору не менялась в течение периода       
					Найдем ставку как д.р. шаблона транзакции открытия вклада
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					/*Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/


									for each acct-pos where 
										acct-pos.acct = LoanAcct
										and
										acct-pos.since ge beg_date
										and
										acct-pos.since lt end_date
										no-lock:

					/*##########################################                Процентная ставка по договору
					Условимся также, что процентная ставка по договору не менялась в течение периода       
					Найдем ставку как д.р. шаблона транзакции открытия вклада*/
					
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).	
					
					/*
					Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/
												if Balance = acct-pos.balance then next.
												PeriodEnd = acct-pos.since.
												Period = PeriodEnd - PeriodBegin + 1.
												Summa = Balance * Rate / PeriodBase * Period.
												TotalSumma = TotalSumma + round(Summa,2).
												StrTable = StrTable + "│" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
													+ "│" + STRING(PeriodBegin,"99/99/9999") 
													+ "│" + STRING(PeriodEnd,"99/99/9999") 
													+ "│" + STRING(Period,">>>>>>>>")
													+ "│" + STRING(Rate * 100,">>>9.99%")
													+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr.
												PeriodBegin = PeriodEnd + 1.
												PeriodEnd = end_date.
												Balance = acct-pos.balance.
									end. 
									
									
									Period = PeriodEnd - PeriodBegin + 1.
									Summa = Balance * Rate / PeriodBase * Period.
									TotalSumma = TotalSumma + round(Summa,2).
					/* 
						 Примечание 1.
						 
						 Теперь выполняем корректировку расчитанного значения процентов по сумме проводок по процентам.
					   Обычно разница этих сумм составляет от 1 од 3 копеек, и возникает она в результате погрешности 
					   в арифметическом вычислении процентов за весь период и за каждый подпериод начисления в отдельности.
					   Например:
					   Вклад А пролежал 91 день, предположим, за это время произошло 2 начисления процентов на суммы 200.01 руб.
					   В последний период начислено 100 рублей. Следовательно по проводкам сумма процентов равна 500.02, а процедура
					   расчитала за полный срок 500.03, что на 0.01 рубль больше.
					   
					   Решение: позволим процедуре корректировать сумму процентов в расчетной таблице за последний период на разницу
					   между суммой по проводкам и общей рассчитаной суммой.
					*/
        					
        					Summa = Summa - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).

									StrTable = StrTable + "│" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99") 
										+ "│" + STRING(PeriodBegin,"99/99/9999") 
										+ "│" + STRING(PeriodEnd,"99/99/9999") 
										+ "│" + STRING(Period,">>>>>>>>")
										+ "│" + STRING(Rate * 100,">>>9.99%")
										+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr.
								end.
					else	
								do:
									
									find last acct-cur where 
											acct-cur.acct = LoanAcct
											and
											acct-cur.since lt beg_date
											no-lock no-error.
									if avail acct-cur then
										do:
											Balance = acct-cur.balance.
										end.
									else
										do:
											Balance = 0.
										end.
									PeriodBegin = beg_date.
									PeriodEnd = end_date.

					/*##########################################                Процентная ставка по договору
					Условимся также, что процентная ставка по договору не менялась в течение периода       
					Найдем ставку как д.р. шаблона транзакции открытия вклада
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					
					/*Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/

									for each acct-cur where 
										acct-cur.acct = LoanAcct
										and
										acct-cur.since ge beg_date
										and
										acct-cur.since lt end_date
										no-lock:

					/*##########################################                Процентная ставка по договору
					Условимся также, что процентная ставка по договору не менялась в течение периода       
					Найдем ставку как д.р. шаблона транзакции открытия вклада
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					/*																																																	
					Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or 
									comm-rate.acct = LoanAcct
								)					
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/
												if Balance = acct-cur.balance then next.
												PeriodEnd = acct-cur.since.
												Period = PeriodEnd - PeriodBegin + 1.
												Summa = Balance * Rate / PeriodBase * Period.
												TotalSumma = TotalSumma + round(Summa,2).
												StrTable = StrTable + "│" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
													+ "│" + STRING(PeriodBegin,"99/99/9999") 
													+ "│" + STRING(PeriodEnd,"99/99/9999") 
													+ "│" + STRING(Period,">>>>>>>>")
													+ "│" + STRING(Rate * 100,">>>9.99%")
													+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr.
												PeriodBegin = PeriodEnd + 1.
												PeriodEnd = end_date.
												Balance = acct-cur.balance.
									end. 
									Period = PeriodEnd - PeriodBegin + 1.
									Summa = Balance * Rate / PeriodBase * Period.
									TotalSumma = TotalSumma + round(Summa,2).
					/* 
						 Примечание 1.
						 
						 Теперь выполняем корректировку расчитанного значения процентов по сумме проводок по процентам.
					   Обычно разница этих сумм составляет от 1 од 3 копеек, и возникает она в результате погрешности 
					   в арифметическом вычислении процентов за весь период и за каждый подпериод начисления в отдельности.
					   Например:
					   Вклад А пролежал 91 день, предположим, за это время произошло 2 начисления процентов на суммы 200.01 руб.
					   В последний период начислено 100 рублей. Следовательно по проводкам сумма процентов равна 500.02, а процедура
					   расчитала за полный срок 500.03, что на 0.01 рубль больше.
					   
					   Решение: позволим процедуре корректировать сумму процентов в расчетной таблице за последний период на разницу
					   между суммой по проводкам и общей рассчитаной суммой.
					*/
        					Summa = Summa - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).
									
									StrTable = StrTable + "│" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
										+ "│" + STRING(PeriodBegin,"99/99/9999") 
										+ "│" + STRING(PeriodEnd,"99/99/9999") 
										+ "│" + STRING(Period,">>>>>>>>")
										+ "│" + STRING(Rate * 100,">>>9.99%")
										+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr.
								end.
					TotalSumma = TotalSumma - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).
					
					StrTable = StrTable + "└──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
					 	                  + "                                        Начислено процентов:" + STRING(ABS(TotalSumma),">>>,>>>,>>>,>>9.99") + cr.
					if isCloseLoan then
						do:
							Appendix1 = "     В связи  с   окончанием  срока  действия  Договора банковского вклада" + cr
												+ "N " + PrintLoan + "  от  " + STRING(LoanDate,"99/99/9999") + "г.  осуществить   возврат  вклада и" + cr
												+	"начисленных процентов на счет N " + PayAcct + " (" + ClientName + ")." + cr.
						end.
					else
						do:
							Appendix0 = " и" + cr + "перевести    начисленные   проценты     на    счет    N " + PayAcct + cr + "(" + ClientName + ")".
						end.
					
				end.
			else
				do:
				message "Судя по субаналитике - это не операция по уплате начисленных процентов!" view-as alert-box.
				return.
				end.
			end.
		else
			do:
			message "Неполная субаналитическая информация об операции!" view-as alert-box.
			return.
			end.
		end.
	else
		do:
		message "Проводка не привязана к депозитному договору!" view-as alert-box.
		return.
		end.
	
/* ======================================================================================================= */


{setdest.i}

put unformatted SPACE(50) "В Департамент 3" SKIP(1)
								SPACE(50) cBankName SKIP(3)
								SPACE(50) "Дата: " op.op-date FORMAT "99/99/9999" SKIP(5)
			SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP(3)
			"     В   соответствии   с   Положением  Банка России   N39-П   от   26.06.98г." SKIP
			"начислить  проценты  за  период  с  " beg_date format "99/99/9999" "  по " end_date format "99/99/9999" " вкл. по Договору" SKIP
			"банковского   вклада   N " PrintLoan "  от  " LoanDate "г.   (вкладчик   - " SKIP
			ClientName ")   на   счет    N " LoanAcct " в размере " SKIP
			Amount format ">>>,>>>,>>9.99" "/" LoanCur " (" AmtStr[1] ") " Appendix0 "." SKIP(1)
			Appendix1 SKIP(3)
		  StrTable SKIP(7)
			PIRbosdps SPACE(70 - LENGTH(PIRbosdps)) PIRbosdpsFIO SKIP.
			/*
			По просьбе Маршевой: 26.12.2005 17:28 закоментировал Бурягин ЕП
			
			"Исполнитель: " ExecFIO SKIP. */


{preview.i}
/* ======================================================================================================= */
END.

