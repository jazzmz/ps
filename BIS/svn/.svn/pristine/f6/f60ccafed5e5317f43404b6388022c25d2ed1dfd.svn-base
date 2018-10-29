/*
#2743
Проверочная ведомость остатков на счетах по учету переоценки ЦБ
Заказчик : Елешина Г.Н.
Исполнитель : Никитина Ю.А.
Процедура идет по всем ЦБ и смотрит счет положительной переоценки и отрицательной переоценки. 
Если счет не нулевой, то создает запись в таблице.

*/

{globals.i}
{getdate.i}
{intrface.get seccd}    /* Библиотека для работы с ЦБ. */
{sh-defs.i}     

def var dr_okr 	as char 	no-undo.
def var dr_pkr 	as char 	no-undo.
def var dr_ns 	as char 	no-undo.
def var dr_nv 	as char 	no-undo.
def var dr_acb 	as char 	no-undo.
def var sum_sh-bal 	as dec 	no-undo.
def var i 	as dec 	no-undo.
def var hEmit  	as HANDLE 	no-undo.
def var Emit-custid 	as char no-undo.
def var emit-custcat 	as char no-undo.
DEF VAR oTable	AS TTable	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR oClient AS TClient    	NO-UNDO.

oTable = new TTable(6).
oTpl = new TTpl("pir_per_cb.tpl").

oTable:addRow().
oTable:addCell("Наименование ЦБ").
oTable:addCell("Код ЦБ").
oTable:addCell("На соотв. б/счете 10603").
oTable:addCell("На соотв. б/счете 50*21").
oTable:addCell("На соотв. б/счете 10605").
oTable:addCell("На соотв. б/счете 50*20").

/*for each op-entry where op-entry.op-date eq end-date and 
		(can-do("10603*,10605*",op-entry.acct-db) or can-do("10603*,10605*",op-entry.acct-cr)) no-lock:
	if avail(op-entry) then do:
*/
		for each sec-code where (sec-code.close-date EQ ? OR sec-code.close-date >= end-date) no-lock:
			dr_okr = GetXAttrValueEx("sec-code",sec-code.sec-code,"СчетОКР",""). 
			dr_pkr = GetXAttrValueEx("sec-code",sec-code.sec-code,"СчетПКР",""). 
/*			if dr_pkr eq op-entry.acct-db or dr_pkr eq op-entry.acct-cr then do:*/
			if dr_pkr ne "" then do:
				RUN acct-pos IN h_base (dr_pkr,"", end-date, end-date, gop-status).
				if sh-bal ne 0 then do:
        				oTable:addRow().
                                        oTable:addCell(sec-code.name).
                                        oTable:addCell(sec-code.sec-code).
                                        oTable:addCell(string(abs(sh-bal),">>>,>>>,>>>,>>9.99")).
                                	hEmit = secEmitInfo(sec-code.sec-code).
                                        IF VALID-HANDLE (hEmit) 
                                        THEN do:
        				        emit-custcat = hEmit:BUFFER-FIELD ("emit-custcat"):BUFFER-VALUE.
                                                emit-custid  = hEmit:BUFFER-FIELD ("emit-custid"):BUFFER-VALUE. 
                				oClient = NEW TClient(emit-custcat,int(emit-custid)).
                                                Find first cust-role WHERE cust-role.file-name NE 'loan' AND 
                						cust-role.cust-cat EQ emit-custcat AND cust-role.cust-id EQ emit-custid and
                						cust-role.Class-Code eq "ImaginEmit" and 
                						(cust-role.close-date eq ? or cust-role.close-date >= end-date) NO-LOCK no-error. 
        					if avail(cust-role) then do:
                                                        dr_ns = GetXAttrValueEx("cust-role",string(cust-role.cust-role-id),"pir_emit_2dig","").
        						if dr_ns <> "" then do:
								dr_nv = GetXAttrValueEx("sec-code",sec-code.sec-code,"issue_num","").
								sum_sh-bal = 0.
                                				for each acct where can-do("50.21......" + dr_ns + dr_nv + "*",acct.acct) 
										no-lock :
      									dr_acb = GetXAttrValueEx("acct",acct.acct + "," + acct.currency,"sec-code","").
      									if dr_acb eq sec-code.sec-code then do:
              									RUN acct-pos IN h_base (acct.acct,acct.currency, end-date, end-date, gop-status).
                                                      	                        sum_sh-bal = sum_sh-bal + abs(sh-bal).
      									end.
        							end.
                                      	                        oTable:addCell(string(sum_sh-bal,">>>,>>>,>>>,>>9.99")).
        						end.
        						else oTable:addCell("-").
        					end. 				
        					else oTable:addCell("-").
        					DELETE OBJECT oClient.
        				end.
        				else oTable:addCell("-").
        				oTable:addCell("-").
        				oTable:addCell("-").
				end.
                	end.
/*			if dr_okr eq op-entry.acct-db or dr_okr eq op-entry.acct-cr then do:*/
			if dr_okr ne "" then do:
				RUN acct-pos IN h_base (dr_okr,"", end-date, end-date, gop-status).
				if sh-bal ne 0 then do:
                                        oTable:addRow().
                                        oTable:addCell(sec-code.name).
                                        oTable:addCell(sec-code.sec-code).
        				oTable:addCell("-").
        				oTable:addCell("-").
                                        oTable:addCell(string(abs(sh-bal),">>>,>>>,>>>,>>9.99")).
                                	hEmit = secEmitInfo(sec-code.sec-code).
                                        IF VALID-HANDLE (hEmit) 
                                        THEN do:
        				        emit-custcat = hEmit:BUFFER-FIELD ("emit-custcat"):BUFFER-VALUE.
                                                emit-custid  = hEmit:BUFFER-FIELD ("emit-custid"):BUFFER-VALUE. 
                				oClient = NEW TClient(emit-custcat,int(emit-custid)).
                                                Find first cust-role WHERE cust-role.file-name NE 'loan' AND 
                						cust-role.cust-cat EQ emit-custcat AND cust-role.cust-id EQ emit-custid and
                						cust-role.Class-Code eq "ImaginEmit" and 
                						(cust-role.close-date eq ? or cust-role.close-date >= end-date) NO-LOCK no-error. 
        					if avail(cust-role) then do:
                                                        dr_ns = GetXAttrValueEx("cust-role",string(cust-role.cust-role-id),"pir_emit_2dig","").
        						if dr_ns <> "" then do:
								dr_nv = GetXAttrValueEx("sec-code",sec-code.sec-code,"issue_num","").
								sum_sh-bal = 0.
                                				for each acct where can-do("50.20......" + dr_ns + dr_nv + "*",acct.acct) 
										no-lock :
      									dr_acb = GetXAttrValueEx("acct",acct.acct + "," + acct.currency,"sec-code","").
									i = i + 1.
/*									message string(i) + "50.20......" + dr_ns + dr_nv + "*" + acct.acct + dr_acb view-as alert-box.*/
      									if dr_acb eq sec-code.sec-code then do:
              									RUN acct-pos IN h_base (acct.acct,acct.currency, end-date, end-date, gop-status).
                                                      	                        sum_sh-bal = sum_sh-bal + abs(sh-bal).
      									end.
        							end.
                                      	                        oTable:addCell(string(sum_sh-bal,">>>,>>>,>>>,>>9.99")).
        						end.
        						else oTable:addCell("-").
        					end. 				
        					else oTable:addCell("-").
        					DELETE OBJECT oClient.
        				end.
        				else oTable:addCell("-").
				end.				
                	end.
		end. 
/*	end.
end.
*/

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("DATE",end-date).
{setdest.i &cols=135 &custom = " 2 * "}
	oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.

