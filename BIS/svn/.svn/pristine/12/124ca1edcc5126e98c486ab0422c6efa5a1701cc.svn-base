/*
**	Бурягин Е.П.
**	06.12.2005 12:11
**	Процедура формирования распоряжения по погашению процентов за пользование кредитом
*/

{globals.i}

{ulib.i} /* Библиотека функций для работы с кредитными договорами */
{pir-getsumbyoper.i} /* Доработка по заявку #418 */
{tmprecid.def}
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
def var idate as date  NO-UNDO.
def var Amount1 as decimal no-undo.
def var Amount2 as decimal no-undo. 
def var Account1 as char no-undo.
def var Account2 as char no-undo.
def var AmountFuture as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var Rate as decimal no-undo.
def var NewRate as decimal no-undo.

def var ULLShowErrorMsg as logical initial false  NO-UNDO.

def var PeriodBase as integer initial 365 no-undo. /* База начисления процентов 365/366 дней в году */

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
def var rpt-cont-code as char format "x(12)" no-undo.

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
	if CAN-DO("7*,47422*", op-entry.acct-cr) then
	do:
	if op-entry.kau-cr begins "Кредит," OR true then
		do:
		if (NUM-ENTRIES(op-entry.kau-cr) = 3 AND 
		   (ENTRY(3,op-entry.kau-cr) = "10" or ENTRY(3, op-entry.kau-cr) = "371")) OR true then
			do:
			if true then
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
def var cur_year as integer  NO-UNDO.
cur_year = YEAR(end_date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	PeriodBase = 366.
else
	PeriodBase = 365.
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
	
	/* Сумма прописью */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	

        
					/*########################################### 																		Найдем договор */
				rpt-cont-code = IF NUM-ENTRIES(op-entry.kau-cr) > 1 THEN ENTRY(2,op-entry.kau-cr) ELSE "".
				repeat:	
					find first loan where 
							loan.contract = "Кредит"
							and
							loan.cont-code = rpt-cont-code
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
							leave.
						end.						
					else
						do:
							message "Договор, указанный в субаналитике, не найден! Задайте договор вручную." view-as alert-box.
							set rpt-cont-code with frame frm-cont-code centered overlay title "Введите номер договора".
							hide frame frm-cont-code.
							retry.
						end.
				end. /* repeat */
					

					/*########################################## 										Найдем клиента и его название/ФИО */
					
					ClientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false). 
					
					/** Buryagin commented at 6/10/2010
					if loan.cust-cat = "Ю" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
/*									ClientName = cust-corp.cust-stat + " " + cust-corp.name-corp. */
									ClientName = cust-corp.name-short.
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
					/*########################################## 																Найдем счета */
					PayAcct = op-entry.acct-db.
					RateAcct = op-entry.acct-cr.
					LoanAcct = GetCredLoanAcct_ULL(Loan,"Кредит",beg_date, ULLShowErrorMsg).
					
					/*##########################################                Процентная ставка по кредиту 
																																																	 */
					Rate = GetCredLoanCommission_ULL(Loan,"%Кред",beg_date, ULLShowErrorMsg).
						
					/*##########################################               Сумма предварительной оплаты
						это есть ни что иное как параметр 6 
					*/


                    /* Здесь взяли ранее оплаченные проценты в предыдущем период */

/*                    Maslov D. A. #418 */
					PrePaySumma = getSumByOperInCurrPer(op-entry.op,Loan,10,beg_date,end_date) + MAXIMUM(0, abs(GetLoanParamValue_ULL("Кредит", Loan, 352, /*op-entry.op-date*/ end_date, ULLShowErrorMsg))).                   
										
					/*##########################################					
					Перед выполнением дальнейших действий, нужно расчитать таблицу процентов за период, найти 
					итоговую сумму, чтобы затем сравнить ее с суммой из проводки, дабы определить, какую сумму нужно 
					учесть в счет следующего процентного периода */
					
					/* сохраним будущий рисунок таблицы в переменную */
					StrTable =        "                                  РАСЧЕТ  ПРОЦЕНТОВ" + cr
									+	        "                             С  " + STRING(beg_date,"99/99/9999") 
													+ "  ПО  " + STRING(end_date, "99/99/9999") + cr
													+ "                                   (в валюте - " + LoanCur + ")" + cr
													+ "        ┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
													+ "        │ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
													+ "        │ задолженности    ├──────────┬──────────┤ дней   │        │ процентов        │" + cr
													+ "        │                  │     С    │    ПО    │        │        │                  │" + cr
													+ "        ├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.

					/* Найдем входящий остаток на счете за период и подпериоды начисления */
					Balance = GetCredLoanParamValue_ULL(Loan, 0, beg_date - 1, ULLShowErrorMsg).
					PeriodBegin = beg_date.
					PeriodEnd = end_date.
					DO idate = PeriodBegin TO PeriodEnd:
							NewBalance = GetCredLoanParamValue_ULL(Loan, 0, idate, ULLShowErrorMsg).
							NewRate = GetCredLoanCommission_ULL(Loan, "%Кред", idate + 1, ULLShowErrorMsg).
							IF Balance <>  NewBalance	OR Rate <> NewRate OR (DAY(idate + 1) = 1 AND idate < PeriodEnd) THEN
								/* Если изменилось сумма ссудной задолжености или процентная ставка по кредиту */
								DO:
									ASSIGN
										PeriodEnd = idate
										Period = PeriodEnd - PeriodBegin + 1
										Summa = Balance * Rate / PeriodBase * Period
										TotalSumma = TotalSumma + round(Summa,2)
										StrTable = StrTable + "        │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
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
					ASSIGN
						Period = PeriodEnd - PeriodBegin + 1
						Summa = Balance * Rate / PeriodBase * Period
						TotalSumma = TotalSumma + round(Summa,2)
						StrTable = StrTable + "        │" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
							+ "│" + STRING(PeriodBegin,"99/99/9999") 
							+ "│" + STRING(PeriodEnd,"99/99/9999") 
							+ "│" + STRING(Period,">>>>>>>>")
							+ "│" + STRING(Rate * 100,">>>9.99%")
							+ "│" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "│" + cr
					StrTable = StrTable + "        └──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
					 	                  + "                                                Начислено процентов:" + STRING(TotalSumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                                     Ранее погашено:" + STRING(PrePaySumma,">>>,>>>,>>>,>>9.99") + cr
					 	                  + "                                          ИТОГО (проценты к оплате):" + STRING(MAXIMUM(TotalSumma - PrePaySumma, 0),">>>,>>>,>>>,>>9.99") + cr.  
/*					 	                  + "                                          ИТОГО (проценты к оплате):" + STRING(MAXIMUM(TotalSumma, 0),">>>,>>>,>>>,>>9.99") + cr.*/
					
					/* В этом случае нужно вывести кое-что */
					Appendix1 = "                                       в том числе:" + cr
												+	"         за период с " + STRING(beg_date,"99/99/9999") + " по " + STRING(end_date,"99/99/9999") + " - " 
												/*ИСПРАВИЛ Красков А.С. Заявка #622		+ STRING(MINIMUM(MAXIMUM(TotalSumma - PrePaySumma, 0), Amount),">>>,>>>,>>>,>>9.99") + cr */
												/*ИСПРАВИЛ Маслов Д. А. ЗАЯВКА #691*/		
													+ STRING(Amount,">>>,>>>,>>>,>>9.99") + cr 
												/*ИСПРАВИЛ Красков А.С. Заявка #622 + "        в счет следующего процентного периода - " + STRING(MAXIMUM(0,Amount - MINIMUM(TotalSumma - PrePaySumma, Amount)),">>>,>>>,>>>,>>9.99") + cr */												
												+ "        в счет следующего процентного периода - " + STRING(GetLoanParamValue_ULL("Кредит",Loan, 381, end_date, ULLShowErrorMsg),">>>,>>>,>>>,>>9.99") + cr
												+       "        ───────────────────────────────────────────────────────────────────────────────" + cr.
					
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
				message "Судя по субаналитике - это не операция по погашению процентов!" view-as alert-box.
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
			"        Кредитный договор:   │№ " Loan " от " LoanDate format "99/99/9999" SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Валюта:              │" LoanCur SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Вид операции:        │Погашение процентов за кредит" SKIP
			"        ─────────────────────┴─────────────────────────────────────────────────────────" SKIP
			Appendix1 SKIP(3)
		  StrTable SKIP(7)
			"        " PIRbosloan SPACE(70 - LENGTH(PIRbosloan)) PIRbosloanFIO SKIP(4)
			"        Исполнитель: " ExecFIO SKIP(4)
			"        Отметка Департамента учета и отчетности:" SKIP.

/* ======================================================================================================= */
END.

{preview.i}