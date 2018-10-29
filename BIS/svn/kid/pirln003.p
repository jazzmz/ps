{pirsavelog.p}

/*
**	Бурягин Е.П.
**	06.12.2005 12:11
**	Процедура формирования распоряжения по погашению основного долга по кредитному договору
*/

{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */
{ulib.i}
{get-bankname.i}

def var ClientName as char no-undo.
def var Loan as char no-undo.
def var LoanDate as date no-undo.
def var PayAcct as char no-undo.
def var LoanAcct as char no-undo.
def var Amount as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var StrEarlyPartic as char no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var PIRbosloan as char no-undo.
def var PIRbosloanFIO as char no-undo.
def var LoanCur as char no-undo.
PIRbosloan = ENTRY(1,FGetSetting("PIRboss","PIRbosloan","")).
PIRbosloanFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosloan","")).

/* ========================================================================= */


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
	/* Сумма прописью */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	
	
	find first loan-acct where 
			loan-acct.acct = op-entry.acct-cr 
			and
			loan-acct.acct-type = "Кредит"
			no-lock no-error.
	if avail loan-acct then
		do:
			/* Ссудный счет */
			LoanAcct = loan-acct.acct.
			LoanCur = SUBSTRING(LoanAcct,6,3).
			
			find first loan where
				loan.contract = loan-acct.contract 
				and 
				loan.cont-code = loan-acct.cont-code
			no-lock no-error.
			if avail loan then
				do:
					/* Номер договора */
					Loan = loan.cont-code.
					
					/* Дата открытия */
					LoanDate = loan.open-date.
					find first signs where 
							signs.code = "ДатаСогл"
							and
							signs.file-name = "loan"
							and
							signs.surrogate = "Кредит," + Loan
							no-lock no-error.
					if avail signs then
						LoanDate = DATE(signs.code-value).
							
					/* Получим название клиента */

					ClientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).

					/** Buryagin commented at 6/10/2010
					if loan.cust-cat = "Ю" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
									ClientName = cust-corp.cust-stat + " " + cust-corp.name-corp.
									ClientName = cust-corp.name-short.
								end.
							else
								message "У договора нет клиента!" view-as alert-box.
						end.
					if loan.cust-cat = "Ч" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								do:
									ClientName = person.name-last + " " + person.first-names.
								end.
						end.
					Получили название клиента */
					
				end.
			else
				message "Счет по кредиту привязан к несуществующему договору!" view-as alert-box.
		end.
	else
		message "Счет по кредиту не привязан к кредитному договору или не является ссудным счетом!" view-as alert-box.
	
	PayAcct = op-entry.acct-db.
	
/* ======================================================================================================= */
{setdest.i}

put unformatted SPACE(50) "В Департамент 3" SKIP
								SPACE(50) "В Департамент 4" SKIP
								SPACE(50) cBankName SKIP(3)
								SPACE(50) op.op-date FORMAT "99/99/9999" SKIP(5)
			SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP(3)
			"            Произвести  з а ч и с л е н и е  денежных средств:" SKIP(2)
			"        ─────────────────────┬─────────────────────────────────────────────────────────" SKIP
			"        Сумма:               │" Amount format ">,>>>,>>>,>>>,>>9.99" SKIP
			"                             │(" AmtStr[1] ")" SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        На счет:             │" LoanAcct format "x(20)" SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Заемщик:             │" ClientName SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Корреспондирующий    │" PayAcct SKIP
			"        счет:                │" SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Кредитный договор:   │" getMainLoanAttr(loan.contract,loan,"№ %cont-code от %ДатаСогл")  SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Валюта:              │" LoanCur SKIP
			"        ─────────────────────┼─────────────────────────────────────────────────────────" SKIP
			"        Вид операции:        │Погашение основного долга по кредиту" SKIP
			"        ─────────────────────┴─────────────────────────────────────────────────────────" SKIP(4)
			"       " PIRbosloan SPACE(70 - LENGTH(PIRbosloan)) PIRbosloanFIO SKIP(4)
			"        Исполнитель: " ExecFIO SKIP(4)
			"        Отметка Департамента учета и отчетности:" SKIP.

{preview.i}
/* ======================================================================================================= */
END.

