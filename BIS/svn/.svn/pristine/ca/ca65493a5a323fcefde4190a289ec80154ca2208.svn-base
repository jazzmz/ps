/*
#2574
Считает проценты за текущий месяц при частичном досрочном погашении ОД.
Исключает аннутинтные договоры, просроченные договоры.
*/

{globals.i}                    
{tmprecid.def}
{intrface.get xclass}
{sh-defs.i}
{intrface.get date}

DEF VAR oTable  	AS TTable    	NO-UNDO.
DEF VAR oTpl 		AS TTpl 	NO-UNDO.
DEF VAR proc-name     	AS CHARACTER 	NO-UNDO.
def var total_summ 	AS DEC INIT 0 	NO-UNDO.
DEF VAR dat-per 	AS DATE 	NO-UNDO.	/* Дата перехода на 39-П */
DEF VAR date-b 		AS char format "99/99/99" NO-UNDO.
DEF VAR date-e 		AS char format "99/99/99" NO-UNDO.
DEF VAR date-dp 	AS char format "99/99/99" NO-UNDO.
DEF VAR sum-dp 		AS dec 	format ">>>,>>>,>>>,>>>,>>9.99"	NO-UNDO.
DEF VAR date-nend 	AS char format "99/99/99" NO-UNDO.
DEF VAR sum-od 		AS dec 		NO-UNDO.
DEF VAR stavka 		AS dec 		NO-UNDO.
DEF VAR sum-pr 		AS dec 		NO-UNDO.
DEF VAR vSumma      	AS DEC   	NO-UNDO.

oTable = new TTable(7).
oTpl = new TTpl("pir_s1.tpl").

{t-otch.i new}

find first tmprecid no-error.
if not avail tmprecid then return.

find first loan where recid(loan) eq tmprecid.id no-lock.

if loan.cont-code matches "* *" then do:
	message "Договор является траншем. Надо формировать на охватывающем договоре." view-as alert-box.
	return.
end.

if loan.class-code eq "loan_mortgage" then do:
	message "Договор является аннуитентным. ТЗ исключает аннуитентные договоры" view-as alert-box.
	return.
end.

form
"Дата досроч. погашения  :" date-dp no-label skip
"Сумма досроч. погашения :" sum-dp no-label skip
with frame wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE COLOR bright-white "[ Период подсчета процентов ]".
pause 0.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE: 
	UPDATE date-dp sum-dp GO-ON(ESC) WITH FRAME wow.
	if lastkey eq 27 then do:
        	HIDE FRAME wow.
	        return.
	end.
	HIDE FRAME wow. 
END.


date-b = string(FirstMonDate(date(date-dp)),"99/99/99").
date-e = string(LastMonDate(date(date-dp)),"99/99/99").

{empty otch1}                         
{ch_dat_p.i} 
{get_meth.i 'NachProc' 'nach-pp'}

oTable:addRow().
oTable:addCell("Сумма ОД").
oTable:addCell("Начало периода").
oTable:addCell("Окочание периода").
oTable:addCell("Кол-во дней").
oTable:addCell("Ставка %").
oTable:addCell("Проценты").
oTable:addCell("Валюта").

run VALUE(proc-name + ".p") (loan.contract,
		 loan.cont-code,
                 date-b,
                 date-dp,
                 dat-per,                               		
	         ?,
                 1).

FOR EACH otch1 ,
	FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
   		         AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK  :
        oTable:addRow().
        oTable:addCell(STRING(otch1.bal-sum,">>>,>>>,>>>,>>9.99")).
        oTable:addCell(otch1.beg-date).
        oTable:addCell(otch1.end-date).
	oTable:addCell(otch1.ndays).
        oTable:addCell(STRING(otch1.rat1) + "%").
        oTable:addCell(STRING(otch1.summ_pr,">>>,>>>,>>>,>>9.99")).
	total_summ = total_summ + otch1.summ_pr.
        oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
	sum-od = otch1.bal-sum.
	stavka = otch1.rat1.	                           	
END.

if sum-od = 0 then do:
	message "Договор на просрочке. ТЗ исключает просроченные договоры" view-as alert-box.
	return.
end.
 
Find last term-obl WHERE term-obl.cont-code EQ loan.cont-code AND term-obl.contract EQ loan.contract AND term-obl.idnt EQ 3 
                and term-obl.end-date GE date(date-dp)
		NO-LOCK no-error.
if avail term-obl then do:
    	if term-obl.end-date lt date(date-e) then do:
		date-e = string(term-obl.end-date,"99/99/99"). 
        end.
end.

date-nend = date-e. 
/*if {holiday.i date(date-e)} then do:
	if {holiday.i date(date-e) - 1} then do:
		date-nend = string(date(date-e) - 2,"99/99/99"). 
	end.
	else date-nend = string(date(date-e) - 1,"99/99/99"). 
end.
*/
Find first term-obl WHERE term-obl.cont-code EQ loan.cont-code AND term-obl.contract EQ loan.contract AND term-obl.idnt EQ 3 
                and term-obl.end-date GE date(date-dp)
		NO-LOCK no-error.
if avail term-obl then do:
        RUN summ-t.p (OUTPUT vSumma,
                  loan.Contract,
                  loan.Cont-Code,
                  RECID(term-obl),
                  term-obl.end-date).
	if term-obl.end-date LT date(date-e) then 
		date-nend = string(date(term-obl.end-date),"99/99/99"). 
end.

/*sum-pr = (sum-od - sum-dp) * stavka / 100 / 365 * (date(date-nend) - date(date-dp)).*/

if date-nend ne date-e then do:
	if vSumma <= sum-dp or term-obl.end-date GT date(date-nend) then do:
		sum-pr = round((sum-od - sum-dp) * stavka / 100 / 365 * (date(date-e) - date(date-dp)),2).
	        oTable:addRow().
                oTable:addCell(STRING(sum-od - sum-dp,">>>,>>>,>>>,>>9.99")).
                oTable:addCell(string(date(date-dp) + 1,"99/99/99")).
                oTable:addCell(string(date(date-e),"99/99/99")).
        	oTable:addCell(date(date-e) - date(date-dp)).
                oTable:addCell(string(stavka) + "%").
                oTable:addCell(string(sum-pr,">>>,>>>,>>>,>>9.99")).
        	total_summ = total_summ + sum-pr.
                oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
	end.
	if vSumma > sum-dp and term-obl.end-date eq date(date-nend) then do:
		sum-pr = round((sum-od - sum-dp) * stavka / 100 / 365 * (date(date-nend) - date(date-dp)),2).
	        oTable:addRow().
                oTable:addCell(STRING(sum-od - sum-dp,">>>,>>>,>>>,>>9.99")).
                oTable:addCell(string(date(date-dp) + 1,"99/99/99")).
                oTable:addCell(date-nend).
        	oTable:addCell(date(date-nend) - date(date-dp)).
                oTable:addCell(string(stavka) + "%").
                oTable:addCell(string(sum-pr,">>>,>>>,>>>,>>9.99")).
        	total_summ = total_summ + sum-pr.
                oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
		sum-pr = round((sum-od - vSumma) * stavka / 100 / 365 * (date(date-e) - date(date-nend)),2).
		oTable:addRow().
                oTable:addCell(STRING(sum-od - vSumma,">>>,>>>,>>>,>>9.99")).
                oTable:addCell(string(date(date-nend) + 1,"99/99/99")).
                oTable:addCell(string(date(date-e),"99/99/99")).
        	oTable:addCell(date(date-e) - date(date-nend)).
                oTable:addCell(string(stavka) + "%").
                oTable:addCell(string(sum-pr,">>>,>>>,>>>,>>9.99")).
        	total_summ = total_summ + sum-pr.
                oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
	end.
end.
if date-nend eq date-e then do:
	sum-pr = round((sum-od - sum-dp) * stavka / 100 / 365 * (date(date-e) - date(date-dp)),2).
        oTable:addRow().
        oTable:addCell(STRING(sum-od - sum-dp,">>>,>>>,>>>,>>9.99")).
        oTable:addCell(string(date(date-dp) + 1,"99/99/99")).
        oTable:addCell(string(date(date-e),"99/99/99")).
	oTable:addCell(date(date-e) - date(date-dp)).
        oTable:addCell(string(stavka) + "%").
        oTable:addCell(string(sum-pr,">>>,>>>,>>>,>>9.99")).
	total_summ = total_summ + sum-pr.
        oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
end.

oTable:addRow().
oTable:addCell("ИТОГО").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell(string(total_summ,">>>,>>>,>>>,>>9.99")).
oTable:addCell("").
oTpl:addAnchorValue("Table1",oTable).
oTpl:addAnchorValue("Dogovor",loan.cont-code).
oTpl:addAnchorValue("Period","с " + date-b + " по " + date-e).


{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
