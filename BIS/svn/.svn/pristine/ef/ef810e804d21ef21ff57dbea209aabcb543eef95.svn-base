{pirsavelog.p}

/**
 * Распоряжение о закрытии лицевого счета.
 * Запускается из броузера депозитных договоров
 * Бурягин Е.П., 11.08.2006 9:39
 */
 
DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR docDate AS DATE.
docDate = TODAY.

DEF VAR account AS CHAR.
DEF VAR balAcct AS CHAR.
DEF VAR valStr AS CHAR.
DEF VAR val AS CHAR.
DEF VAR loanInfo AS CHAR.
DEF VAR client AS CHAR.
DEF VAR openDate AS CHAR.
DEF VAR closeDate AS DATE.
DEF VAR str AS CHAR EXTENT 5.
DEF VAR i AS INTEGER.

/** Бос */
DEF VAR pirbosdps AS CHAR.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).

{ulib.i}
{get-bankname.i}

{wordwrap.def}
 
 
/** Поиск выбранного счета */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
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
		openDate = STRING(loan.open-date, "99/99/9999").
		closeDate = loan.end-date.
		
		pause 0.
		
		DISPLAY 
			"Договор            :" loanInfo FORMAT "x(30)" SKIP
			"Дата распоряжения  :" docDate SKIP
			"Дата закрытия      :" closeDate SKIP
		WITH FRAME frmGetDate OVERLAY CENTERED ROW 8 NO-LABELS
		TITLE COLOR BRIGTH-WHITE "[ Введите ]".

		UPDATE 
			docDate
			closeDate
		WITH FRAME frmGetDate.
		HIDE FRAME frmGetDate.
		

		{setdest.i}

		str[1] = 'В связи с невозможностью дальнейшего использования счетов (окончание срока ' +
		          'договоров, пролонгация) для последующих операций закрыть депозитный счет ' +
		         account + ' вкладчик ' + client + ' датой ' + STRING(closeDate, "99/99/9999") + ".".		
		{wordwrap.i &s=str &l=80 &n=5}
		
		/** Формируем распоряжение */
		PUT UNFORMATTED SPACE(50) "В Управление открытия счетов и регистраий" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3)
		SPACE(4) str[1] SKIP.
		
		DO i = 2 TO 5:
			IF str[i] <> "" THEN PUT UNFORMATTED str[i] SKIP.
		END.
		
		/*
		SPACE(4) 'Прошу на балансовом счете № ' balAcct ' открыть лицевой счет в ' valStr ' по Договору банковского' SKIP 
						'вклада № ' loanInfo ' (вкладчик - ' client ') датой ' openDate '.' SKIP(3).
		*/
		
		/** Подпись */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

		if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
		
		{preview.i}

END.

 