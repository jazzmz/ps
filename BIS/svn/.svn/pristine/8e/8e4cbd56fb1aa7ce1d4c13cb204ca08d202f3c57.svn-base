/*
#2698
Отчет по заемщикам с изменением коэффициента резервирования
Заказчик Елешина Г.Н.
Исполнитель Никитина Ю.А.
22.04.2013
*/

{globals.i}
{getdate.i}
{sh-defs.i}
{intrface.get db2l}

DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR oTable 	AS TTable 	NO-UNDO.
DEF VAR oClient AS TClient    	NO-UNDO.
DEF VAR ost_o 	AS dec	 	NO-UNDO.
DEF VAR ost_r 	AS dec	 	NO-UNDO.
DEF VAR kr_f 	AS dec	 	NO-UNDO.
DEF VAR ac_r 	AS char	 	NO-UNDO.
DEF VAR kau_ob 	AS char	 	NO-UNDO.
DEF BUFFER comm-rate_p FOR comm-rate.
DEF BUFFER comm-rate_o FOR comm-rate.
DEF BUFFER comm-rate_v FOR comm-rate.
DEF BUFFER comm-rate_vp FOR comm-rate.
DEF BUFFER loan-acct_o FOR loan-acct.
DEF BUFFER loan-acct_r FOR loan-acct.
DEF VAR vCRSurr       AS CHAR NO-UNDO. /* Суррогат comm-rate'a  */
DEF VAR vKachObespech AS CHAR NO-UNDO. /* Качество обеспечения  */

DEF temp-table tmp_izmkk NO-UNDO
    FIELD cont-code as char 
    FIELD name as char 
    FIELD kk_s as char 
    FIELD kk_n as char 
    FIELD acct_o as char 
    FIELD acct-type as char 
    FIELD ost_ov as dec 
    FIELD ost_or as dec 
    FIELD acct_r as char 
    FIELD ost_r as dec 
    FIELD kk_o as dec 
    FIELD ob as char 
    FIELD prim as char 
.


oTpl = new TTpl("pir_izmkk.tpl").
oTable = new TTable(11).

oTable:addRow().
oTable:addCell("Номер договора").
oTable:addCell("Заемщик").
oTable:addCell("Коэффициент резерв. (старый)").
oTable:addCell("Коэффициент резерв. (новый)").
oTable:addCell("Счет, являющийся элементом расчетной базы").
oTable:addCell("Сумма остатка на счете (вал)").
oTable:addCell("Сумма остатка на счете (руб)").
oTable:addCell("Счет по учету соответствующего резерва").
oTable:addCell("Сумма созданного резерва").
oTable:addCell("Коэффициент резерв. (фактический)").
oTable:addCell("Примечание").

/*коэффициенты резервирования*/
for each comm-rate WHERE
        	comm-rate.commission EQ "%Рез"
/*     		AND   comm-rate.kau EQ (loan.contract + "," + loan.cont-code)- */
		AND   comm-rate.since eq end-date	
	NO-LOCK break by comm-rate.kau:
        find first loan where loan.contract eq entry(1,comm-rate.kau) and loan.cont-code eq entry(2,comm-rate.kau) 
			and can-do("!MM*,*",loan.cont-code)
			no-lock no-error.

	if avail loan then do:
		find first term-obl where term-obl.cont-code eq loan.cont-code and term-obl.idnt = 128 /*не ПОС*/ 
			and term-obl.contract eq "Кредит" and (term-obl.sop-date eq ? or term-obl.sop-date GT end-date) NO-LOCK no-error.
		if not avail term-obl then do:
        		oClient = NEW TClient(loan.cust-cat,loan.cust-id).
        /*		message tt-comm-rate.acct-type comm-rate.rate-fixed view-as alert-box.*/
        		find last comm-rate_p where comm-rate_p.commission EQ "%Рез"
        		     		AND   comm-rate_p.kau EQ (loan.contract + "," + loan.cont-code)
        				AND   comm-rate_p.since LT end-date  no-lock no-error.
        		for each loan-acct_o where loan-acct_o.contract EQ loan.contract
        	                       	AND (loan-acct_o.cont-code EQ loan.cont-code or loan-acct_o.cont-code begins loan.cont-code + " ")
                	               	AND loan-acct_o.since LE end-date 
        				AND can-do("Кредит,КредПр,КредН,КредЛин,КредТ,КредПр%,КредБудПени",loan-acct_o.acct-type) 
        				no-lock:
                	        RUN acct-pos IN h_base (loan-acct_o.acct, loan-acct_o.currency, end-date, end-date, gop-status).
                                IF loan-acct_o.currency EQ "" THEN ost_o = abs(sh-bal). ELSE ost_o = abs(sh-val).
        			find first tmp_izmkk where tmp_izmkk.acct_o eq loan-acct_o.acct no-lock no-error.
        			if not avail tmp_izmkk then do:
                                        if ost_o <> 0 then do:
                				CREATE tmp_izmkk.
                				tmp_izmkk.cont-code = entry(1,loan-acct_o.cont-code," ").
                				tmp_izmkk.name = oClient:name-short.
                				if avail comm-rate_p then tmp_izmkk.kk_s = string(comm-rate_p.rate-comm). else tmp_izmkk.kk_s = "".
                				tmp_izmkk.kk_n = string(comm-rate.rate-comm).
                				tmp_izmkk.acct_o = loan-acct_o.acct.
                				tmp_izmkk.acct-type = loan-acct_o.acct-type.
                                                tmp_izmkk.ost_ov = abs(sh-val).
                                                tmp_izmkk.ost_or = abs(sh-bal).

                				if loan-acct_o.acct-type eq "Кредит" then ac_r = "КредРез".
                				if loan-acct_o.acct-type eq "КредПр" then ac_r = "КредРез1".
                				if loan-acct_o.acct-type eq "КредН" or loan-acct_o.acct-type eq "КредЛин" then do:
        						ac_r = "КредРезВб".
                                                        find first comm-rate_v WHERE
                                                               	comm-rate_v.commission EQ "%Рез"
                                                        /*     		AND   comm-rate.kau EQ (loan.contract + "," + loan.cont-code)- */
                                                        	AND   comm-rate_v.since eq end-date
        							and comm-rate_v.acct eq loan-acct_o.acct	
                                                        	NO-LOCK no-error.
        						if avail comm-rate_v then tmp_izmkk.kk_n = string(comm-rate_v.rate-comm).
							else tmp_izmkk.kk_n = "".
                                                        find first comm-rate_vp WHERE
                                                               	comm-rate_vp.commission EQ "%Рез"
                                                        /*     		AND   comm-rate.kau EQ (loan.contract + "," + loan.cont-code)- */
                                                        	AND   comm-rate_vp.since < end-date
        							and comm-rate_vp.acct eq loan-acct_o.acct	
                                                        	NO-LOCK no-error.
        						if avail comm-rate_vp then tmp_izmkk.kk_s = string(comm-rate_vp.rate-comm).
							else tmp_izmkk.kk_s = "".
                        			end.
                				if loan-acct_o.acct-type eq "КредТ" then ac_r = "КредРезП".
                				if loan-acct_o.acct-type eq "КредПр%" then ac_r = "КредРезПр".
                				if loan-acct_o.acct-type eq "КредБудПени" then ac_r = "КредРезПени".
                        			find last loan-acct_r where loan-acct_r.contract EQ loan.contract
                        	                       	AND loan-acct_r.cont-code EQ loan.cont-code
                                	               	AND loan-acct_r.since LE end-date 
                        				AND loan-acct_r.acct-type eq ac_r no-lock no-error.
                        			if avail loan-acct_r then do:
        						tmp_izmkk.acct_r = loan-acct_r.acct.
                                	        	RUN acct-pos IN h_base (loan-acct_r.acct, loan-acct_r.currency, end-date, end-date, gop-status).
        						tmp_izmkk.ost_r = abs(sh-bal).
                        			end.
                        			else do:
        						tmp_izmkk.acct_r = "Счет с ролью " + ac_r + " на дату " + string(end-date) + " не найден".
        						tmp_izmkk.ost_r = 0.
                        			end.

                                		for each term-obl WHERE term-obl.cont-code EQ loan.cont-code AND term-obl.contract EQ loan.contract 
                                		        	and term-obl.end-date >= end-date no-lock:
                                			kau_ob = term-obl.contract + "," + term-obl.cont-code + "," + string(term-obl.idnt) + "," + string(term-obl.end-date) + ",0".
                                                	FOR each comm-rate_o WHERE comm-rate_o.commission EQ "КачОбеспеч" AND comm-rate_o.acct EQ "0" AND 
                                					comm-rate_o.kau EQ kau_ob and 
                                					comm-rate_o.since <= end-date 
                                					NO-LOCK :
                                				vCRSurr  = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate_o:HANDLE)).
                                				/* Категорию качества по доп.реку на comm-rate */
                                				vKachObespech = GetXAttrValueEx("comm-rate",vCRSurr,"КачОбеспеч","бе").
                                				if vKachObespech eq "II" then tmp_izmkk.ob = "Обеспечение". 
                                			end.
                                		end.
        				end.
        			end.
        		end.		
        		DELETE OBJECT oClient.
		end.
	end.
end.

for each tmp_izmkk where tmp_izmkk.kk_n ne "" no-lock break by tmp_izmkk.cont-code by tmp_izmkk.acct-type :
	ACCUMULATE tmp_izmkk.ost_or (TOTAL BY tmp_izmkk.acct-type).
	oTable:addRow().
	if first-of(tmp_izmkk.cont-code) and not last-of(tmp_izmkk.cont-code) then do:
	       	oTable:addCell(tmp_izmkk.cont-code).
		oTable:setBorder(1,oTable:height,1,1,1,0).
	       	oTable:addCell(tmp_izmkk.name).
		oTable:setBorder(2,oTable:height,1,1,1,0).
        end.
	if last-of(tmp_izmkk.cont-code) and not first-of(tmp_izmkk.cont-code) then do:
	       	oTable:addCell("").
		oTable:setBorder(1,oTable:height,1,0,1,1).
	       	oTable:addCell("").
		oTable:setBorder(2,oTable:height,1,0,1,1).
        end.

	if not first-of(tmp_izmkk.cont-code) and not last-of(tmp_izmkk.cont-code) then do:
	       	oTable:addCell("").
		oTable:setBorder(1,oTable:height,1,0,1,0).
	       	oTable:addCell("").
		oTable:setBorder(2,oTable:height,1,0,1,0).
        end.

	if first-of(tmp_izmkk.cont-code) and last-of(tmp_izmkk.cont-code) then do:
	       	oTable:addCell(tmp_izmkk.cont-code).
	       	oTable:addCell(tmp_izmkk.name).
        end.

/*       	oTable:addCell(tmp_izmkk.kk_s).
	oTable:addCell(tmp_izmkk.kk_n).
*/
       	if last-of(tmp_izmkk.acct-type) then do:
		if first-of(tmp_izmkk.acct-type) then do:
                       	oTable:addCell(tmp_izmkk.kk_s).
                	oTable:addCell(tmp_izmkk.kk_n).
                end.
		else do:
                       	oTable:addCell(tmp_izmkk.kk_s).
			oTable:setBorder(3,oTable:height,1,0,1,1).
                	oTable:addCell(tmp_izmkk.kk_n).
			oTable:setBorder(4,oTable:height,1,0,1,1).
		end.
	end.
	else do:
		if first-of(tmp_izmkk.acct-type) then do:
		       	oTable:addCell("").
			oTable:setBorder(3,oTable:height,1,1,1,0).
			oTable:addCell("").
			oTable:setBorder(4,oTable:height,1,1,1,0).
		end.
		else do:
		       	oTable:addCell("").
			oTable:setBorder(3,oTable:height,1,0,1,0).
			oTable:addCell("").
			oTable:setBorder(4,oTable:height,1,0,1,0).
		end.
	end.

       	oTable:addCell(tmp_izmkk.acct_o).
       	oTable:addCell(string(tmp_izmkk.ost_ov,">>>,>>>,>>>,>>9.99")).
/*       	oTable:addCell(ACCUM TOTAL BY tmp_izmkk.acct-type tmp_izmkk.ost_or).*/
       	oTable:addCell(string(tmp_izmkk.ost_or,">>>,>>>,>>>,>>9.99")).
       	oTable:addCell(tmp_izmkk.acct_r).
       	oTable:addCell(string(tmp_izmkk.ost_r,">>>,>>>,>>>,>>9.99")).
       	if last-of(tmp_izmkk.acct-type) then do:
		ost_o = ACCUM TOTAL BY tmp_izmkk.acct-type tmp_izmkk.ost_or.
		tmp_izmkk.kk_o = round(tmp_izmkk.ost_r * 100 / ost_o,2).
		if first-of(tmp_izmkk.acct-type) then do:
		       	oTable:addCell(string(tmp_izmkk.kk_o,">>9.99")).
			if dec(tmp_izmkk.kk_n) <> dec(tmp_izmkk.kk_o) then oTable:addCell("Внимание" + " " + tmp_izmkk.ob).
			else oTable:addCell("").
                end.
		else do:
		       	oTable:addCell(string(tmp_izmkk.kk_o,">>9.99")).
			oTable:setBorder(10,oTable:height,1,0,1,1).
			if dec(tmp_izmkk.kk_n) <> tmp_izmkk.kk_o then do: 
				oTable:addCell("Внимание" + " " + tmp_izmkk.ob).
				oTable:setBorder(11,oTable:height,1,0,1,1).
                	end.
			else do:
				oTable:addCell("").
				oTable:setBorder(11,oTable:height,1,0,1,1).
			end.
		end.
	end.
	else do:
		if first-of(tmp_izmkk.acct-type) then do:
		       	oTable:addCell("").
			oTable:setBorder(10,oTable:height,1,1,1,0).
			oTable:addCell("").
			oTable:setBorder(11,oTable:height,1,1,1,0).
		end.
		else do:
		       	oTable:addCell("").
			oTable:setBorder(10,oTable:height,1,0,1,0).
			oTable:addCell("").
			oTable:setBorder(11,oTable:height,1,0,1,0).
		end.
	end.
end.

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.

