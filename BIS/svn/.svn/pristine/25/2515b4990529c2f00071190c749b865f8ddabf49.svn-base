/*распоряжение по погашению ПЕНИ, модифицированое pirloan014
Автор модификации: Красков А.С.
Заказчик: Валезнева Э.К.*/

{pirsavelog.p}

/*
**	Бурягин Е.П.
**	06.12.2005 12:11
**	Процедура формирования распоряжения по погашению штрафа за несвоевременное исполнение обязательств по кредиту

*/

{tmprecid.def}        /** Используем информацию из броузера */
{globals.i}
{intrface.get xclass}
{ulib.i} /* Библиотека функций для работы с кредитными договорами */
{get-bankname.i}

def var ClientName as char no-undo.
def var Loan as char no-undo.
def var LoanDate as date no-undo.
def var PayAcct as char no-undo.
def var LoanAcct as char no-undo.
def var RateAcct as char no-undo.
def var LoanCur as char no-undo.
def var Amount as decimal no-undo.
def var isDivAmount as logical initial "no" no-undo.
def var idate as date.
def var Amount1 as decimal no-undo.
def var Amount2 as decimal no-undo. 
def var Account1 as char no-undo.
def var Account2 as char no-undo.
def var AmountFuture as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var Rate as decimal no-undo.
def var RateValueType as char no-undo.
def var NewRate as decimal no-undo.

def var ULLShowErrorMsg as logical initial false.

def var PeriodBase as integer initial 1 no-undo. /* База начисления процентов 365/366 дней в году */

def var Summa as decimal no-undo.
def var PrePaySumma as decimal no-undo.
def var TotalSumma as decimal initial 0 no-undo.

def var Balance as decimal no-undo.
def var NewBalance as decimal no-undo.

def var Period as integer no-undo.
def var PeriodBegin as date no-undo.
def var PeriodEnd as date no-undo.

def var StrTable as char no-undo.
def var Appendix1 as char no-undo.
def var AccountStr as char no-undo.
def var cr as char no-undo.
cr = CHR(10).

def var beg_date as date no-undo.
def var beg_date_2 as date no-undo.
def var end_date as date no-undo.
def var PIRbosloan as char no-undo.
def var PIRbosloanFIO as char no-undo.

def buffer bfr-op-entry for op-entry.
def buffer bfr-op for op.

/* ========================================================================= */
PIRbosloan = ENTRY(1,FGetSetting("PIRboss","PIRbosloan","")).
PIRbosloanFIO = ENTRY(2, FGetSetting("PIRboss","PIRbosloan","")).

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
	if op-entry.acct-cr begins "7" then
	do:
	if op-entry.kau-cr begins "Кредит," then
		do:
		if NUM-ENTRIES(op-entry.kau-cr) = 3 then
			do:
			if ENTRY(3,op-entry.kau-cr) = "358" or ENTRY(3,op-entry.kau-cr) = "57" then
				/* Либо основные проценты, либо просроченные */
				do:
					

pause 0.

DISPLAY 
	"C  :" beg_date SKIP
	"По :" end_date SKIP
WITH FRAME frmGetDates OVERLAY CENTERED ROW 8 no-LABELS
TITLE COLOR BRIGTH-WHITE "[ Период погашения ]".

SET 
	beg_date
	end_date
WITH FRAME frmGetDates.
HIDE FRAME frmGetDates.
def var cur_year as integer.
cur_year = YEAR(end_date).
/*if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	PeriodBase = 366.
else
	PeriodBase = 365.*/
	/* Сумма операции */
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
	Amount1 = Amount.
	Account1 = op-entry.acct-cr.
		
	/* Найдем все проводки, созданные одной транзакцией, имеющие по кредиту код суб.
	   аналитической операции = 10.
	*/
	/*
	for each bfr-op WHERE
				bfr-op.op-transaction = op.op-transaction
				and
				bfr-op.op <> op.op 
				and
				bfr-op.op-date = op.op-date
				no-lock,
			first bfr-op-entry of bfr-op WHERE
			  NUM-ENTRIES(bfr-op-entry.kau-cr) = 3
				no-lock
		:
			if ENTRY(2, bfr-op-entry.kau-cr) = Loan then
				do:
					if NUM-ENTRIES(bfr-op-entry.kau-cr) = 3 then
						do:
							if CAN-DO("10,371", ENTRY(3,bfr-op-entry.kau-cr)) then
								do:
									isDivAmount = true.
									Amount2 = (IF bfr-op-entry.currency = "" THEN bfr-op-entry.amt-rub ELSE bfr-op-entry.amt-cur).
									Amount = Amount + Amount2.
								end.
							if CAN-DO("77", ENTRY(3,bfr-op-entry.kau-cr)) then
								do:
									isDivAmount = true.
									Account2 = bfr-op-entry.acct-cr.
									Amount2 = (IF bfr-op-entry.currency = "" THEN bfr-op-entry.amt-rub ELSE bfr-op-entry.amt-cur).
								end.
						end.
				end.
	end.
	*/
	
	/* Сумма прописью */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	

					/*########################################### 																		Найдем договор */
					find first loan where 
							loan.contract = "Кредит"
							and
							loan.cont-code = ENTRY(2,op-entry.kau-cr)
							no-lock no-error.
					if avail loan then
						do:
							IF loan.since LT end_date THEN 
								MESSAGE "*** ВНИМАНИЕ! *** " + CHR(10) + "Договор " + loan.cont-code + " нужно пересчитать на дату "
								 + STRING(end_date,"99/99/9999") + " иначе расчет процентов может быть некорректным!" VIEW-AS ALERT-BOX.
							Loan = loan.cont-code.
							LoanDate = loan.open-date.
							LoanCur = IF loan.currency = "" THEN "810" ELSE loan.currency.
							find first signs where 
									signs.code = "ДатаСогл"
									and
									signs.file-name = "loan"
									and
									signs.surrogate = "Кредит," + Loan
									no-lock no-error.
							if avail signs then
								LoanDate = DATE(signs.code-value).
						end.						
					else
						do:
							message "Договор, указанный в субаналитике, не найден!" view-as alert-box.
							return.
						end.
					
					/*########################################## 										Найдем клиента и его название/ФИО */
					/*
					if loan.cust-cat = "Ю" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
									ClientName = cust-corp.cust-stat + " " + cust-corp.name-corp.
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
					*/
					ClientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", ULLShowErrorMsg).
					
					/*########################################## 																Найдем счета */
					PayAcct = op-entry.acct-db.
					RateAcct = op-entry.acct-cr.
					LoanAcct = GetCredLoanAcct_ULL(Loan,"Кредит",beg_date, ULLShowErrorMsg).
					
					/*##########################################                Пеня за просрочку по кредиту 
					rate = 0.																																												 */
					Rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code,"Пеня-К", beg_date, ULLShowErrorMsg, RateValueType).
					if rate = 0 then 
					Rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code,"Пеня%К", beg_date, ULLShowErrorMsg, RateValueType).						
					if rate = 0 then 
					Rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code,"%КрПр", beg_date, ULLShowErrorMsg, RateValueType).						
					/*##########################################               Сумма предварительной оплаты
						это есть ни что иное как параметр 6 
					*/

					PrePaySumma = MAXIMUM(0, abs(GetLoanParamValue_ULL("Кредит", Loan, 90, op-entry.op-date, ULLShowErrorMsg)) - Amount).
					
										
					/*##########################################					
					Перед выполнением дальнейших действий, нужно расчитать таблицу процентов за период, найти 
					итоговую сумму, чтобы затем сравнить ее с суммой из проводки, дабы определить, какую сумму нужно 
					учесть в счет следующего процентного периода */
					
					/* сохраним будущий рисунок таблицы в переменную */
					StrTable =        "                                РАСЧЕТ  ШТРАФНЫХ САНКЦИЙ" + cr
									+	        "                             С  " + STRING(beg_date,"99/99/9999") 
													+ "  ПО  " + STRING(end_date, "99/99/9999") + cr
													+ "                                   (в валюте - " + LoanCur + ")" + cr
													+ "        ┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
													+ "        │ ПРОСРОЧЕННАЯ     │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
													+ "        │ ЗАДОЛЖЕННОСТЬ    ├──────────┬──────────┤ дней   │        │ штрафов          │" + cr
													+ "        │                  │     С    │    ПО    │        │        │                  │" + cr
													+ "        ├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.

					/* Найдем входящий остаток "просрочки" */
					Balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, beg_date - 1, ULLShowErrorMsg)
					          + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 48, beg_date - 1, ULLShowErrorMsg)
					          + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 10, beg_date - 1, ULLShowErrorMsg).
					PeriodBegin = beg_date.
					PeriodEnd = end_date.
					DO idate = PeriodBegin TO PeriodEnd - 1:
							NewBalance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, idate , ULLShowErrorMsg)
							             + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 48, idate , ULLShowErrorMsg)
							             + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 10, idate, ULLShowErrorMsg).
							newRate = Rate.
/*							NewRate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "Пеня-К", idate + 1, ULLShowErrorMsg, RateValueType).*/
							IF Balance <>  NewBalance	OR Rate <> NewRate OR (DAY(idate + 1) = 1 AND idate < PeriodEnd) THEN
								/* Если изменилось сумма ссудной задолжености или процентная ставка по кредиту */
								DO:

									ASSIGN
										PeriodEnd = idate
										Period = PeriodEnd - PeriodBegin + 1
										Summa = (if RateValueType = "%" then Balance * (Rate / 100) * Period	else Rate * Period) / PeriodBase
										TotalSumma = TotalSumma + round(Summa,2)
										StrTable = StrTable + "        │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
												+ "│" + STRING(PeriodBegin,"99/99/9999") 
												+ "│" + STRING(PeriodEnd,"99/99/9999") 
												+ "│" + STRING(Period,">>>>>>>>")
												+ "│" + STRING(Rate,">>>9.99%")
												+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr
										PeriodBegin = PeriodEnd + 1
										PeriodEnd = end_date
										Balance = NewBalance
										Rate = NewRate.

									
								END.
					END.
						

					ASSIGN
						Period = PeriodEnd - PeriodBegin + 1
						Summa = (if RateValueType = "%" then Balance * (Rate / 100) * Period	else Rate * Period) / PeriodBase
						TotalSumma = TotalSumma + round(Summa,2)
						StrTable = StrTable + "        │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
							+ "│" + STRING(PeriodBegin,"99/99/9999") 
							+ "│" + STRING(PeriodEnd,"99/99/9999") 
							+ "│" + STRING(Period,">>>>>>>>")
							+ "│" + STRING(Rate, ">>>9.99%")
							+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr
					StrTable = StrTable + "        └──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
					 	                  + "                                                  Начислено штрафов:" + STRING(TotalSumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                             Ранее погашено штрафов:" + STRING(PrePaySumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                                   ИТОГО (к оплате):" + STRING(TotalSumma - PrePaySumma,">>>,>>>,>>>,>>9.99") + cr.


					
					/* В этом случае нужно вывести кое-что */
					/*
					Appendix1 = "                                       в том числе:" + cr
												+	"         за период с " + STRING(beg_date,"99/99/9999") + " по " + STRING(end_date,"99/99/9999") + " - " 
														+ STRING(MINIMUM(TotalSumma - PrePaySumma, Amount),">>>,>>>,>>>,>>9.99") + cr
												+ "        в счет следующего процентного периода - " + STRING(MAXIMUM(0,Amount - MINIMUM(TotalSumma - PrePaySumma, Amount)),">>>,>>>,>>>,>>9.99") + cr
												+       "        ───────────────────────────────────────────────────────────────────────────────" + cr.
					*/
					if isDivAmount then
								AccountStr = "        ─────────────────────┴─────────────────────────────────────────────────────────" + cr
													 + "                                    	в том числе:" + cr
													 + "          - " + STRING(Amount1,">>>,>>>,>>>,>>9.99") + " на счет: " + Account1 + cr
													 + "          - " + STRING(Amount2,">>>,>>>,>>>,>>9.99") + " на счет: " + Account2 + cr
								           + "        ─────────────────────┬─────────────────────────────────────────────────────────" + cr.
					else
								AccountStr = "        ─────────────────────┼─────────────────────────────────────────────────────────" + cr
													 + "        На счет:             │" + STRING(RateAcct,"x(20)") + cr
								           + "        ─────────────────────┼─────────────────────────────────────────────────────────" + cr.

				end.
			else
				do:
				message "Судя по субаналитике - это не операция по погашению штрафа!" view-as alert-box.
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
		message "Проводка не привязана к кредитному договору!" view-as alert-box.
		return.
		end.
	end.
	else
	do:
		message "Счет по кредиту не является счетом доходов по процентам!" view-as alert-box.
		return.
	end.
	
/* ======================================================================================================= */

	
		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Определение и вставку кода,
		 * ранее не делаю, так как не хочется
		 * влезать в алгоритм расчета.
		 * Заявка (Event): #607
		 ******************************************/
			DEF VAR cDocId AS CHARACTER.
			cDocID = getMainLoanAttr("Кредит",Loan,"%cont-code от %ДатаСогл").			
		/*** Конец #607 ***/


{setdest.i}

put unformatted SPACE(50) "В Департамент 3" SKIP
								SPACE(50) "В Департамент 4" SKIP
								SPACE(50) cBankName SKIP(3)
								SPACE(50) "Дата: " op.op-date FORMAT "99/99/9999" SKIP(5)
			SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP(3)
			"            Произвести  з а ч и с л е н и е  денежных средств:" SKIP(2)
			"        ─────────────────────┬─────────────────────────────────────────────────────────" SKIP
			"        Сумма:               │" Amount format ">,>>>,>>>,>>>,>>9.99" SKIP
			"                             │(" AmtStr[1] ")" SKIP
			AccountStr 
			"        Заемщик:             │" ClientName SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Корреспондирующий    │" PayAcct SKIP
			"        счет:                │" SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Кредитный договор:   │№ " cDocID SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Валюта:              │" LoanCur SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Вид операции:        │Погашение штрафных санкций за несвоевременное " SKIP
			"                             │исполнение обязательств по кредиту" SKIP
			"        ─────────────────────┴─────────────────────────────────────────────────────────" SKIP
			Appendix1 SKIP(3)
		  StrTable SKIP(7)
			"        " PIRbosloan SPACE(70 - LENGTH(PIRbosloan)) PIRbosloanFIO SKIP(4)
			"        Исполнитель: " ExecFIO SKIP(4)
			"        Отметка Департамента учета и отчетности:" SKIP.

/* ======================================================================================================= */
END.

{preview.i}
{intrface.del}