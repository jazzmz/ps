/* ------------------------------------------------------
     File: $RCSfile: pir_pctr_rep.p,v $ $Revision: 1.1 $ $Date: 2008-08-18 12:08:44 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: ТЗ от 31 мая 2008 года
     Что делает: Формирует журнал по транзакциям по ПК.
     Как работает: Делает выборку за запрашиваемый период, группируя по:
                   1) Валюте (рубли/валюта) операции
                   2) Типу операции (pc-trans.inpc-code 
                      [details from classicator 'PIRCT2T'])
                   3) Валюте карты (счета) (код валюты)
                   
                   Для хранения выборки используется временная таблица ttReport.
                   
     Параметры: 
     Место запуска: Броузер транзакций ПЦ  
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

{globals.i}
/** Библиотека моих процеДурок (ПИРБАНК) */
{ulib.i}
{intrface.get xclass}

/* {tmprecid.def} */

/** Определим буфер для поиска карты. (loan менее наглядно, чем bfrCard ) */
DEF BUFFER bfrCard FOR LOAN.
/** Определим буфер для поиска суммы в валюте карты (счета) */
DEF BUFFER bfrTransAmtCard FOR pc-trans-amt.
/** Определим буфер для поиска суммы в валюте операции */
DEF BUFFER bfrTransAmtOper FOR pc-trans-amt.
/** Определим буфер для поиска суммы комиссии */
DEF BUFFER bfrTransAmtComm FOR pc-trans-amt.
/** Итоговые значения */
DEF VAR totalCount AS INTEGER NO-UNDO.
DEF VAR totalCardAmount AS DECIMAL NO-UNDO.
DEF VAR totalCommAmount AS DECIMAL NO-UNDO.
DEF VAR totalAllCount AS INTEGER INIT 0 NO-UNDO.

/** Здесь храним выборку */
DEFINE TEMP-TABLE ttReport
	FIELD cardNumber AS CHAR
	FIELD clientFIO AS CHAR
	FIELD clientAccount AS CHAR
	FIELD paySystem AS CHAR /** Платежная система MC or Visa */
	FIELD operAmount AS DECIMAL /** Сумма в валюте операции */
	FIELD operCurrency AS CHAR /** Валюта операции */
		FIELD isNationalCurrency AS LOGICAL /** рубли/валюта ? */
	FIELD operPlace AS CHAR /** Местро проведения операции */
		FIELD operType AS CHAR /** Тип операции */
		FIELD operName AS CHAR /** Название типа операции */
	FIELD cardAmount AS DECIMAL /** Сумма в валюте карты (счета) */
	FIELD cardCurrency AS CHAR /** Валюта карты (счета) */
	FIELD currencyRate AS DECIMAL /** Курс пересчета */
	FIELD commAmount AS DECIMAL /** Сумма комиссии */
	INDEX mainIndex isNationalCurrency operType cardCurrency
.

/** Выбираем все ТП за запрашиваемый период */
/* 
FOR 	EACH tmprecid NO-LOCK,
		FIRST pc-trans WHERE RECID(pc-trans) = tmprecid.id NO-LOCK,
*/
{getdates.i}
FOR EACH pc-trans WHERE pc-trans.cont-date GE beg-date
                        AND
                        pc-trans.cont-date LE end-date
                        NO-LOCK,
		FIRST bfrCard WHERE bfrCard.contract = "card"
		                    AND 
		                    bfrCard.doc-num = pc-trans.num-card 
		                    NO-LOCK,
		FIRST bfrTransAmtOper WHERE bfrTransAmtOper.pctr-id = pc-trans.pctr-id
		                            AND bfrTransAmtOper.amt-code = "СУМТ" NO-LOCK,
		FIRST bfrTransAmtCard WHERE bfrTransAmtCard.pctr-id = pc-trans.pctr-id
		                            AND bfrTransAmtCard.amt-code = "СУМСЧ" NO-LOCK,		
		FIRST bfrTransAmtComm WHERE bfrTransAmtComm.pctr-id = pc-trans.pctr-id
		                            AND bfrTransAmtComm.amt-code = "КМССЧ" NO-LOCK		
	:
		CREATE ttReport.
		ttReport.cardNumber = pc-trans.num-card.
		
		/** Из карты можно найдти договор, но это не нужно. Счета договора, реквизиты клиента
		    можно достать из bfrCard. */
		ttReport.clientFIO = GetLoanInfo_ULL(bfrCard.contract, bfrCard.cont-code, 
		                                     "client_name", false).
		
		/** Найдем счет клиента. Используем сумму в валюте счета для поиска (валюта и дата операции) */
		ttReport.clientAccount = GetLoanAcct_ULL(bfrCard.parent-contract, bfrCard.parent-cont-code, 
		                                          "SCS@" + bfrTransAmtCard.currency, 
		                                          bfrTransAmtCard.cont-date, false).                                     
		/** Платежная система */
		ttReport.paySystem = pc-trans.pl-sys.

		/** Сумма и валюта операции */
		ttReport.operAmount = bfrTransAmtOper.amt-cur.
		ttReport.operCurrency = bfrTransAmtOper.currency.
		IF ttReport.operCurrency = "" THEN ttReport.operCurrency = "810".
		ttReport.isNationalCurrency = ttReport.operCurrency EQ "810".
		ttReport.operPlace = pc-trans.eq-country + "," + pc-trans.eq-city + "," + pc-trans.eq-location.
		ttReport.operType = pc-trans.inpc-code.
		ttReport.operName = GetCodeName("PIRCT2T", ttReport.operType).
		
		/** Cумма и валюта счета */
		ttReport.cardAmount = bfrTransAmtCard.amt-cur.
		ttReport.cardCurrency = bfrTransAmtCard.currency.
		IF ttReport.cardCurrency = "" THEN ttReport.cardCurrency = "810".		
		/** Курс пересчета */
		ttReport.currencyRate = 0. 

		/** Сумма комиссии */
		ttReport.commAmount = bfrTransAmtComm.amt-cur.		
		
		
END. /** loop tmprecid */

/** Формирование отчета */
{setdest.i}
PUT UNFORMATTED
"Период: " beg-date " - " end-date SKIP(1)
"┌────────────────────┬────────────────────┬────────────────────┬────┬───────────────────┬───┬────────┬───────────────────┬───┬───────────────────┬────────────────────┐" SKIP
"│НОМЕР КАРТЫ         │ФИО КЛИЕНТА         │СЧЕТ КЛИЕНТА        │ПС  │СУММА В ВАЛ.ОПЕР.  │ВАЛ│КУРС    │СУММА В ВАЛ.КАРТЫ  │ВАЛ│КОМИССИЯ           │МЕСТО ПРОВЕДЕНИЯ    │" SKIP
"├────────────────────┴────────────────────┴────────────────────┴────┴───────────────────┴───┴────────┴───────────────────┴───┴───────────────────┴────────────────────┤" SKIP.
FOR EACH ttReport NO-LOCK
	BREAK BY ttReport.isNationalCurrency DESC
		  BY ttReport.operType
		  BY ttReport.cardCurrency :
	
	IF FIRST-OF(ttReport.isNationalCurrency) THEN DO:
		PUT UNFORMATTED "│" (IF isNationalCurrency THEN "РУБЛЕВЫЕ ОПЕРАЦИИ" 
		                 ELSE "ВАЛЮТНЫЕ ОПЕРАЦИИ") FORMAT "x(165)" "│" SKIP.
	   	PUT UNFORMATTED
	   	"├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP.
	END.	              
	IF FIRST-OF(ttReport.operType) THEN DO:
		PUT UNFORMATTED "│" ttReport.operName FORMAT "x(165)" "│" SKIP.
	   	PUT UNFORMATTED
	   	"├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP.
	END.
	IF FIRST-OF(ttReport.cardCurrency) THEN DO:
		PUT UNFORMATTED "│" ttReport.cardCurrency FORMAT "x(165)" "│" SKIP.
	   	PUT UNFORMATTED
	   	"├────────────────────┬────────────────────┬────────────────────┬────┬───────────────────┬───┬────────┬───────────────────┬───┬───────────────────┬────────────────────┤" SKIP.
	END.
	PUT UNFORMATTED "│"
		ttReport.cardNumber FORMAT "x(20)" "│"
		ttReport.clientFIO FORMAT "x(20)" "│"
		ttReport.clientAccount FORMAT "x(20)" "│"
		ttReport.paySystem FORMAT "x(4)" "│"
		ttReport.operAmount FORMAT "->>>,>>>,>>>,>>9.99" "│"
		ttReport.operCurrency FORMAT "x(3)" "│"
		ttReport.currencyRate FORMAT ">>9.9999" "│"
		ttReport.cardAmount FORMAT "->>>,>>>,>>>,>>9.99" "│"
		ttReport.cardCurrency FORMAT "x(3)" "│"
		ttReport.commAmount FORMAT "->>>,>>>,>>>,>>9.99" "│"
		ttReport.operPlace FORMAT "x(20)" "│"
		SKIP.
		
		totalCount = totalCount + 1.
		totalCardAmount = totalCardAmount + ttReport.cardAmount.
		totalCommAmount = totalCommAmount + ttReport.commAmount.
		
	IF LAST-OF(ttReport.isNationalCurrency) OR 
	   LAST-OF(ttReport.operType) OR
	   LAST-OF(ttReport.cardCurrency) THEN
	DO:
		
	   	PUT UNFORMATTED
	   	"├────────────────────┼────────────────────┼────────────────────┼────┼───────────────────┼───┼────────┼───────────────────┼───┼───────────────────┼────────────────────┤" SKIP.	
	   	PUT UNFORMATTED
	   	"│ИТОГО:" totalCount FORMAT ">>>>>>>>>>>>>9" "│                    │                    │    │                   │   │        │" totalCardAmount FORMAT "->>>,>>>,>>>,>>9.99" 
	   	"│   │" totalCommAmount FORMAT "->>>,>>>,>>>,>>9.99" "│                    │" SKIP.
	   	PUT UNFORMATTED
	   	"├────────────────────┴────────────────────┴────────────────────┴────┴───────────────────┴───┴────────┴───────────────────┴───┴───────────────────┴────────────────────┤" SKIP.
	   	
	   	totalAllCount = totalAllCount + totalCount.
	   	totalCount = 0.
	   	totalCardAmount = 0.
	   	totalCommAmount = 0.
	   	
	END.
	
	
END. /** loop ttReport */
PUT UNFORMATTED
"│ИТОГО:" totalAllCount FORMAT ">>>>>>>>>>>>>9" SPACE(145) "│" SKIP
"└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘" SKIP.
{preview.i}
