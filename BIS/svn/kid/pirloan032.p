{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirloan032.p,v $ $Revision: 1.4 $ $Date: 2011-02-15 14:45:58 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Формирует печатную форму распоряжения по простому учету дополнительного соглашения по кредитному договору
     Как работает: 
     Параметры: 
     Место запуска: Броузер кредитных договоров.
     Автор: $Author: kraskov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.3  2010/12/28 13:02:08  borisov
     Изменения: U Maslova ne rabotaet CVS
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
DEF VAR loaninfo AS CHAR NO-UNDO. /** номер и дата договора */
DEF VAR client AS CHAR NO-UNDO. /** Наименование клиента */

DEF VAR bankname AS CHAR NO-UNDO. /** Наименование банка */

DEF VAR str AS CHAR EXTENT 15 NO-UNDO. /** Текст распоряжения */

DEF VAR i AS INTEGER NO-UNDO. /* Итератор */

DEF VAR bosLoan AS CHAR NO-UNDO. /* Начальник кредитного отдела */
DEF VAR execUser AS CHAR NO-UNDO. /* Исполнитель */

DEF VAR contNum AS CHAR LABEL "Доп.согл. НОМЕР" FORMAT "x(10)" NO-UNDO.
DEF VAR contDate AS DATE LABEL "ДАТА" FORMAT "99/99/9999" NO-UNDO.

DEF VAR end-date AS DATE LABEL "Дата расчета" FORMAT "99/99/9999" NO-UNDO.

DEF FRAME editFrame 
	contNum contDate SKIP 
	end-date LABEL "Дата распоряжения" SKIP
	WITH SIZE 60 BY 6 SIDE-LABELS CENTERED OVERLAY TITLE "Введите данные".


/***** Р Е А Л И З А Ц И Я *****/


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
				
		DISPLAY contNum contDate end-date WITH FRAME editFrame.
		
		SET contNum contDate end-date WITH FRAME editFrame.

		/** Собираем всю необходимую информацию */
		
		/** Номер и дата договора, наименование клиента */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
		client = ENTRY(1, loaninfo).
		loaninfo = loan.cont-code + " от " + ENTRY(2,loaninfo) + "г.".
		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/

		str[1] = "#tabПрошу принять Дополнительное соглашение №" + contNum + " от " + STRING(contDate, "99.99.9999") 
										+ " к Кредитному договору №" + loaninfo
										+ ', заключенному между ' + bankname + ' и ' +  client
										+ ", для дальнейшего учета"
					    	    + "#cr#tabПрилагаемые документы: Дополнительное соглашение №" + contNum + " от " + STRING(contDate, "99.99.9999") 
		  				      + " к договору №" + loaninfo + " (копия).".
						
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

		PUT UNFORMATTED "" SKIP(3) 
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) 'Исполнитель: ' execUser SKIP.
		
		
		/** Показываем распоряжение на экране */
		{preview.i}
END.

