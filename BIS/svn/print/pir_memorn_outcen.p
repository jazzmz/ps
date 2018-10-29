{pirsavelog.p}

/*          
    Copyright: (C) ОАО КБ "Пpоминвестрасчет" , Управление автоматизации
     Filename: pir_memorn_outcen.p
      Comment: Банковский ордер 2181-У
      Used by:
      Created: 07.02.2011 - Ситов С.А.
/*Красков А.С. Добавил доп.строку для транзакций 1400104,1400105 по ТЗ от Судник */
*/

 
{globals.i}
{wordwrap.def} /** Определение утилиты переноса по словам */
{ulib.i}
{intrface.get xclass}

/** идетификатор операции */
&IF DEFINED(MULTI-FROM-OP) &THEN
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.
{tmprecid.def}
&ELSEIF DEFINED(MULTI-FROM-ENTRY) &THEN
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.
{tmprecid.def}
&ELSE
DEFINE INPUT PARAM rid AS RECID NO-UNDO.
&ENDIF

def var tempacct as char no-undo.
DEF VAR page-rows AS INT INIT 70 NO-UNDO.
DEF VAR page-count AS INT NO-UNDO.
DEF VAR row-count AS INT NO-UNDO.
DEF VAR left-space AS CHAR INIT "        " NO-UNDO.

DEF STREAM listDirExch.
DEF VAR theKontr  AS CHAR NO-UNDO.
DEF VAR theKontrID AS CHAR NO-UNDO.
DEF VAR theUser   AS CHAR FORMAT "x(22)" NO-UNDO.
DEF VAR theUserID AS CHAR NO-UNDO.
DEF VAR theRecipient  AS CHAR NO-UNDO.
DEF VAR oldPackagePrint AS LOGICAL NO-UNDO.
DEF VAR group-acct AS CHAR NO-UNDO.
DEF VAR group-currency AS CHAR NO-UNDO.
DEF VAR ans AS CHAR FORMAT "x(10)"
	VIEW-AS COMBO-BOX 
	LIST-ITEMS "По дебету", "По кредиту" 
	INIT ""
	NO-UNDO.
	
DEF FRAME ans-frame
	ans
	WITH NO-LABELS TITLE "Как сводить?" OVERLAY CENTERED.
	
DEF VAR str AS CHAR NO-UNDO.
DEF VAR str2 AS CHAR NO-UNDO.

/** счетчик документов */
DEF VAR i AS INT NO-UNDO.
/** итератор */
DEF VAR icount AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DEF VAR count AS INT NO-UNDO.

/** временная переменная - для всяких нужд */
DEF VAR tmpStr AS CHAR EXTENT 5 NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO. 

DEF VAR acct-db-found AS LOGICAL NO-UNDO.
DEF VAR acct-cr-found AS LOGICAL NO-UNDO.

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

DEF VAR loc-user-id AS CHAR NO-UNDO.
DEF VAR loc-inspector AS CHAR NO-UNDO.
DEF VAR loc-doc-date AS DATE NO-UNDO.

DEF VAR can-lazer-print AS LOGICAL INIT YES NO-UNDO.

/** настройки */

/** откуда брать дату документа */
DEF VAR date-from AS CHAR NO-UNDO.
date-from = FGetSetting("МемориальнОрдер", "МемоОрдДатаИз", "").
IF NOT CAN-DO("op-date,doc-date", date-from) THEN date-from = "op-date".

/** наименование банка */
{get-bankname.i}
DEF VAR bank-name AS CHAR NO-UNDO.
bank-name = cBankName.

/** вид операции для всех без исключения документов */
DEF VAR doc-type AS CHAR NO-UNDO.
doc-type = FGetSetting("МемориальнОрдер", "МемоОрдВидОпер", "09").

/** группирующие счета */
DEF VAR group-acct-mask-db AS CHAR NO-UNDO.
DEF VAR group-acct-mask-cr AS CHAR NO-UNDO.
group-acct-mask-db = FGetSetting("МемориальнОрдер", "МемоОрдГрупСчет", "").
group-acct-mask-cr = group-acct-mask-db.

/** группирующие счета */
DEF VAR client-acct-mask AS CHAR NO-UNDO.
client-acct-mask = FGetSetting("БанковскийОрдер", "МемоОрдСчКлиента", "").

/** виды документов для групповой печати */
DEF VAR kind-can-group-print AS CHAR NO-UNDO.
kind-can-group-print = FGetSetting("МемориальнОрдер", "МемоОрдГрупПчть", "*").

/** транзакции документов для которых можно выводить ФИО исполнителя */
DEF VAR print-user-for-doc-mask AS CHAR NO-UNDO.
print-user-for-doc-mask = FGetSetting("МемориальнОрдер", "МемоОрдПчтИсполн", "*").

DEF TEMP-TABLE rep2 NO-UNDO
	FIELD id AS INT
	FIELD str2 AS CHAR
	INDEX idx id.
	
DEF TEMP-TABLE doc NO-UNDO
	FIELD id AS INT
	FIELD okud AS CHAR 			
	FIELD doc-num AS CHAR		
	FIELD doc-date AS DATE	
	FIELD op-kind AS CHAR	
	FIELD name-ben AS CHAR	
	FIELD amt-str AS CHAR		 
	FIELD amt-rub AS DEC 		
	FIELD amt-cur AS DEC		
	FIELD acct-db-count AS INT
	FIELD acct-cr-count AS INT
	FIELD kind AS CHAR 			 
	FIELD order AS CHAR 		
	FIELD details AS CHAR		
	FIELD group-acct AS CHAR
	FIELD op AS INT
	FIELD user-id AS CHAR
	FIELD inspector AS CHAR
	FIELD currency AS CHAR
.

DEF BUFFER bfrDoc FOR doc.
DEF BUFFER bfrOpEntry FOR op-entry.
DEF BUFFER op-entry-2 FOR op-entry.

DEF TEMP-TABLE acct-db NO-UNDO
	FIELD group-id AS INT
	FIELD doc-id AS INT
	FIELD name AS CHAR
	FIELD acct AS CHAR
	FIELD amt-rub AS DECIMAL
	FIELD amt-cur AS DECIMAL
	FIELD qty AS DECIMAL
	FIELD curr AS CHAR
	FIELD op AS INT
	INDEX idx amt-rub acct
.
	
DEF TEMP-TABLE acct-cr NO-UNDO
	FIELD group-id AS INT
	FIELD doc-id AS INT
	FIELD name AS CHAR
	FIELD acct AS CHAR
	FIELD amt-rub AS DECIMAL
	FIELD amt-cur AS DECIMAL
	FIELD qty AS DECIMAL
	FIELD curr AS CHAR
	FIELD op AS INT
	INDEX idx amt-rub acct
.

DEF TEMP-TABLE groups NO-UNDO
	FIELD acct AS CHAR
	FIELD cnt AS INT
	FIELD side AS CHAR
.

DEF TEMP-TABLE doctypes NO-UNDO
	FIELD doc-type AS CHAR
	FIELD acct-db AS CHAR
	FIELD acct-cr AS CHAR
	FIELD not-acct-db AS CHAR
	FIELD not-acct-cr AS CHAR
.


DEF VAR oAcct       AS TAcct NO-UNDO.
DEF VAR db-contract AS CHAR  NO-UNDO.
DEF VAR cr-contract AS CHAR  NO-UNDO.

/** какие-либо дополнительные определения */
{pir_memorn.def}

/** заполним таблицу doctypes */
count = INT(GetParamByName_ULL(kind-can-group-print, "count", "0", ";")) NO-ERROR.
IF ERROR-STATUS:ERROR THEN count = 0.
DO i = 1 TO count :
	tmpStr[1] = GetParamByName_ULL(kind-can-group-print, "doc-type-" + STRING(i), "", ";").
	IF tmpStr[1] <> "" THEN DO:
		CREATE doctypes.
		doctypes.doc-type = tmpStr[1].
		doctypes.acct-db = GetParamByName_ULL(kind-can-group-print, "acct-db-" + STRING(i), "*", ";").
		doctypes.acct-cr = GetParamByName_ULL(kind-can-group-print, "acct-cr-" + STRING(i), "*", ";").
		doctypes.not-acct-db = GetParamByName_ULL(kind-can-group-print, "not-acct-db-" + STRING(i), "", ";").
		doctypes.not-acct-cr = GetParamByName_ULL(kind-can-group-print, "not-acct-cr-" + STRING(i), "", ";").
		/*message doctypes.doc-type + ";" + doctypes.acct-db + ";" + doctypes.acct-cr view-as alert-box.*/
	END.
END.

/** В зависимости от точки запуска */

&IF DEFINED(MULTI-FROM-ENTRY) &THEN
ans = GetParamByName_ULL(iParam, "group-by", "", ";").

/** выбрать все помеченые проводки, найти для них документ,
    проверить, что данный докумен может быть напечатан как МО,
    используя настройку МемориальнОрдер.МемоОрдГрупПчть.
    Проверка должна корректно обрабатывать как обычные документы, так и полупроводки
    учитывать разрешающую маску (например, doctypes.acct-db) и запрещающую
    (например, doctypes.not-acct-db)
*/
FOR EACH tmprecid NO-LOCK,
    FIRST op-entry WHERE RECID(op-entry) = tmprecid.id 
    	NO-LOCK:
    FOR FIRST op WHERE op.op = op-entry.op NO-LOCK,
    	FIRST doctypes WHERE CAN-DO(doctypes.doc-type, op.doc-type)
			AND (	
					(
						CAN-DO(doctypes.acct-db, op-entry.acct-db)
						OR
						(op-entry.acct-db = ? AND CAN-FIND(FIRST op-entry-2 WHERE op-entry-2.op = op.op AND CAN-DO(doctypes.acct-db, op-entry-2.acct-db)))
					)
					AND
					( 
						CAN-DO(doctypes.acct-cr, op-entry.acct-cr)
						OR
						(op-entry.acct-cr = ? AND CAN-FIND(FIRST op-entry-2 WHERE op-entry-2.op = op.op AND CAN-DO(doctypes.acct-cr, op-entry-2.acct-cr)))
					)
				)
			AND NOT 
				(
					(
						CAN-DO(doctypes.not-acct-db, op-entry.acct-db)
						AND
						NOT op-entry.acct-db = ?
					)
					AND
					( 
						CAN-DO(doctypes.not-acct-cr, op-entry.acct-cr)
						AND
						NOT op-entry.acct-cr = ?
					)
				)
    		NO-LOCK:
&ELSEIF DEFINED(MULTI-FROM-OP) &THEN
ans = GetParamByName_ULL(iParam, "group-by", "", ";").


/** выбрать все помеченые документы, найти все их проводки,
    проверить, что данный докумен может быть напечатан как МО,
    используя настройку МемориальнОрдер.МемоОрдГрупПчть.
    Проверка должна корректно обрабатывать как обычные документы, так и полупроводки
    учитывать разрешающую маску (например, doctypes.acct-db) и запрещающую
    (например, doctypes.not-acct-db)
*/
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id
    NO-LOCK:
	FOR EACH op-entry WHERE op-entry.op = op.op NO-LOCK,
	FIRST doctypes WHERE CAN-DO(doctypes.doc-type, op.doc-type)
			AND (	
					(
						CAN-DO(doctypes.acct-db, op-entry.acct-db)
						OR
						(op-entry.acct-db = ? AND CAN-FIND(FIRST op-entry-2 WHERE op-entry-2.op = op.op AND CAN-DO(doctypes.acct-db, op-entry-2.acct-db)))
					)
					AND
					( 
						CAN-DO(doctypes.acct-cr, op-entry.acct-cr)
						OR
						(op-entry.acct-cr = ? AND CAN-FIND(FIRST op-entry-2 WHERE op-entry-2.op = op.op AND CAN-DO(doctypes.acct-cr, op-entry-2.acct-cr)))
					)
				)
			AND NOT 
				(
					(
						CAN-DO(doctypes.not-acct-db, op-entry.acct-db)
						AND
						NOT op-entry.acct-db = ?
					)
					AND
					( 
						CAN-DO(doctypes.not-acct-cr, op-entry.acct-cr)
						AND
						NOT op-entry.acct-cr = ?
					)
				)
			NO-LOCK:


&ELSE
FOR EACH op WHERE RECID(op) =   rid NO-LOCK:
	FOR EACH op-entry WHERE op-entry.op = op.op
		NO-LOCK ON ENDKEY UNDO, RETURN:
&ENDIF
		
		RELEASE doc.
tempacct = op-entry.acct-db.
/**
 * По #1066 запоминаем назначение
 * счета.
 **/
oAcct = NEW TAcct(op-entry.acct-db).
 db-contract = oAcct:contract.
DELETE OBJECT oAcct.

oAcct = NEW TAcct(op-entry.acct-cr).
 cr-contract = oAcct:contract.
DELETE OBJECT oAcct.

&IF DEFINED(MULTI-FROM-ENTRY) EQ 0 AND DEFINED(MULTI-FROM-OP) EQ 0 &THEN
		/** определим сводный счет */
		
		
		/** для обычных многопроводочных документов */
		IF NOT CAN-FIND(FIRST groups) AND op-entry.acct-cr <> ? THEN DO:
			FOR EACH bfrOpEntry WHERE bfrOpEntry.op = op.op NO-LOCK:
				FIND FIRST groups WHERE groups.acct = bfrOpEntry.acct-db
					AND groups.side = "D"
					NO-LOCK NO-ERROR.
				IF AVAIL groups THEN groups.cnt = groups.cnt + 1.
				ELSE DO:
					CREATE groups.
					groups.acct = bfrOpEntry.acct-db.
					groups.side = "D".
					groups.cnt = 1.
				END.
				FIND FIRST groups WHERE groups.acct = bfrOpEntry.acct-cr
					AND groups.side = "C"
					NO-LOCK NO-ERROR.
				IF AVAIL groups THEN groups.cnt = groups.cnt + 1.
				ELSE DO:
					CREATE groups.
					groups.acct = bfrOpEntry.acct-cr.
					groups.side = "C".
					groups.cnt = 1.
				END.
			END.
			group-acct-mask-db = "".
			FOR EACH groups WHERE groups.cnt > 1 AND groups.side = "D":
				IF group-acct-mask-db <> "" THEN 
					group-acct-mask-db = group-acct-mask-db + ",".
				group-acct-mask-db = group-acct-mask-db + groups.acct.
			END.
			group-acct-mask-cr = "".
			FOR EACH groups WHERE groups.cnt > 1 AND groups.side = "C":
				IF group-acct-mask-cr <> "" THEN 
					group-acct-mask-cr = group-acct-mask-cr + ",".
				group-acct-mask-cr = group-acct-mask-cr + groups.acct.
			END.
			
			if group-acct-mask-db <> "" and group-acct-mask-cr <> "" then
				group-acct-mask-cr = "".
		END.
&ELSE
		IF NOT CAN-DO(group-acct-mask-db, op-entry.acct-db) AND
		   NOT CAN-DO(group-acct-mask-cr, op-entry.acct-cr) AND
		   ans = "" 
		THEN DO:
			PAUSE 0.
			UPDATE ans WITH FRAME ans-frame.
			HIDE FRAME ans-frame.
			IF ans = "" THEN ans = "По дебету".
		END.
		IF TRIM(ans) = "По дебету" THEN DO:
			group-acct-mask-db = op-entry.acct-db.
			group-acct-mask-cr = "".
		END.	
		IF TRIM(ans) = "По кредиту" THEN DO:
			group-acct-mask-cr = op-entry.acct-cr.
			group-acct-mask-db = "".
		END.
&ENDIF

/** для полупроводок */
IF op-entry.op-entry = 1 AND op-entry.acct-cr = ? THEN DO:
	group-acct = op-entry.acct-db.
	group-currency = op-entry.currency.
END.

IF op-entry.op-entry = 1 AND op-entry.acct-db = ? THEN DO:
	group-acct = op-entry.acct-cr.
	group-currency = op-entry.currency.
END.

loc-doc-date = (IF date-from = "op-date" THEN op.op-date ELSE (IF op.doc-date = ? THEN op.op-date ELSE op.doc-date)).
loc-user-id = FirstIndicateCandoIn_ULL("PirSigns", "first," + op.user-id + "," + op.op-kind, loc-doc-date, "*", "").
IF (loc-user-id = ?) OR (loc-user-id = "") THEN loc-user-id = op.user-id.
loc-inspector = FirstIndicateCandoIn_ULL("PirSigns", "second," + op.user-inspector + "," + op.op-kind, loc-doc-date, "*", "").
IF (loc-inspector = ?) OR (loc-inspector = "") THEN loc-inspector = op.user-inspector.
IF (loc-inspector = ? OR loc-inspector = "") AND (op.op-status >= CHR(251)) THEN loc-inspector = op.user-id.

		IF CAN-DO(group-acct-mask-db, op-entry.acct-db) 
			OR (op-entry.acct-db = group-acct)
			OR (op-entry.acct-cr = ?)
		THEN DO:
			/*message "db: mask=" + group-acct-mask-cr + ",group-acct=" + group-acct view-as alert-box.*/
			FIND doc WHERE  
				    doc.group-acct = (IF op-entry.acct-cr = ? THEN group-acct ELSE op-entry.acct-db)
				AND doc.doc-num = op.doc-num
				AND doc.doc-date = loc-doc-date
				AND doc.user-id = loc-user-id
				AND doc.inspector = loc-inspector
				AND doc.currency = (IF op-entry.acct-cr = ? THEN group-currency ELSE op-entry.currency)
				AND (IF op-entry.acct-cr <> ? THEN true ELSE doc.op EQ op-entry.op)
				NO-ERROR.
			tmpStr2 = op-entry.acct-db.
		END.
		IF CAN-DO(group-acct-mask-cr, op-entry.acct-cr) 
			OR (op-entry.acct-db = ?)
			OR (op-entry.acct-cr = group-acct) 
		THEN DO:
			/*message "cr: mask=" + group-acct-mask-cr + ",group-acct=" + group-acct view-as alert-box.*/
			FIND doc WHERE  
				    doc.group-acct = (IF op-entry.acct-db = ? THEN group-acct ELSE op-entry.acct-cr) 
				AND doc.doc-num = op.doc-num
				AND doc.doc-date = loc-doc-date
				AND doc.user-id = loc-user-id
				AND doc.inspector = loc-inspector
				AND doc.currency = (IF op-entry.acct-db = ? THEN group-currency ELSE op-entry.currency)
				AND (IF op-entry.acct-cr <> ? THEN true ELSE doc.op EQ op-entry.op)
				NO-ERROR.
			tmpStr2 = op-entry.acct-cr.
		END.
		
		IF NOT AVAIL doc THEN DO:
			CREATE doc.
			doc.id = i.
	
			/** (2) код формы */
			doc.okud = FGetSetting("МемориальнОрдер", "МемоОрдКодФормы", "").
	
			/** (3) номер документа */
			doc.doc-num = op.doc-num.
			
			/** получатель */
			doc.name-ben = op.name-ben.

			/** код транзакции */
			doc.op-kind = op.op-kind.
			
			/** исполнитель и контролер */
			doc.user-id = loc-user-id.
			doc.inspector = loc-inspector.

			/** (4) дата документа */
			IF date-from = "op-date" THEN doc.doc-date = op.op-date.
			IF date-from = "doc-date" THEN doc.doc-date = (IF op.doc-date = ? THEN op.op-date ELSE op.doc-date).
	
			/** (18) вид операции */
			doc.kind = TRIM(doc-type).
			IF doc.kind = "" THEN doc.kind = op.doc-type.
	
			/** (21) очередность платежа */
			doc.order = op.order-pay.
	
			/** (24) содержание операции */
&IF DEFINED(MULTI-FROM-ENTRY) EQ 0 AND DEFINED(MULTI-FROM-OP) EQ 0 &THEN
			doc.details = op.details.
&ELSE
			doc.details = GetCode("PirMODetails", doc.doc-num).
			IF doc.details = ? or doc.details = "" THEN
				doc.details = op.details.
			doc.details = REPLACE(doc.details, "#ddm", MONTH_NAMES[MONTH(doc.doc-date)]).
			doc.details = REPLACE(doc.details, "#ddy", STRING(YEAR(doc.doc-date))). 
			doc.details = REPLACE(doc.details, "#dd", STRING(doc.doc-date, "99.99.9999")).
&ENDIF
			/* (7) сумма в рублях */
			doc.amt-rub = 0.
	
			/* (7а) сумма в валюте */
			doc.amt-cur = 0.
			
			doc.group-acct = tmpStr2.
			
			doc.op = op-entry.op.
			
			doc.currency = op-entry.currency.
			
			i = i + 1.
		END.
		
		IF op-entry.acct-db <> ? THEN DO:
		/** информация по дебету */
		FIND FIRST acct-db WHERE acct-db.acct = op-entry.acct-db
								 AND acct-db.doc-id = doc.id 
								 AND CAN-DO(group-acct-mask-db, op-entry.acct-db)
								 NO-ERROR.
		IF NOT AVAIL acct-db THEN DO:
			CREATE acct-db.
			acct-db.doc-id = doc.id.
			acct-db.acct = op-entry.acct-db.
			acct-db.curr = op-entry.currency.
			FIND FIRST acct WHERE acct.acct = op-entry.acct-db NO-LOCK.
			tmpStr2 = GetAcctClientID_ULL(acct-db.acct, false).
			IF acct.details = ? THEN DO:
				IF CAN-DO("Ю,Ч,Б", ENTRY(1, tmpStr2)) THEN 
					acct-db.name = GetClientInfo_ULL(tmpStr2, "name", false).
				ELSE
					acct-db.name = "".
			END. ELSE
				acct-db.name = acct.details.
/*
			tmpStr2 = GetAcctClientID_ULL(acct-db.acct, false).
			IF CAN-DO("В", ENTRY(1, tmpStr2)) THEN DO: 
				IF doc.group-acct = op-entry.acct-db THEN 
					acct-db.name = bank-name.
				ELSE DO:
				END.						
			END.
			IF CAN-DO("Ю,Ч,Б", ENTRY(1, tmpStr2)) THEN 
				acct-db.name = GetClientInfo_ULL(tmpStr2, "name", false).
*/
		END. 
		acct-db.amt-rub = acct-db.amt-rub + op-entry.amt-rub.
		acct-db.amt-cur = acct-db.amt-cur + op-entry.amt-cur.
		doc.acct-db-count = doc.acct-db-count + 1.
		END.
			
		IF op-entry.acct-cr <> ? THEN DO:	
		/** информация по кредиту */
		FIND FIRST acct-cr WHERE acct-cr.acct = op-entry.acct-cr
								 AND acct-cr.doc-id = doc.id 
								 AND CAN-DO(group-acct-mask-cr, op-entry.acct-cr)
								 NO-ERROR.
		IF NOT AVAIL acct-cr THEN DO:
			CREATE acct-cr.
			acct-cr.doc-id = doc.id.
			acct-cr.acct = op-entry.acct-cr.
			acct-cr.curr = op-entry.currency.
			FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK.
			tmpStr2 = GetAcctClientID_ULL(acct-cr.acct, false).
			IF acct.details = ? THEN DO:
				IF CAN-DO("Ю,Ч,Б", ENTRY(1, tmpStr2)) THEN 
					acct-cr.name = GetClientInfo_ULL(tmpStr2, "name", false).
				ELSE
					acct-cr.name = "".
			END. ELSE
				acct-cr.name = acct.details.
/*
			tmpStr2 = GetAcctClientID_ULL(acct-cr.acct, false).
			IF CAN-DO("В", ENTRY(1, tmpStr2)) THEN 
				IF doc.group-acct = op-entry.acct-cr THEN 
					acct-cr.name = bank-name.
				ELSE DO:
				END.						
			IF CAN-DO("Ю,Ч,Б", ENTRY(1, tmpStr2)) THEN 
				acct-cr.name = GetClientInfo_ULL(tmpStr2, "name", false).
*/				
		END. 
		acct-cr.amt-rub = acct-cr.amt-rub + op-entry.amt-rub.
		acct-cr.amt-cur = acct-cr.amt-cur + op-entry.amt-cur.
		doc.acct-cr-count = doc.acct-cr-count + 1.
		END.
		
		doc.amt-rub = doc.amt-rub + op-entry.amt-rub.
		doc.amt-cur = doc.amt-cur + op-entry.amt-cur.
		
		/** какие-нибудь дополнительные присвоения */
		{pir_memorn_oe.set}
	END.
END.

FOR EACH doc:
	/* (6) сумма прописью */
	RUN x-amtstr.p(doc.amt-rub, "", true, true, output tmpStr[1], output tmpStr[2]).
	doc.amt-str = tmpStr[1] + ' ' + tmpStr[2].
	substr(doc.amt-str,1,1) = caps(substr(doc.amt-str,1,1)).

	IF doc.acct-db-count > 3 OR doc.acct-cr-count > 3 THEN can-lazer-print = NO.	

	/** какие-нибудь дополнительные присвоения */
	{pir_memorn_op.set}
	
END.

/** Вывод в файл */

{strtout3.i &option=Paged &cols=100 &custom="printer.page-lines - "}
oldPackagePrint = PackagePrint.
PackagePrint = YES.

FOR EACH doc:
	k = 0.
	{empty rep2}
	
	/* User and Kontr */
	FIND FIRST _user WHERE _user._userid = doc.user-id NO-LOCK.
  	theUser   = TRIM(_user._user-name).
  	theUserID = TRIM(_user._userid).
  IF ( TRIM(doc.inspector) NE "" ) AND ( TRIM(doc.inspector) NE theUserID ) THEN DO:
     FIND FIRST _user WHERE _user._userid = doc.inspector NO-LOCK.
     theKontr   = TRIM(_user._user-name).
     theKontrID = TRIM(_user._userid).
  END.
	theRecipient = TRIM(doc.name-ben) .

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 65) + "┌───────────────────┐".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 65) + "│Код формы документа│".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 65) + "│      по ОКУД      │".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 65) + "│      " + STRING(doc.okud, "x(13)") + "│".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 65) + "└───────────────────┘".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tabСоставитель " + bank-name.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = " ".

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "МЕМОРИАЛЬНЫЙ {&MEM_TYPE}ОРДЕР    N" + doc.doc-num + FILL(" ", 20) + STRING(doc.doc-date, "99.99.9999").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                       " + FILL(" ", LENGTH(doc.doc-num)) + FILL(" ", 20) + "──────────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                       " + FILL(" ", LENGTH(doc.doc-num)) + FILL(" ",20) + "   дата   ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "─────────────────────────┬────────────────────┬──────────────────────────────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + " Наименование счета      │   Дебет счета      │       Сумма цифрами     ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "─────────────────────────│────────────────────├─────────────┬────────────────".

FOR EACH acct-db WHERE acct-db.doc-id = doc.id:
	
	tmpstr = acct-db.name.
	{wordwrap.i &s=tmpstr &l=25 &n=5}
	CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
	ASSIGN rep2.str2 = "#tab" + 
		STRING(tmpstr[1], "x(25)") + "│" + 
		STRING(acct-db.acct, "x(20)") + "│" + 
		REPLACE(STRING(acct-db.amt-rub, ">>>>>>>>>9.99"), ".", "-") + "│" + 
		(IF acct-db.amt-cur > 0 THEN REPLACE(STRING(acct-db.amt-cur, ">>>>>>>>9.99"), ".", "-") + "|" + acct-db.curr ELSE ""). 
	DO j = 2 TO 5:
		IF tmpstr[j] <> "" THEN DO:
			CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
			ASSIGN rep2.str2 = "#tab" + 
				STRING(tmpstr[j], "x(25)") + "│" +  
				FILL(" ",20) + "│" +  
				FILL(" ",13) + "│".
		END.
	END. 
	
END.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "─────────────────────────┼────────────────────┤             │                ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + " Наименование счета      │    Кредит счета    │             │                ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "─────────────────────────│────────────────────│             │                ".

FOR EACH acct-cr WHERE acct-cr.doc-id = doc.id:
	
	tmpstr = acct-cr.name.
	{wordwrap.i &s=tmpstr &l=25 &n=5}
	
	CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
	ASSIGN rep2.str2 =  
		"#tab" + 
		STRING(tmpstr[1], "x(25)") + "│" + 
		STRING(acct-cr.acct, "x(20)") + "│" + 
		REPLACE(STRING(acct-cr.amt-rub, ">>>>>>>>>9.99"), ".", "-") + "│" + 
		(IF acct-cr.amt-cur > 0 THEN REPLACE(STRING(acct-cr.amt-cur, ">>>>>>>>9.99"), ".", "-") + "|" + acct-cr.curr ELSE "").
	DO j = 2 TO 5:
		IF tmpstr[j] <> "" THEN DO:
			CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
			ASSIGN rep2.str2 =  
				"#tab" + 
				STRING(tmpstr[j], "x(25)") + "│" +  
				FILL(" ",20) + "│" +  
				FILL(" ",13) + "│".
		END.
	END. 
	
END.

/** (6) сумма прописью */
tmpstr[1] = doc.amt-str.
{wordwrap.i &s=tmpstr &l=55 &n=3}

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "─────────────────────────┴────────────────────┴────────────┬──────────┬──────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + " Сумма прописью                                            │Шифр      │" + doc.kind.
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                                                           │документа │".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[1], "x(58)")                              + " ├──────────┼──────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[2], "x(58)")                              + " │          │".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[3], "x(58)")                              + " ├──────────┼──────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                                                           │          │".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "───────────────────────────────────────────────────────────┴──────────┴──────".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + " Содержание операции, наименование, номер и дата документа,".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + " на основании которого составлен мемориальный ордер ".

tmpstr[1] = doc.details.
{wordwrap.i &s=tmpstr &l=65 &n=5}

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[1], "x(65)").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[2], "x(65)").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[3], "x(65)").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[4], "x(65)").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[5], "x(65)").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
	
/** всего строк */
row-count = 0.
FOR EACH rep2:
	row-count = row-count + 1.
END.

/** всего страниц */
page-count = TRUNC(row-count / page-rows, 0) + MIN(1, row-count MOD page-rows).

/** разбиваем на страницы и печатаем постранично */
DO i = 1 TO page-count:

	beg-row = page-rows * (i - 1) + 1.
	end-row = MIN(page-rows * i, row-count).

	FIND FIRST rep2 WHERE rep2.id = MIN(i * page-rows, row-count).
	rep2.str2 = rep2.str2 +
		CHR(10) + CHR(10) + "#tab─────────────────────────────────────────────────────────────────────────────" 
			+ CHR(10) + "#tab" + STRING("Исполнитель:","x(39)") + STRING("Контролер:","x(39)")
			+ CHR(10) + "#tab" + STRING(theUser + "_______________________________________", "x(38)") + " " + STRING(theKontr + "______________________________________" ,"x(38)") 
			+ CHR(10) + CHR(10)	+  
		"#tabЛист " + string(i) + " из " + string(page-count).
		
	IF rep2.id = row-count THEN DO:
		rep2.str2 = rep2.str2 +
			CHR(10) + CHR(10) + "#tab─────────────────────────────────────────────────────────────────────────────" 
			+ CHR(10) + "#tab" + STRING("Приложение: ________________________ документов на ________________ листах.").

	/***************************************
	 * По #1066
	 * Если документ создан транзакцией
	 * из перечня, и по счету ДБ или Кредит
	 * стоит счет с назначением "Касса",
	 * то выводим слово "Принято".
	 **************************************
	 * Автор : Маслов Д. А.
	 * Заявка: #1066
	 * Дата создания: 09.07.12
	 **/
	if CAN-DO(FGetSetting("МемориальнОрдер","ПолучилВБН","!*"),op.op-kind) 
	   AND (db-contract EQ "Касса" OR cr-contract EQ "Касса") THEN rep2.str2 = rep2.str2 + CHR(10) + CHR(10) + "#tab" + STRING("Получил: _______________ /              /"). 

	END. 

{pirlazerprn.lib &DATARETURN = pir_memorn.gen
                 &PRINTER_COLS = 100
				 &USER_SIGN_XY = "VALUE('/X:1000 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
				 &KONTR_SIGN_XY = "VALUE('/X:2900 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
                 {&*}}

END.

IF doc.id > 0 THEN 
	PUT UNFORMATTED CHR(12).

FOR EACH rep2:

	/** отступы */
	rep2.str2 = REPLACE(rep2.str2, "#tab", left-space).

	PUT UNFORMATTED rep2.str2 SKIP.
END.

END. /* doc */

PackagePrint = oldPackagePrint. /* чтобы вывести в preview */

{endout3.i &nofooter=yes}
