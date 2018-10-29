/**
 *	������᪨� �थ� 2161-�
 */
 
{globals.i}
{wordwrap.def} /** ��।������ �⨫��� ��७�� �� ᫮��� */
{ulib.i}
{intrface.get xclass}

/** ����䨪��� ����樨 */
&IF DEFINED(MULTI-FROM-OP) &THEN
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.
{tmprecid.def}
&ELSEIF DEFINED(MULTI-FROM-ENTRY) &THEN
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.
{tmprecid.def}
&ELSE
DEFINE INPUT PARAM rid AS RECID NO-UNDO.
&ENDIF

DEF VAR page-rows AS INT INIT 70 NO-UNDO.
DEF VAR page-count AS INT NO-UNDO.
DEF VAR row-count AS INT NO-UNDO.
DEF VAR left-space AS CHAR INIT "        " NO-UNDO.

DEF STREAM listDirExch.
DEF VAR theKontr  AS CHAR NO-UNDO.
DEF VAR theKontrID AS CHAR NO-UNDO.
DEF VAR theUser   AS CHAR FORMAT "x(22)" NO-UNDO.
DEF VAR theUserID AS CHAR NO-UNDO.
DEF VAR oldPackagePrint AS LOGICAL NO-UNDO.
DEF VAR group-acct AS CHAR NO-UNDO.
DEF VAR group-currency AS CHAR NO-UNDO.
DEF VAR ans AS CHAR FORMAT "x(10)"
	VIEW-AS COMBO-BOX 
	LIST-ITEMS "�� ������", "�� �।���" 
	INIT ""
	NO-UNDO.
	
DEF FRAME ans-frame
	ans
	WITH NO-LABELS TITLE "��� ᢮����?" OVERLAY CENTERED.
	
DEF VAR str AS CHAR NO-UNDO.
DEF VAR str2 AS CHAR NO-UNDO.

/** ���稪 ���㬥�⮢ */
DEF VAR i AS INT NO-UNDO.
/** ����� */
DEF VAR icount AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DEF VAR count AS INT NO-UNDO.

/** �६����� ��६����� - ��� ��直� �㦤 */
DEF VAR tmpStr AS CHAR EXTENT 5 NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO. 

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

DEF VAR loc-user-id AS CHAR NO-UNDO.
DEF VAR loc-inspector AS CHAR NO-UNDO.
DEF VAR loc-doc-date AS DATE NO-UNDO.

DEF VAR acct-db-found AS LOGICAL NO-UNDO.
DEF VAR acct-cr-found AS LOGICAL NO-UNDO.

DEF VAR can-lazer-print AS LOGICAL INIT YES NO-UNDO.

/** ����ன�� */

/** ��㤠 ���� ���� ���㬥�� */
DEF VAR date-from AS CHAR NO-UNDO.
date-from = FGetSetting("������᪨��थ�", "�����ऄ�⠈�", "").
IF NOT CAN-DO("op-date,doc-date", date-from) THEN date-from = "op-date".

/** ������������ ����� */
{get-bankname.i}

DEF VAR bank-name AS CHAR NO-UNDO.
bank-name = cBankName.

/** ��� ����樨 ��� ��� ��� �᪫�祭�� ���㬥�⮢ */
DEF VAR doc-type AS CHAR NO-UNDO.
doc-type = FGetSetting("������᪨��थ�", "�����ं������", "").

/** ��㯯����騥 ��� */
DEF VAR group-acct-mask-db AS CHAR NO-UNDO.
DEF VAR group-acct-mask-cr AS CHAR NO-UNDO.
group-acct-mask-db = FGetSetting("������᪨��थ�", "�����ः�㯑��", "").
group-acct-mask-cr = group-acct-mask-db.

/** ��।����� ���⥦� */
DEF VAR default-order AS CHAR NO-UNDO.
default-order = FGetSetting("������᪨��थ�", "�����ऎ�।��", "").

/** ������᪨� ��� */
DEF VAR client-acct-mask AS CHAR NO-UNDO.
client-acct-mask = FGetSetting("������᪨��थ�", "�����ऑ犫����", "").

/** ����� ���㬥�⮢ ��� ������ ����� �뢮���� ��� �ᯮ���⥫� */
DEF VAR print-user-for-doc-mask AS CHAR NO-UNDO.
print-user-for-doc-mask = FGetSetting("������᪨��थ�", "�����ए��ᯮ��", "*").

/** ���� ���㬥�⮢ ��� ��㯯���� ���� */
DEF VAR kind-can-group-print AS CHAR NO-UNDO.
kind-can-group-print = FGetSetting("������᪨��थ�", "�����ः�㯏���", "*").

DEF TEMP-TABLE rep2 NO-UNDO
	FIELD id AS INT
	FIELD str2 AS CHAR
	INDEX idx id.

DEF TEMP-TABLE doc NO-UNDO
	FIELD id AS INT
	FIELD okud AS CHAR 			/* (2) */
	FIELD doc-num AS CHAR		/* (3) */
	FIELD op-kind AS CHAR
	FIELD doc-date AS DATE		/* (4) */
	FIELD amt-str AS CHAR		/* (6) */ 
	FIELD amt-rub AS DEC 		/* (7) */
	FIELD amt-cur AS DEC		/* (7�) */
	FIELD acct-db-count AS INT
	FIELD acct-cr-count AS INT
	FIELD kind AS CHAR 			/* (18) */ 
	FIELD order AS CHAR 		/* (21) */
	FIELD details AS CHAR		/* (24) */
	FIELD group-acct AS CHAR
	FIELD op AS INT
	FIELD user-id AS CHAR
	FIELD inspector AS CHAR
	FIELD currency AS CHAR
	field op-status AS CHAR
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

/** �����-���� �������⥫�� ��।������ */
{pir_bankord.def}

/** �������� ⠡���� doctypes */
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

/** � ����ᨬ��� �� �窨 ����᪠ */

&IF DEFINED(MULTI-FROM-ENTRY) &THEN 
ans = GetParamByName_ULL(iParam, "group-by", "", ";").

/** ����� �� ����祭� �஢����, ���� ��� ��� ���㬥��,
    �஢����, �� ����� ���㬥� ����� ���� �����⠭ ��� ��,
    �ᯮ���� ����ன�� ����ਠ�쭎थ�.�����ः�㯏���.
    �஢�ઠ ������ ���४⭮ ��ࠡ��뢠�� ��� ����� ���㬥���, ⠪ � ����஢����
    ���뢠�� ࠧ������ ���� (���ਬ��, doctypes.acct-db) � ���������
    (���ਬ��, doctypes.not-acct-db)
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

/** ����� �� ����祭� ���㬥���, ���� �� �� �஢����,
    �஢����, �� ����� ���㬥� ����� ���� �����⠭ ��� ��,
    �ᯮ���� ����ன�� ����ਠ�쭎थ�.�����ः�㯏���.
    �஢�ઠ ������ ���४⭮ ��ࠡ��뢠�� ��� ����� ���㬥���, ⠪ � ����஢����
    ���뢠�� ࠧ������ ���� (���ਬ��, doctypes.acct-db) � ���������
    (���ਬ��, doctypes.not-acct-db)
*/
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id
    NO-LOCK:
	FOR EACH op-entry WHERE op-entry.op = op.op	NO-LOCK,
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


&IF DEFINED(MULTI-FROM-ENTRY) EQ 0 AND DEFINED(MULTI-FROM-OP) EQ 0 &THEN
		/** ��।���� ᢮��� ��� */
		
		
		/** ��� ������ ������஢������ ���㬥�⮢ */
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
			IF ans = "" THEN ans = "�� ������".
		END.
		IF TRIM(ans) = "�� ������" THEN DO:
			group-acct-mask-db = op-entry.acct-db.
			group-acct-mask-cr = "".
		END.	
		IF TRIM(ans) = "�� �।���" THEN DO:
			group-acct-mask-cr = op-entry.acct-cr.
			group-acct-mask-db = "".
		END.
&ENDIF

		/** ��� ����஢���� */
		IF op-entry.op-entry = 1 AND op-entry.acct-cr = ? THEN DO:
			group-acct = op-entry.acct-db.
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
		THEN DO:
			FIND doc WHERE  
				    doc.group-acct = op-entry.acct-db
				AND doc.doc-num = op.doc-num
				AND doc.doc-date = loc-doc-date
				AND doc.user-id = loc-user-id
				AND doc.inspector = loc-inspector
				AND doc.currency = op-entry.currency
				AND (IF op-entry.acct-cr <> ? THEN true ELSE doc.op EQ op-entry.op) 
				NO-ERROR.
			tmpStr2 = op-entry.acct-db.
		END.
		IF CAN-DO(group-acct-mask-cr, op-entry.acct-cr) 
			OR (op-entry.acct-db = ?) 
		THEN DO:
          		/*message "cr: mask=" + group-acct-mask-cr + ",group-acct=" + group-acct view-as alert-box.*/
          		FIND doc WHERE  
				    doc.group-acct = (IF op-entry.acct-db = ? THEN group-acct ELSE op-entry.acct-cr) 
				AND doc.doc-num = op.doc-num
				AND doc.doc-date = loc-doc-date
				AND doc.user-id = loc-user-id
				AND doc.inspector = loc-inspector
				AND doc.currency = (IF op-entry.acct-db = ? THEN group-currency ELSE op-entry.currency)
				AND (IF op-entry.acct-db <> ? THEN true ELSE doc.op EQ op-entry.op)
				NO-ERROR.
			tmpStr2 = op-entry.acct-cr.
		END.
		
		IF NOT AVAIL doc THEN DO:
			CREATE doc.
			doc.id = i.
	
			/** (2) ��� ��� */
			doc.okud = FGetSetting("������᪨��थ�", "�����ऊ������", "").
	
			/** (3) ����� ���㬥�� */
			doc.doc-num = op.doc-num.
			
			/** ��� �࠭���樨 */
			doc.op-kind = op.op-kind.
			
			/** (4) ��� ���㬥�� */
			doc.doc-date = loc-doc-date.
	
			/** �ᯮ���⥫� � ����஫�� */
			doc.user-id = loc-user-id.
			doc.inspector = loc-inspector.

			/** (18) ��� ����樨 */
			doc.kind = TRIM(doc-type).
			IF doc.kind = "" THEN doc.kind = op.doc-type.
	
			/** (21) ��।����� ���⥦� */
			doc.order = op.order-pay.
			IF doc.order = ? OR doc.order = "" THEN 
				doc.order = default-order.
	
			/** (24) ᮤ�ঠ��� ����樨 */
&IF DEFINED(MULTI-FROM-ENTRY) EQ 0 AND DEFINED(MULTI-FROM-OP) EQ 0 &THEN
			doc.details = op.details.
&ELSE
			doc.details = GetCode("PirBODetails", doc.doc-num).
			IF doc.details = ? or doc.details = "" THEN
				doc.details = op.details.
			doc.details = REPLACE(doc.details, "#ddm", MONTH_NAMES[MONTH(doc.doc-date)]).
			doc.details = REPLACE(doc.details, "#ddy", STRING(YEAR(doc.doc-date))).
			doc.details = REPLACE(doc.details, "#dd", STRING(doc.doc-date, "99.99.9999")). 
&ENDIF
			/* (7) �㬬� � �㡫�� */
			doc.amt-rub = 0.
	
			/* (7�) �㬬� � ����� */
			doc.amt-cur = 0.
			
			doc.group-acct = tmpStr2.
			
			doc.op = op-entry.op.
			
			doc.currency = op-entry.currency.
			
			i = i + 1.
		END.
									
		IF op-entry.acct-db <> ? THEN DO:
		/** ���ଠ�� �� ������ */
		FIND FIRST acct-db WHERE acct-db.acct = op-entry.acct-db
								 AND acct-db.doc-id = doc.id 
								 AND CAN-DO(group-acct-mask-db, op-entry.acct-db)
								 NO-ERROR.
		IF NOT AVAIL acct-db THEN DO:
			CREATE acct-db.
			acct-db.doc-id = doc.id.
			acct-db.acct = op-entry.acct-db.
			acct-db.curr = op-entry.currency.
			IF CAN-DO(client-acct-mask, op-entry.acct-db) THEN DO: 
				tmpStr2 = GetAcctClientID_ULL(acct-db.acct, false).
				IF CAN-DO("�", ENTRY(1, tmpStr2)) THEN DO: 
					FIND FIRST acct WHERE acct.acct = op-entry.acct-db NO-LOCK.
					acct-db.name = acct.details.
				END.						
				IF CAN-DO("�,�,�", ENTRY(1, tmpStr2)) THEN DO: 
					acct-db.name = GetClientInfo_ULL(tmpStr2, "name", false).
				END.
			END. ELSE DO:
				acct-db.name = bank-name.
			END.
		END. 
		acct-db.amt-rub = acct-db.amt-rub + op-entry.amt-rub.
		acct-db.amt-cur = acct-db.amt-cur + op-entry.amt-cur.
		doc.acct-db-count = doc.acct-db-count + 1.
		END.
			
		IF op-entry.acct-cr <> ? THEN DO:	
		/** ���ଠ�� �� �।��� */
		FIND FIRST acct-cr WHERE acct-cr.acct = op-entry.acct-cr
								 AND acct-cr.doc-id = doc.id 
								 AND CAN-DO(group-acct-mask-cr, op-entry.acct-cr)
								 NO-ERROR.
		IF NOT AVAIL acct-cr THEN DO:
			CREATE acct-cr.
			acct-cr.doc-id = doc.id.
			acct-cr.acct = op-entry.acct-cr.
			acct-cr.curr = op-entry.currency.
			IF CAN-DO(client-acct-mask, op-entry.acct-cr) THEN DO: 
				tmpStr2 = GetAcctClientID_ULL(acct-cr.acct, false).
				IF CAN-DO("�", ENTRY(1, tmpStr2)) THEN DO: 
					FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK.
					acct-cr.name = acct.details.
				END.						
				IF CAN-DO("�,�,�", ENTRY(1, tmpStr2)) THEN DO: 
					acct-cr.name = GetClientInfo_ULL(tmpStr2, "name", false).
				END.
			END. ELSE DO:
				acct-cr.name = bank-name.
			END.
		END. 
		acct-cr.amt-rub = acct-cr.amt-rub + op-entry.amt-rub.
		acct-cr.amt-cur = acct-cr.amt-cur + op-entry.amt-cur.
		doc.acct-cr-count = doc.acct-cr-count + 1.
		END.
		
		doc.amt-rub = doc.amt-rub + op-entry.amt-rub.
		doc.amt-cur = doc.amt-cur + op-entry.amt-cur.
		
		/** �����-����� �������⥫�� ��᢮���� */
		{pir_bankord_oe.set}
	END.
	
	/** �᫨ ���⠥�� ���㬥�� �⮨� �� ����⥪� (op.op-status = "��") 
	    � ��� ������� � doc � ������� ����, ��।�������� ����. ���, �����
	    ��।���� ���, ����� ���㬥��� �� ��ࠡ�⠥�, ��⮬� �� � ���㬥�⮢, 
	    ���⠢������ �� ����⥪�, ��� op-entry, � �� ����稥 ���� 
	    ��易⥫�� �᫮���� ��ࠡ�⪨. 
	    �।����������, �� ����� ⠪�� ���㬥�� ���⠥��� �������窥. */
	IF op.op-status = "��" THEN DO:

		loc-doc-date = (IF date-from = "op-date" THEN op.op-date ELSE (IF op.doc-date = ? THEN op.op-date ELSE op.doc-date)).
		loc-user-id = FirstIndicateCandoIn_ULL("PirSigns", "first," + op.user-id + "," + op.op-kind, loc-doc-date, "*", "").
		IF (loc-user-id = ?) OR (loc-user-id = "") THEN loc-user-id = op.user-id.
		loc-inspector = FirstIndicateCandoIn_ULL("PirSigns", "second," + op.user-inspector + "," + op.op-kind, loc-doc-date, "*", "").
		IF (loc-inspector = ?) OR (loc-inspector = "") THEN loc-inspector = op.user-inspector.
		IF (loc-inspector = ? OR loc-inspector = "") AND (op.op-status >= CHR(251)) THEN loc-inspector = op.user-id.

		CREATE doc.
		doc.id = 1.

		/** (2) ��� ��� */
		doc.okud = FGetSetting("������᪨��थ�", "�����ऊ������", "").

		/** (3) ����� ���㬥�� */
		doc.doc-num = op.doc-num.
		
		/** ��� �࠭���樨 */
		doc.op-kind = op.op-kind.
		
		/** (4) ��� ���㬥�� */
		doc.doc-date = loc-doc-date.

		/** �ᯮ���⥫� � ����஫�� */
		doc.user-id = loc-user-id.
		doc.inspector = loc-inspector.

		/** (18) ��� ����樨 */
		doc.kind = TRIM(doc-type).
		IF doc.kind = "" THEN doc.kind = op.doc-type.
	
		/** (21) ��।����� ���⥦� */
		doc.order = op.order-pay.
		IF doc.order = ? OR doc.order = "" THEN 
			doc.order = default-order.
	
		/** (24) ᮤ�ঠ��� ����樨 */
			doc.details = op.details.

		/* (7) �㬬� � �㡫�� */
		doc.amt-rub = 0.
	
		/* (7�) �㬬� � ����� */
		doc.amt-cur = 0.
			
		doc.group-acct = tmpStr2.
			
		doc.op = op.op.
			
		doc.currency = "".
			
		CREATE acct-db.
		acct-db.doc-id = doc.id.
		/** ��� ����� ��᫥ ���⠭���� �� ����⥪� ��७����� � �.�. ���㬥�� */ 
		acct-db.acct = GetXAttrValueEx("op", STRING(op.op), "acctbal", "").
		/** �� ����⥪� �⠢���� ⮫쪮 �㡫��� ���㬥��� */
		acct-db.curr = "". 
		IF CAN-DO(client-acct-mask, acct-db.acct) THEN DO: 
			tmpStr2 = GetAcctClientID_ULL(acct-db.acct, false).
			IF CAN-DO("�", ENTRY(1, tmpStr2)) THEN DO: 
				FIND FIRST acct WHERE acct.acct = acct-db.acct NO-LOCK.
				acct-db.name = acct.details.
			END.						
			IF CAN-DO("�,�,�", ENTRY(1, tmpStr2)) THEN DO: 
				acct-db.name = GetClientInfo_ULL(tmpStr2, "name", false).
			END.
		END. ELSE DO:
			acct-db.name = bank-name.
		END.

		acct-db.amt-rub = DEC(GetXAttrValueEx("op", STRING(op.op), "amt-rub", "0")) NO-ERROR.
		/** �� ����⥪� ⮫쪮 �㡫��� ���㬥��� */
		acct-db.amt-cur = 0. 
		doc.acct-db-count = doc.acct-db-count + 1.
			
		CREATE acct-cr.
		acct-cr.doc-id = doc.id.
		acct-cr.acct = GetXAttrValueEx("op", STRING(op.op), "acctcorr", "").
		acct-cr.curr = "".
		IF CAN-DO(client-acct-mask, acct-cr.acct) THEN DO: 
			tmpStr2 = GetAcctClientID_ULL(acct-cr.acct, false).
			IF CAN-DO("�", ENTRY(1, tmpStr2)) THEN DO: 
				FIND FIRST acct WHERE acct.acct = acct-cr.acct NO-LOCK.
				acct-cr.name = acct.details.
			END.						
			IF CAN-DO("�,�,�", ENTRY(1, tmpStr2)) THEN DO: 
				acct-cr.name = GetClientInfo_ULL(tmpStr2, "name", false).
			END.
		END. ELSE DO:
			acct-cr.name = bank-name.
		END.
		acct-cr.amt-rub = DEC(GetXAttrValueEx("op", STRING(op.op), "amt-rub", "0")) NO-ERROR.
		acct-cr.amt-cur = 0.
		doc.acct-cr-count = doc.acct-cr-count + 1.
		
		doc.amt-rub = acct-cr.amt-rub.
		doc.amt-cur = acct-cr.amt-cur.
		
	END.
END.

FOR EACH doc:
	/* (6) �㬬� �ய���� */
	RUN x-amtstr.p(doc.amt-rub, "", true, true, output tmpStr[1], output tmpStr[2]).
	doc.amt-str = tmpStr[1] + ' ' + tmpStr[2].
	substr(doc.amt-str,1,1) = caps(substr(doc.amt-str,1,1)).

	IF doc.acct-db-count > 3 OR doc.acct-cr-count > 3 THEN can-lazer-print = NO.
	
	/** �����-����� �������⥫�� ��᢮���� */
	{pir_bankord_op.set}

END.

/** �뢮� � 䠩� */

{strtout3.i &option=Paged &cols=100 &custom="printer.page-lines - "}
oldPackagePrint = PackagePrint.
PackagePrint = YES.

DEF BUFFER b2acct-cr FOR acct-cr.
DEF BUFFER b2acct-db FOR acct-db.
DEF VAR dSumRub1 AS DECIMAL INITIAL 0.
DEF VAR dSumCur1 AS DECIMAL INITIAL 0.

FOR EACH doc:

	k = 0.
	{empty rep2}
/*** #1293 ***/
FOR EACH acct-cr WHERE acct-cr.doc-id EQ doc.id:	
dSumRub1 = 0.
dSumCur1 = 0.
	FOR EACH b2acct-cr WHERE b2acct-cr.acct = acct-cr.acct 
				 AND b2acct-cr.doc-id EQ doc.id
				 AND RECID(b2acct-cr) <> RECID(acct-cr):
             dSumRub1 = dSumRub1 + b2Acct-cr.amt-rub.
             dSumCur1 = dSumCur1 + b2Acct-cr.amt-cur.
	     DELETE b2acct-cr.
        END.
acct-cr.amt-rub = acct-cr.amt-rub + dSumRub1.
acct-cr.amt-cur = acct-cr.amt-cur + dSumCur1.
END.


FOR EACH acct-db WHERE acct-db.doc-id EQ doc.id:
dSumRub1 = 0.
dSumCur1 = 0.
 FOR EACH b2acct-db WHERE b2acct-db.acct = acct-db.acct
			  AND b2acct-db.doc-id EQ doc.id
			  AND RECID(b2acct-db) <> RECID(acct-db):
             dSumRub1 = dSumRub1 + b2Acct-db.amt-rub.
             dSumCur1 = dSumCur1 + b2Acct-db.amt-cur.
	DELETE b2acct-db.
 END.

 acct-db.amt-rub = acct-db.amt-rub + dSumRub1.
 acct-db.amt-cur = acct-db.amt-cur + dSumCur1.
END.

/*** ����� #1293 ***/
   

/* User and Kontr */
	FIND FIRST _user WHERE _user._userid = doc.user-id NO-LOCK.
	theUser   = TRIM(_user._user-name).
	theUserID = TRIM(_user._userid).
  IF ( TRIM(doc.inspector) NE "" ) AND ( TRIM(doc.inspector) NE theUserID ) THEN DO:
	FIND FIRST _user WHERE _user._userid = doc.inspector NO-LOCK.
	theKontr   = TRIM(_user._user-name).
	theKontrID = TRIM(_user._userid).
  END.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 75) + "�" + FILL("�", LENGTH(doc.okud)) + "�".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 75) + "�" + doc.okud + "�".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = FILL(" ", 75) + "�" + FILL("�", LENGTH(doc.okud)) + "�".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "".
    
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "���������� �����      N" + doc.doc-num + FILL(" ", 20) + STRING(doc.doc-date, "99.99.9999").
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                       " + FILL(" ", LENGTH(doc.doc-num)) + FILL(" ", 20) + "����������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                       " + FILL(" ", LENGTH(doc.doc-num)) + FILL(" ",20) + "   ���   ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "".     


/** (6) �㬬� �ய���� */
tmpstr[1] = doc.amt-str.
{wordwrap.i &s=tmpstr &l=45 &n=3}

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�����������������������������������������������������������������������������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�㬬�    � " + STRING(tmpstr[1], "x(47)") + " ���� ��.   �" + doc.kind.
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�ய���� � " + STRING(tmpstr[2], "x(47)") + " ������������������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "         � " + STRING(tmpstr[3], "x(47)") + " ����.����.�" + doc.order.
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�����������������������������������������������������������������������������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "      ���⥫�騪         �        ��.N        �           �㬬�          ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "������������������������ĳ���������������������������������������������������".

FOR EACH acct-db WHERE acct-db.doc-id = doc.id:
	
	tmpstr = acct-db.name.
	{wordwrap.i &s=tmpstr &l=25 &n=5}
	CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
	ASSIGN rep2.str2 = "#tab" + 
		STRING(tmpstr[1], "x(25)") + "�" + 
		STRING(acct-db.acct, "x(20)") + "�" + 
		REPLACE(STRING(acct-db.amt-rub, ">>>>>>>>>9.99"), ".", "-") + "�" + 
		(IF acct-db.amt-cur > 0 THEN REPLACE(STRING(acct-db.amt-cur, ">>>>>>>>9.99"), ".", "-") + "|" + acct-db.curr ELSE ""). 
	DO j = 2 TO 5:
		IF tmpstr[j] <> "" THEN DO:
			CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
			ASSIGN rep2.str2 = "#tab" + 
				STRING(tmpstr[j], "x(25)") + "�" +  
				FILL(" ",20) + "�" +  
				FILL(" ",13) + "�".
		END.
	END. 
	
END.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "���������������������������������������������ĳ             �                ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "      �����⥫�         �        ��.N        �             �                ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "������������������������ĳ�������������������ĳ             �                ".

FOR EACH acct-cr WHERE acct-cr.doc-id = doc.id:
	
	tmpstr = acct-cr.name.
	{wordwrap.i &s=tmpstr &l=25 &n=5}
	
	CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
	ASSIGN rep2.str2 = "#tab" + 
		STRING(tmpstr[1], "x(25)") + "�" + 
		STRING(acct-cr.acct, "x(20)") + "�" + 
		REPLACE(STRING(acct-cr.amt-rub, ">>>>>>>>>9.99"), ".", "-") + "�" + 
		(IF acct-cr.amt-cur > 0 THEN REPLACE(STRING(acct-cr.amt-cur, ">>>>>>>>9.99"), ".", "-") + "|" + acct-cr.curr ELSE "").
	DO j = 2 TO 5:
		IF tmpstr[j] <> "" THEN DO:
			CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
			ASSIGN rep2.str2 = "#tab" + 
				STRING(tmpstr[j], "x(25)") + "�" +  
				FILL(" ",20) + "�" +  
				FILL(" ",13) + "�".
		END.
	END. 
	
END.

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�����������������������������������������������������������������������������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "             �����祭�� ���⥦�               �                             ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "�����������������������������������������������������������������������������".
	
tmpstr[1] = doc.details.
{wordwrap.i &s=tmpstr &l=45 &n=5}
DEF VAR tempChar AS CHAR INIT "" NO-UNDO.
/*Message op.op-status VIEW-AS ALERT-BOX.*/
if op.op-status <> "��" then TempChar = STRING(doc.doc-date, "99.99.9999").

CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[1], "x(45)") + " �      �⬥⪨ ����� ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[2], "x(45)") + " �                    ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[3], "x(45)") + " �                " + TempChar.
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[4], "x(45)") + " �                    ".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + STRING(tmpstr[5], "x(45)") + " �                    ".
	     
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "���������������������������������������������Ĵ         ������".
CREATE rep2. k = k + 1. ASSIGN rep2.id = k.
ASSIGN rep2.str2 = "#tab" + "                                              �".

/** �ᥣ� ��ப */
row-count = 0.
FOR EACH rep2:
	row-count = row-count + 1.
END.

/** �ᥣ� ��࠭�� */
page-count = TRUNC(row-count / page-rows, 0) + MIN(1, row-count MOD page-rows).

/** ࠧ������ �� ��࠭��� � ���⠥� ����࠭�筮 */
DO i = 1 TO page-count - 1:

	beg-row = page-rows * (i - 1) + 1.
	end-row = MIN(page-rows * i, row-count).

	FIND FIRST rep2 WHERE rep2.id = MIN(i * page-rows, row-count).
	rep2.str2 = rep2.str2 +
		CHR(10) + CHR(10) + "#tab�����������������������������������������������������������������������������" 
			+ CHR(10) + "#tab" + STRING("            ","x(39)") + STRING("          ","x(39)")
			+ CHR(10) + "#tab" + STRING(theUser + "_______________________________________", "x(38)") + " " + STRING(theKontr + "______________________________________", "x(38)") 
			+ CHR(10) + CHR(10)	+  
		"#tab���� " + string(i) + " �� " + string(page-count). 

{pirlazerprn.lib &DATARETURN = pir_bankord.gen
                 &PRINTER_COLS = 100
				 &USER_SIGN_XY = "VALUE('/X:1000 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
				 &KONTR_SIGN_XY = "VALUE('/X:2900 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
                 {&*}}

END.

beg-row = page-rows * (page-count - 1) + 1.
end-row = MIN(page-rows * page-count, row-count).

FIND FIRST rep2 WHERE rep2.id = MIN(page-count * page-rows, row-count).
rep2.str2 = rep2.str2 +
	CHR(10) + 
	"#tab" + "                                              �" + CHR(10) +
	"#tab" + "                                              �" + STRING(theKontr + "_____________________________", "x(30)") + CHR(10) +
	"#tab" + "                                              �" + CHR(10) +
	"#tab" + "                                              �" + CHR(10) +
	"#tab" + "                                              �" + STRING(theUser + "_____________________________", "x(30)") + CHR(10) +
	
	/*
	"#tab�����������������������������������������������������������������������������" 
		+ CHR(10) + "#tab" + STRING("            ","x(39)") + STRING("          ","x(39)")
		+ CHR(10) + "#tab" + STRING(theUser + "_______________________________________", "x(38)") + " " + STRING(theKontr + "______________________________________", "x(38)") 
		+ CHR(10) + CHR(10)	+
	*/
	  
	"#tab���� " + string(page-count) + " �� " + string(page-count). 

{pirlazerprn.lib &DATARETURN = pir_bankord.gen
                 &PRINTER_COLS = 100
				 &USER_SIGN_XY = "VALUE('/X:2900 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
				 &KONTR_SIGN_XY = "VALUE('/X:2900 /Y:' + STRING((end-row - beg-row) * 75 - 900))"
				 &STAMPBO = YES
				 &STAMPBO_XY = "VALUE('/X:2300 /Y:' + STRING((end-row - beg-row) * 75 - 800))"
                 {&*}}


IF doc.id > 0 THEN 
	PUT UNFORMATTED CHR(12).

FOR EACH rep2:

	/** ������ */
	rep2.str2 = REPLACE(rep2.str2, "#tab", left-space).

	PUT UNFORMATTED rep2.str2 SKIP.
	
END.

END. /* doc */

PackagePrint = oldPackagePrint. /* �⮡� �뢥�� � preview */

{endout3.i &nofooter=yes}

