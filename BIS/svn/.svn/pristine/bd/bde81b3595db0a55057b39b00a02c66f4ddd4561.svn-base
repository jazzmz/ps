{pirsavelog.p}

/**
 * Печать распоряжения "Погашение просроченных процентов"
 * Бурягин Е.П., 18.07.2006 11:47
 *
 * Запускается из броузера документов.
 * Информация о сумме и корреспондирующих счетах берется из проводки.
 * Информация о договоре берется из субаналитической информации по кредиту проводки, и далее ищется 
 * соответсвующий кредитный договор.
 * 
 * Используется библиотека ULIB.I - функции для работы с договорами, счетами и др. (Автор: Бурягин Е.П.)
 *
 * Общее описание работы:
 * 1. Все ID выделенных в броузере объектов сохраняются в "общей" таблице TMPRECID.
 *    Необходимо найти требуемые записи в БД по соответствию их RECID() полю TMPRECID.ID.
 *    Ищем их с помощью FOR FIRST.
 * 2. Найдя документ, найдем проводку этого документа.
 * 3. Проверим, есть ли по кредиту проводки субаналитическая информация.
 *    Если нет, то выдаем ошибку и выходим из процедуры.
 *    Если есть, то найдем запись кредитного договора.
 * 4. Все данные для формирования распоряжения теперь есть.
 *
 */
 
 /** Глобальные переменные и определения */
{globals.i}
{get-bankname.i}
/** Моя Библиотека функций */
{ulib.i}
/** Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/** Определение полей печатной формы распоряжения */
DEF VAR orderDate AS DATE NO-UNDO.
DEF VAR summa AS DECIMAL NO-UNDO.
DEF VAR summaStr AS CHAR EXTENT 3 NO-UNDO.
DEF VAR acctCr AS CHAR NO-UNDO.
DEF VAR clientName AS CHAR EXTENT 3 NO-UNDO.
DEF VAR acctDb AS CHAR NO-UNDO.
DEF VAR loanInfo AS CHAR NO-UNDO.
DEF VAR loanCurrency AS CHAR NO-UNDO.
DEF VAR bosLoan AS CHAR NO-UNDO.
DEF VAR execUser AS CHAR NO-UNDO.

DEF VAR i AS INTEGER NO-UNDO.

/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
/** Прочитаем исполнителя */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** Для всех выделенных записей... */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK
    :
    
    /** Проверка, есть ли субаналитическая информация по кредиту проводки */
    IF op-entry.kau-cr = "" THEN DO:
    	MESSAGE "Операция не привязана к договору" VIEW-AS ALERT-BOX.
    	RETURN.
    END.

    /** 
     * Проанализируем субаналитическую информацию 
     * Необходимо, чтобы в ней содержались данные о кредитном договоре 
     * Формат суб.аналит. информации: <Тип_договора>,<Номер_договора>,<Код_операции>
    */
    IF NUM-ENTRIES(op-entry.kau-cr) <> 3 THEN DO:
    	MESSAGE "Формат суб.аналитической информации по кредиту проводки не верный!" VIEW-AS ALERT-BOX.
    	RETURN.
    END.
    
    /** Дата распоряжения = дате операции */
    orderDate = op.op-date.
    
    /** Сумма операции в рублях или валюте */
    summa = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
		/** Сумма строкой */
		RUN x-amtstr.p(summa,op-entry.currency,TRUE,TRUE,OUTPUT summaStr[1], OUTPUT summaStr[2]).
		/** Сливаем целые и дробные единицы в одну переменную */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** Первая буква должна быть заглавной */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).
		{wordwrap.i &s=summaStr &l=40 &n=3}

    /** Счет по дебету и кредиту */
    acctDb = op-entry.acct-db.
    acctCr = op-entry.acct-cr.
    
    /** Найдем кредитный договор */
    FIND FIRST loan WHERE 
    	loan.contract = "Кредит"
    	AND
    	loan.cont-code = ENTRY(2, op-entry.kau-cr)
    	NO-LOCK NO-ERROR.
    
    /** Если договор найден */
    IF AVAIL loan THEN 
    	DO:
		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			loanInfo = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
		/*** Конец #607 ***/

    		clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", FALSE).
    		{wordwrap.i &s=clientName &l=40 &n=3}
    		loanCurrency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
    	END.
    	
    /** Если договор не найден */	
    ELSE
    	DO:
    		MESSAGE "Не найден договор '" + ENTRY(2, op-entry.kau-cr) + "'" VIEW-AS ALERT-BOX.
    		RETURN.
    	END.
    
    /** Формирование печатной формы распоряжения */	
	
		{setdest.i}
		
		PUT UNFORMATTED 
		SPACE(50) "В Департамент 3" SKIP
		SPACE(50) "В Департамент 4" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' orderDate FORMAT "99/99/9999" SKIP(1)
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
		'НА СЧЕТ              │' acctCr FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ЗАЕМЩИК              │' clientName[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF clientName[i] <> "" THEN
				PUT UNFORMATTED     '                     │' clientName[i] FORMAT "x(40)" SKIP.
		END. 		
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КОРРЕСПОНД. СЧЕТ №   │' acctDb FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КРЕДИТНЫЙ ДОГОВОР    │' loanInfo SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ВАЛЮТА               │' loanCurrency FORMAT "xxx" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ВИД ОПЕРАЦИИ         │Погашение просроченных процентов'  SKIP
		'─────────────────────┴─────────────────────────────────────────────────────────' SKIP(2)
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) 'Исполнитель: ' execUser SKIP(3)
		SPACE(4) 'Отметка Департамента 3:' SKIP.
		{preview.i}
	    
END.
