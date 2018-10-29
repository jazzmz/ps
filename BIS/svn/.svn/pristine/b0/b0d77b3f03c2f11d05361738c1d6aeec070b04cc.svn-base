{pirsavelog.p}

/**
 * Распоряжение по погашению просроченной задолженности 
 * по кредитному договору	
 * Бурягин Е.П., 03.03.2006 10:00
 */
 
/** Глобальные переменные и определения */
{globals.i}
/** Моя Библиотека функций */
{ulib.i}
/** Перенос строк */
{wordwrap.def}
{get-bankname.i}
/** Выделенные документы **/
{tmprecid.def}

/** Начальники всякие */
DEF VAR bosLoan AS CHAR NO-UNDO.

/** Поля распоряжения */
/** Дата распоряжения: из даты документа */
DEF VAR rDate AS DATE NO-UNDO.
/** Счет погашения */
DEF VAR loanAccount AS CHAR NO-UNDO.
/** Сумма */
DEF VAR summa AS DECIMAL NO-UNDO.
DEF VAR summaStr AS CHAR EXTENT 3 NO-UNDO.

/** Заемщик */
DEF VAR clientName AS CHAR EXTENT 3 NO-UNDO.
/** Счет, с которого гасят */
DEF VAR account AS CHAR NO-UNDO.

/** Договор (в том числе и транш)*/
DEF VAR loanNo AS CHAR. DEF VAR loanOpenDate AS CHAR NO-UNDO.

/***********************************
 * Автор: Маслов Д. А.(Maslov D. A.)
 * Заявка (Event): #607
 * Идентификатор договора.
 ***********************************/

DEF VAR cDocID AS CHARACTER NO-UNDO.

/*** Конец #607 ***/

/** Валюта договора */
DEF VAR currency AS CHAR NO-UNDO.


/** Исполнитель */
DEF VAR ExecFIO AS CHAR NO-UNDO.
/** */
DEF VAR tmpStr AS CHAR NO-UNDO.

/* Add By Maslov D. A. */
DEF VAR vainVar AS LOGICAL NO-UNDO.

DEF VAR i AS INTEGER NO-UNDO.
 
/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	ExecFIO = _user._user-name.
ELSE
	ExecFIO = "-".
	
/** Найдем документ, выбранный в броузере */
FOR FIRST tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK
:
	/** Проверки на существование субаналитической информации */
		/** 1. Проводка должна быть привязана к договору */
		IF NOT op-entry.kau-cr BEGINS "Кредит," THEN DO:
			MESSAGE "Операция не привязана к договору!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		/** Возьмем из субаналитической информации номер договора */

		/* Add By Maslov D. A.
			Ацкая строка:
							1. Берем номер договора из kau - внутренний ENTRY;
							2. Берем родительский договор GetMainLoan_ULL;
							3. Берем номер родительского договоар.
		*/

		loanNo = ENTRY(2,GetMainLoan_ULL("Кредит",ENTRY(2,op-entry.kau-cr),vainVar)).
		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			cDocID = getMainLoanAttr("Кредит",loanNo,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/

		tmpStr = GetLoanInfo_ULL(ENTRY(1,op-entry.kau-cr),loanNo,"open_date,client_short_name",false).
		loanOpenDate = ENTRY(1,tmpStr).
		clientName[1] = ENTRY(2,tmpStr).

		
		{wordwrap.i &s=clientName &l=40 &n=3}
		currency = op-entry.currency.
		summa = IF currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur.

		/** Сумма строкой */
		RUN x-amtstr.p(summa,currency,TRUE,TRUE,OUTPUT summaStr[1], OUTPUT summaStr[2]).

		/** Сливаем целые и дробные единицы в одну переменную */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** Первая буква должна быть заглавной */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).

		{wordwrap.i &s=summaStr &l=40 &n=3}
		account = op-entry.acct-db.
		loanAccount = op-entry.acct-cr.
		
				{setdest.i}
		
		PUT UNFORMATTED 
		SPACE(50) "В Департамент 3" SKIP
		SPACE(50) "В Департамент 4" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' op.op-date FORMAT "99/99/9999" SKIP(1)
		SPACE(35) 'Р А С П О Р Я Ж Е Н И Е' SKIP(1)
		SPACE(4) 'Произвести зачисление денежных средств:' SKIP
		'─────────────────────┬─────────────────────────────────────────────────────────' SKIP
		'СУММА                │' summa FORMAT "->>>,>>>,>>>,>>9.99" SKIP
		'                     │' summaStr[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF summaStr[i] <> "" THEN 
				PUT UNFORMATTED '                     │' summaStr[i] FORMAT "x(40)" SKIP.
		END.
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'НА СЧЕТ              │' loanAccount FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ЗАЕМЩИК              │' clientName[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF clientName[i] <> "" THEN
				PUT UNFORMATTED     '                     │' clientName[i] FORMAT "x(40)" SKIP.
		END. 		
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КОРРЕСПОНД. СЧЕТ №   │' account FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КРЕДИТНЫЙ ДОГОВОР    │' cDocID SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ВАЛЮТА               │' currency FORMAT "xxx" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ВИД ОПЕРАЦИИ         │Погашение просроченной задолженности по кредиту'  SKIP
		'─────────────────────┴─────────────────────────────────────────────────────────' SKIP(2)
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) 'Исполнитель: ' ExecFIO SKIP(3)
		SPACE(4) 'Отметка Департамента 3:' SKIP.
		{preview.i}
END.
