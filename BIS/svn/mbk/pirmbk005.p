{pirsavelog.p}

/** 
		Формирование распоряжения на учет зачисленных процентов по договору МБК.
		
		Бурягин Е.П., 17.04.2007 16:40
		
		<Как_работает> 
	  
	  <Как запускается>
	  Запускается из броузера кредитных/депозитных договоров.
	  
	  <Параметры> 
	  Роль счета учета процентов.
	  Код параметра суб.аналитики, по которому учитываются проценты.
	  
	  <Особенности_реализации>
		
		Изменено: <Бурягин Е.П.> <28.09.2007 11:50> (Локальный код для поиска 0000001)
		          <Описание изменения>
		          Урбрал из списка подписей "исполнителя", и вместо него добавил подпись нач.отдела.фин.рынков.

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Глобализация */
{globals.i}
{get-bankname.i}

/** Буду использовать информацию из броузера о выделенных записях */
{tmprecid.def}

/** Мои функции */
{ulib.i}

/** Буду использовать перенос по словам */
{wordwrap.def}

/** Входящий параметр */
DEF INPUT PARAM iParam AS CHAR.
DEF VAR loanParam AS INTEGER NO-UNDO.
DEF VAR acctType AS CHAR NO-UNDO.
acctType = ENTRY(1,iParam).
loanParam = INT(ENTRY(2,iParam)).

/** Предпоследний договор */
DEF BUFFER bfrLastLoan FOR loan.

/** Дата распоряжения */
DEF VAR orderDate AS DATE LABEL "Дата распоряжения" FORMAT "99/99/9999" NO-UNDO.
/** Форма ввода реквизитов распоряжения */
DEF FRAME frmOrder
	orderDate SKIP
	WITH CENTERED TITLE "Реквизиты распоряжения" SIDE-LABELS OVERLAY.

/** Сумма процентов */
DEF VAR amount AS DECIMAL LABEL "Сумма" FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEF VAR strAmount AS CHAR EXTENT 2 NO-UNDO.

/** Начальники */
DEF VAR bosD2 AS CHAR NO-UNDO.
DEF VAR bosKazna AS CHAR NO-UNDO.
/** 0000001: added at 28.09.2007 11:52 */
DEF VAR bosFin AS CHAR NO-UNDO.
/** 0000001: end */
/** Исполнитель */
DEF VAR executor AS CHAR NO-UNDO.
DEF VAR execPost AS CHAR EXTENT 3 NO-UNDO.


/** Старый и новый счет */
DEF VAR account AS CHAR NO-UNDO.

/** Наименование банка */
DEF VAR bankname AS CHAR NO-UNDO.

/** Основной текст */
DEF VAR str AS CHAR EXTENT 20 NO-UNDO.
/** Итератор для вывода текста распоряжения */
DEF VAR i AS INTEGER NO-UNDO.

/** Наименование клиента */
DEF VAR client AS CHAR NO-UNDO.
/** Генеральное соглашение */
DEF VAR genagree AS CHAR LABEL "Номер ГС" FORMAT "x(20)" NO-UNDO.
DEF VAR genagreedate AS DATE LABEL "Дата ГС" FORMAT "99/99/9999" NO-UNDO.

/** Форма просмотра/редактирования */
DEF FRAME frmClient
	/** ttClient.id SKIP */
	loan.cont-code LABEL "Сделка МБК" SKIP
	genagree genagreedate SKIP
	WITH CENTERED TITLE "Реквизиты сделки" SIDE-LABELS OVERLAY.


PAUSE 0.

/** Запрашиваем у пользователя реквизиты распоряжения */
orderDate = TODAY.
UPDATE orderDate WITH FRAME frmOrder.
HIDE FRAME frmOrder.

/** Возьмем начальников */
bosD2 = FGetSetting("PIRboss","PIRbosD2", "<не найден>,<не найден>").
bosKazna = FGetSetting("PIRboss", "PIRbosKazna", "<не найден>,<не найден>").
/** 0000001: added at 28.09.2007 11:53 */
bosFin = FGetSetting("PIRboss", "PIRbosfinmark", "<не найден>,<не найден>").
/** 0000001: end */

/** Возьмем наименование банка */
bankname = cBankName.

/** Вычислим исполнителя */
find first _user where _user._userid = userid no-lock no-error.
if avail _user then 
	do:
	executor = _user._user-name.
	executor = GetXAttrValueEx("_user", _user._userid, "Должность", "") + "," + executor. 
	end.
else
	executor = "-,-".

/** Для каждого выделенной в броузере записи делаем... */
FOR EACH tmprecid NO-LOCK,
    /** Найдем договор */
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    /** Найдем условие */
    LAST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code
    		AND loan-cond.since <= orderDate NO-LOCK
  :

		/** Т.к. читаем параметры, то они должны быть актуальными */
		
		IF loan.since <> orderDate THEN DO:
			MESSAGE "Пересчитайте состояние договора на дату распоряжения " VIEW-AS ALERT-BOX.
			RETURN.
		END.
		
		
  	/** Возьмем сумму процентов на соответствующем параметре */
  	amount = GetLoanParamValue_ULL(loan.contract, loan.cont-code, loanParam, orderDate, false).
  	/** Сумма прописью */
		Run x-amtstr.p(amount, loan.currency, true, true, output strAmount[1], output strAmount[2]).
  	strAmount[1] = strAmount[1] + ' ' + strAmount[2].
		Substr(strAmount[1],1,1) = Caps(Substr(strAmount[1],1,1)).

		/** Возьмем клиента */
		client = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
		
		/** Cчет */
		account = GetLoanAcct_ULL(loan.contract, loan.cont-code, acctType, orderDate, false).
		
  	/** Возьмем реквизиты генерального соглашения */
  	genagree = GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "pirgenagree", ",").
  	/** Если нет на текущем договоре, ищем на предыдущем */
  	if genagree = "," then do:
  		FIND LAST bfrLastLoan WHERE 
  						bfrLastLoan.contract = loan.contract AND bfrLastLoan.cont-code <> loan.cont-code 
  						NO-LOCK NO-ERROR.
  		IF AVAIL bfrLastLoan THEN DO:
  			genagree = GetXAttrValueEx("loan", bfrLastLoan.contract + "," + bfrLastLoan.cont-code, "pirgenagree", ",").
  		END.
  	end.
  	genagreedate = DATE(ENTRY(1, genagree)).
  	genagree = ENTRY(2, genagree).
  	
  	DISPLAY loan.cont-code genagree genagreedate WITH FRAME frmClient.
  	UPDATE genagree genagreedate WITH FRAME frmClient.

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
  	str[1] = "#tabУчесть сумму, зачисленную на счет №" + account + ", в размере "
  	       + STRING(amount) + " (" + strAmount[1] + "), как погашение процентов по предоставленному "
  	       + client + " МБК (сделка №" + loan.cont-code + ") в рамках Генерального Соглашения №"
  	       + genagree + " об общих условиях сотрудничества в области проведения операций на "
  	       + "российском валютном и денежном рынках от " + STRING(genagreedate, "99/99/9999")
  	       + "г. по сделке от " 
  	       + STRING((IF loan-cond.since = loan.open-date THEN loan-cond.since ELSE loan-cond.since - 1), "99/99/9999") + "г.".

  	{wordwrap.i &s=str &l=80 &n=20}    
  	
  	{setdest.i}
  	/** Формируем распоряжение */
  	PUT UNFORMATTED bankname SKIP
  			SPACE(50) "Утверждаю" SKIP
  			SPACE(50) ENTRY(1,bosD2) SKIP(1)
  			SPACE(50) "___________________" SKIP
  			SPACE(54) ENTRY(2,bosD2) SKIP(1)
  			SPACE(50) "В Департамент 3" SKIP(2)
  			SPACE(25) "Р А С П О Р Я Ж Е Н И Е" SKIP
  			SPACE(32) orderDate FORMAT "99/99/9999" SKIP(1).
  			
  	
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
/** 0000001: commented at 28.09.2007 11:54 
						PUT UNFORMATTED	SPACE(4) execPost[1] FORMAT "x(50)" "___________________" SKIP
														SPACE(4) execPost[2] FORMAT "x(50)" SPACE(3) ENTRY(2,executor) SKIP
														SPACE(4) execPost[3] FORMAT "x(50)" SKIP.
*/

/** 0000001: added at 28.09.2007 11:55 */
		PUT UNFORMATTED
						" " SKIP(2) SPACE(4) ENTRY(1,bosFin) FORMAT "x(50)" "___________________" SKIP
						SPACE(4 + 50 + 3) ENTRY(2,bosFin) SKIP(3).
/** 0000001: end */
	  			
  	{preview.i}
  	
END.

HIDE FRAME frmClient.
