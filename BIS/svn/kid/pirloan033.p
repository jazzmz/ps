/** 
	переделан из pirloan019.p
	Формирование распоряжение по открытию(переделан из увеличения) лимита выдачи/задолженности.
	Бурягин Е.П., 12.01.2007 12:18
	
	Процедура запускается из броузера договоров.

	26.09.11 Внебалансовый счет - если нет на транше, то пробуем взять с охватывающего договора
*/

/* должен передаваться список классов по которым будет печатать "договору овердрафта" для остальных "Кредитному договору"*/
DEF INPUT PARAM ip_over_class-code AS CHAR. 

/***** О П Р Е Д Е Л Е Н И Я *****/

{globals.i}

{ulib.i} /** Библиотека функций для работы с кредитными договорами */

{wordwrap.def} /** Определение утилиты переноса по словам */

{get-bankname.i}


{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR account AS CHAR NO-UNDO. /** номер счета для учета лимита */
DEF VAR amount AS DECIMAL NO-UNDO. /** сумма просроченного кредита */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** сумма прописью */
DEF VAR loaninfo AS CHAR NO-UNDO. /** номер и дата договора */
DEF VAR client AS CHAR NO-UNDO. /** Наименование клиента */

DEF VAR bankname AS CHAR NO-UNDO. /** Наименование банка */

DEF VAR str AS CHAR EXTENT 10 NO-UNDO. /** Текст распоряжения */

DEF VAR i AS INTEGER NO-UNDO. /* Итератор */

DEF VAR bosLoan AS CHAR NO-UNDO. /* Начальник кредитного отдела */
DEF VAR bosD2 AS CHAR NO-UNDO. /* Начальник Д2 */
DEF VAR execUser AS CHAR NO-UNDO. /* Исполнитель */

/** Основание */
DEF VAR evidence1 AS CHAR EXTENT 10  NO-UNDO.
DEF VAR evidence AS CHAR 
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.


/***** Р Е А Л И З А Ц И Я *****/

/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
/** Прочитаем исполнителя */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** Наименование банка из настроечного параметра */
bankname = cBankName.

/** Запрашиваем дату распоряжения - beg-date = end-date = введенной_дате */
{getdate.i} 

/** Запрос текста основания */
SET evidence WITH FRAME frmTmp CENTERED.

/** Поток вывода в preview */
{setdest.i}


/** Для каждого выбранного договора... */
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		/** Договор должен быть пересчитан на дату распоряжения + 1 день */
		IF TRUE THEN 
			DO:
		

/* message (loan.contract, loan.cont-code, end-date, false)
GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date - 1, false). */
				/** Возьмем лимит выдачи/задолженности */
				amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date, false)
									- GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date - 1, false).

				IF amount > 0 THEN 
					DO:
						DEF VAR cLoanName AS CHAR NO-UNDO.
						cLoanName = (IF CAN-DO(ip_over_class-code, loan.class-code)
							THEN "договору овердрафта"
							ELSE "Кредитному договору").

						/** Выбираем информацию */
						account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредЛин,КредН", end-date, false).
						IF account = "" OR account = ? /* если нет на транше, то пробуем взять с охватывающего договора */
						  THEN account = GetLoanAcct_ULL(loan.contract, SUBSTR(loan.cont-code, 1, 9), "КредЛин,КредН", end-date, false).
						
						loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).

						client = ENTRY(1, loaninfo).

						/******************************************
						 * Автор: Маслов Д. А. (Maslov D. A.)
						 * Заявка (Event): #607
						 ******************************************/
							loaninfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
						/*** Конец #607 ***/

						/** Сумма прописью */
						RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
						amount-str[1] = amount-str[1] + ' ' + amount-str[2].
						substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
				
						str[1] = /* "Увеличить лимит " + (IF account BEGINS "91316" THEN "выдачи" ELSE "задолженности")
						         + ", учитываемый на внебалансовом */

							 "Учесть на внебалансовом счете №" + account + ", открытие лимита " + (IF account BEGINS "91316" THEN "выдачи" ELSE "задолженности") + " в сумме "
						         + STRING(amount) + " (" + amount-str[1] + ") по " + cLoanName + " №" + loaninfo 
						         + ', заключенному между ' + bankname + ' и ' + client + ".".
						
						/** Собственно преренос по словам */
						{wordwrap.i &s=str &l=75 &n=10}
						evidence1[1] = evidence.
				                {wordwrap.i &s=evidence1 &l=75 &n=10}
						/** Вывод в поток */
						PUT UNFORMATTED 
												SPACE(50) "Утверждаю" SKIP
												SPACE(50) ENTRY(1,bosD2) SKIP
												SPACE(50) ENTRY(2,bosD2) SKIP(2)
												SPACE(50) "В Департамент 3" SKIP
												SPACE(50) bankname SKIP(2)
				                SPACE(50) "Дата: " STRING(end-date, "99/99/9999") SKIP(4)
				                SPACE(20) "Р А С П О Р Я Ж Е Н И Е" SKIP(2)
				                SPACE(4) str[1] SKIP.
				
						DO i = 2 TO 10:
							IF str[i] <> "" THEN DO:
								PUT UNFORMATTED str[i] SKIP.
							END.
						END.
				
						PUT UNFORMATTED "" SKIP(3) "Основание:  " evidence1[1] skip. 
						DO i = 2 TO 10:
							IF evidence1[i] <> "" THEN DO:
								PUT UNFORMATTED evidence1[i] SKIP.
							END.
						END.
PUT UNFORMATTED                                 skip(2)
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) 'Исполнитель: ' execUser SKIP.
				
						PUT UNFORMATTED CHR(12).
						
					END.
					ELSE
					 DO:
						PUT UNFORMATTED "Не определена сумма изменения лимита выдачи. Проверьте заведено ли условие на изменения лимита выдачи!" SKIP.
					 END.
				
				/** Конец вывода в поток */
				
 
			
			END. 
		ELSE 
			MESSAGE "Договор " + loan.cont-code + 
							" должен быть пересчитан на дату большую, чем " + STRING(end-date,"99/99/9999")
							VIEW-AS ALERT-BOX.
		
END.	

/** Вывод на экран */
{preview.i}
	