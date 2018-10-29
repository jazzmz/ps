{pirsavelog.p}

/** 
		Формирование печатной формы распоряжения на выдачу МБК
		
		Бурягин Е.П., 16.04.2007 9:54
		
		Запускается из броузера кредитных договоров.
		На момент запуска необходимо, чтобы вся информация, которая отражается в распоряжении, 
		кроме бухгалтерской проводки, была введена в базу. Т.е., сначала формируется 
		распоряжение, после создается проводка.
		
		Данные о генеральном соглашении хранятся в д.р. loan.pirgenagree.
		Если для текущего договора реквизиты генерального соглашения определить не удалось,
		то программа будет искать их в предпоследнем договоре данного клиента. Найдя таковой на предпоследнем договоре,
		предложит пользователю для просмотра и редактирования и в случае согласия пользователя сохранит их в текущем
		договоре. Если реквизиты не будут найдены вообще, то пользователь может ввести их.
		
		Изменено: Бурягин Е.П. 10.08.2007 9:53 (Локальный код для поиска 0000001)
		          По устной заявке Машковой И.
		          Убрал из подписей исполнителя, вместо убранного добавил нач.финансовых рынков.

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Глобальные */
{globals.i}
{get-bankname.i}

/** Личная библиотека функций */
{ulib.i}

/** Будем использовать информацию из броузера о выделенных записях */
{tmprecid.def}

/** Перенос по словам */
{wordwrap.def}

/** Запись о клиенте */
DEF TEMP-TABLE ttClient NO-UNDO
	FIELD id AS INTEGER
	FIELD name AS CHAR LABEL "Наименование" FORMAT "x(50)"
	FIELD inn AS CHAR LABEL "ИНН" FORMAT "x(20)"
	FIELD account AS CHAR LABEL "Р/С" FORMAT "x(20)"
	FIELD nostro AS CHAR LABEL "К/С" FORMAT "x(20)"
	FIELD bic AS CHAR LABEL "БИК" FORMAT "x(9)".

/** Запись о банке */
DEF TEMP-TABLE ttBank NO-UNDO LIKE ttClient.

/** Реквизиты генерального соглашения */
DEF VAR genagree AS CHAR FORMAT "x(20)" LABEL "Номер ГС" NO-UNDO.
DEF VAR genagreedate AS DATE FORMAT "99/99/9999" LABEL "Дата ГС" NO-UNDO.

/** Форма просмотра/редактирования */
DEF FRAME frmClient
	/** ttClient.id SKIP */
	loan.cont-code LABEL "Сделка МБК" SKIP
	genagree genagreedate SKIP
	ttClient.name SKIP
	ttClient.inn SKIP
	ttClient.account SKIP
	ttClient.nostro SKIP
	ttClient.bic 
	WITH CENTERED TITLE "Реквизиты клиента" SIDE-LABELS OVERLAY.

/** Дата распоряжения */
DEF VAR orderDate AS DATE LABEL "Дата распоряжения" FORMAT "99/99/9999" NO-UNDO.
/** Номер рейса */
DEF VAR seriesNumber AS CHAR LABEL "Номер рейса" FORMAT "x(2)" NO-UNDO.
/** Форма ввода реквизитов распоряжения */
DEF FRAME frmOrder
	orderDate SKIP
	seriesNumber SKIP
	WITH CENTERED TITLE "Реквизиты распоряжения" SIDE-LABELS OVERLAY.
	
/** Предпоследний договор для поиска реквизитов */
DEF BUFFER bfrLastLoan FOR loan.

	
/** Сумма МБК */
DEF VAR amount AS DECIMAL LABEL "Сумма" FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEF VAR strAmount AS CHAR EXTENT 2 NO-UNDO.

/** Начальники */
DEF VAR bosD2 AS CHAR NO-UNDO.
DEF VAR bosKazna AS CHAR NO-UNDO.

/** 0000001: added at 10.08.2007 9:55 */
DEF VAR bosFin AS CHAR NO-UNDO.
/** 0000001: end */

/** Исполнитель */
DEF VAR executor AS CHAR NO-UNDO.
DEF VAR execPost AS CHAR EXTENT 3 NO-UNDO.

/** Основной текст */
DEF VAR str AS CHAR EXTENT 20 NO-UNDO.
/** Итератор для вывода текста распоряжения */
DEF VAR i AS INTEGER NO-UNDO.


PAUSE 0.

/** Запрашиваем у пользователя реквизиты распоряжения */
orderDate = TODAY.
UPDATE orderDate seriesNumber WITH FRAME frmOrder.
HIDE FRAME frmOrder.

/** Возьмем начальников */
bosD2 = FGetSetting("PIRboss","PIRbosD2", "<не найден>,<не найден>").
bosKazna = FGetSetting("PIRboss", "PIRbosKazna", "<не найден>,<не найден>").

/** 0000001: added at 10.08.2007 9:56 */
bosFin = FGetSetting("PIRboss", "PIRbosfinmark", "<не найден>,<не найден>").
/** 0000001: end */

/** Вычислим исполнителя */
find first _user where _user._userid = userid no-lock no-error.
if avail _user then 
	do:
	executor = _user._user-name.
	executor = GetXAttrValueEx("_user", _user._userid, "Должность", "") + "," + executor. 
	end.
else
	executor = "-,-".



/** Для каждой выделенной в броузере кредитных/депозитных договоров записи делаем... */
FOR EACH tmprecid NO-LOCK,
    /** Найдем договор */
    FIRST loan WHERE RECID(loan) = tmprecid.id AND loan.cust-cat = "Б" NO-LOCK,
    /** Найдем банк */
    FIRST banks WHERE banks.bank-id = loan.cust-id NO-LOCK,
    /** Найдем БИК банка */
    FIRST banks-code WHERE banks-code.bank-id = banks.bank-id AND bank-code-type = "МФО-9" NO-LOCK,
    /** Найдем корссчет */
    FIRST banks-corr WHERE banks-corr.bank-corr = banks.bank-id NO-LOCK,
    /** Найдем ссудный счет по договору */
    FIRST loan-acct WHERE loan-acct.contract = loan.contract AND loan-acct.cont-code = loan.cont-code
    		AND loan-acct.acct-type = "Кредит" NO-LOCK,
    /** Найдем ИНН */
    FIRST cust-ident WHERE cust-ident.cust-cat = loan.cust-cat AND cust-ident.cust-id = loan.cust-id 
    		AND cust-ident.cust-code-type = "ИНН" NO-LOCK,
    /** Найдем расчетный счет */
    FIRST code WHERE code.class = "recipient" 
    		AND NUM-ENTRIES(code.code) > 2 
    		AND ENTRY(1,code.code) = banks-code.bank-code 
    		AND ENTRY(3,code.code) = cust-ident.cust-code
    		NO-LOCK 
  :
  	/** Соберем данные о банке-клиенте */
  	CREATE 	ttClient.
  	ASSIGN 	ttClient.id = banks.bank-id
  					ttClient.name = banks.name 
  					ttClient.inn = cust-ident.cust-code
  					ttClient.account = ENTRY(2, code.code)
  					ttClient.nostro = banks-corr.corr-acct
  					ttClient.bic = banks-code.bank-code.
  	
  	/** Соберем данные о банке */
  	CREATE	ttBank.
  	ASSIGN	ttBank.name = cBankName
  					ttBank.inn = FGetSetting("ИНН", "", "")
  					ttBank.account = loan-acct.acct
  					ttBank.nostro = FGetSetting("КорСч", "", "")
  					ttBank.bic = FGetSetting("БанкМФО", "", "").
  	
  	/** Возьмем сумму договора */
  	amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false).
  	/** Сумма прописью */
		Run x-amtstr.p(amount, loan.currency, true, true, output strAmount[1], output strAmount[2]).
  	strAmount[1] = strAmount[1] + ' ' + strAmount[2].
		Substr(strAmount[1],1,1) = Caps(Substr(strAmount[1],1,1)).
  	
  	/** Возьмем реквизиты генерального соглашения */
  	genagree = GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "pirgenagree", ",").
  	/** Если нет на текущем договоре, ищем на предыдущем */
  	if genagree = "," then do:
  		FIND LAST bfrLastLoan WHERE 
  						bfrLastLoan.contract = loan.contract AND bfrLastLoan.cont-code <> loan.cont-code
  						AND bfrLastLoan.cust-cat = loan.cust-cat AND bfrLastLoan.cust-id = loan.cust-id 
  						NO-LOCK NO-ERROR.
  		IF AVAIL bfrLastLoan THEN DO:
  			genagree = GetXAttrValueEx("loan", bfrLastLoan.contract + "," + bfrLastLoan.cont-code, "pirgenagree", ",").
  		END.
  	end.
  	genagreedate = DATE(ENTRY(1, genagree)).
  	genagree = ENTRY(2, genagree).
  	
  	DISPLAY loan.cont-code genagree genagreedate ttClient.name ttClient.inn ttClient.account ttClient.nostro ttClient.bic 
  					WITH FRAME frmClient.
  					
  	UPDATE genagree genagreedate ttClient.account WITH FRAME frmClient.
  	
  	/** Сохраним реквизиты генерального соглашения */
  	FIND FIRST signs WHERE 
  			signs.file-name = "loan"  	
  			AND
  			signs.code = "pirgenagree"
  			AND
  			signs.surrogate = loan.contract + "," + loan.cont-code 
  			NO-ERROR.
  	IF AVAIL signs THEN
  		signs.xattr-value = STRING(genagreedate,"99/99/9999") + "," + genagree.
  	ELSE 
  		DO:
  			CREATE 	signs.
  			ASSIGN 	signs.file-name = "loan"
  							signs.code = "pirgenagree"
  							signs.surrogate = loan.contract + "," + loan.cont-code
  							signs.xattr-value = STRING(genagreedate,"99/99/9999") + "," + genagree.
  		END.
  	
  	/** Формируем основной текст c #tab - табуляцией, #cr - переносами */
  	str[1] = "#tabПрошу перечислить сумму в размере " + STRING(amount) + " (" + strAmount[1] + ") по следующим реквизитам:"
  	    + "#cr" + CHR(10)
  	    + "#tabПолучатель - " + ttClient.name + CHR(10)
  	    + "#tabРеквизиты получателя: ИНН " + ttClient.inn + CHR(10)
  	    + "#tabсч. " + ttClient.account + CHR(10)
  	    + "#tabк/с " + ttClient.nostro + CHR(10)
  	    + "#tabБИК " + ttClient.bic + CHR(10)
  	    + "#cr" + CHR(10)
  	    + "#tabПлательщик - " + ttBank.name + CHR(10) 
  	    + "#tabРеквизиты плательщика: " + ttBank.inn + CHR(10)
  	    + "#tabсч. " + ttBank.account + CHR(10)
  	    + "#tabк/с " + ttBank.nostro + CHR(10)
  	    + "#tabБИК " + ttBank.bic + CHR(10)
  	    + "#cr" + CHR(10)
  	    + "Основание: перечисление МБК согласно сделки №" + loan.cont-code + " от " + STRING(loan.open-date, "99/99/9999")
  	    + "г." + CHR(10)
  	    + "Генеральное соглашение №" + genagree + " об общих условиях сотрудничества в области проведения операций на "
  	    + "Российском валютном и денежном рынках от " + STRING(genagreedate,"99/99/9999") + "г." + CHR(10)
  	    + "Категория качества - " + STRING(loan.gr-riska) + " - " + STRING(loan.risk) + "%".
  	{wordwrap.i &s=str &l=80 &n=20}    
  	
  	{setdest.i}
  	/** Формируем распоряжение */
  	PUT UNFORMATTED ttBank.name SKIP
  			SPACE(50) "Утверждаю" SKIP
  			SPACE(50) ENTRY(1,bosD2) SKIP(1)
  			SPACE(50) "___________________" SKIP
  			SPACE(54) ENTRY(2,bosD2) SKIP(1)
  			SPACE(50) "В Департамент 3" SKIP(2)
  			SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP
  			SPACE(32) orderDate FORMAT "99/99/9999" SKIP(1)
  			SPACE(31) "Платеж " STRING(seriesNumber) " рейс" SKIP(1).
  			
  	
		/** Выводим основной текст */
		DO i = 1 TO 20:
							IF str[i] <> "" THEN DO:
								str[i] = REPLACE(str[i], "#tab",CHR(9)).
								str[i] = REPLACE(str[i], "#cr", CHR(10)).
								PUT UNFORMATTED str[i] SKIP.
							END.
		END.
		
		/** Выводим подписи */
		
		execPost[1] = ENTRY(1,executor).
		{wordwrap.i &s=execPost &l=30 &n=3}
		
		PUT UNFORMATTED
						" " SKIP(2) SPACE(4) ENTRY(1,bosKazna) FORMAT "x(50)" "___________________" SKIP
						SPACE(4 + 50 + 3) ENTRY(2,bosKazna) SKIP(3).
/** 0000001: commented at 10.08.2007 9:58 
						PUT UNFORMATTED	SPACE(4) execPost[1] FORMAT "x(50)" "___________________" SKIP
														SPACE(4) execPost[2] FORMAT "x(50)" SPACE(3) ENTRY(2,executor) SKIP
														SPACE(4) execPost[3] FORMAT "x(50)" SKIP.
*/

/** 0000001: added at 10.08.2007 9:58 */
		PUT UNFORMATTED
						" " SKIP(2) SPACE(4) ENTRY(1,bosFin) FORMAT "x(50)" "___________________" SKIP
						SPACE(4 + 50 + 3) ENTRY(2,bosFin) SKIP(3).
/** 0000001: end */
    
	  			
  	{preview.i}
  					
END.

HIDE FRAME frmClient.
	