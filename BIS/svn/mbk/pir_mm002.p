
/* ------------------------------------------------------
     File: $RCSfile: pir_mm002.p,v $ $Revision: 1.2 $ $Date: 2007-12-13 14:57:16 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Внедрение модуля Денежный рынок
     Что делает: Формирует распоряжение для пролонгированной сделки МБК.
     Как работает? не понятно!!!! ;)
     Параметры: 
     Место запуска: Броузер сделок ГС, или архив сделок.
     Автор: $Author: buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

/** Глобальные определения */
{globals.i}

{get-bankname.i}


/** Используем выделенные записи броузера */
{tmprecid.def}

/** Функции для работы с ассоциированными параметрами */
{parsin.def}

/** Определения временных таблиц и функций */
{pir_mm_def.i}

/** Функции для работы с договорами от Пирбанка */
{ulib.i}

/** =============================== Определения ================================== */

DEF INPUT PARAM iParam AS CHAR.

DEF BUFFER bfrCurrentLoan FOR loan. /** Выделенная в броузере сделка */
DEF BUFFER bfrCurrentLoanLine FOR loan. /** Частичная сумма текущей сделки. */
DEF BUFFER bfrFirstLoan FOR loan. /** Первая сделка */
DEF BUFFER bfrFirstLoanLine FOR loan. /** Частичная сумма первой сделки */
DEF BUFFER bfrRolloveredLoan FOR loan. /** Пролонгированная сделка */
DEF BUFFER bfrBankCorrespond FOR banks. /** Банк корреспондент */
DEF BUFFER bfrGeneralLoan FOR loan. /** Генеральное соглашение */
DEF buffer bfrLoanAmount FOR term-obl. /** Сумма сделки */
def buffer bfrPersentAmount FOR term-obl. /** Сумма процентов */
def buffer bfrPay FOR term-obl. /** Исходящие и входящие платежи (используется поочередно */

DEF VAR fileName AS CHAR NO-UNDO. /** Имя создаваемого файла */
DEF VAR cr AS CHAR NO-UNDO. /** Win-коды перехода на новую строку */
DEF VAR bankName AS CHAR NO-UNDO. /** Наименование нашего банка */
DEF VAR agreeUser AS CHAR NO-UNDO. /** Данные сотрудника, утверждающего распоряжение. Определяется по коду пользоватея
из параметра процедуры. Формат: <Код_пользователя,Должность,ФИО> */
DEF VAR kaznaUsers AS CHAR NO-UNDO. /** коды пользователей (через точку с запятой ";") для отметок казначейства.
Формат: <Код_пользователя,Должность,ФИО>;<Код_пользователя,Должность,ФИО>;... */
DEF VAR kaznaSignsHtmlCode AS CHAR NO-UNDO. /** HTML-код, содержащий таблицу подписей сотрудников казначейства */
DEF VAR outPayHtmlCode AS CHAR NO-UNDO. /** HTML-код, содержащий таблицу исходящих платежей */
DEF VAR inPayHtmlCode AS CHAR NO-UNDO. /** HTML-код, содержащий таблицу входящих платежей */
DEF VAR reportUser AS CHAR NO-UNDO. /** код пользователя для отметки департамента учета и отчетности */

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.

/** ====================================== Всякие функции ====================== */


/** =============================== Реализация =================================== */

cr = CHR(13) + CHR(10).


bankName = cBankName.
iParam = REPLACE(iParam,"CURRENTUSER",USERID("bisquit")).

agreeUser = SetUserDetails(GetParamByNameAsChar(iParam, "КодУтверждаю", "")).
kaznaUsers = SetUserDetails(GetParamByNameAsChar(iParam, "КодыПодписей", "")).
DO i = 1 TO NUM-ENTRIES(kaznaUsers, "|") :
	kaznaSignsHtmlCode = kaznaSignsHtmlCode + 
				"<tr height=40 valign=middle><td>" + ENTRY(2, ENTRY(i, kaznaUsers, "|")) + "</td><td>_____________(" + ENTRY(3, ENTRY(i, kaznaUsers, "|")) + ")</td></tr>" + cr.
END.
reportUser = SetUserDetails(GetParamByNameAsChar(iParam, "КодДепУчета", "")).



/** Для каждой выбранной сделки */
FOR EACH tmprecid NO-LOCK,
    FIRST bfrCurrentLoan WHERE RECID(bfrCurrentLoan) = tmprecid.id NO-LOCK,
    FIRST bfrGeneralLoan WHERE bfrGeneralLoan.contract = bfrCurrentLoan.parent-contract AND
                               bfrGeneralLoan.cont-code = bfrCurrentLoan.parent-cont-code NO-LOCK
  :
			
			/** -------------------------------------- Сбор данных ------------------------------------- */
			
			/** Вычисляем имя файла */
			fileName = "/home/bis/quit41d/imp-exp/users/" + LC(USERID) + "/fb_" + REPLACE(REPLACE(REPLACE(bfrCurrentLoan.doc-num,"/","-"),	"-", "_"), "Р", "P") + ".html.doc".
  	  
  	  
  	  /**  - - - - - - Реквизиты банка-корреспондента  - - - - - - - */
  	  /** Найдем банк корреспондент */
  	  FIND FIRST bfrBankCorrespond WHERE bfrBankCorrespond.bank-id = bfrCurrentLoan.cust-id NO-LOCK NO-ERROR.  	  
  	  /** Далее используем временную таблицу */
  	  BUFFER-COPY bfrBankCorrespond TO ttBankCorrespond.
			/** Найдем ИНН банка-корреспондента */
			FIND FIRST cust-ident WHERE cust-ident.cust-cat = "Б" AND cust-ident.cust-id = ttBankCorrespond.bank-id
				AND cust-ident.cust-code-type = "ИНН" NO-LOCK NO-ERROR.
			IF AVAIL cust-ident THEN ttBankCorrespond.inn = cust-ident.cust-code.
			/** Найдем БИК банка-корреспондента */
			FIND FIRST banks-code WHERE banks-code.bank-id = ttBankCorrespond.bank-id AND 
			                            banks-code.bank-code-type = "МФО-9" NO-LOCK NO-ERROR.
			IF AVAIL banks-code THEN ttBankCorrespond.bic = banks-code.bank-code.
			/** Найдем корс.счет */
			FIND FIRST banks-corr WHERE banks-corr.bank-corr = ttBankCorrespond.bank-id NO-LOCK NO-ERROR.
			IF AVAIL banks-corr THEN ttBankCorrespond.corr-acct = banks-corr.corr-acct.
			/** Найдем SWIFT банка-корреспондента */
			FIND FIRST banks-code WHERE banks-code.bank-id = ttBankCorrespond.bank-id AND 
			                            banks-code.bank-code-type = "BIC" NO-LOCK NO-ERROR.
			IF AVAIL banks-code THEN ttBankCorrespond.swift = banks-code.bank-code.
			/** Найдем английское наименование */
			ttBankCorrespond.engl-name = GEtXAttrValueEx("banks", STRING(ttBankCorrespond.bank-id), "engl-name", "").
			
			
			/** Найдем ссудный счет счет. Проблема в том, что технически счет привязан не к соглашению, а к частичной
			сумме. частичная сумма так же хранится в таблице loan и имеет первую часть номера cont-code, равную номеру сделки.
			Но вторая часть cont-code частичной суммы отделена пробелом и является номером из (1,2,...). Для первой сделки ищем
			номер 1 - это упрощает задачу. Быть может в дальнейшем опыта будет больше и появится информация о том, какая на самом
			деле нумерация у частичных сум. */
			BUFFER-COPY bfrCurrentLoan TO ttCurrentLoan.
			ttCurrentLoan.loan-acct = GetLoanAcct_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code + "..", "Кредит", ttCurrentLoan.open-date, false).
			/** Счет по учету доходов по процентам привязан к самой сделке */
			ttCurrentLoan.pers-acct = GetLoanAcct_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, "КредПроц", ttCurrentLoan.open-date, false).
			/** Ну и Группа и процент риска */
			/*
			ttCurrentLoan.risk = GetLoanInfo_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, ,"gr_riska,risk", false).
			ttCurrentLoan.gr-riska = ENTRY(1, ttCurrentLoan.risk).
			ttCurrentLoan.risk = ENTRY(2, ttCurrentLoan.risk).
			*/


			/** Найдем валюту договора */
			FIND FIRST currency WHERE currency.currency = ttCurrentLoan.currency NO-LOCK NO-ERROR.

			
			/** Найдем сумму процентов за период сделки */
			FIND FIRST bfrPersentAmount WHERE bfrPersentAmount.contract = ttCurrentLoan.contract AND
																		    bfrPersentAmount.cont-code = ttCurrentLoan.cont-code AND
																		    bfrPersentAmount.end-date = ttCurrentLoan.end-date AND
																		    bfrPersentAmount.class-code = "mml-int-call" NO-LOCK NO-ERROR.
			
			/** Определим прологированную cделку. Она хранится в д.р. транша сделки PrevLoanID. Если, случайно, этого д.р. на транше сделки нет, то пусть "пеняет" сам на себя... */
			/** Итак, найдем сперва транш сделки */
			FIND FIRST bfrCurrentLoanLine WHERE bfrCurrentLoanLine.contract = ttCurrentLoan.contract AND
			                                    ENTRY(1, bfrCurrentLoanLine.cont-code," ") = ttCurrentLoan.cont-code AND
			                                    NUM-ENTRIES(bfrCurrentLoanLine.cont-code, " ") = 2 NO-LOCK NO-ERROR.
			/** Значение д.р. транша сделки */                                    
			tmpStr = GetXAttrValueEx("loan", bfrCurrentLoanLine.contract + "," + bfrCurrentLoanLine.cont-code, "PrevLoanID", ttCurrentLoan.contract + "," + ttCurrentLoan.cont-code).
			
			/** Из найденного номера нужно взять только первую часть cont-code, а то она тоже ссылается на транш сделки */
			FIND FIRST bfrRolloveredLoan WHERE bfrRolloveredLoan.contract = ENTRY(1, tmpStr) AND
			                                   bfrRolloveredLoan.cont-code = ENTRY(1, ENTRY(2, tmpStr), " ") NO-LOCK NO-ERROR.

			/** Найдем первую сделку. Это не просто! Так как там сложная система связей через частичные суммы (транши).
			Т.е. сначала нужно найти частичная сумму текущей сделки, потом найти с какой частичной суммой эта частичная сумма связана и т.д. пока не определим, что дальше цепь заканчивается... потом по последней частичной сумме найти сделку, 
			которой она принадлежит. */
			
			REPEAT WHILE tmpStr <> "" :
				FIND FIRST bfrFirstLoan WHERE bfrFirstLoan.contract = ENTRY(1, tmpStr) AND
			                             	  bfrFirstLoan.cont-code = ENTRY(1, ENTRY(2, tmpStr), " ") NO-LOCK NO-ERROR.
			                              
				FIND FIRST bfrFirstLoanLine WHERE bfrCurrentLoanLine.contract = bfrFirstLoan.contract AND
			                                    ENTRY(1, bfrFirstLoanLine.cont-code," ") = bfrFirstLoan.cont-code AND
			                                    NUM-ENTRIES(bfrFirstLoanLine.cont-code, " ") = 2 NO-LOCK NO-ERROR.
				/** Значение д.р. транша сделки */                                    
				tmpStr = GetXAttrValueEx("loan", bfrFirstLoanLine.contract + "," + bfrFirstLoanLine.cont-code, "PrevLoanID", "").
			END.

			/** Найдем сумму сделки */
			FIND FIRST bfrLoanAmount WHERE bfrLoanAmount.contract = bfrFirstLoan.contract AND 
			                               bfrLoanAmount.cont-code = bfrFirstLoan.cont-code AND
			                               bfrLoanAmount.end-date = bfrFirstLoan.open-date AND
			                               bfrLoanAmount.class-code = "mml-pr-obl" NO-LOCK NO-ERROR.
			                                   
			/** Определим все пролонгации по сделке. На самом деле, т.к. разрабатывалось все в спешке и без документации о структуре
			и технологии, пролонгация одна! на сумму первой сделки!  */
			FOR EACH bfrPay WHERE bfrPay.contract = bfrFirstLoan.contract AND
			                         bfrPay.cont-code = bfrFirstLoan.cont-code AND
			                         CAN-DO("mml-*-obl", bfrPay.class-code) AND
			                         bfrPay.end-date = bfrFirstLoan.open-date NO-LOCK
			  :
			  	outPayHtmlCode = outPayHtmlCode + 
			  		"<tr valign=top><td>" + bfrRolloveredLoan.doc-num + "</td>" + 
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td>" +
			  		"<td align=right>" + TRIM(STRING(GetLoanCommissionEx_ULL(bfrRolloveredLoan.contract, bfrRolloveredLoan.cont-code, "%Кред", bfrRolloveredLoan.open-date, false, tmpStr), ">>9.99")) + "</td>" +
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>" + cr. 
      END.
      			  		
			/** Определим все входящие платежи по сделке */
			FOR EACH bfrPay WHERE bfrPay.contract = ttCurrentLoan.contract AND
			                         bfrPay.cont-code = ttCurrentLoan.cont-code AND
			                         CAN-DO("mml-*-call", bfrPay.class-code) NO-LOCK
			  :
			  	inPayHtmlCode = inPayHtmlCode + 
			  		"<tr valign=top><td>" + STRING(bfrPay.end-date, "99.99.9999") + "</td>" + 
			  		"<td>" + currency.i-currency + "</td>" + 
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td>". 
			  		
			  	/** В зависимости от класса следующие поля должны заполняться по-разному */
			  	CASE ENTRY(2, bfrPay.class-code, "-") :
			  		WHEN "pr" THEN 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + ttCurrentLoan.loan-acct + "</td>" + 
			  				"<td>" + bfrPay.acct + "</td>".
			  			END.
			  		WHEN "int" THEN 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + ttCurrentLoan.pers-acct + "</td>" + 
			  				"<td>" + bfrPay.acct + "</td>".
			  			END.
			  		OTHERWISE 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + "не определен" + "</td>" + 
			  				"<td>" + "не определен" + "</td>".
			  			END.
			  			
					END CASE.
					
			  	inPayHtmlCode = inPayHtmlCode + "</tr>" + cr.
			END.
			
  	  /** ------------------------------------- Вывод данных -------------------------------------- */
  	  OUTPUT TO VALUE(fileName) CONVERT TARGET "1251" SOURCE SESSION:CHARSET. 
  	  PUT UNFORMATTED "<html>" + cr.
  	  PUT UNFORMATTED '<head><title></title><meta http-equiv="Content-Type" content="text/html; application/msword; charset=windows-1251"></head>' + cr.

  	  PUT UNFORMATTED "<body>" + cr.

  	  /** Общая структура документа */
  	  PUT UNFORMATTED "<table border=0 widht=100% height=100% bgcolor=#000000 cellpadding=0 cellspacing=1>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td>" + bankName + "</td><td>Утверждаю<br>" 
  	  										+ ENTRY(2, agreeUser) + "<br>_____________" + ENTRY(3, agreeUser) 
  	  										+ "</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>РАСПОРЯЖЕНИЕ<br>ПО СДЕЛКЕ НА МЕЖБАНКОВСКОМ ДЕНЕЖНОМ РЫНКЕ<br><br>N " 
  	  										+ ttCurrentLoan.doc-num + "</b></td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>ОСНОВНЫЕ УСЛОВИЯ<b><br>" + cr +
  	  									  "<table border=0 width=100%>" + cr +
  	  									  	"<tr><td valign=top>" + cr +
  	  									  		"<table border=0><tr><td>Дата сделки</td><td>" + STRING(ttCurrentLoan.open-date, "99.99.9999") + "</td></tr>" + cr +
  	  									  		"<tr><td>Сделка</td><td><b>Пролонгация</b></td></tr>" + cr +
  	  									  		"<tr><td>Контрагент</td><td>" + 
  	  									  			(IF ttCurrentLoan.currency = "" THEN ttBankCorrespond.name + "<br>ИНН " + ttBankCorrespond.inn
  	  									  			                                ELSE ttBankCorrespond.engl-name + ",<br>" + ttBankCorrespond.swift) + 
  	  									  		  "</td></tr>" + cr +
  	  									  		"<tr><td>Генеральное соглашение</td><td>№ " + bfrGeneralLoan.doc-ref + " от " + STRING(bfrGeneralLoan.open-date, "99.99.9999") + "</td></tr>" + cr +
  	  									  		"</table>" + cr +
  	  									  	"</td><td valign=top>" + cr +
  	  									  		"<table border=0><tr><td>Валюта</td><td>" + currency.i-currency + "</td></tr>" + cr +
  	  									  		"<tr><td>Сумма</td><td>" + TRIM(STRING(bfrLoanAmount.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>" + cr +
  	  									  		"<tr><td>Ставка</td><td>" + TRIM(STRING(GetLoanCommissionEx_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, "%Кред", ttCurrentLoan.open-date, false, tmpStr), ">>9.99")) + "</td></tr>" + cr +
  	  									  		"<tr><td>Дата начала</td><td>" + STRING(ttCurrentLoan.open-date, "99.99.9999") + "</td></tr>"
  	  									  		"<tr><td>Дата окончания</td><td>" + STRING(ttCurrentLoan.end-date, "99.99.9999") + "</td></tr>"
  	  									  		"<tr><td>Количество дней</td><td>" + STRING(INT(ttCurrentLoan.end-date - ttCurrentLoan.open-date)) + "</td></tr>"
  	  									  		"<tr><td>Сумма процентов</td><td>" + TRIM(STRING(bfrPersentAmount.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>"
  	  									  		"</table>" + cr +
  	  									  	"</td></tr>" + cr +
  	  										"</table>" + cr +
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>ПРОЛОНГАЦИЯ</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>Номер сделки<hr size=1></td><td align=right>Сумма сделки<hr size=1></td><td align=right>Ставка<hr size=1></td><td align=right>Сумма пролонгации<hr size=1></td></tr>" + cr +
  	  											outPayHtmlCode + 
  	  										"</table>" + cr + 
  	  										"<br>" + cr +
  	  										"<table border=0 width=100%><tr><td>Первая сделка</td><td>N " + bfrFirstLoan.doc-num + " от " + STRING(bfrFirstLoan.open-date, "99.99.9999") + " (всего кол-во дней: " + STRING(INT(ttCurrentLoan.end-date - bfrFirstLoan.open-date)) + ")</td></tr></table>" + cr +
  	  										"<br><b>ПЛАТЕЖИ КОНТРАГЕНТА</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>Дата<hr size=1></td><td>Валюта<hr size=1></td><td align=right>Сумма<hr size=1></td><td>Реквизиты<hr size=1></td><td>Транзакция<hr size=1></td></tr>" + cr +
  	  											inPayHtmlCode + 
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>Категория качества</td><td>" + STRING(ttCurrentLoan.gr-riska) + " (" + STRING(ttCurrentLoan.risk) + "%)</td></tr>" + cr +
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>ОТМЕТКИ КАЗНАЧЕЙСТВА</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>Дата и время</td><td>" + STRING(TODAY, "99.99.9999") + " " + STRING(TIME, "HH:MM:SS") + "</td></tr>" + cr +
  	  											kaznaSignsHtmlCode + 
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td width=60%><b>ОТМЕТКА ДЕПАРТАМЕНТА УЧЕТА И ОТЧЕТНОСТИ</b></td><td>_____________(" + ENTRY(3, reportUser) + 
  	  											")</td></tr>" + cr +
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	                  "</table>" + cr.
  	  PUT UNFORMATTED "</body>" + cr.
  	  PUT UNFORMATTED "</html>" + cr.
  	  
  	  OUTPUT CLOSE.  	  
  	  
  	  MESSAGE "Файл сформирован и сохранен в " + fileName VIEW-AS ALERT-BOX.
  	  
END.
