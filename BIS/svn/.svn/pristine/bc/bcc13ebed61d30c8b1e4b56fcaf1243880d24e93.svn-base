{pirsavelog.p}

/**
		Формирование печатной формы распоряжения на перенос ссудной задолженности с одного лицевого счета на другой лицевой счет
		в рамках одного кредитного договора в связи с пролонгацией.
		
		Бурягин Е.П., 03.03.2007 14:28
		
*/

/***** О П Р Е Д Е Л Е Н И Я *****/

{globals.i}
{ulib.i} /** Библиотека функций для работы с кредитными договорами */
{wordwrap.def} /** Определение утилиты переноса по словам */
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}

DEF VAR oldaccount AS CHAR NO-UNDO. /** номер "старого" ссудного счета  */
DEF VAR newaccount AS CHAR NO-UNDO. /** номер "старого" ссудного счета  */

DEF VAR amount AS DECIMAL NO-UNDO. /** сумма лимита */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** сумма прописью */
DEF VAR loaninfo AS CHAR NO-UNDO. /** номер и дата договора */
DEF VAR client AS CHAR NO-UNDO. /** Наименование клиента */

DEF VAR bankname AS CHAR NO-UNDO. /** Наименование банка */

DEF VAR str AS CHAR EXTENT 10 NO-UNDO. /** Текст распоряжения */

DEF VAR i AS INTEGER NO-UNDO. /* Итератор */
                     
DEF VAR end-date AS DATE NO-UNDO. /** Дата распоряжения */
DEF VAR opDate AS DATE NO-UNDO. /** Дата операции переноса средств */

DEF VAR bosD2 AS CHAR NO-UNDO. /* Начальник Д2 */
DEF VAR bosLoan AS CHAR NO-UNDO. /* Начальник кредитного отдела */
DEF VAR bosKazna AS CHAR NO-UNDO. /* Начальник казначейства */
DEF VAR execUser AS CHAR NO-UNDO . /* Исполнитель */

def var summ as dec 
	     LABEL "Сумма"
		
        NO-UNDO.

/** Основание */
DEF VAR evidence AS CHAR 
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7.


/***** Р Е А Л И З А Ц И Я *****/

/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
bosKazna = FGetSetting("PIRboss","PIRbosKazna","").

/** Прочитаем исполнителя */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** Наименование банка из настроечного параметра */
bankname = cBankName.

/** Запрашиваем дату распоряжения и дату операции */
/** Запрос текста основания */
pause 0.
end-date = TODAY. opDate = TODAY.
UPDATE end-date LABEL "Дата распоряжения" opDate LABEL "Дата переноса" SKIP evidence SKIP summ FORMAT ">>>,>>>,>>>,>>9.99"  WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

/** Поток вывода в preview */
{setdest.i &cols=90}

FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
	:
		/** Номер и дата договора, наименование клиента */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
		client = ENTRY(1, loaninfo).

		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/
		
		/** Счета договора */
		newaccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Кредит", end-date, false).
		/** Предполагается, что распоряжение формируется в день привязки нового счета */
		oldaccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Кредит", end-date - 1, false).
		
		/** Остаток ссудной задолженности цифрами и прописью */
		amount = GetAcctPosValue_UAL(oldaccount, loan.currency, end-date, false).

		if summ > amount then do:
		message "Остаток на счете: " amount VIEW-AS ALERT-BOX.
                end.
		if summ <> 0 and summ <= amount then amount = summ.

		RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
		amount-str[1] = amount-str[1] + ' ' + amount-str[2].
		substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).

		/** Основной текст распоряжения */
		str[1] = "#tabВ связи продлением по " + STRING(loan.end-date, "99/99/9999") + " вкл. срока возврата кредита, "
						+ "выданного по Кредитному договору №" + loaninfo + " (заемщик - " + client 
						+ "), прошу перенести со счета №" + oldaccount + " на счет №" + newaccount
						+ " сумму в размере " + STRING(amount) + " (" + amount-str[1] + ") датой " + STRING(opDate, "99/99/9999") 
						+ "г.".
						
		/** Преренос по словам */
		{wordwrap.i &s=str &l=75 &n=10}
					
		/** Вывод в поток */
		PUT UNFORMATTED 
												SPACE(50) "Утверждаю" SKIP
												SPACE(50) ENTRY(1, bosD2) SKIP
												SPACE(50) ENTRY(2, bosD2) SKIP(2)
												SPACE(50) "В Департамент 3" SKIP
												SPACE(50) bankname SKIP(2)
				                SPACE(50) "Дата: " STRING(end-date, "99/99/9999") SKIP(4)
				                SPACE(20) "Р А С П О Р Я Ж Е Н И Е" SKIP(2).
				
		DO i = 1 TO 10:
							IF str[i] <> "" THEN DO:
								str[i] = REPLACE(str[i], "#tab",CHR(9)).
								str[i] = REPLACE(str[i], "#cr", CHR(10)).
								PUT UNFORMATTED str[i] SKIP.
							END.
		END.
				
		PUT UNFORMATTED "" SKIP(3) "Основание: " evidence "(копия)" SKIP(4) 
						SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(3)
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) 'Исполнитель: ' execUser SKIP.
		
END.


/** Вывод на экран */
{preview.i}
