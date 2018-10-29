/*
Ведомость по оценке риска клиента (РиКл)
Процедура идет по выделенным клиентам.
Для Категория С - анализируем адрес клиента ДР ПОДФТ_Признак на стране. Адрес юридический и адрес фактический. 
Если ДР ПОДФТ_Признак заполнен на стране, то устанавливаем риск С для клиента.
Для Категория Д - анализируем проводки клиента за период. Просматриваются все счета клиента открытые на конец периода.
Если хотя бы на одной проводке проставлен ДР КодНеобПодоз , то устанваливаем риск Д для клиента.
Для Категория Т - анализируем ДР Статус_ИПДЛ на клиенте. ДР Статус_ИПДЛ темпорированный и смотрится на конец задаваемого периода.
Если на клиент проставлен ДР Статус_ИПДЛ, то устанавливаем риск Т на клиент.
Просматриваем выставленные риски по каждому клиенту. Если на клиенте нет рисков, то риск клиента низкий, если на клиенте одни риск,
то риск клиента средний, если на клиента несколько рисков, то риск клиента повышенный.

Никитина Ю.А. 21.03.2013
#2709
*/

{globals.i}
{getdates.i}
{tmprecid.def}

DEF VAR drAdrFactCountr	as char    init ""	no-undo.
DEF VAR drAdrPropCountr	as char    init ""	no-undo.
DEF VAR drIPDL		as char    init ""	no-undo.
DEF VAR dr375		as char    init ""	no-undo.
DEF VAR oClient 	AS TClient 		NO-UNDO.
DEF VAR fl 		AS logical init false 	NO-UNDO.
DEF VAR oTable   	AS TTable2 		NO-UNDO.
DEF VAR oTpl     	AS TTpl 		NO-UNDO.
DEF VAR AdrPropCountr	as char    		no-undo.
DEF VAR AdrFactCountr	as char    		no-undo.
DEF VAR sfinish 	as char 		NO-UNDO.
DEF VAR sstart 		as char 		NO-UNDO.
DEF VAR tstart 		as int64 		NO-UNDO.
DEF VAR i 		as dec	    init 0	NO-UNDO.

DEF TEMP-TABLE tclient_r NO-UNDO
	field cl_id 	as char
	field cl_name 	as char
	field kr_c 	as char
	field kr_d 	as char
	field kr_t 	as char
	field kr_sred 	as char
	field kr_pov 	as char
	field kr_niz 	as char
	INDEX idx_id cl_id
.

oTpl = new TTpl("pir_rikl.tpl").
oTable = new TTable2(7).

oTable:addRow().
oTable:addCell("Клиент").
oTable:addCell("РИСК С").
oTable:addCell("РИСК Д").
oTable:addCell("РИСК Т").
oTable:addCell("Низкий").
oTable:addCell("Средний").
oTable:addCell("Повышенный").

sstart = string(Time,"HH:MM:SS").
tstart = Time.

/*for each person no-lock :*/
FOR EACH tmprecid NO-LOCK,FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:

	i = i + 1.
	Display "время запуска " + sstart format "x(26)" skip "время работы " + string((Time - tstart),"HH:MM:SS") format "x(26)" skip "кол-во клиентов " + string(i) format "x(26)" with frame Inf overlay Centered . PAUSE 0.
	oClient = new TClient("Ю",cust-corp.cust-id).
	create tclient_r.
	tclient_r.cl_id = oClient:Surrogate.
	tclient_r.cl_name = oClient:name-short.

/*	tclient_r.cl_id = string(cust-corp.cust-id).
	tclient_r.cl_name = person.name-last.
*/
	/* Опредляем риск Категории С */
	/* ищем страну в адресе прописки */

	FIND FIRST cust-ident WHERE
        	cust-ident.cust-cat       EQ 'Ю'
		AND cust-ident.cust-id        EQ cust-corp.cust-id
	        AND cust-ident.cust-code-type EQ 'АдрЮр'
        	AND cust-ident.class-code     EQ "p-cust-adr"
	        AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrPropCountr = GetXAttrValueEx("cust-ident",STRING("АдрЮр," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
		/* Смотрим на ДР ПОДФТ_Признак страны в адресе */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			drAdrPropCountr =  getXAttrValueEx("country", country.country-id , "ПОДФТ_Признак", "").
		end.
	end.
	/* ищем страну в адресе фактического нахождения */
	FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
	        AND cust-ident.cust-id        EQ cust-corp.cust-id
        	AND cust-ident.cust-code-type EQ 'АдрФакт'
	        AND cust-ident.class-code     EQ "p-cust-adr"
        	AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrFactCountr = GetXAttrValueEx("cust-ident",STRING("АдрФакт," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .  
		/* Смотрим на ДР ПОДФТ_Признак страны в адресе */
		find first country where country.country-id eq AdrFactCountr NO-LOCK NO-ERROR.
		if avail country then do:
			drAdrFactCountr =  getXAttrValueEx("country", country.country-id , "ПОДФТ_Признак", "").
		end.
	end.
	/* Если на стране есть ДР ПОДФТ_Признак, то значит клиент емеет Риск С */
	if drAdrPropCountr ne "" or drAdrFactCountr ne "" then do:
		tclient_r.kr_c = "v".
	end.

	/* Определяем риск Категории Т */

        drIPDL = oClient:getXAttr("Статус_ИПДЛ",end-date).
/*	message "ИПДЛ" drIPDL. pause.*/
	if drIPDL ne "" and drIPDL ne ? then do:
		tclient_r.kr_t = "v".
	end.

	/* Определяем риск Категории Д */
	FOR EACH acct WHERE acct.cust-cat = "Ю" AND acct.cust-id = cust-corp.cust-id 
			and (acct.close-date = ? or acct.close-date > end-date)
			/*and acct.open-date <= end-date */ NO-LOCK:
		for each op-entry where (op-entry.acct-db eq acct.acct or op-entry.acct-cr eq acct.acct) 
				and (op-entry.op-date >= beg-date and op-entry.op-date <= end-date) no-lock:
			find first op of op-entry no-lock no-error.
			dr375 = GetXAttrValue("op",STRING(op.op),"КодНеобПодоз").
			if dr375 ne "" then do:
                        	tclient_r.kr_d = "v".
				LEAVE.
			end.
		end.
	end.

	/* определяем уровень риска клиента */
	if tclient_r.kr_c = "" and tclient_r.kr_d = "" and tclient_r.kr_t = "" then tclient_r.kr_niz = "v".
	else do:
		if (tclient_r.kr_c = "v" and tclient_r.kr_d = "" and tclient_r.kr_t = "")
				or (tclient_r.kr_c = "" and tclient_r.kr_d = "v" and tclient_r.kr_t = "")
				or (tclient_r.kr_c = "" and tclient_r.kr_d = "" and tclient_r.kr_t = "v")
		 		then 
			tclient_r.kr_sred = "v".	
	        else
		tclient_r.kr_pov = "v".
	end.

	DELETE OBJECT oClient.

end.
i = 0.
sstart = string(Time,"HH:MM:SS").
tstart = Time.
for each tclient_r no-lock:
	i = i + 1.
	Display "время запуска " + sstart format "x(26)" skip "время работы " + string((Time - tstart),"HH:MM:SS") format "x(26)" skip "кол-во клиентов " + string(i) format "x(26)" with frame Inf2 overlay Centered . PAUSE 0.
	oTable:addRow().
	oTable:addCell(tclient_r.cl_name).
	oTable:addCell(tclient_r.kr_c).
	oTable:addCell(tclient_r.kr_d).
	oTable:addCell(tclient_r.kr_t).
	oTable:addCell(tclient_r.kr_niz).
	oTable:addCell(tclient_r.kr_sred).
	oTable:addCell(tclient_r.kr_pov).

end.
Hide Frame Inf No-Pause.
Hide Frame Inf2 No-Pause.
sfinish = string(Time,"HH:MM:SS").
oTpl:addAnchorValue("Timer"," старт " + sstart + " финиш " + sfinish).

oTpl:addAnchorValue("period","Период с " + string(beg-date) + " по " + string(end-date)).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
