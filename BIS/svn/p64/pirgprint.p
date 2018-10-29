/**
 *  Процедура, выполняющая групповую печать.
 *  Использует классификатор pirgprint - настроки фильтров.
 *  в параметрах запуска указываются:
 *    1) группа настроек фильтров, например group=u11
 
 */
 
DEFINE INPUT PARAM iParam AS CHAR.

{globals.i}

{ulib.i}

{tmprecid.def}

DEF VAR iGroup AS CHAR NO-UNDO.
iGroup = GetParamByName_ULL(iParam, "group", "", ";").
DEF VAR iDate AS DATE NO-UNDO.


DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DEF BUFFER bfrCode FOR code.
DEF BUFFER bfrCode2 FOR code.
DEF BUFFER op-entry-1 FOR op-entry.
DEF BUFFER op-entry-2 FOR op-entry.
DEF BUFFER op-entry-3 FOR op-entry.

DEF TEMP-TABLE groups NO-UNDO
	FIELD id AS INT
	FIELD code AS CHAR /** code.code */
	FIELD group-code AS CHAR
	INDEX idx id
	.

DEF TEMP-TABLE grsince NO-UNDO
	FIELD id AS INT
	FIELD groupid AS INT
	FIELD since AS DATE
	INDEX idx id
	INDEX idg groupid since
	.
		
DEF TEMP-TABLE filters NO-UNDO
	FIELD id AS INT
	FIELD view-id AS INT
	FIELD name AS CHAR
	FIELD grsinceid AS INT
	FIELD val AS CHAR
	FIELD proc AS CHAR
	FIELD proc-param AS CHAR
	FIELD recid-table AS CHAR /** {op,op-entry} */
	FIELD enabled AS LOGICAL
	INDEX idx view-id
	INDEX idg grsinceid
	.
	
iDate = DATE(GetParamByName_ULL(iParam, "date", "00/00/0000", ";")) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
	{getdate.i}
	iDate = end-date.
END.	
i = 1.
j = 1.
k = 1.
FOR EACH code WHERE code.parent = "pirgprint" 
		AND code.class = "pirgprint"
		NO-LOCK 
	:
	IF not can-do(iGroup, GetParamByName_ULL(code.val, "group", "", ";")) THEN NEXT. 
	
	CREATE groups.
	groups.id = i.
	groups.group-code = iGroup.
	groups.code = code.code.

	FOR EACH bfrCode WHERE bfrCode.parent = code.code 
		AND bfrCode.class = code.class
		NO-LOCK
		:
		CREATE grsince.
		grsince.id = j.
		grsince.groupid = groups.id.
		grsince.since = DATE(GetParamByName_ULL(bfrCode.val, "since", "", ";")) NO-ERROR.
		IF ERROR-STATUS:ERROR THEN DO:
			MESSAGE "Ошибка: неверная дата в 'since' в записи '" + code.code + "'" VIEW-AS ALERT-BOX.
			grsince.since = ?.
		END. ELSE DO:
			FOR EACH bfrCode2 WHERE bfrCode2.parent = bfrCode.code 
				AND bfrCode2.class = code.class
				NO-LOCK
				:
				CREATE filters.
				filters.grsinceid = grsince.id.
				filters.name = bfrCode2.name.
				filters.val = bfrCode2.val.
				filters.proc = GetParamByName_ULL(bfrCode2.val, "proc", "", ";").
				/** некоторые процедуры печати группируют документы относительно
    				дебета или кредита. тип группировки задается в каждом конкретном
    				фильтре. в процедуру печати передается в виде 
    				group-by=<{По дебету,По кредиту,}> */
				filters.proc-param =  "group-by=" + GetParamByName_ULL(bfrCode2.val, "group-by", "", ";").
				filters.recid-table = GetParamByName_ULL(bfrCode2.val, "recid-table", "op", ";").
				filters.enabled = GetParamByName_ULL(bfrCode2.val, "enable", "yes", ";") <> "no".
				filters.id = (if filters.enabled then k else 0).
				filters.view-id = INT(GetParamByName_ULL(bfrCode2.val, "id", "0", ";")) NO-ERROR.
				IF ERROR-STATUS:ERROR THEN DO:
					filters.view-id = 0.
				END.
				k = (if filters.enabled then k + 1 else k).
			END.
		END.
		j = j + 1.
	END.
	i = i + 1.
END.

i = 1.
FOR EACH groups NO-LOCK,
	LAST grsince WHERE grsince.groupid = groups.id 
		AND grsince.since <> ?
		AND grsince.since <= iDate NO-LOCK,
	EACH filters WHERE filters.grsinceid = grsince.id
		AND filters.proc <> ""
		AND filters.enabled
		NO-LOCK
		USE-INDEX idx
	:
		
		MESSAGE "[" + STRING(i) + " из " + STRING(k - 1) + "] " + filters.name + " (id=" + STRING(filters.view-id) + ")" VIEW-AS ALERT-BOX.
		
		{empty tmprecid}

		FOR EACH op WHERE
			CAN-DO(GetParamByName_ULL(filters.val, "op.user-id", "*", ";"), op.user-id)
			AND CAN-DO(GetParamByName_ULL(filters.val, "op.op-kind", "*", ";"), op.op-kind)
			AND CAN-DO(GetParamByName_ULL(filters.val, "op.doc-num", "*", ";"), op.doc-num)
			AND CAN-DO(GetParamByName_ULL(filters.val, "op.doc-type", "*", ";"), op.doc-type)
			AND CAN-DO(GetParamByName_ULL(filters.val, "op.op-status", "*", ";"), op.op-status)
			AND CAN-DO(GetParamByName_ULL(filters.val, "op.user-inspector", "*", ";"), op.user-inspector)
			AND op.op-date = iDate
			NO-LOCK,
		EACH op-entry-1 WHERE op-entry-1.op = op.op 
			AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-1.acct-db", "*", ";"), (IF op-entry-1.acct-db = ? THEN "?" ELSE op-entry-1.acct-db))
			AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-1.acct-cr", "*", ";"), (IF op-entry-1.acct-cr = ? THEN "?" ELSE op-entry-1.acct-cr))
			AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-1.currency", "*", ";"), op-entry-1.currency)
			NO-LOCK
			:
			IF CAN-DO("*op-entry-2*", filters.val) THEN DO:
				FIND FIRST op-entry-2 WHERE op-entry-2.op = op.op
					AND op-entry-2.op-entry <> op-entry-1.op-entry
					AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-2.acct-db", "*", ";"), (IF op-entry-2.acct-db = ? THEN "?" ELSE op-entry-2.acct-db))
					AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-2.acct-cr", "*", ";"), (IF op-entry-2.acct-cr = ? THEN "?" ELSE op-entry-2.acct-cr))
					AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-2.currency", "*", ";"), op-entry-2.currency)
					NO-LOCK NO-ERROR.
				IF AVAIL op-entry-2 THEN DO:
					IF CAN-DO("*op-entry-3*", filters.val) THEN DO:
						FIND FIRST op-entry-3 WHERE op-entry-3.op = op.op
							AND op-entry-3.op-entry <> op-entry-2.op-entry
							AND op-entry-3.op-entry <> op-entry-1.op-entry
							AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-3.acct-db", "*", ";"), (IF op-entry-3.acct-db = ? THEN "?" ELSE op-entry-3.acct-db))
							AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-3.acct-cr", "*", ";"), (IF op-entry-3.acct-cr = ? THEN "?" ELSE op-entry-3.acct-cr))
							AND CAN-DO(GetParamByName_ULL(filters.val, "op-entry-3.currency", "*", ";"), op-entry-3.currency)
							NO-LOCK NO-ERROR.
						IF AVAIL op-entry-3 THEN DO:
							{pirgprint.i &tabl=op-entry-3}
						END.
					END. ELSE DO:
						{pirgprint.i &tabl=op-entry-2}
					END.
				END.
			END. ELSE DO:
				{pirgprint.i &tabl=op-entry-1}
			END.
			
		END.
		
		IF CAN-FIND(FIRST tmprecid) THEN DO:
			RUN VALUE(filters.proc) (INPUT filters.proc-param).
		END. ELSE DO:
			MESSAGE "В выборку не попало ни одного документа!" VIEW-AS ALERT-BOX.
		END.		
		
		i = i + 1.
END.
