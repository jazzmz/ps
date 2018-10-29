{globals.i}
{tmprecid.def}
{getdate.i}
{intrface.get xclass}
{sh-defs.i}     

DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR oClient AS TClient    	NO-UNDO.

def var count     as int   init 0 NO-UNDO.
def var count_l   as int   init 0 NO-UNDO.
def var count_a   as int   init 0 NO-UNDO.
def var count_cc  as int   init 0 NO-UNDO.
def var count_p   as int   init 0 NO-UNDO.
def var count_b   as int   init 0 NO-UNDO.
def var count_dr  as int   init 0 NO-UNDO.
DEF VAR outfile   as char 	  NO-UNDO.
DEF VAR cXL       AS CHAR         NO-UNDO.

def input param iObj as char no-undo.

DEF TEMP-TABLE tt-code NO-UNDO
   FIELD i AS int
   FIELD tobj AS CHARACTER
   FIELD tobjn AS CHARACTER
   FIELD tobjnk AS CHARACTER
   FIELD tnamedr AS CHARACTER
   FIELD dr AS CHARACTER
   FIELD drtrue AS CHARACTER
index i is primary i
.
DEF BUFFER bfrCode FOR code.

oTpl = new TTpl("pir_ved.tpl").

/*for each code WHERE code.class EQ 'pir_ved' AND code.parent EQ 'pir_ved' no-lock:*/

	if iObj eq "loan" then do:
                FOR EACH tmprecid NO-LOCK,
        	        FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK:

/*	if code.code eq "loan" then do:
        	for each loan where loan.contract eq "кредит" 	
				and (loan.close-date gt end-date or loan.close-date eq ?)
				and can-do("!MM*,!НО*,*",loan.cont-code)
				no-lock:
*/
			count_l = 0.
			FOR EACH bfrCode WHERE bfrCode.class EQ 'pir_ved' AND bfrCode.parent EQ 'loan' no-lock: 
        			if can-do(bfrCode.val,userid("bisquit")) then do:
					create tt-code.
					count_l = count_l + 1. 
					tt-code.tobj = "loan".
					tt-code.tobjn = loan.cont-code.
                                        tt-code.tnamedr = bfrCode.name.
		        		oClient = NEW TClient(loan.cust-cat,loan.cust-id).
                                        tt-code.tobjnk = oClient:name-short.
					DELETE OBJECT oClient.
					Display loan.cont-code with frame Inf1 overlay Centered. pause 0.
                			if bfrCode.description[2] ne "" then do:
	                                       	IF Search(bfrCode.description[2] + ".r") <> ? then do:
							run value(bfrCode.description[2] + ".r")(end-date,recid(loan),output tt-code.dr,output tt-code.drtrue).
                                        	end.
						else do:
					    		if Search(bfrCode.description[2] + ".p") <> ? THEN do:
								RUN Value(bfrCode.description[2] + ".p")(end-date,recid(loan),output tt-code.dr,output tt-code.drtrue).
							end.
							else do:
								/*MESSAGE COLOR MESSAGE "Процедура " + bfrCode.description[2] + ".p" SKIP
									"не обнаружена. Сообщите в автоматизацию."
								VIEW-AS ALERT-BOX.*/
								tt-code.dr = "".
								/*return.*/
							end.
						end.
					end.
					else do:
                                                IF IsTemporal("loan",bfrCode.code) THEN
							tt-code.dr = GetTempXAttrValueEx("loan",loan.contract + "," + loan.cont-code,bfrCode.code,end-date,"").
                                                ELSE
        						tt-code.dr = GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,bfrCode.code,"").
					end.
        			end.
			end.
                end.
 	end.

	if iObj eq "acct" then do:
                FOR EACH tmprecid NO-LOCK,
        	        FIRST acct WHERE RECID(acct) = tmprecid.id NO-LOCK:

/*	if code.code eq "acct" then do:*/
/*        	for each acct where (acct.acct-cat eq "b" or acct.acct-cat eq "o")
				and (acct.close-date gt end-date or acct.close-date eq ?)
				no-lock:
*/
			RUN acct-pos IN h_base (acct.acct, acct.currency, end-date, end-date, gop-status).
			if abs(sh-bal) > 0 or abs(sh-val) > 0 then do:
				count_a = 0.
        			FOR EACH bfrCode WHERE bfrCode.class EQ 'pir_ved' AND bfrCode.parent EQ 'acct' no-lock: 
                			if can-do(bfrCode.val,userid("bisquit")) then do:
        					create tt-code.
        					count_a = count_a + 1. 
        					tt-code.tobj = "acct".
        					tt-code.tobjn = acct.acct.
                                                tt-code.tnamedr = bfrCode.name.
        		        		oClient = NEW TClient(acct.acct).
                                                tt-code.tobjnk = acct.Details + " Клиент:" + oClient:name-short.
        					DELETE OBJECT oClient.
        					Display acct.acct with frame Inf2 overlay Centered. pause 0.
                        			if bfrCode.description[2] ne "" then do:
        	                                       	IF Search(bfrCode.description[2] + ".r") <> ? then do:
        							run value(bfrCode.description[2] + ".r")(end-date,recid(acct),output tt-code.dr,output tt-code.drtrue).
                                                	end.
        						else do:
        					    		if Search(bfrCode.description[2] + ".p") <> ? THEN do:
        								RUN Value(bfrCode.description[2] + ".p")(end-date,recid(acct),output tt-code.dr,output tt-code.drtrue).
        							end.
        							else do:
        								/*MESSAGE COLOR MESSAGE "Процедура " + bfrCode.description[2] + ".p" SKIP
        									"не обнаружена. Сообщите в автоматизацию."
        								VIEW-AS ALERT-BOX.*/
        								tt-code.dr = "".
        								/*return.*/
        							end.
        						end.
        					end.
        					else do:
                                                        IF IsTemporal("acct",bfrCode.code) THEN
        							tt-code.dr = GetTempXAttrValueEx("acct",acct.acct + "," + acct.currency,bfrCode.code,end-date,"").
                                                        ELSE
                						tt-code.dr = GetXAttrValueEx("acct",acct.acct + "," + acct.currency,bfrCode.code,"").
        					end.
                			end.
        			end.
			end.
                end.
 	end.

	if iObj eq "cust-corp" then do:
                FOR EACH tmprecid NO-LOCK,
        	        FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK
                :

/*	if code.code eq "cust-corp" then do:
        	for each cust-corp no-lock:
*/
			count_cc = 0.
			find first acct of cust-corp where acct.close-date eq ? or acct.close-date gt end-date no-lock no-error.
			if avail acct then do:
        			FOR EACH bfrCode WHERE bfrCode.class EQ 'pir_ved' AND bfrCode.parent EQ 'cust-corp' no-lock: 
                			if can-do(bfrCode.val,userid("bisquit")) then do:
        					create tt-code.
        					count_cc = count_cc + 1. 
        					tt-code.tobj = "cust-corp".
        					tt-code.tobjn = string(cust-corp.cust-id).
                                                tt-code.tnamedr = bfrCode.name.
        		        		oClient = NEW TClient("Ю",cust-corp.cust-id).
                                                tt-code.tobjnk = oClient:name-short.
        					Display oClient:name-short format "x(20)" with frame Inf3 overlay Centered. pause 0.
        					DELETE OBJECT oClient.
                        			if bfrCode.description[2] ne "" then do:
        	                                       	IF Search(bfrCode.description[2] + ".r") <> ? then do:
        							run value(bfrCode.description[2] + ".r")(end-date,recid(cust-corp),output tt-code.dr,output tt-code.drtrue).
                                                	end.
        						else do:
        					    		if Search(bfrCode.description[2] + ".p") <> ? THEN do:
        								RUN Value(bfrCode.description[2] + ".p")(end-date,recid(cust-corp),output tt-code.dr,output tt-code.drtrue).
        							end.
        							else do:
        								/*MESSAGE COLOR MESSAGE "Процедура " + bfrCode.description[2] + ".p" SKIP
        									"не обнаружена. Сообщите в автоматизацию."
        								VIEW-AS ALERT-BOX.*/
        								tt-code.dr = "".
        								/*return.*/
        							end.
        						end.
        					end.
        					else do:
                                                        IF IsTemporal("cust-corp",bfrCode.code) THEN
        							tt-code.dr = GetTempXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),bfrCode.code,end-date,"").
                                                        ELSE
                						tt-code.dr = GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),bfrCode.code,"").
        					end.
                			end.
        			end.
			end.
                end.
 	end.

	if iObj eq "person" then do:
                FOR EACH tmprecid NO-LOCK,
        	        FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK:
			count_p = 0.
			find first acct where acct.cust-id eq person.person-id and
					(acct.close-date eq ? or acct.close-date gt end-date) no-lock no-error.
			if avail acct then do:
        			FOR EACH bfrCode WHERE bfrCode.class EQ 'pir_ved' AND bfrCode.parent EQ 'person' no-lock: 
                			if can-do(bfrCode.val,userid("bisquit")) then do:
        					create tt-code.
        					count_p = count_p + 1. 
        					tt-code.tobj = "person".
        					tt-code.tobjn = string(person.person-id).
                                                tt-code.tnamedr = bfrCode.name.
        		        		oClient = new TClient("Ч",person.person-id).
                                                tt-code.tobjnk = oClient:name-short.
        					Display oClient:name-short format "x(20)" with frame Inf4 overlay Centered. pause 0.
        					DELETE OBJECT oClient.
                        			if bfrCode.description[2] ne "" then do:
        	                                       	IF Search(bfrCode.description[2] + ".r") <> ? then do:
        							run value(bfrCode.description[2] + ".r")(end-date,recid(person),output tt-code.dr,output tt-code.drtrue).
                                                	end.
        						else do:
        					    		if Search(bfrCode.description[2] + ".p") <> ? THEN do:
        								RUN Value(bfrCode.description[2] + ".p")(end-date,recid(person),output tt-code.dr,output tt-code.drtrue).
        							end.
        							else do:
        								/*MESSAGE COLOR MESSAGE "Процедура " + bfrCode.description[2] + ".p" SKIP
        									"не обнаружена. Сообщите в автоматизацию."
        								VIEW-AS ALERT-BOX.*/
        								tt-code.dr = "".
        								/*return.*/
        							end.
        						end.
        					end.
        					else do:
                                                        IF IsTemporal("person",bfrCode.code) THEN
        							tt-code.dr = GetTempXAttrValueEx("person",STRING(person.person-id),bfrCode.code,end-date,"").
                                                        ELSE
                						tt-code.dr = GetXAttrValueEx("person",STRING(person.person-id),bfrCode.code,"").
        					end.
                			end.
        			end.
			end.
                end.
 	end.

	if iObj eq "banks" then do:
                FOR EACH tmprecid NO-LOCK,
        	        FIRST banks WHERE RECID(banks) = tmprecid.id NO-LOCK:
			count_b = 0.
			FOR EACH bfrCode WHERE bfrCode.class EQ 'pir_ved' AND bfrCode.parent EQ 'banks' no-lock: 
        			if can-do(bfrCode.val,userid("bisquit")) then do:
					create tt-code.
					count_b = count_b + 1. 
					tt-code.tobj = "banks".
					tt-code.tobjn = string(banks.bank-id).
                                        tt-code.tnamedr = bfrCode.name.
		        		oClient = NEW TClient("Б",banks.bank-id).
                                        tt-code.tobjnk = oClient:name-short.
					Display oClient:name-short format "x(20)" with frame Inf5 overlay Centered. pause 0.
					DELETE OBJECT oClient.
                			if bfrCode.description[2] ne "" then do:
	                                       	IF Search(bfrCode.description[2] + ".r") <> ? then do:
							run value(bfrCode.description[2] + ".r")(end-date,recid(banks),output tt-code.dr,output tt-code.drtrue).
                                        	end.
						else do:
					    		if Search(bfrCode.description[2] + ".p") <> ? THEN do:
								RUN Value(bfrCode.description[2] + ".p")(end-date,recid(banks),output tt-code.dr,output tt-code.drtrue).
							end.
							else do:
								/*MESSAGE COLOR MESSAGE "Процедура " + bfrCode.description[2] + ".p" SKIP
									"не обнаружена. Сообщите в автоматизацию."
								VIEW-AS ALERT-BOX.*/
								tt-code.dr = "".
								/*return.*/
							end.
						end.
					end.
					else do:
                                                IF IsTemporal("person",bfrCode.code) THEN
							tt-code.dr = GetTempXAttrValueEx("banks",STRING(banks.bank-id),bfrCode.code,end-date,"").
                                                ELSE
        						tt-code.dr = GetXAttrValueEx("banks",STRING(banks.bank-id),bfrCode.code,"").
					end.
        			end.
			end.
                end.
 	end.
/*end.*/
HIDE FRAME Inf1.
HIDE FRAME Inf2.
HIDE FRAME Inf3.
HIDE FRAME Inf4.
HIDE FRAME Inf5.

{pir_exf_exl.i}
{setdest.i}
outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/pir_ved.xls").
/*outfile = ("./pir_ved.xls").*/
OUTPUT TO VALUE(outfile) CONVERT TARGET "UTF-8".

PUT UNFORMATTED XLHead("ved","CCCCCC","50,130,300,300,200,200").
/* специально так написала, т.к. возникали проблемы с кодировкой */
cXL = "<Cell><Data ss:Type=""String"">Номер</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" + 
      "<Cell><Data ss:Type=""String"">Наименование</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
      "<Cell><Data ss:Type=""String"">Наименоваине клиента</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
      "<Cell><Data ss:Type=""String"">Реквизит</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
      "<Cell><Data ss:Type=""String"">Значение реквизит</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
      "<Cell><Data ss:Type=""String"">Ожидаемое значение</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>".

/*PUT UNFORMATTED "Номер" format "x(5)" "|" "Наименование" format "x(12)" "|" "Наименоваине клиента" format "x(30)" "|" 
	"Реквизит" format "x(30)" "|" "Значение реквизита" format "x(20)" "|" 
	"Ожидаемое значение" format "x(20)" "|" skip. 
*/

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

for each tt-code no-lock break by tt-code.tobj by tt-code.tobjn by tt-code.tnamedr :
	if first-of(tt-code.tobjn) then do:
		count = count + 1.
		/* put unformatted fill("-",94) skip. */
		/* очень хочется объеденять ячейки в стобце 1, 2 и 3 */
		if tt-code.tobj eq "loan" then count_dr = count_l. 
		if tt-code.tobj eq "acct" then count_dr = count_a. 
		if tt-code.tobj eq "cust-corp" then count_dr = count_cc. 
		if tt-code.tobj eq "person" then count_dr = count_p. 
		if tt-code.tobj eq "banks" then count_dr = count_b. 
                cXL = "<Cell ss:MergeDown=" + CHR(34) + STRING(count_dr - 1) + CHR(34) + " ss:StyleId=""s21""><Data ss:Type=""String"">" + string(count) + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    			"<Cell ss:MergeDown=" + CHR(34) + STRING(count_dr - 1) + CHR(34) + " ss:StyleId=""s21""><Data ss:Type=""String"">" + tt-code.tobjn + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    			"<Cell ss:MergeDown=" + CHR(34) + STRING(count_dr - 1) + CHR(34) + " ss:StyleId=""s21""><Data ss:Type=""String"">" + tt-code.tobjnk + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
			"<Cell><Data ss:Type=""String"">" + tt-code.tnamedr + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    			"<Cell><Data ss:Type=""String"">" + tt-code.dr + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    			"<Cell><Data ss:Type=""String"">" + tt-code.drtrue + " </Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>".

		PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

/*		PUT UNFORMATTED string(count) format "x(5)" "|" tt-code.tobjn format "x(12)" "|" tt-code.tobjnk format "x(30)" "|" 
			tt-code.tnamedr format "x(30)" "|" tt-code.dr format "x(20)" "|" 
			tt-code.drtrue format "x(20)" "|" skip. 
*/
	end.
	else do:
/*		PUT UNFORMATTED " " format "x(5)" "|" " " format "x(12)" "|" " " format "x(30)" "|" tt-code.tnamedr format "x(30)" "|" tt-code.dr format "x(20)" "|" 
			tt-code.drtrue format "x(20)" "|" skip. 
*/
		/* здесь я объеденяю строки в стоблце 1 , 2 и 3 */
                cXL = "<Cell ss:Index=""4""><Data ss:Type=" + CHR(34) + "String" + CHR(34) + ">" + tt-code.tnamedr + "</Data><NamedCell ss:Name=" + CHR(34) + "_FilterDatabase" + CHR(34) + "/></Cell>" +
		      "<Cell><Data ss:Type=" + CHR(34) + "String" + CHR(34) + ">" + tt-code.dr + "</Data><NamedCell ss:Name=" + CHR(34) + "_FilterDatabase" + CHR(34) + "/></Cell>" + 
                      "<Cell><Data ss:Type=" + CHR(34) + "String" + CHR(34) + ">" + tt-code.drtrue + "</Data><NamedCell ss:Name=" + CHR(34) + "_FilterDatabase" + CHR(34) + "/></Cell>".

		PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

	end.

end.
cXL = "<Cell ss:StyleId=""s21""><Data ss:Type=""String""> Исполнитель </Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    	"<Cell ss:StyleId=""s21""><Data ss:Type=""String"">" + userid("bisquit") + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    	"<Cell ss:StyleId=""s21""><Data ss:Type=""String"">" + string(today) + "</Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
	"<Cell><Data ss:Type=""String""> </Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    	"<Cell><Data ss:Type=""String""> </Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>" +
    	"<Cell><Data ss:Type=""String""> </Data><NamedCell ss:Name=""_FilterDatabase""/></Cell>".

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
PUT UNFORMATTED XLEnd().
OUTPUT CLOSE.

{intrface.del}

OS-COPY VALUE(outfile) VALUE("/home2/bis/quit41d/imp-exp/protocol/finved/pir_ved_d" + string(today,"9999-99-99") + "_t" + replace(STRING(TIME,"HH:MM:SS"),":","-") + "_" + string(USERID("bisquit")) + ".xls").
MESSAGE "Расчет сохранен в " SKIP outfile VIEW-AS ALERT-BOX.

/*{preview.i}*/

DELETE OBJECT oTpl.
