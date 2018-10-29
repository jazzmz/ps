/*
Ведомость клиентов, у которых связанный субъект с Кодом страны IRQ,PAK,AFG,IND,YEM,COD,IRN,PRK,CIV,LBR,LBN,SOM,SDN,SLE,ERI,ETH,LBY,MMR,UZB,TKM
#2719
Никитина Ю.А. 21.03.2013
*/

{globals.i}

DEF VAR drAdrFactCountr	as char    init ""	no-undo.
DEF VAR drAdrPropCountr	as char    init ""	no-undo.
DEF VAR drIPDL		as char    init ""	no-undo.
DEF VAR dr375		as char    init ""	no-undo.
DEF VAR oClient 	AS TClient 		NO-UNDO.
DEF VAR fl 		AS logical init false 	NO-UNDO.
DEF VAR oTable   	AS TTable 		NO-UNDO.
DEF VAR oTpl     	AS TTpl 		NO-UNDO.
DEF VAR AdrPropCountr	as char    		no-undo.
DEF VAR AdrFactCountr	as char    		no-undo.
DEF VAR i 		as dec	   init 0	NO-UNDO.
DEF VAR drPrizPODFT	as char    init ""	NO-UNDO.
DEF VAR ListCountry 	as char 		NO-UNDO.

DEF TEMP-TABLE tclient_r NO-UNDO
	field cl_id 	as char
	field cl_name 	as char
	field kr_c 	as char
	field kr_d 	as char
	field kl-cat 	as char
	field klvig_name 	as char
	field klvig_role 	as char
	field kr_niz 	as char
	field chrs 	as char
	field drOcRisk 	as char
	INDEX idx_id cl_id
.

FUNCTION fPrizPODFT RETURNS CHAR (iStr AS CHAR,iPrPODFT AS CHAR).
	DEF VAR oStr as CHAR NO-UNDO INIT "".     
	if iPrPODFT matches "*МеждСанкц*" then do: 
		if not can-do("*2.1*",iStr) then oStr = oStr + "2.1,".
	end.
	if iPrPODFT matches "*СпецЭкМеры*" then do: 
		if not can-do("*2.2*",iStr) then oStr = oStr + "2.2,".
	end.
	if iPrPODFT matches "*ИгнРекФАТФ*" then do: 
		if not can-do("*2.3*",iStr) then oStr = oStr + "2.3,".
	end.
	if iPrPODFT matches "*Террор*" then do: 
		if not can-do("*2.4*",iStr) then oStr = oStr + "2.4,".
	end.
	if iPrPODFT matches "*ВысокКорруп*" then do: 
		if not can-do("*2.5*",iStr) then oStr = oStr + "2.5,".
	end.

	RETURN oStr.
END FUNCTION. 

FUNCTION fDrOcRisk RETURNS CHAR (iStr AS CHAR,iPrPODFT AS CHAR).
	DEF VAR oStr as CHAR NO-UNDO INIT "".     
	if iPrPODFT matches "*2.1.*" then do: 
		if not can-do("*2.1*",iStr) then oStr = oStr + "2.1,".
	end.
	if iPrPODFT matches "*2.2.*" then do: 
		if not can-do("*2.2*",iStr) then oStr = oStr + "2.2,".
	end.
	if iPrPODFT matches "*2.3.*" then do: 
		if not can-do("*2.3*",iStr) then oStr = oStr + "2.3,".
	end.
	if iPrPODFT matches "*2.4.*" then do: 
		if not can-do("*2.4*",iStr) then oStr = oStr + "2.4,".
	end.
	if iPrPODFT matches "*2.5.*" then do: 
		if not can-do("*2.5*",iStr) then oStr = oStr + "2.5,".
	end.
	RETURN oStr.
END FUNCTION. 

/*ListCountry = "IRQ,PAK,AFG,IND,YEM,COD,IRN,PRK,CIV,LBR,LBN,SOM,SDN,SLE,ERI,ETH,LBY,MMR,UZB,TKM". */
for each country no-lock :
	drPrizPODFT = GetXAttrValueEx("country",country.country-id,"ПОДФТ_Признак","").
	if drPrizPODFT <> "" then
		ListCountry = ListCountry + country.country-id + ",".
end.

if ListCountry ne "" then ListCountry = substring(ListCountry,1,LENGTH(ListCountry) - 1).

oTpl = new TTpl("pir_klvig_strana.tpl").
oTable = new TTable(6).

oTable:addRow().
oTable:addCell("Клиент").
oTable:setAlign(1,oTable:currRow,"left").
oTable:addCell("Связанный субъект").
oTable:setAlign(2,oTable:currRow,"left").
oTable:addCell("Роль").
oTable:setAlign(3,oTable:currRow,"left").
oTable:addCell("Cтрана").
oTable:setAlign(4,oTable:currRow,"left").
oTable:addCell("Фактор оценки риска Приложение 2/1 ПВК").
oTable:setAlign(5,oTable:currRow,"left").
oTable:addCell("ДР Оценка риска пп.2.1 - 2.5").
oTable:setAlign(6,oTable:currRow,"left").

for each cust-corp no-lock :
/*FOR EACH tmprecid NO-LOCK,FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:*/
	i = i + 1.
	PAUSE 0.
	Display "Процедура запущена" format "x(30)" skip "Ничего не нажимайте. Ждите." format "x(30)" skip "Обрабатываю клиента юр.л.:" + string(i) format "x(30)" skip with frame Inf overlay Centered . PAUSE 0. 
	oClient = new TClient("Ю",cust-corp.cust-id).

        for each cust-role where string(cust-role.surrogate) eq string(cust-corp.cust-id) and cust-role.file-name EQ "cust-corp" no-lock:
		/* Смотрим на код страны в адресе из списка Михалевой С. */
		find first country where country.country-id eq cust-role.country-id NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				create tclient_r.
				tclient_r.cl_id = oClient:Surrogate.
				tclient_r.cl_name = oClient:name-short.
				if tclient_r.cl_name = "" then tclient_r.cl_name = cust-corp.name-corp.
				tclient_r.kl-cat = "Ю".
		  		tclient_r.klvig_name = cust-role.cust-name.
				tclient_r.klvig_role = cust-role.Class-Code.
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"ПОДФТ_Признак","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("ОценкаРиска",today)).
			end.
		end.

	end.

	DELETE OBJECT oClient.

end.

i = 0.
FOR EACH person NO-LOCK:

	i = i + 1.
	Display "Процедура запущена" format "x(30)" skip "Ничего не нажимайте. Ждите." format "x(30)" skip "Обрабатываю клиента ф.л.:" + string(i) format "x(30)" skip with frame Inf3 overlay Centered . PAUSE 0. 
	oClient = new TClient("Ч",person.person-id).

/*	tclient_r.cl_id = string(person.person-id).
	tclient_r.cl_name = person.name-last.
*/

        for each cust-role where string(cust-role.surrogate) eq string(oClient:Surrogate) and cust-role.file-name EQ "person" no-lock:
		/* Смотрим на код страны в адресе из списка Михалевой С. */
		find first country where country.country-id eq cust-role.country-id NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				create tclient_r.
				tclient_r.cl_id = oClient:Surrogate.
				tclient_r.cl_name = oClient:name-short.
				tclient_r.kl-cat = "Ч".
		  		tclient_r.klvig_name = cust-role.cust-name.
				tclient_r.klvig_role = cust-role.Class-Code.
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"ПОДФТ_Признак","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("ОценкаРиска",today)).
			end.
		end.

	end.

	DELETE OBJECT oClient.

end.

i = 0.
for each banks WHERE banks.client no-lock :
/*FOR EACH tmprecid NO-LOCK,FIRST banks WHERE RECID(banks) = tmprecid.id NO-LOCK:*/

	i = i + 1.
	Display "Процедура запущена" format "x(30)" skip "Ничего не нажимайте. Ждите." format "x(30)" skip "Обрабатываю клиента:" + string(i) format "x(30)" skip with frame Inf4 overlay Centered . PAUSE 0. 
	oClient = new TClient("Б",banks.bank-id).

	/* ищем страну в адресе прописки */

        for each cust-role where string(cust-role.surrogate) eq string(oClient:Surrogate) and cust-role.file-name EQ "banks" no-lock:
		/* Смотрим на код страны в адресе из списка Михалевой С. */
		find first country where country.country-id eq cust-role.country-id NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				create tclient_r.
				tclient_r.cl_id = oClient:Surrogate.
				tclient_r.cl_name = oClient:name-short.
				tclient_r.kl-cat = "Б".
		  		tclient_r.klvig_name = cust-role.cust-name.
				tclient_r.klvig_role = cust-role.Class-Code.
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"ПОДФТ_Признак","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("ОценкаРиска",today)).
			end.
		end.

	end.

	DELETE OBJECT oClient.
end.

i = 0.
for each tclient_r where tclient_r.kr_c ne "" no-lock by tclient_r.kl-cat: 
	i = i + 1.
	Display "Процедура запущена" format "x(30)" skip "Ничего не нажимайте. Ждите." format "x(30)" skip "Обрабатываю клиента б.:" + string(i) format "x(30)" skip with frame Inf5 overlay Centered . PAUSE 0. 
	oTable:addRow().
	oTable:addCell(tclient_r.cl_name).
	oTable:setAlign(1,oTable:currRow,"left").
	oTable:addCell(tclient_r.klvig_name).
	oTable:setAlign(2,oTable:currRow,"left").
	oTable:addCell(tclient_r.klvig_role).
	oTable:setAlign(3,oTable:currRow,"left").
	oTable:addCell(tclient_r.kr_c).
	oTable:setAlign(4,oTable:currRow,"left").
	oTable:addCell(if tclient_r.chrs ne "" then substring(tclient_r.chrs,1,LENGTH(tclient_r.chrs) - 1) else "").
	oTable:setAlign(5,oTable:currRow,"left").
	oTable:addCell(if tclient_r.drOcRisk ne "" then substring(tclient_r.drOcRisk,1,LENGTH(tclient_r.drOcRisk) - 1) else "").
	oTable:setAlign(6,oTable:currRow,"left").

end.

Hide Frame Inf No-Pause.
Hide Frame Inf3 No-Pause.
Hide Frame Inf4 No-Pause.
Hide Frame Inf5 No-Pause.

oTpl:addAnchorValue("ListCountry",ListCountry).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
