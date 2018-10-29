{pirsavelog.p}

/** 
	pirloan018.p
	Формирование распоряжение по открытию лимита выдачи/задолженности.
	Бурягин Е.П., 10.01.2007 17:19
	
	Процедура запускается из броузера договоров.
		
*/

/***** О П Р Е Д Е Л Е Н И Я *****/

{globals.i}
{ulib.i} /** Библиотека функций для работы с кредитными договорами */
{wordwrap.def} /** Определение утилиты переноса по словам */
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}

DEF VAR account AS CHAR. /** номер счета для учета лимита */
DEF VAR amount AS DECIMAL. /** сумма просроченного кредита */
DEF VAR amount-str AS CHAR EXTENT 2. /** сумма прописью */
DEF VAR loaninfo AS CHAR. /** номер и дата договора */
DEF VAR client AS CHAR. /** Наименование клиента */

DEF VAR bankname AS CHAR. /** Наименование банка */

DEF VAR str AS CHAR EXTENT 10. /** Текст распоряжения */

DEF VAR i AS INTEGER. /* Итератор */

DEF VAR bosLoan AS CHAR. /* Начальник кредитного отдела */
DEF VAR bosD2 AS CHAR. /* Начальник Д2 */
DEF VAR execUser AS CHAR. /* Исполнитель */

/** Основание */
DEF VAR evidence AS CHAR 
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7.


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
		
				/** Возьмем лимит выдачи/задолженности */
				amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date, false).

				IF amount > 0 THEN 
					DO:
						/** Выбираем информацию **/
						account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредЛин,КредН", end-date, false).
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
				
						str[1] = "Учесть на счете №" + account + " открытие лимита " + 
										(IF account BEGINS "91316" THEN "выдачи" ELSE "задолженности") + " на сумму " +
										STRING(amount) + " (" + amount-str[1] + ") по Кредитному договору №" + loaninfo + 
										', заключенному между ' + bankname + ' и ' + client + ".".
							
						/** Собственно преренос по словам */
						{wordwrap.i &s=str &l=75 &n=10}
				
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
				
						PUT UNFORMATTED "" SKIP(3) "Основание: " evidence SKIP(4) 
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) 'Исполнитель: ' execUser SKIP.
				
						PUT UNFORMATTED CHR(12).
						
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