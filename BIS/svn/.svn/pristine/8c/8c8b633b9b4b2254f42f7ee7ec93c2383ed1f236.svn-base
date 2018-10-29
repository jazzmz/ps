{globals.i}
{getdate.i}

DEF VAR oAcct   AS TAcct NO-UNDO.
DEF VAR oAArray AS TAArray NO-UNDO.

DEF VAR key1 AS CHAR NO-UNDO.
DEF VAR val1 AS CHAR NO-UNDO.

DEF VAR flagp AS logical initial false NO-UNDO.
def var sfinish as char NO-UNDO.
def var sstart as char NO-UNDO.
def var tstart as int64 NO-UNDO.
def var i as int NO-UNDO.
def var sdateed as char NO-UNDO.
def var per_temp as char NO-UNDO.
def var per_ta as char NO-UNDO.
def var srokall as char NO-UNDO.
def temp-table ttmp_kr 
	field tnumber as char
	field tacct as char
	field namet as char
	field ssrokt as dec
	field kolt as dec initial 0
	field tactype as char
	field ssroktod as dec
	field ssroktproc as dec
.

def  temp-table ttemp_per
	field tpnumber as char
	field tpacct as char
	field datebt as char
	field dateet as char
	field datebtall as char
	field dateetall as char
	field srokt as char
	field srokall as char
	field namet as char
.
DEF BUFFER bttemp_per     FOR ttemp_per.

sstart = string(Time,"HH:MM:SS").
tstart = Time.
/*for each term-obl where term-obl.cont-code eq "ПК-002/08" NO-LOCK :
        message term-obl.cont-code string(term-obl.sop-date) string(term-obl.idnt) string(term-obl.end-date) term-obl.contract. pause.
end.
*/
for each loan where loan.contract eq "Кредит" and (loan.close-date EQ ? OR loan.close-date >= end-date) and can-do("!MM*,*",loan.cont-code)
		NO-LOCK :
	find first term-obl where term-obl.cont-code eq loan.cont-code and term-obl.idnt = 128 /*не ПОС*/ 
			and term-obl.contract eq "Кредит" and (term-obl.sop-date eq ? or term-obl.sop-date GT end-date) NO-LOCK no-error.
	Display "время запуска " + sstart format "x(26)" skip "время работы " + string((Time - tstart),"HH:MM:SS") format "x(26)" with frame Inf overlay Centered . PAUSE 0.
	if not avail (term-obl) then do:        
	/*	message loan.cont-code. pause.*/
	for each loan-acct where loan-acct.contract eq "Кредит" and
			loan-acct.cont-code eq loan.cont-code and
                        loan-acct.since < end-date and
			(loan-acct.acct-type eq "КредПр" /*просроченная задолженность ОД*/  or
			 loan-acct.acct-type eq "КредПр%" /*просроченная задолженность по %*/  or
			 loan-acct.acct-type eq "КредПр%В" /*просроченная задолженность по % на внебалансе*/ )
			no-lock:
		FIND FIRST acct OF loan-acct WHERE acct.acct = loan-acct.acct and
                		acct.currency = loan-acct.currency NO-LOCK no-error.
			find first ttmp_kr where ttmp_kr.tacct eq acct.acct NO-LOCK no-error.
			if not avail (ttmp_kr) then do:			
				create ttmp_kr.
				ttmp_kr.tacct = acct.acct.	
				ttmp_kr.tnumber = loan.cont-code.
				ttmp_kr.tactype = loan-acct.acct-type.
				CASE loan.cust-cat:
					WHEN "Б" then do:
						find first banks where banks.bank-id = loan.cust-id NO-LOCK NO-ERROR.
						if avail banks then 
							ttmp_kr.namet = banks.name.
					END.
					WHEN "Ю" THEN do:
						FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
						IF AVAIL(cust-corp) THEN 
							ttmp_kr.namet = /*cust-corp.cust-stat + " " + cust-corp.name-corp + " " + */ cust-corp.name-short.
					end.
					WHEN "Ч" THEN do:
						FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
						IF AVAIL(person) THEN 
							ttmp_kr.namet = person.name-last + " " + person.first-names.				
					end.
				END CASE.
				oAcct = NEW TAcct(acct.acct).
				oAArray = oAcct:getStableIntervals((end-date - 180),end-date + 1).
				flagp = false.
				{foreach oAArray key1 val1}
				/*	message "key1" key1 "val1" val1 acct.acct. pause.*/
					if val1 ne "0" then do:
						if flagp = false then do:
							create ttemp_per.
							ttemp_per.tpnumber = loan.cont-code.
							ttemp_per.namet = ttmp_kr.namet.							
							ttemp_per.tpacct = acct.acct. 
							ttemp_per.datebt = string(date(entry(1,key1,"-")) - 1).
							ttemp_per.datebtall = string(date(entry(1,key1,"-")) - 1).
						end.
						flagp = true.
					end.
					else do:
						if flagp = true then do:
							ttemp_per.dateet = string(date(entry(1,key1,"-")) - 1).
							ttemp_per.dateetall = string(date(entry(1,key1,"-")) - 1).
						end.
						flagp = false.
					end.
				{endforeach oAArray}
				DELETE OBJECT oAArray.
				DELETE OBJECT oAcct.
			
			end.
	end.  
	end.      
end.

/* здесь мы ищем отдельно для каждой задолженности интервал */
for each ttemp_per no-lock:
	if (ttemp_per.dateet eq "") or (ttemp_per.dateet eq ?) then ttemp_per.dateetall = string(end-date).
	ttemp_per.srokt = string(date(ttemp_per.dateetall) - date(ttemp_per.datebt)).
	find first ttmp_kr where ttemp_per.tpnumber eq ttmp_kr.tnumber NO-LOCK no-error.
		ttmp_kr.kolt = ttmp_kr.kolt + 1.
	find first ttmp_kr where ttmp_kr.tnumber eq ttemp_per.tpnumber and ttmp_kr.tacct eq ttemp_per.tpacct no-lock no-error.
	if ttmp_kr.tactype eq "КредПр" then do: 
	        ttmp_kr.ssroktod = ttmp_kr.ssroktod + dec(ttemp_per.srokt).
	end.
	if ttmp_kr.tactype eq "КредПр%" then do: 
		ttmp_kr.ssroktproc = ttmp_kr.ssroktproc + dec(ttemp_per.srokt).
	end.
	if ttmp_kr.tactype eq "КредПр%В" then do: 
		ttmp_kr.ssroktproc = ttmp_kr.ssroktproc + dec(ttemp_per.srokt).
	end.
end.
/* здесь мы ищем общий интервал */
for each ttemp_per no-lock:
	for each bttemp_per where bttemp_per.tpnumber eq ttemp_per.tpnumber no-lock:
		if date(ttemp_per.datebtall) >= date(bttemp_per.datebtall) and date(ttemp_per.datebtall) <= date(bttemp_per.dateetall) then do:	
			ttemp_per.datebtall = bttemp_per.datebtall.  
			bttemp_per.srokall = "".
		end.		
		if date(ttemp_per.dateetall) >= date(bttemp_per.datebtall) and date(ttemp_per.dateetall) <= date(bttemp_per.dateetall) then do:	
			ttemp_per.dateetall = bttemp_per.dateetall.
			bttemp_per.srokall = "".
		end.		
		ttemp_per.srokall = string(date(ttemp_per.dateetall) - date(ttemp_per.datebtall)).
	end.
end.

Hide Frame Inf No-Pause.
sfinish = string(Time,"HH:MM:SS").

{setdest.i}
put unformatted " старт " + sstart + " финиш " + sfinish skip.
put unformatted "	Проверочная ведомость по просроченной задолженности за " + string(end-date) + " за период с " + string(end-date - 180) + " по " + string(end-date) skip.
put unformatted " № договора " format "x(15)" "|" " Наименование заемщика " format "x(25)" "|" 
		" Счет просрочки " format "x(20)" "|" " Дата возникновения просрочки " format "x(31)" "|" 
		" Дата погашения просрочки " format "x(27)" "|" " Срок просрочки " format "x(27)" "|" 
		 skip.
put unformatted fill("-",150) skip.

/*for each ttmp_kr no-lock by ttmp_kr.namet by ttmp_kr.tnumber by ttmp_kr.tactype:*/
	i = 0.
	per_temp = "".
	for each ttemp_per /*where ttemp_per.tpnumber eq ttmp_kr.tnumber*/ no-lock break by ttemp_per.namet by ttemp_per.tpnumber:
                per_ta = "".
		find first ttmp_kr where ttmp_kr.tacct eq ttemp_per.tpacct and ttmp_kr.tnumber eq ttemp_per.tpnumber no-lock no-error.
		put unformatted ttemp_per.tpnumber format "x(15)" "|" ttmp_kr.namet format "x(25)" "|" 
			        ttemp_per.tpacct format "x(20)" "|" ttemp_per.datebt format "x(31)" "|" 
				ttemp_per.dateet format "x(27)" "|" ttemp_per.srokt format "x(27)" "|" 
				skip.
 		i = 1.
		per_temp = ttemp_per.tpnumber.
                srokall = string(dec(ttemp_per.srokall) + dec(srokall)).
/*		if ttemp_per.tpnumber ne per_temp and per_temp ne "" then do:*/
		if LAST-OF(ttemp_per.tpnumber) THEN do:
			put unformatted fill("-",150) skip.
			find first ttmp_kr where ttmp_kr.tnumber eq per_temp no-lock no-error.
        		put unformatted "Кол-во случаев просрочек " ttmp_kr.tnumber " : " string(ttmp_kr.kolt) skip.
			find first ttmp_kr where ttmp_kr.tnumber eq per_temp and ttmp_kr.tactype eq "КредПр" no-lock no-error.
/*			if avail (ttmp_kr) then
			        put unformatted "Суммарынй срок просрочки по ОД: " string(ttmp_kr.ssroktod) skip.
			find first ttmp_kr where ttmp_kr.tnumber eq per_temp and ttmp_kr.tactype eq "КредПр%" no-lock no-error.
			if avail (ttmp_kr) then do:
				per_ta = string(dec(per_ta) + ttmp_kr.ssroktproc).
			end.
			find first ttmp_kr where ttmp_kr.tnumber eq per_temp and ttmp_kr.tactype eq "КредПр%В" no-lock no-error.
			if avail (ttmp_kr) then do:
				per_ta = string(dec(per_ta) + ttmp_kr.ssroktproc).
			end.
			find first ttmp_kr where ttmp_kr.tnumber eq per_temp and (ttmp_kr.tactype eq "КредПр%" or ttmp_kr.tactype eq "КредПр%В") no-lock no-error.
			if avail (ttmp_kr) then do:
	        		put unformatted "Суммарный срок просрочки по процентам: " per_ta skip.
			end.
*/			put unformatted "Суммарный срок просрочки: " srokall skip.
			srokall = "".
			put unformatted fill("-",150) skip.
        	end.
	end.	
/*end.*/
{preview.i}
