/**
 * Проверка+справка о необходимости уведомлять ПОДФТ перед изменением документа в закрытом опер.дне
 * силами У2-3.
 *
 * Использует алгоритм 1-6.
 */
 
{globals.i}

{tmprecid.def}

{pir-chkop-6.def &closeday=yes}

DEF VAR iParam AS CHAR NO-UNDO INIT "".

DEF BUFFER lbfrOpEntryCr FOR op-entry.
DEF BUFFER lbfrAcctDb FOR acct.
DEF BUFFER lbfrAcctCr FOR acct.

{ulib.i}

{setdest.i}

/** По всем выбранным в броузере документам */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry OF op WHERE op-entry.acct-db <> ? NO-LOCK,
    FIRST lbfrOpEntryCr OF op WHERE lbfrOpEntryCr.acct-cr <> ? NO-LOCK,
    FIRST lbfrAcctDb WHERE lbfrAcctDb.acct = op-entry.acct-db NO-LOCK,
    FIRST lbfrAcctCr WHERE lbfrAcctCr.acct = lbfrOpEntryCr.acct-cr NO-LOCK
    :
    
    podft_need = false.
    
    /** внутри инклюдника происходит присвоение podft_need */
    {pir-chkop-6.i &closeday=yes}

    PUT UNFORMATTED 
    	"ДОКУМЕНТ N" op.doc-num " ОТ " op.doc-date FORMAT "99/99/9999" SKIP(1)
    	"опер.день       : " op.op-date FORMAT "99/99/9999" SKIP
    	"дебет           : " lbfrAcctDb.acct FORMAT "x(20)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctDb.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctDb.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"кредит          : " lbfrAcctCr.acct FORMAT "x(20)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctCr.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctCr.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"валюта          : " (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency) FORMAT "x(3)" SKIP
    	"сумма           : " op-entry.amt-cur FORMAT ">,>>>,>>>,>>>,>>9.99" SKIP
    	"сумма руб.эквив.: " op-entry.amt-rub FORMAT ">,>>>,>>>,>>>,>>9.99" SKIP
    	"назначение п-жа : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 101, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 151, 50) FORMAT "x(50)" SKIP
    	"код документа   : " op.doc-type FORMAT "x(3)" SKIP
    	"кассовый символ : " STRING(op-entry.symbol) SKIP 
    	"создатель док-та: " GetUserInfo_ULL(op.user-id, "fio", false) FORMAT "x(30)" SKIP
    	"время справки   : " TODAY FORMAT "99/99/9999" " " STRING(TIME, "HH:MM:SS") SKIP(1)
    	"1. Дополнительный реквизит op.PIRcheckPODFT : " 
    		GetXAttrValueEx("op", STRING(op.op), "PIRcheckPODFT", "(пусто)") SKIP
    	"   (Документ проверен ПОДФТ)" SKIP(1)
    	 
    	"2. Дополнительный реквизит op.КодОпОтмыв    : "
    		GetXAttrValueEx("op", STRING(op.op), "КодОпОтмыв", "(пусто)") SKIP
    	"   (Легализация доходов. Код Операции)" SKIP(1) 
    		
    	"3. Дополнительный реквизит op.ПодозДокумент : "
    		GetXAttrValueEx("op", STRING(op.op), "ПодозДокумент", "(пусто)") SKIP
    	"   (Легализация доходов. Подоз.документ)" SKIP(1)
    		
    	"ЗАКЛЮЧЕНИЕ: " (IF podft_need THEN 
    		"Б. модификация документа ТРЕБУЕТ согласования Отдела ПОД/ФТ" ELSE
    		"А. модификация документа НЕ требует согласования Отдела ПОД/ФТ") SKIP(2)
    	"Подразделение-инициатор: " GetXAttrValueEx("_user", USERID, "group-id", "") SKIP(1)
    	"Сотрудник подразделения: ____________________ /" GetUserInfo_ULL(USERID, "fio", false) "/" SKIP(1)
    	"Исполнил Сотрудник У2-3: ____________________ /_________________________/" SKIP(1).
    IF podft_need THEN DO:
    	PUT UNFORMATTED
    	"Сотрудник Отдела ПОДФТ : ____________________ /_________________________/" SKIP(1)
    	"РЕЗОЛЮЦИЯ: ______________________________________________________________" SKIP(1)
    	"_________________________________________________________________________" SKIP.
    END. 
	PUT UNFORMATTED
    	"-------------------------------------------------------------------------------------------------------" SKIP(1).
END.

{preview.i} 