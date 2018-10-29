{pirsavelog.p}

/**

	Формирование печатной формы распоряжения по учету поручительства/залога.
	
	Бурягин Е.П., 03.03.2007 9:22
	
	Тип обеспечения (поручительство, залог, ...) задается в параметре процедуры индексом согласно 
	следующему списку (при появлении новых типов обеспечения добавить также):
	1 - Поручительство
	2 - Залог

*/

{globals.i} /** Определение глобальных параметров, настроек и т.п. */
{ulib.i} /* Подключаю свою библиотеку функций */
{wordwrap.def} /** Определение утилиты переноса по словам */

/* Таблица идентификаторов записей, выбранных в каком-либо броузере */
{tmprecid.def}
{get-bankname.i}

pause 0.

DEF INPUT PARAM iParam AS CHAR.
DEF VAR oblTypeIdx AS INTEGER NO-UNDO. /** Индекс в массиве oblType */
DEF VAR amount AS DECIMAL NO-UNDO. /** сумма обеспечения */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** сумма прописью */
DEF VAR terminfo AS CHAR NO-UNDO. /** номер и дата обеспечения */
DEF VAR loaninfo AS CHAR NO-UNDO. /** номер и дата договора */
DEF VAR client AS CHAR NO-UNDO. /** Наименование клиента */
DEF VAR guarantor AS CHAR NO-UNDO. /** Наименование поручителя */

DEF VAR bankname AS CHAR NO-UNDO. /** Наименование банка */

DEF VAR str AS CHAR EXTENT 15 NO-UNDO. /** Текст распоряжения */

DEF VAR i AS INTEGER NO-UNDO. /* Итератор */

DEF VAR bosLoan AS CHAR NO-UNDO. /* Начальник кредитного отдела */
DEF VAR execUser AS CHAR NO-UNDO. /* Исполнитель */

DEF VAR srgt AS CHAR NO-UNDO. /** значение поля signs.surrogate */

DEF VAR oblNum AS CHAR LABEL "Номер обеспечения" FORMAT "x(20)"
	VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 5 NO-UNDO.
DEF VAR end-date AS DATE LABEL "Дата расчета" FORMAT "99/99/9999" NO-UNDO.

DEF FRAME editFrame 
	"" SKIP oblNum SKIP 
	end-date LABEL "Дата распоряжения"
	WITH SIZE 60 BY 4 SIDE-LABELS CENTERED OVERLAY TITLE "Введите данные".


/** В этом массиве хранятся названия типов обеспечений в родительном падеже. Индекс исползуемого элемента
    задается в параметре iParam настоящей функции */
DEF VAR oblType AS CHAR EXTENT 2 INITIAL ["поручительства", "залога"] NO-UNDO.

/***** Р Е А Л И З А Ц И Я *****/

/** Разберем параметр процедуры */
oblTypeIdx = INT(ENTRY(1, iParam)) NO-ERROR.
IF ERROR-STATUS:ERROR OR oblTypeIdx > EXTENT(oblType) OR oblTypeIdx < 1 THEN DO:
	MESSAGE "Ошибка задания параметра процедуры! Значение должно быть целым числом от 1 до " + STRING(EXTENT(oblType)) + "."
	     VIEW-AS ALERT-BOX.
	RETURN.
END.

/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
/** Прочитаем исполнителя */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** Наименование банка из настроечного параметра */
bankname = cBankName.


/** Для первого выбранного кредитного договора делаем... */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
	:
		/** Нужно, чтобы пользователь задал дату и выбрал из предложенного ему списка тот договор обеспечения
		    по которому ему необходимо распечатать распоряжение */
		FOR EACH term-obl WHERE 
				term-obl.contract = loan.contract
				AND
				term-obl.cont-code = loan.cont-code
				AND
				term-obl.idnt = 5 
				NO-LOCK
			:
				srgt = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) 
							+ "," + STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
				oblNum:ADD-LAST(GetXAttrValueEx("term-obl", srgt, "НомДогОб", "б/н"), STRING(RECID(term-obl))) IN FRAME editFrame.
		END.
				
		DISPLAY oblNum SKIP end-date WITH FRAME editFrame.
		
		SET oblNum end-date WITH FRAME editFrame.
		
		FIND FIRST term-obl WHERE RECID(term-obl) = INT(oblNum:SCREEN-VALUE) 
				NO-LOCK.
		
		/** Собираем всю необходимую информацию */
		/** Сумма обеспечения цифрами и прописью */
		amount = term-obl.amt-rub.

        /*
            Modifed By Maslov D. A.
            Event #458
        */
		RUN x-amtstr.p(amount, term-obl.currency, true, true, output amount-str[1], output amount-str[2]).

		amount-str[1] = amount-str[1] + ' ' + amount-str[2].
		substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
		
		/** Номер и дата обеспечения */
		srgt = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) 
					+ "," + STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
		terminfo = GetXAttrValueEx("term-obl", srgt, "НомДогОб", "б/н") + " от " + STRING(term-obl.fop-date, "99/99/9999").
		
		/** Номер и дата договора, наименование клиента, наименование поручителя */

		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date,guarantor_name(" + STRING(RECID(term-obl)) + ")", true).
		client = ENTRY(1, loaninfo).
		guarantor = ENTRY(3, loaninfo).

		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/

		str[1] = "#tabПрошу учесть Договор " + oblType[oblTypeIdx] + " №" + terminfo
										+ " на сумму " + STRING(amount) + " (" + amount-str[1] + ")"
										+ ', заключенный между ' + bankname + ' и ' + guarantor 
										+ ", как обеспечение по Кредитному договору №" + loaninfo
										+ ', заключенному между ' + bankname + ' и ' + client + "." + CHR(10) 
										+ "#cr#tabПрилагаемые документы: Договор " + oblType[oblTypeIdx] + " №" + terminfo + " (копия).".
						
		/** Собственно преренос по словам */
		{wordwrap.i &s=str &l=75 &n=15}
					

		/** Определяем поток вывода в стандартный файл. Каждое распоряжение в отдельный файл */
		{setdest.i}
		
		/** Вывод в поток */
		PUT UNFORMATTED 
	  						SPACE(50) "В Департамент 3" SKIP
								SPACE(50) bankname SKIP(2)
	     	        SPACE(50) "Дата: " STRING(end-date, "99/99/9999") SKIP(4)
	     		      SPACE(20) "Р А С П О Р Я Ж Е Н И Е" SKIP(2).
		DO i = 1 TO 15:
			IF str[i] <> "" THEN DO:
				str[i] = REPLACE(str[i], "#tab",CHR(9)).
				str[i] = REPLACE(str[i], "#cr", CHR(10)).
				PUT UNFORMATTED str[i] SKIP.
			END.
		END.

		PUT UNFORMATTED "" SKIP(3) SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) 'Исполнитель: ' execUser SKIP.
		
		
		/** Показываем распоряжение на экране */
		{preview.i}
END.

