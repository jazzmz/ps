{pirsavelog.p}

/**
		Формирование распоряжения на перенос средств с одного депозитного счета на другой в рамках одного
		депозитного договора в связи с продлением срока окончания (пролонгацией).
		
		Бурягин Е.П., 12.03.2007 9:16
		
		Запускается из броузера договоров ЧВ.
		
		Процедура требует, чтобы на момент запуска дата окончания договора уже была 
		введена новая, и новый депозитный счет привязан.
		
		Процедура запрашивает дату распоряжения. Предполагается, что новый депозитный счет привязан 
		с этой даты. Старый депозитный счет процедура ищет на дату равную дате распоряжения за минусом один день.
*/

{globals.i}
{wordwrap.def}
{intrface.get xclass}
{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR docDate AS DATE LABEL "Дата распоряжения" FORMAT "99/99/9999". /** Дата распоряжения */
DEF VAR transDate AS DATE LABEL "Дата перевода средств" FORMAT "99/99/9999". /** Дата переноса средств */

DEF VAR client AS CHAR. /** ФИО клиента */
DEF VAR oldacct AS CHAR. /** Старый депозитный счет */
DEF VAR newacct AS CHAR. /** Новый депозитный счет */
DEF VAR amount AS DECIMAL. /** Переносимая сумма */
DEF VAR amountStr AS CHAR EXTENT 2. /** Она же прописью */
DEF VAR loanInfo AS CHAR. /** Номер и дата договора */
DEF VAR condInfo AS CHAR. /** Номер и дата доп.соглашения */
DEF VAR tmpStr AS CHAR EXTENT 10. /** Для временных нужд */
DEF VAR bankName AS CHAR. /** Наименования нашего банка */
DEF VAR i AS INTEGER. /** Итератор */


/** Наименование нашего банка из настроечного параметра */
{get-bankname.i}
bankName = cBankName.

/** Бос */
DEF VAR pirbosdps AS CHAR  NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR  NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

{ulib.i}

pause 0.
/** Запрашиваем даты */
docDate = TODAY.
transDate = TODAY.
UPDATE docDate SKIP transDate WITH FRAME editFrame CENTERED SIDE-LABELS OVERLAY.

{setdest.i}
 
/** Поиск выбранного договора */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
		LAST loan-cond WHERE 
			loan-cond.contract = loan.contract 
			AND 
			loan-cond.cont-code = loan.cont-code
			AND
			loan-cond.since LE docDate NO-LOCK
	:
		/** Возьмем дату открытия договора и наименование клиента */
		loanInfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date,client_short_name", false).
		client = ENTRY(2, loanInfo).
		loanInfo = loan.cont-code + " от " + ENTRY(1, loanInfo).
		
		/** Возьмем реквизиты доп.соглашения */
		condInfo = GetXAttrValueEx("loan-cond", loan.contract + "," + loan.cont-code + "," + STRING(loan-cond.since), "PIRNumber", "б/н")
				 + " от " + STRING(loan-cond.since, "99/99/9999").
				
		/** Возьмем счета */
		oldAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t", transDate - 1, false).
		newAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t", transDate, false).
		
		/** Сумма цифрами и прописью */
		amount = ABS(GetAcctPosValue_UAL(oldAcct, loan.currency, transDate, false)).
		Run x-amtstr.p(amount, loan.currency, true, true, 
				output amountStr[1], 
				output amountStr[2]).
	  amountStr[1] = amountStr[1] + ' ' + amountStr[2].
		Substr(amountStr[1],1,1) = Caps(Substr(amountStr[1],1,1)).
		
		/** в tmpStr сохраним основной текст распоряжения */
		tmpStr[1] = "#tabВ связи с продлением по " + STRING(loan.end-date, "99/99/9999") + " вкл. срока возврата вклада,"
						+ " размещенного по Договору банковского вклада №" + loanInfo + " г. (вкладчик - " + client + ")"
						+ " прошу перевести с депозитного счета №" + oldacct + " на депозитный счет №" + newAcct
						+ " сумму вклада в размере " + STRING(amount) + " (" + amountStr[1] + ") датой " 
						+ STRING(transDate, "99/99/9999") + " г. " + CHR(10)
						+ "#cr#crПрилагаемые документы: Дополнительное соглашение № " + condInfo + " к Договору банковского вклада №" 
						+ loanInfo + " г. (копия)".
						
		{wordwrap.i &s=tmpStr &l=80 &n=10}

		/** Формируем распоряжение */
		PUT UNFORMATTED SPACE(50) "В Департамент 3" SKIP
		SPACE(50) bankName SKIP(2)
		SPACE(50) 'Дата: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3).
		
		DO i = 1 TO 10:
							IF tmpstr[i] <> "" THEN DO:
								tmpstr[i] = REPLACE(tmpstr[i], "#tab",CHR(9)).
								tmpstr[i] = REPLACE(tmpstr[i], "#cr", CHR(10)).
								PUT UNFORMATTED tmpstr[i] SKIP.
							END.
		END.
		
		PUT "" SKIP(3).
		
		/** Подпись */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP.
						
		
END.
 
{preview.i}