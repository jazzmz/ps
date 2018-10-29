{pirsavelog.p}

/*
	КБ ПPОМИНВЕСТРАСЧЕТ
  Остатки на пластике по валютам
  
  параметры пример:
  ПорядокВалют=810;БалСчета=42301,40817,40820,42601 

*/

{globals.i}
{sh-defs.i}

def input parameter inline as char no-undo.
/* 
inline = "ПорядокВалют=810,840,978;БалСчета=40817".
*/
DEFINE TEMP-TABLE ttOborot
   FIELD bal-acct LIKE bal-acct.bal-acct
   FIELD currency LIKE acct.currency
   FIELD simv like country.country-id
   FIELD vh-bal-db LIKE sh-val
   FIELD vh-bal-cr LIKE sh-val
   FIELD obor-db LIKE sh-val
   FIELD obor-cr LIKE sh-val
   FIELD ish-bal-db LIKE sh-bal
   FIELD ish-bal-cr LIKE sh-bal
   INDEX acct-cur-idx bal-acct currency.
.

def var i as integer no-undo.
def var j as integer no-undo.
def var tentry as char no-undo.
def var pcur as char no-undo.
def var bline as char no-undo.
def var cur as char no-undo.
def var iCount as integer init 0 no-undo.

/* разбор строки параметров */
do i = 1 to num-entries(inline,";").
 tentry = entry(i,inline,";").
 case entry(1,tentry,"="):
    when "ПорядокВалют" then pcur = entry(2,tentry,"=").
    when "БалСчета"     then bline = entry(2,tentry,"=").
 end.
end.

if pcur = "" or bline = "" then do: 
	message "Ошибка в передаваемых параметрах!!!" view-as alert-box.
	return.
end.

{getdate.i}

do j = 1 to num-entries(pcur).
 cur = entry (j,pcur).
 if cur = "810" then cur = "".
  do i = 1 to num-entries(bline).
  	
  	FIND FIRST bal-acct where bal-acct.bal-acct eq integer(entry(i,bline)) no-lock no-error.

    For each acct where acct.bal-acct = integer(entry(i,bline)) and
    substring (acct.acct,6,3) = entry (j,pcur) and (substring(acct.acct,14,3) = "050" or substring(acct.acct,14,3) = "550") 
    /* and acct.close-date = ? */ and acct.open-date <= end-date no-lock:
       run acct-pos in h_base (acct.acct, acct.currency, end-date, end-date, "√").
       if acct.currency = "" or acct.currency = ? then do: 
       			accumulate sh-bal (total).
       			accumulate sh-in-bal (total).
						accumulate sh-db  (total).
						accumulate sh-cr  (total).
			 end.      
       else do:
       			accumulate sh-val (total).
       			accumulate sh-in-val (total).
						accumulate sh-vdb  (total).
						accumulate sh-vcr  (total).
       end.
    end.
	      CREATE ttOborot.
        ASSIGN
         ttOborot.bal-acct   = integer(entry(i,bline))
         ttOborot.currency   = entry (j,pcur)
         ttOborot.vh-bal-db  = if bal-acct.side = "А" then (if cur = "" then abs(accum total sh-in-bal) else abs(accum total sh-in-val)) else 0.0
         ttOborot.vh-bal-cr  = if bal-acct.side = "П" then (if cur = "" then abs(accum total sh-in-bal) else abs(accum total sh-in-val)) else 0.0
         ttOborot.obor-db    = if cur = "" then accum total sh-db else accum total sh-vdb
         ttOborot.obor-cr    = if cur = "" then accum total sh-cr else accum total sh-vcr
         ttOborot.ish-bal-db = if bal-acct.side = "А" then (if cur = "" then abs(accum total sh-bal) else abs(accum total sh-val)) else 0.0
         ttOborot.ish-bal-cr = if bal-acct.side = "П" then (if cur = "" then abs(accum total sh-bal) else abs(accum total sh-val)) else 0.0
         .
     
  end.
    

end.

{get-bankname.i}


{setdest.i}
FOR EACH ttOborot
by ttOborot.bal-acct :

if ttOborot.vh-bal-db eq 0 and ttOborot.vh-bal-cr eq 0 and
   ttOborot.obor-db eq 0 and ttOborot.obor-cr eq 0 and
   ttOborot.ish-bal-db eq 0 and ttOborot.ish-bal-cr eq 0 then next.

form header
cBankName skip
"Оборотно-сальдовая ведомость по пластиковым счетам за день" end-date skip
"+-------+-----+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+" skip
"| Счет  | ВАЛ |    ВХ. ДЕБ. ОСТАТОК   |    ВХ. КРЕД. ОСТАТОК  |    ОБОРОТ ПО ДЕБЕТУ   |   ОБОРОТ ПО КРЕДИТУ   |   ИСХ. ДЕБ. ОСТАТОК   |   ИСХ. ДЕБ. ОСТАТОК   |" skip
"+-------+-----+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+" skip
with WIDTH 160 no-box.

            display
            "|" ttOborot.bal-acct
            "|" ttOborot.currency  
            "|" ttOborot.vh-bal-db
            "|" ttOborot.vh-bal-cr
            "|" ttOborot.obor-db
            "|" ttOborot.obor-cr
            "|" ttOborot.ish-bal-db
            "|" ttOborot.ish-bal-cr
						"|"
            WITH NO-LABELS NO-UNDERLINE
            .

put unformatted 
"+-------+-----+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+" skip.

END.

{signatur.i  &user-only = yes}
{preview.i}

