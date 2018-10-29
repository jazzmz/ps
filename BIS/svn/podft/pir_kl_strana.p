/*
��������� �����⮢, � ������ � ���� ��࠭� IRQ,PAK,AFG,IND,YEM,COD,IRN,PRK,CIV,LBR,LBN,SOM,SDN,SLE,ERI,ETH,LBY,MMR,UZB,TKM
#2719
����⨭� �.�. 21.03.2013
*/

{globals.i}

DEF VAR drAdrFactCountr	as char    init ""	no-undo.
DEF VAR drAdrPropCountr	as char    init ""	no-undo.
DEF VAR drIPDL		as char    init ""	no-undo.
DEF VAR drPrizPODFT	as char    init ""	NO-UNDO.
DEF VAR dr375		as char    init ""	no-undo.
DEF VAR oClient 	AS TClient 		NO-UNDO.
DEF VAR fl 		AS logical init false 	NO-UNDO.
DEF VAR oTable   	AS TTable 		NO-UNDO.
DEF VAR oTpl     	AS TTpl 		NO-UNDO.
DEF VAR AdrPropCountr	as char    		no-undo.
DEF VAR AdrFactCountr	as char    		no-undo.
DEF VAR sfinish 	as char 		NO-UNDO.
DEF VAR sstart 		as char 		NO-UNDO.
DEF VAR tstart 		as int64 		NO-UNDO.
DEF VAR i 		as dec	    init 0	NO-UNDO.
DEF VAR ListCountry 	as char 		NO-UNDO.

DEF TEMP-TABLE tclient_r NO-UNDO
	field cl_id 	as char
	field cl_name 	as char
	field kr_c 	as char
	field kr_d 	as char
	field kl-cat 	as char
	field chrs 	as char
	field drOcRisk 	as char
	field kr_niz 	as char
	INDEX idx_id cl_id
.

oTpl = new TTpl("pir_kl_strana.tpl").
oTable = new TTable(5).

oTable:addRow().
oTable:addCell("������").
oTable:setAlign(1,oTable:currRow,"left").
oTable:addCell("���� ��/�ய").
oTable:setAlign(2,oTable:currRow,"left").
oTable:addCell("���� 䠪�/����").
oTable:setAlign(3,oTable:currRow,"left").
oTable:addCell("����� �業�� �᪠ �ਫ������ 2/1 ���").
oTable:setAlign(4,oTable:currRow,"left").
oTable:addCell("�� �業�� �᪠ ��.2.1 - 2.5").
oTable:setAlign(5,oTable:currRow,"left").

FUNCTION fPrizPODFT RETURNS CHAR (iStr AS CHAR,iPrPODFT AS CHAR).
	DEF VAR oStr as CHAR NO-UNDO INIT "".     
	if iPrPODFT matches "*���������*" then do: 
		if not can-do("*2.1*",iStr) then oStr = oStr + "2.1,".
	end.
	if iPrPODFT matches "*���杪����*" then do: 
		if not can-do("*2.2*",iStr) then oStr = oStr + "2.2,".
	end.
	if iPrPODFT matches "*����������*" then do: 
		if not can-do("*2.3*",iStr) then oStr = oStr + "2.3,".
	end.
	if iPrPODFT matches "*�����*" then do: 
		if not can-do("*2.4*",iStr) then oStr = oStr + "2.4,".
	end.
	if iPrPODFT matches "*��᮪�����*" then do: 
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

sstart = string(Time,"HH:MM:SS").
tstart = Time.
i = 0.
/*ListCountry = "IRQ,PAK,AFG,IND,YEM,COD,IRN,PRK,CIV,LBR,LBN,SOM,SDN,SLE,ERI,ETH,LBY,MMR,UZB,TKM". */
for each country no-lock :
	drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").
	if drPrizPODFT <> "" then
		ListCountry = ListCountry + country.country-id + ",".
end.

if ListCountry ne "" then ListCountry = substring(ListCountry,1,LENGTH(ListCountry) - 1).

for each cust-corp no-lock :
/*FOR EACH tmprecid NO-LOCK,FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:*/
	i = i + 1.
	PAUSE 0. 
	Display "��楤�� ����饭�" format "x(30)" skip "��祣� �� ��������. ����." format "x(30)" skip "��ࠡ��뢠� ������ ��.� :" + string(i) format "x(30)" skip with frame Inf overlay Centered . PAUSE 0. 
	oClient = new TClient("�",cust-corp.cust-id).
	create tclient_r.
	tclient_r.cl_id = oClient:Surrogate.
	tclient_r.cl_name = oClient:name-short.
	if tclient_r.cl_name = "" then tclient_r.cl_name = cust-corp.name-corp.
	tclient_r.kl-cat = "�".
	/* �饬 ��࠭� � ���� �ய�᪨ */

	FIND FIRST cust-ident WHERE
        	cust-ident.cust-cat       EQ '�'
		AND cust-ident.cust-id        EQ cust-corp.cust-id
	        AND cust-ident.cust-code-type EQ '�����'
        	AND cust-ident.class-code     EQ "p-cust-adr"
	        AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrPropCountr = GetXAttrValueEx("cust-ident",STRING("�����," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.
	/* �饬 ��࠭� � ���� 䠪��᪮�� ��宦����� */
	FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
	        AND cust-ident.cust-id        EQ cust-corp.cust-id
        	AND cust-ident.cust-code-type EQ '�������'
	        AND cust-ident.class-code     EQ "p-cust-adr"
        	AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrFactCountr = GetXAttrValueEx("cust-ident",STRING("�������," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .  
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_d = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.
	DELETE OBJECT oClient.

end.

i = 0.
FOR EACH person NO-LOCK:

	i = i + 1.
	Display "��楤�� ����饭�" format "x(30)" skip "��祣� �� ��������. ����." format "x(30)" skip "��ࠡ��뢠� ������ �.�.:" + string(i) format "x(30)" skip with frame Inf2 overlay Centered . PAUSE 0. 
	oClient = new TClient("�",person.person-id).
	create tclient_r.
	tclient_r.cl_id = oClient:Surrogate.
	tclient_r.cl_name = oClient:name-short.
	tclient_r.kl-cat = "�".

/*	tclient_r.cl_id = string(person.person-id).
	tclient_r.cl_name = person.name-last.
*/
	/* �饬 ��࠭� � ���� �ய�᪨ */
	FIND FIRST cust-ident WHERE
        	cust-ident.cust-cat       EQ '�'
        	AND cust-ident.cust-id        EQ person.person-id
	        AND cust-ident.cust-code-type EQ '����ய'
        	AND cust-ident.class-code     EQ "p-cust-adr"
	        AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrPropCountr = GetXAttrValueEx("cust-ident",STRING("����ய," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.
	/* �饬 ��࠭� � ���� 䠪��᪮�� ��宦����� */
	FIND FIRST cust-ident WHERE
        	cust-ident.cust-cat       EQ '�'
        	AND cust-ident.cust-id        EQ person.person-id
	        AND cust-ident.cust-code-type EQ '�������'
        	AND cust-ident.class-code     EQ "p-cust-adr"
	        AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrFactCountr = GetXAttrValueEx("cust-ident",STRING("�������," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .  
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.

	DELETE OBJECT oClient.

end.

i = 0.
for each banks WHERE banks.client no-lock :
/*FOR EACH tmprecid NO-LOCK,FIRST banks WHERE RECID(banks) = tmprecid.id NO-LOCK:*/

	i = i + 1.
	Display "��楤�� ����饭�" format "x(30)" skip "��祣� �� ��������. ����." format "x(30)" skip "��ࠡ��뢠� ������ �.:" + string(i) format "x(30)" skip with frame Inf3 overlay Centered . PAUSE 0. 
	oClient = new TClient("�",banks.bank-id).
	create tclient_r.
	tclient_r.cl_id = oClient:Surrogate.
	tclient_r.cl_name = oClient:name-short.
	tclient_r.kl-cat = "�".

	/* �饬 ��࠭� � ���� �ய�᪨ */

	FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
	        AND cust-ident.cust-id        EQ banks.bank-id
        	AND cust-ident.cust-code-type EQ '�����'
	        AND cust-ident.class-code     EQ "p-cust-adr"
        	AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrPropCountr = GetXAttrValueEx("cust-ident",STRING("�����," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.
	/* �饬 ��࠭� � ���� 䠪��᪮�� ��宦����� */
	FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
	        AND cust-ident.cust-id        EQ banks.bank-id
        	AND cust-ident.cust-code-type EQ '�������'
	        AND cust-ident.class-code     EQ "p-cust-adr"
        	AND cust-ident.close-date     EQ ?
	NO-ERROR.
	if avail cust-ident then do:
		AdrFactCountr = GetXAttrValueEx("cust-ident",STRING("�������," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .  
		/* ����ਬ �� ��� ��࠭� � ���� �� ᯨ᪠ ��堫���� �. */
		find first country where country.country-id eq AdrPropCountr NO-LOCK NO-ERROR.
		if avail country then do:
			if can-do(ListCountry,country.country-id) then do:
				tclient_r.kr_c = country.country-id.
				drPrizPODFT = GetXAttrValueEx("country",country.country-id,"�����_�ਧ���","").	
				tclient_r.chrs = tclient_r.chrs + fPrizPODFT(tclient_r.chrs,drPrizPODFT).
				tclient_r.drOcRisk = tclient_r.drOcRisk + fDrOcRisk(tclient_r.drOcRisk,oClient:getXAttr("�業����᪠",today)).
			end.
		end.
	end.

	DELETE OBJECT oClient.
end.


for each tclient_r where tclient_r.kr_c ne "" or tclient_r.kr_d ne "" no-lock by tclient_r.kl-cat: 
	i = i + 1.
	oTable:addRow().
	oTable:addCell(tclient_r.cl_name).
	oTable:setAlign(1,oTable:currRow,"left").
	oTable:addCell(tclient_r.kr_c).
	oTable:setAlign(2,oTable:currRow,"left").
	oTable:addCell(tclient_r.kr_d).
	oTable:setAlign(3,oTable:currRow,"left").
	oTable:addCell(if tclient_r.chrs ne "" then substring(tclient_r.chrs,1,LENGTH(tclient_r.chrs) - 1) else "").
	oTable:setAlign(4,oTable:currRow,"left").
	oTable:addCell(if tclient_r.drOcRisk ne "" then substring(tclient_r.drOcRisk,1,LENGTH(tclient_r.drOcRisk) - 1) else "").
	oTable:setAlign(5,oTable:currRow,"left").

end.
Hide Frame Inf No-Pause.
Hide Frame Inf2 No-Pause.
Hide Frame Inf3 No-Pause.

sfinish = string(Time,"HH:MM:SS").
oTpl:addAnchorValue("Timer"," ���� " + sstart + " 䨭�� " + sfinish).
oTpl:addAnchorValue("ListCountry",ListCountry).
oTpl:addAnchorValue("period","��ਮ� � " + string(beg-date) + " �� " + string(end-date)).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
