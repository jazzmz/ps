{pirsavelog.p}

/**
		Распоряжение на безакцептное списание суммы в счет погашения просроченной ссудной задолженности.
		Бурягин Е.П., 09.04.2007 10:47
		Запускается из броузера кредитных договоров.
		Запрашивает дату распоряжения, сумму, которую необходимо списать и основание распоряжения.
*/

/** Глобальные переменные и определения */
{globals.i}
/** Моя Библиотека функций */
{ulib.i}
/** Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}

/** Счет, с которого списывают средства */
DEF VAR from_acct AS CHAR NO-UNDO.
/** Счет, на который зачисляют средства */
DEF VAR to_acct AS CHAR NO-UNDO.

DEF VAR amount AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Сумма" NO-UNDO. /** сумма */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** сумма прописью */

/** Реквизиты договора */
DEF VAR loan_info AS CHAR NO-UNDO.

/** Итератор */
DEF VAR i AS INTEGER NO-UNDO.

/** Наименование клиента */
DEF VAR client AS CHAR NO-UNDO.

/** Дата распоряжения */
def var orderDate as date format "99/99/9999" label "Дата распоряжения" NO-UNDO.
/** Подписи */
def var ExecUser as char no-undo.
/** Наименование банка */
def var bankname as char NO-UNDO.
/** Основание */
DEF VAR evidence AS CHAR
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.
	
DEF VAR str AS CHAR EXTENT 10 NO-UNDO. /** Текст распоряжения */

def var PIRbosloan as char no-undo.
PIRbosloan = FGetSetting("PIRboss","PIRbosloan","").
find first _user where _user._userid = userid no-lock no-error.
if avail _user then
	ExecUser = _user._user-name.
else
	ExecUser = "-".

bankname = cBankName.

/** Запрашиваем дату распоряжения и дату операции */
/** Запрос текста основания */
pause 0.
orderDate = TODAY. 
UPDATE orderDate SKIP amount SKIP evidence WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

/** Поток вывода в preview */
{setdest.i}


/** Поиск выделенного договора */
FOR FIRST tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
    :
 		/** Номер и дата договора, наименование клиента */
		loan_info = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
		client = ENTRY(1, loan_info).
		loan_info = loan.cont-code + " от " + ENTRY(2,loan_info).

		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loan_info = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/
		
		from_acct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредРасч", orderDate, false).
		to_acct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр", orderDate, false).

		/** Остаток ссудной задолженности цифрами и прописью */
		RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
		amount-str[1] = amount-str[1] + ' ' + amount-str[2].
		substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).

		/** Основной текст распоряжения */
		str[1] = "#tabСписать в безакцептном порядке со счета №" + from_acct + " с последующим зачислением на счет №"
					+ to_acct + " сумму в размере " + STRING(amount) + " (" + amount-str[1] + ") в счет погашения "
					+ "просроченной задолженности по кредиту по Кредитному договору №" 
					+ loan_info + ", заключенному между "	+ bankname + " и " + client + ".".
						
		/** Преренос по словам */
		{wordwrap.i &s=str &l=75 &n=10}
					
		/** Вывод в поток */
		PUT UNFORMATTED 
												/*SPACE(50) "Утверждаю" SKIP
												SPACE(50) ENTRY(1, bosD2) SKIP
												SPACE(50) ENTRY(2, bosD2) SKIP(2) */
												SPACE(50) "В Департамент 3" SKIP
												SPACE(50) "В Департамент 4" SKIP
												SPACE(50) bankname SKIP(2)
				                SPACE(50) "Дата: " STRING(orderDate, "99/99/9999") SKIP(4)
				                SPACE(20) "Р А С П О Р Я Ж Е Н И Е" SKIP(2).
				
		DO i = 1 TO 10:
							IF str[i] <> "" THEN DO:
								str[i] = REPLACE(str[i], "#tab",CHR(9)).
								str[i] = REPLACE(str[i], "#cr", CHR(10)).
								PUT UNFORMATTED str[i] SKIP.
							END.
		END.
				
		PUT UNFORMATTED "" SKIP(3) "Основание: " evidence SKIP(4) 
						/*SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(3)*/
						SPACE(4) ENTRY(1,PIRbosloan) SPACE(50 - LENGTH(ENTRY(1,PIRbosloan))) ENTRY(2,PIRbosloan) SKIP(3)
						SPACE(4) 'Исполнитель: ' execUser SKIP(3)
						SPACE(4) 'Отметка Департамента 3:' SKIP.

END.

{preview.i}