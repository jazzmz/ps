{pirsavelog.p}
/**
 * Распоряжение об открытии лицевого счета.
 * Запускается из броузера депозитных договоров
 * Бурягин Е.П., 16.06.2006 10:19
 */
 
DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR docDate AS DATE NO-UNDO.
{getdate.i}
docDate = end-date.

DEF VAR account AS CHAR NO-UNDO.
DEF VAR balAcct AS CHAR NO-UNDO.
DEF VAR valStr AS CHAR NO-UNDO.
DEF VAR val AS CHAR NO-UNDO.
DEF VAR loanInfo AS CHAR NO-UNDO.
DEF VAR client AS CHAR NO-UNDO.
DEF VAR openDate AS CHAR NO-UNDO.

/** Бос */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR NO-UNDO. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).

{ulib.i}

{get-bankname.i}

{setdest.i}

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
		
		/** Формируем распоряжение */
		PUT UNFORMATTED SPACE(50) "В Управление открытия счетов и регистраий" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3)
		SPACE(4) 'Прошу на балансовом счете № ' balAcct ' открыть лицевой счет в ' valStr ' по Договору банковского' SKIP 
						'вклада № ' loanInfo ' (вкладчик - ' client ') датой ' openDate '.' SKIP(3).
		
		
		/** Подпись */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

		if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
END.

{preview.i}
 