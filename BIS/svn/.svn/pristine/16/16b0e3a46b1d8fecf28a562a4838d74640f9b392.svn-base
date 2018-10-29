{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirloan029.p,v $ $Revision: 1.7 $ $Date: 2011-02-15 14:45:58 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Формирует печатную форму распоряжения по учету Доп.соглашения. к договору 
                 поручительства/залога с изменением суммы.
     Как работает: 
     Параметры: {1|2},{Да|Нет} 
                где [1] - тип договора обеспечения (1 - поручительство, 2 - залог)
                    [2] - выводить ли в тексте изменение суммы.
     Место запуска: Броузер кредитных договоров.
     Автор: $Author: kraskov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.6  2010/12/28 13:02:08  borisov
     Изменения: U Maslova ne rabotaet CVS
     Изменения:
     Изменения: Revision 1.4  2010/09/30 08:57:59  Buryagin
     Изменения: Fix: added a amount value into the combo-box widget for the list of warranties.
     Изменения:
     Изменения: Revision 1.3  2008/05/21 13:31:39  Buryagin
     Изменения: *** empty log message ***
     Изменения:
     Изменения: Revision 1.2  2007/10/18 07:42:23  anisimov
     Изменения: no message
     Изменения:
     Изменения: Revision 1.1  2007/09/21 12:28:22  buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */


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

DEF VAR contNum AS CHAR LABEL "Доп.согл. НОМЕР" FORMAT "x(10)" NO-UNDO.
DEF VAR contDate AS DATE LABEL "ДАТА" FORMAT "99/99/9999" NO-UNDO.

DEF VAR oblNum AS CHAR LABEL "Номер обеспечения" FORMAT "x(20)"
	VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 5
.

DEF VAR end-date AS DATE LABEL "Дата расчета" FORMAT "99/99/9999" NO-UNDO.

DEF FRAME editFrame 
	contNum contDate SKIP 
	oblNum SKIP 
	end-date LABEL "Дата распоряжения" SKIP
	amount LABEL "Сумма изменения" FORMAT "->>>,>>>,>>>,>>9.99"
	WITH SIZE 60 BY 6 SIDE-LABELS CENTERED OVERLAY TITLE "Введите данные".


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
				oblNum:ADD-LAST(GetXAttrValueEx("term-obl", srgt, "НомДогОб", "б/н") + " - " + STRING(term-obl.amt-rub), STRING(RECID(term-obl))) IN FRAME editFrame.
		END.
				
		DISPLAY contNum contDate oblNum end-date amount WITH FRAME editFrame.
		
		
		/** Если 2-ой параметр = Да, то пользователь должен ввести сумму */
		IF ENTRY(2, iParam) = "Да" THEN 
			DO:
				SET contNum contDate oblNum end-date amount WITH FRAME editFrame.
				RUN x-amtstr.p(ABS(amount), loan.currency, true, true, output amount-str[1], output amount-str[2]).
							amount-str[1] = amount-str[1] + ' ' + amount-str[2].
				substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
			END.
		ELSE
			SET contNum contDate oblNum end-date WITH FRAME editFrame.
		
		FIND FIRST term-obl WHERE RECID(term-obl) = INT(oblNum:SCREEN-VALUE) 
				NO-LOCK.
		
		/** Собираем всю необходимую информацию */
		
		/** Номер и дата обеспечения */
		srgt = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) 
					+ "," + STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
		terminfo = GetXAttrValueEx("term-obl", srgt, "НомДогОб", "б/н") + " от " + STRING(term-obl.fop-date, "99.99.9999").
		
		/** Номер и дата договора, наименование клиента, наименование поручителя */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date,guarantor_name(" + STRING(RECID(term-obl)) + ")", true).
		client = ENTRY(1, loaninfo).
		guarantor = ENTRY(3, loaninfo).

		loaninfo = loan.cont-code + " от " + ENTRY(2,loaninfo).

		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/

		str[1] = "#tabПрошу принять Дополнительное соглашение №" + contNum + " от " + STRING(contDate, "99.99.9999") 
										+ " к Договору " + oblType[oblTypeIdx] + " №" + terminfo
										+ ', заключенному между ' + bankname + ' и ' + guarantor 
										+ ", для дальнейшего учета". 

		IF ENTRY(2, iParam) = "Да" THEN 
			DO:
				str[1] = str[1] + " и " + (IF amount >= 0 THEN "увеличить" ELSE "уменьшить") + " сумму " + oblType[oblTypeIdx] 
				         + " на " + STRING(ABS(amount)) + " (" + amount-str[1] + ") датой " + STRING(end-date, "99.99.9999") + "г".
			END.
		
		str[1] = str[1] + "." + CHR(10)
						 + "#cr#tabПрилагаемые документы: Дополнительное соглашение №" + contNum + " от " 
						 + STRING(contDate, "99.99.9999") + " к Договору " + oblType[oblTypeIdx] + " №" + terminfo + " (копия).".
						
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

