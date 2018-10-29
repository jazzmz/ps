{pirsavelog.p}

/**
 * Распоряжение на выдачу кредита.
 * Бурягин Е.П., 22.02.2006 12:43
 */

/** Глобальные переменные и определения */
{globals.i}

{get-bankname.i}

/** Моя Библиотека функций */
{ulib.i}
/** Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/** Логический признак того, что договор имеет течения/линии */
DEF VAR hasTransh AS LOGICAL NO-UNDO.
/** Начальники всякие */
DEF VAR bosD2 AS CHAR NO-UNDO.
DEF VAR bosLoan AS CHAR NO-UNDO.
DEF VAR bosKazna AS CHAR NO-UNDO.
/** Поля распоряжения */
/** Дата распоряжения: из даты документа */
DEF VAR rDate AS DATE NO-UNDO.
/** Расчетный или иной счет, на который выдаются средства */
DEF VAR acctCr AS CHAR NO-UNDO.
/** Сумма выдаваемого кредита */
DEF VAR summa AS DECIMAL NO-UNDO.
DEF VAR summaStr AS CHAR EXTENT 3 NO-UNDO.
/** Валюта операции, точнее ее цифровой код. Для рублей код "" */
DEF VAR currency AS CHAR NO-UNDO.
/** Валюта операции, отображаемая в форме. Для рублей код "810" */
DEF VAR currencyPrint AS CHAR NO-UNDO.
/** Ссудный счет */
DEF VAR loanAcct AS CHAR NO-UNDO.
/** Заемщик */
DEF VAR clientName AS CHAR EXTENT 3 NO-UNDO.
/** Кредитный договор */
DEF VAR loanNo AS CHAR NO-UNDO.
DEF VAR currLoanNo AS CHAR NO-UNDO.

DEF VAR loanDate AS CHAR NO-UNDO.
/** Срок действия договора */
DEF VAR loanPeriod AS CHAR NO-UNDO.
DEF VAR begLoanPeriod AS DATE NO-UNDO.
DEF VAR endLoanPeriod AS DATE NO-UNDO.

DEF VAR DataZakl  AS DATE NO-UNDO.
DEF VAR DataEnd   AS DATE NO-UNDO.

DEF VAR DogPeriod AS CHARACTER NO-UNDO.

/** Признак транша */
DEF VAR isTransh AS LOGICAL NO-UNDO.
/** Срок действия кредитной линии/транша */
DEF VAR transhPeriod AS CHAR NO-UNDO.
DEF VAR begTranshPeriod AS DATE NO-UNDO.
DEF VAR endTranshPeriod AS DATE NO-UNDO.
/** Тип лимита TRUE-выдачи/FALSE-задолженности */
DEF VAR limitType AS LOGICAL NO-UNDO.
/** Лимит задолженности/выдачи */
DEF VAR limit AS DECIMAL NO-UNDO.
/** Счет учета лимита */
DEF VAR limitAcct AS CHAR NO-UNDO.
/** Неиспользованный лимит */
DEF VAR availLimit AS DECIMAL NO-UNDO.
/** Процентная ставка */
DEF VAR rate AS DECIMAL NO-UNDO.
/** Срок уплаты процентов */
DEF VAR percentTerm AS CHAR NO-UNDO.
/** Категория качества: группа и процент риска */
DEF VAR risk AS CHAR NO-UNDO.
/** Обеспечение */
DEF VAR backing AS CHAR NO-UNDO.
DEF VAR backingTotalSumma AS DECIMAL NO-UNDO.
DEF VAR backLoans AS CHAR EXTENT 10 NO-UNDO.
DEF VAR backSumma AS DECIMAL EXTENT 10 NO-UNDO.
/** Рабочая лошадка */
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStrArr AS CHAR EXTENT 4 NO-UNDO.
/** Итератор */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** Исполнитель */
DEF VAR ExecFIO AS CHAR NO-UNDO.

/***********************************
 * Автор: Маслов Д. А.(Maslov D. A.)
 * Заявка (Event): #607
 * Идентификатор договора.
 ***********************************/

DEF VAR cDocID AS CHARACTER NO-UNDO.

/*** Конец #607 ***/
/***********************************
 * Автор: Красков А.С.
 * Заявка (Event): #718
 * Идентификатор договора.
 ***********************************/

DEF VAR oAcct AS TAcct NO-UNDO.

/*** Конец #718 ***/

/** Основание */
DEF VAR evidence AS CHAR
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.

/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosKazna = FGetSetting("PIRboss","PIRbosKazna","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
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
		/** Далее идет серия проверок */
		/** 1. Проводка должна быть привязана к договору */
		IF NOT op-entry.kau-db BEGINS "Кредит," THEN DO:
			MESSAGE "Операция не привязана к договору!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		/** 2. Проводка должна быть привязана с кодом 4 */
		IF ENTRY(3, op-entry.kau-db) <> "4" THEN DO:
			MESSAGE "Это не операция выдачи кредита!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		
		/** Сохраним значения */
		rDate = op.op-date.
		acctCr = op-entry.acct-cr.
		currency = op-entry.currency.
		currencyPrint = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency).
		summa = (IF currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
		/* Сумма прописью */
		RUN x-amtstr.p(summa,currency,TRUE,TRUE,OUTPUT summaStr[1], OUTPUT summaStr[2]).
		/** Сливаем целые и дробные единицы в одну переменную */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** Первая буква должна быть заглавной */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).
		{wordwrap.i &s=summaStr &l=40 &n=3}
		
		loanAcct = op-entry.acct-db.

		/** Определим, является ли договор течением */
		tmpStr = GetMainLoan_ULL(ENTRY(1, op-entry.kau-db), ENTRY(2, op-entry.kau-db), false).
	
		/******************************************
		 * Автор: Маслов Д. А. (Maslov D. A.)
		 * Заявка (Event): #607
		 ******************************************/
			cDocID = getMainLoanAttr("Кредит",ENTRY(2,tmpStr),"%cont-code от %ДатаСогл").
		/*** КОНЕЦ #607 ***/


		loanNo = ENTRY(1, op-entry.kau-db) + "," + ENTRY(2, op-entry.kau-db).

		/** Если это транш, то вычислим период кредитования для него*/
		IF tmpStr <> loanNo THEN 
			DO:
				isTransh = TRUE.
			END.

		/** Далее работаем с охватывающим договором */
		currLoanNo = loanNo.
		loanNo = tmpStr.

		
		clientName[1] = GetLoanInfo_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "client_short_name", false).
		{wordwrap.i &s=clientName &l=40 &n=3}
		

		loanDate = GetLoanInfo_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "open_date", false).

				/************************************
				 * Исправлена дата начала действия
				 * договора. Теперь она берется
				 * с поля beg-date договора.
				 * Автор: Маслов Д. А. Maslov D. A.
				 * Заявка: #670
				 ************************************/
					/******************              
					 * Всего в договоре
					 * два периода:
					 * СРОК ДЕЙСТВИЯ - смотрится на охватывающем с
					 * даты заключения по дату окончания.
					 * СРОК ДЕЙСТВИЯ ЕДИН ДЛЯ ТРАНША И ДОГОВОРА.
					 *
					 * СРОК - смотрится с ДАТЫ ВЫДАЧИ ПО ДАТУ ОКОНЧАНИЯ,
					 * каждого из траншей.
					 ********************/
					 /*******************
					  * !!! ВНИМАНИЕ !!!
					  * 1. Номер currLoanNo - это номер договора,
					  * к которому привязана проводка (в том числе и транша).
					  * 2. Номер loanNo - это номер охватывающего договра.
					  * Заявка: #693.
					  * Маслов Д. А. Maslov D. A.
					  **********************/
					  


					dataZakl = DATE(getMainLoanAttr("Кредит",ENTRY(2,currLoanNo),"%ДатаСогл")).
					dataEnd  = DATE(getMainLoanAttr("Кредит",ENTRY(2,currLoanNo),"%ДатаОк")).

					begLoanPeriod = DATE(getLoanAttr("Кредит",ENTRY(2,currLoanNo),"%ДатаНач")).
					endLoanPeriod = DATE(GetLoanInfo_ULL("Кредит", ENTRY(2,currLoanNo), "end_date", false)).
	 	
				dogPeriod = "c " + STRING(begLoanPeriod,"99/99/9999")
					+ " по " + STRING(endLoanPeriod,"99/99/9999") + "(" + STRING(endLoanPeriod - begLoanPeriod) + " дней)".

                                /*** Срок Действия кредитного договора ***/
				loanPeriod = "c " + STRING(dataZakl)
						  + " по " + STRING(dataEnd, "99/99/9999") + " (" + STRING(dataEnd - dataZakl) + " дней)".

					 /*** КОНЕЦ #670 ***/
			
		/** Если это транш, то нужно вывести информацию о лимите */
		IF isTransh THEN DO:
		limit = GetLoanLimit_ULL(ENTRY(1,loanNo), ENTRY(2, loanNo), op.op-date, false).
		limitAcct = GetLoanAcct_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "КредЛин", rDate, false).
		IF limitAcct <> "" THEN 
			limitType = TRUE.
		ELSE	
			DO:
				limitAcct = GetLoanAcct_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "КредН", rDate, false).
				IF limitAcct <> "" THEN
					limitType = FALSE.
				ELSE
					DO:
						MESSAGE "Счет лимита не найден!" VIEW-AS ALERT-BOX.
					END.
			END.

		/* заявка # 718 */
		
/*                availLimit = ABS(GetAcctPosValue_UAL(limitAcct, currency, rDate - 1, false)).*/

                oAcct = new TAcct(limitAcct).
		availLimit = ABS(oAcct:getLastPos2Date(rDate)) + summa.
		DELETE OBJECT oAcct.

		/* заявка # 718 */

		END. /* isTransh */
		
		/** Процентная ставка */
		rate = GetLoanCommission_ULL(ENTRY(1,loanNo),ENTRY(2,loanNo),"%Кред",rDate, false).
		/** Срок уплаты процентов. Найдем актуальные на дату документа условия договора */
		FIND LAST loan-cond WHERE
			loan-cond.contract = ENTRY(1,loanNo)
			AND
			loan-cond.cont-code = ENTRY(2,loanNo)
			AND
			loan-cond.since LE rDate
			NO-LOCK NO-ERROR.
		IF AVAIL loan-cond THEN
			DO:

				IF loan-cond.int-date = 31 THEN 
					percentTerm = "Ежемесячно не позднее последнего рабочего дня месяца".
				ELSE
					percentTerm = "Ежемесячно " + STRING(loan-cond.int-date) + " числа".

				if loan-cond.int-period = "Кс" then
					percentTerm = "В конце срока".
			END.
			
		risk = GetLoanInfo_ULL(ENTRY(1,loanNo),ENTRY(2,loanNo),"gr_riska,risk", false).
		
		/** Обеспечение */
		i = 0.
        /************
            Modifed By Maslov D.
            Event: #456
            Ia dobavil uslovit "AND (term-obl.sop-date GE rDate OR term-obl.sop-date EQ ?)"
        ************/
		FOR EACH term-obl WHERE
			term-obl.contract = ENTRY(1,loanNo)
			AND
			term-obl.cont-code = ENTRY(2,loanNo)
			AND
			term-obl.idnt = 5 
            AND (term-obl.sop-date GE rDate OR term-obl.sop-date EQ ?)
			NO-LOCK:
			i = i + 1.
			tmpStr = ENTRY(1,loanNo) + "," + ENTRY(2,loanNo) + "," + STRING(term-obl.idnt) + "," + 
				STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
			
			/** 
			 * Формат значения в элементе массива backLoans: 
			 * <Название вида обеспечения>,<Номер дог. обеспечения> 
			 */
			backLoans[i] = GetXAttrValueEx("term-obl",tmpStr,"ВидДогОб","").
			
			FIND FIRST code WHERE code.class = "ВидДогОб" AND code.code = backLoans[i] NO-LOCK NO-ERROR.
			IF AVAIL code THEN DO:
				backLoans[i] = code.name + ",".
			END.
			
            /* Modify By Maslov D. A.
                Заявка: #320

			backLoans[i] = backLoans[i] + "№" + GetXAttrValueEx("term-obl",tmpStr,"НомДогОб","") + " от " 
				+ GetXAttrValueEx("term-obl",tmpStr,"ДатаПост","").
            */

			backLoans[i] = backLoans[i] + "№" + GetXAttrValueEx("term-obl",tmpStr,"НомДогОб","") + " от " 
				+ STRING(term-obl.fop-date).
			
			backSumma[i] = term-obl.amt.
			backingTotalSumma = backingTotalSumma + term-obl.amt.
		END.
		
		/** Запрашиваем у пользователя основание выдачи кредита */
		
		pause 0.
		/*DISPLAY evidence.*/
		SET evidence WITH FRAME frmTmp CENTERED.

		/********************************************
		 *								 *
		 * Автор: Маслов Д. А. (Maslov D. A.)     *
		 * Заявка: #635					 *
		 *							         *
		 ********************************************/

			evidence = evidence + " " + cDocID.

		/******* КОНЕЦ #635 *******/
		
		/** Начинаем формировать печатный документ */
		
		{setdest.i}
		
		PUT UNFORMATTED 
		SPACE(50) "Утверждаю" SKIP
		SPACE(50) ENTRY(1,bosD2) SKIP
		SPACE(50) ENTRY(2,bosD2) SKIP(2)
		SPACE(50) "В Департамент 3" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' op.op-date FORMAT "99/99/9999" SKIP(2)
		SPACE(20) 'Р А С П О Р Я Ж Е Н И Е' SKIP(1)
		SPACE(4) 'Произвести выдачу кредита:' SKIP
		'─────────────────────┬─────────────────────────────────────────────────────────' SKIP
		'НА СЧЕТ              │' acctCr FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'СУММА                │' summa FORMAT "->>>,>>>,>>>,>>9.99" SKIP
		'                     │' summaStr[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF summaStr[i] <> "" THEN 
				PUT UNFORMATTED '                     │' summaStr[i] FORMAT "x(40)" SKIP.
		END.
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ВАЛЮТА               │' currencyPrint FORMAT "xxx" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP.

		/********************
		 * Автор: Маслов Д. А. Maslov D. A.
		 * Заявка: #370
		 * Исправлена ошибка
		 * определения срока к.д.
		 ********************/
		/** Если это транш, то срок кредитования транша, иначе срок договора */

		PUT UNFORMATTED				'СРОК                 │' dogPeriod	SKIP.

		
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ССУДНЫЙ СЧЕТ №       │' loanAcct FORMAT "x(20)" SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ЗАЕМЩИК              │' clientName[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF clientName[i] <> "" THEN
				PUT UNFORMATTED     '                     │' clientName[i] FORMAT "x(40)" SKIP.
		END. 		

		/*******************
		 *
		 * Автор: Маслов Д. А. (Maslov D.A.)
		 * Заявка (Event):  #607
		 *
		 *******************/

		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КРЕДИТНЫЙ ДОГОВОР    │' cDocID SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP.
		
		/** Если договор - транш, то выведем срок охватывающего договора */
		IF isTransh THEN
			DO:
				PUT UNFORMATTED 'СРОК ДЕЙСТВИЯ ДОГ.   │' loanPeriod	SKIP
 												'─────────────────────┼─────────────────────────────────────────────────────────' SKIP.
			END.
		IF isTransh THEN 
			PUT UNFORMATTED
			'ЛИМИТ ' IF limitType THEN 'ВЫДАЧИ         ' ELSE 'ЗАДОЛЖЕННОСТИ  ' '│' limit FORMAT "->>>,>>>,>>>,>>9.99" SKIP
			'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
			'СЧЕТ УЧЕТА ЛИМИТА №  │' limitAcct FORMAT "x(20)" SKIP
			'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
			'НЕИСПОЛЬЗОВАННЫЙ ЛИМ.│' availLimit FORMAT "->>>,>>>,>>>,>>9.99" SKIP.
		
		/** Проценты */
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ПРОЦЕНТНАЯ СТАВКА    │' STRING(rate * 100,">>9.99") '% годовых' SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'СРОК УПЛАТЫ ПРОЦЕНТОВ│' percentTerm SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'КАТЕГОРИЯ КАЧЕСТВА   │' ENTRY(1,risk) '(' ENTRY(2,risk) '%)' SKIP
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ОБЕСПЕЧЕНИЕ          │'  SKIP
		'                СУММА│' backingTotalSumma FORMAT "->>>,>>>,>>>,>>9.99" SKIP
		'          в том числе│' SKIP.
		DO i = 1 TO 10 :
			IF backLoans[i] <> "" THEN DO:
				
				/** 
				 * Название вида обеспечения должно полностью отражаться,
				 * следовательно нужно выполнить перенос по строкам
				 */				
				tmpStrArr[1] = ENTRY(1, backLoans[i]).
				{wordwrap.i &s=tmpStrArr &l=21 &n=3}
				PUT UNFORMATTED	tmpStrArr[1] FORMAT "x(21)" '│' SKIP.
				DO j = 2 TO 3 :	IF tmpStrArr[j] <> "" THEN
						PUT UNFORMATTED tmpStrArr[j] FORMAT "x(21)" '│' SKIP.
				END.
				
				/** Собственно, сам номер договора и сумма обеспечения */
				PUT UNFORMATTED
					ENTRY(2, backLoans[i]) FORMAT "x(21)" '│' backSumma[i] FORMAT "->>>,>>>,>>>,>>9.99" SKIP.
			END.
		END.

		tmpStrArr[1] = evidence.
		{wordwrap.i &s=tmpStrArr &l=40 &n=4}
		PUT UNFORMATTED
		'─────────────────────┼─────────────────────────────────────────────────────────' SKIP
		'ОСНОВАНИЕ            │' tmpStrArr[1] FORMAT "x(40)" SKIP.
		
		DO i = 2 TO 4 : IF tmpStrArr[i] <> "" THEN
			PUT UNFORMATTED '                     │' tmpStrArr[i] FORMAT "x(40)" SKIP.
		END.
		
		PUT UNFORMATTED
		'─────────────────────┴─────────────────────────────────────────────────────────' SKIP(1)
		SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(1)
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(2)
		SPACE(4) 'Исполнитель: ' ExecFIO SKIP.
		{preview.i}
END.

/** Убрать с экрана форму ввода текста основания */
hide frame frmTmp.
