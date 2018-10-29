{pirsavelog.p}
/** 
 * Распоряжение о зачислении суммы на депозитный счет.
 * Запускается из броузера депозитных договоров.
 * Бурягин Е.П., 16.06.2006 10:50
 */
 
DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR docDate AS DATE.
{getdate.i}
{get-bankname.i}
docDate = end-date.

DEF VAR account AS CHAR.
DEF VAR balAcct AS CHAR.
DEF VAR valStr AS CHAR.
DEF VAR val AS CHAR.
DEF VAR loanInfo AS CHAR.
DEF VAR client AS CHAR.
DEF VAR openDate AS CHAR.
DEF VAR amount AS DECIMAL.
DEF VAR amountStr AS CHAR EXTENT 2.
DEF VAR amountVal AS CHAR.
DEF VAR apdx AS CHAR.

/** Бос */
DEF VAR pirbosdps AS CHAR.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).

{ulib.i}
 
{setdest.i}
 
/** Поиск выбранного счета */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK,
		LAST loan-int WHERE loan.contract = loan-int.contract 
			AND loan.cont-code = loan-int.cont-code 
			AND loan-int.op-date LE docDate 
			AND loan-int.id-d = 0 NO-LOCK
	:
		account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Депоз", docDate, FALSE).
		balAcct = SUBSTRING(account,1,5).
		val = SUBSTRING(account,6,3).
		IF (val = "810") THEN
			valStr = "рублях".
		IF (val = "840") THEN
			valStr = "долларах США".
		IF (val = "978") THEN
			valStr = "ЕВРО".
		loanInfo = loan.cont-code + " от " + STRING(loan.open-date, "99/99/9999").
		client = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE).
		openDate = STRING(loan-int.op-date, "99/99/9999").
		amount = loan-int.amt-rub.
		
		Run x-amtstr.p(amount, loan.currency, true, true, 
				output amountStr[1], 
				output amountStr[2]).
	  amountStr[1] = amountStr[1] + ' ' + amountStr[2].
		Substr(amountStr[1],1,1) = Caps(Substr(amountStr[1],1,1)).
		amountVal = SUBSTRING(account,6,3).
		
		apdx = IF loan-int.op-date <> loan.open-date THEN "как пополнение вклада" ELSE "".
		
		/** Формируем распоряжение */
		PUT UNFORMATTED SPACE(50) "В Департамент 4" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3)
		SPACE(4) 'В соответствии с Договором банковского вклада № ' loanInfo ' (вкладчик - ' SKIP
							client ') зачислить денежные средства в сумме ' amount '/' amountVal SKIP
							'(' amountStr[1] ') на депозитный счет' SKIP
							'№ ' account ' в ' + cBankName + ' датой ' openDate ' ' apdx '.' SKIP(3).
		
		
		/** Подпись */
		PUT UNFORMATTED "Департамент 3" SKIP (2).
		/** Подпись */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

		if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
		

END.

{preview.i}
