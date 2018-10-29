{pirsavelog.p}

form "~n@(#) lcondfrm.p 1.0 Om 20/09/2001"
with frame sccs-id stream-io width 250.

/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR. 

DEF VAR oTpl AS TTpl no-undo. 
DEF VAR oSysClass AS TSysClass no-undo.
def var j as integer no-undo.
def var incontr as char no-undo.
def var incontc as char no-undo.
def var insince as date no-undo.
def var temp_swift as char no-undo.
def var temp_swift1 as char no-undo.
def var name_plat  as char no-undo.
def var bic_plat  as char no-undo.
def var swift_name as char no-undo.
def var date_sd    as char no-undo.
def var refer      as char no-undo.
def var fir        as log  no-undo.
def var perehod    as log  no-undo.
def var inn_plat  as char no-undo.
def var date_n     as char no-undo. /* дата начала */
def var date_mat   as char no-undo. /* дата возврата */
def var proc       as char no-undo. /* процентная ставка */
def var acc_1      as char no-undo. /* основной счет */
def var acc_plat      as char no-undo.
def var corr_acct_plat      as char no-undo.
def var int_2      as char no-undo. /* счет основных процентов */
def var int_3      as char no-undo. /* счет начисленных процентов */
def var valuta     as char no-undo.    /* валюта сделки */
def var di-sum     as decimal no-undo. /* сумма сделки для расчетов */
def var summa      as char no-undo.    /* сумма сделки  строковая */
def var i          as int  no-undo.
def var b22 	   as char no-undo.
def var proc_ref   as char no-undo.
def var n21        as char no-undo.
def var summa_pr_dec      as decimal no-undo. /* сумма процентов */
def var summa_pr_os_dec   as decimal no-undo. /* сумма основных процентов */
def var summa_pr_nach_dec as decimal no-undo. /* сумма начисленных процентов */
def var summa_proc        as char no-undo. /* сумма процентов */
def var summa_proc_os     as char no-undo. /* сумма основных процентов */
def var summa_proc_nach   as char no-undo. /* сумма начисленных процентов */
def var period          as int  no-undo. /* кол-во дней */
def var period_os       as int  no-undo. /* кол-во дней для основных*/
def var period_nach     as int  no-undo. /* кол-во дней  для начисленных*/
def var summa_full as char no-undo. /*полное движение */
def var summa_prol as char no-undo. /* сумма пролонгации */
def var Gen_sogl as char no-undo.
def var tempdate as date no-undo.
def var periodbase as int no-undo.
def var gen_sogl_date as date no-undo.

def buffer l-cond#  for loan-cond.
def buffer cond for loan-cond.
def buffer bloan for loan.


def buffer part-amt-of-deal for loan.
def buffer out-payment for term-obl.


def var RusAlfavit as char INIT "а,б,в,г,д,е,ё,ж,з,и,й,к,л,м,н,о,п,р,с,т,у,ф,х,ц,ч,ш,щ,ъ,ы,ь,э,ю,я".
def var NeRusAlfavit as char INIT "A,B,V,G,F,E,E,ZH,Z,I,I,K,L,M,N,O,P,R,S,T,U,F,H,Z,CH,SH,SH,',Y,',E,YU,YA".


/*
{mysh.i}
*/
{globals.i}
{svarloan.def}
{intrface.get date}
{pp-swi.p}
/* поиск текущего условия */
find first loan-cond where
    recid (loan-cond) eq rid-t
no-lock no-error.
{wordwrap.def}
{gstrings.i}
if not avail loan-cond
then return.

/* поиск превого условия */
find first cond where cond.cont-code eq loan-cond.cont-code and
                      cond.since LT loan-cond.since
no-lock no-error.

/* поиск договора */
find first loan where loan.cont-code eq loan-cond.cont-code
no-lock no-error.

/** Ищем частичную сумму, у которой есть д.р. PrevLoanID */
find first part-amt-of-deal where part-amt-of-deal.contract = loan.contract
                              and num-entries(part-amt-of-deal.cont-code, " ") = 2 
                              and entry(1, part-amt-of-deal.cont-code, " ") = loan.cont-code
                              no-lock no-error.

if avail part-amt-of-deal and 
   GEtXAttrValueEx("loan", part-amt-of-deal.contract + "," + part-amt-of-deal.cont-code, "PrevLoanID", "-") = "-" 
   then fir = yes. 
   else fir = no.

/* поиск клиента */

find first banks where banks.bank-id eq loan.cust-id
no-lock no-error.

IF not avail banks then 
                        do:
                        MESSAGE "Ненайден Банк по договору!" skip
                                                         "Или клиент не является Банком."        
                   VIEW-AS ALERT-BOX.
      RETURN.
      end.

find first cust-ident where (cust-ident.cust-id = banks.bank-id) and (cust-ident.cust-cat eq "Б") and (cust-ident.cust-code-type eq "ИНН").

inn_plat = cust-ident.cust-code.

IF GetXAttrValueEx("banks",string(banks.bank-id),"engl-name","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"engl-name","") eq ? then
                   do:
                   MESSAGE "Незаполнено английское название Банка!" skip
                                                         "Дополнительный реквизит engl-name на клиенте."        
                   VIEW-AS ALERT-BOX.
      RETURN.
      end.
else  
name_plat  = CAPS(TRIM(GetXAttrValueEx("banks",
                         string(banks.bank-id),
                         "engl-name",""))) + ",".


find first banks-code where banks-code.bank-id = banks.bank-id and banks-code.bank-code-type = "МФО-9".                         
bic_plat = banks-code.bank-code.

find first banks-corr where banks-corr.bank-corr = banks.bank-id.

corr_acct_plat = banks-corr.corr-acct.

/* SWIFT */
/*find first banks-code where banks-code.bank-id = banks.bank-id and banks-code.bank-code-type = "BIC" NO-ERROR.*/
periodBase = (IF TRUNCATE(YEAR(loan.end-date) / 4,0) = YEAR(loan.end-date) / 4 THEN 366 ELSE 365).

IF GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","") eq ? then
   		do:
   		MESSAGE "Незаполнен SWIFT Банка!" VIEW-AS ALERT-BOX.
      RETURN.
      end.
else   
do:
 swift_name = GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","").
 out_file_name  = ENTRY(1,iParam) +  "/"  + string(today,"999999") + swift_name  + ".320".                        
/* out_file_name  = string(today,"999999") + swift_name  + ".320".                        */
end.                         
perehod = no.

date_n = if fir eq yes then string(loan-cond.since,"99.99.9999") else string(loan-cond.since - 1,"99.99.9999").

/* дата сделки */
date_sd = string(year(loan-cond.since),"9999") + string(month(loan-cond.since),"99") + string(day(loan-cond.since),"99").

/* референс */


refer = sw-trans(SUBSTRING(loan.doc-num,1,1),YES,"111111") + SUBSTRING(loan.doc-num,2,9).

/*refer = sw-trans(refer,YES,"111111").*/

/* дата  возврата */
find first l-cond# where
    l-cond#.contract  eq loan-cond.contract and
    l-cond#.cont-code eq loan-cond.cont-code and
    l-cond#.since     gt loan-cond.since
no-lock no-error.

if avail l-cond# then 
   do:
   date_mat = string(l-cond#.since - 1,"99.99.9999").

   /* Buryagin commented at 04.12.2007 16:51:47 
   period = if fir = yes then l-cond#.since - loan-cond.since - 1 else l-cond#.since - loan-cond.since.
   */
   period = l-cond#.since - loan-cond.since - 1 .
   end.
   else 
       if loan.end-date = ?
       then date_mat = "".
       else 
       do:
       date_mat = string(loan.end-date,"99.99.9999").
                         /** Buryagin commented at 04.12.2007 16:52:43 
                         period = if fir = yes then loan.end-date - loan-cond.since else loan.end-date - loan-cond.since + 1.
                         */
                    period = loan.end-date - loan-cond.since.
                         end.

/* счет основной */
FIND last loan-acct where   ENTRY(1, loan-acct.cont-code, " ") = loan-cond.cont-code and
                            num-entries(loan-acct.cont-code, " ") = 2 and
                            can-do("Кредит,Депоз", loan-acct.acct-type) and 
			    loan-acct.since LE loan-cond.since no-lock no-error.

if avail loan-acct then acc_1 = loan-acct.acct.



/* счет основных процентов */
FIND last loan-acct where  loan-acct.cont-code = loan-cond.cont-code and
                                                                        loan-acct.acct-type eq "КредПРоц" and 
                                                                        loan-acct.since LE loan-cond.since no-lock no-error.

if avail loan-acct then int_2 = loan-acct.acct.

/* счет начисленных процентов */
FIND last loan-acct where  loan-acct.cont-code = loan-cond.cont-code and
                                                                        loan-acct.acct-type eq "КредТ" and 
                                                                        loan-acct.since LE loan-cond.since no-lock no-error.

if avail loan-acct then int_3 = loan-acct.acct.

find last op-entry where acct-db = acc_1 no-lock no-error.
IF AVAILABLE(op-entry) then do:
   find first op where op.op = op-entry.op.
    acc_plat = op.ben-acct.
end.
else MESSAGE "Нет проводок по сделке!" VIEW-AS ALERT-BOX.


find last bloan where (bloan.class-code EQ 'loan_agr_mm') and
(bloan.close-date eq ?) and (bloan.contract EQ 'СОГЛ') and (bloan.cust-id = banks.bank-id) NO-LOCK NO-ERROR.
IF AVAILABLE(bloan) then do:

gen_sogl = bloan.cont-code.
gen_sogl_date = bloan.open-date.

do i = 1 to 33:
   gen_sogl = replace (gen_sogl,entry(i,rusAlfavit),entry(i,nerusAlfavit)).
end.


/*gen_sogl = /*"//" + */ sw-trans(gen_sogl,YES,"111111").
gen_sogl = REPLACE(gen_sogl,"WX","/").*/
end.
else MESSAGE "не найдено ген.соглашение!" VIEW-AS ALERT-BOX.

/* валюта */
IF loan.currency eq "" then valuta = "RUB".
 else
  DO:
         find currency where currency.currency eq loan.currency 
         no-lock no-error.
         IF avail currency then valuta = currency.i-currency.
   END.




/* сумма */
FIND LAST term-obl {wh-t &f=term-obl &c="/*" }
      AND term-obl.idnt      = 2
      AND term-obl.end-date <= loan-cond.since NO-LOCK NO-ERROR.

IF NOT AVAILABLE term-obl THEN
   FIND FIRST term-obl {wh-t &f=term-obl &c="/*" }
          AND term-obl.idnt = 2
      NO-LOCK NO-ERROR.

di-sum = IF AVAILABLE term-obl THEN term-obl.amt ELSE ?.
  /* если условие последнее */
IF di-sum = 0
THEN DO :
   FIND FIRST  cond {wh-t &f=cond &c="/*"}
      AND cond.since gt loan-cond.since 
      NO-LOCK NO-ERROR.
  IF NOT AVAIL cond AND loan-cond.since ge loan.end-date
  THEN DO :
      FOR EACH  term-obl {wh-t &f=term-obl &c="/*" }
      AND term-obl.idnt      = 2
      AND term-obl.end-date <= loan-cond.since NO-LOCK
      BY term-obl.end-date DESCENDING :
       IF term-obl.amt <> 0
       THEN LEAVE.
     END.
  END.
  IF AVAIL term-obl THEN
  di-sum = term-obl.amt.
END.

summa = valuta + " " + trim(string(di-sum,"->>>,>>>,>>>,>>9.99")).


/* расчет процентной ставки */
DO i = lr-st TO lr-ed :
   FIND LAST comm-rate WHERE
             comm-rate.commi    EQ lrate[i]
         AND comm-rate.kau      EQ loan-cond.contract + "," + loan-cond.cont-code
         AND comm-rate.currency EQ loan.currency
         AND comm-rate.acct     EQ "0"
         AND comm-rate.since    <= loan-cond.since
      NO-LOCK NO-ERROR.

   inrate[i - lr-st + 1] = IF AVAILABLE comm-rate THEN
                              comm-rate.rate-comm
                           ELSE
                              ?.
END.
proc = trim(string(inrate[1] * 100,">9,99")).

if substring(proc,length(proc),1) = "0" then proc_ref = substring(proc,1,length(proc) - 1).
else proc_ref = proc. 

proc_ref = REPLACE(proc_ref,",","").

if length(proc_ref) = 1 then proc_ref = "000" + proc_ref.
if length(proc_ref) = 2 then proc_ref = "00" + proc_ref.
if length(proc_ref) = 3 then proc_ref = "0" + proc_ref.

/* расчет суммы процентов */
summa_pr_dec =round(di-sum / 100 * inrate[1] / periodbase * period,2).
summa_proc = trim(string(di-sum / 100 * inrate[1] / periodbase * period,">>>>>>>>9.99")).

 if (period > 1) and ((month(date(date_mat)) ne month(date(date_n))))
    and (day(date(date_n) + 1) <> 1) then
   do:
      perehod = yes.
      period_nach = LastMonDate(date(date_n)) - date(date_n). 
      period_os = date(date_mat) - FirstMonDate(date(date_mat)) + 1. 

      summa_pr_nach_dec = round(di-sum / 100 * inrate[1] / periodbase * period_nach,2).
      summa_proc_nach = trim(string(summa_pr_nach_dec,">>>>>>>>9.99")).
                 
      summa_pr_os_dec = summa_pr_dec - summa_pr_nach_dec.
      summa_proc_os = trim(string(summa_pr_os_dec,">>>>>>>>9.99")).

   end.


/* расчет сумм полного движения и пролонгации */
if fir eq yes then
  do:
  summa_full = trim(string(ROUND(di-sum,0),"->>>>>>>>>>>9")).
  summa_prol = "0,00".
  end.
else 
  do:
  summa_full = "0,00".
  summa_prol = trim(string(ROUND(di-sum,0),"->>>>>>>>>>>9")).
  end.

 if fir eq yes then b22 = "CONF".
 else b22 = "ROLL".

 
/*output to value("telex_tmp.txt").*/

  tempdate = date(date_mat).
  oSysClass = new TSysClass().

  if (LENGTH(name_plat) > 31) then name_plat = Substring(name_plat,1,30) + CHR(10) + Substring(name_plat,31,LENGTH(name_plat)).
  temp_swift = "".
  temp_swift1 = "".
  if (Length(swift_name) > 8) then 
	do:
           temp_swift = SUBSTRING(swift_name,9,Length(swift_name)).
	   
	   temp_swift1 = temp_swift.	
/*	   message temp_swift1 ViEW-AS ALERT-BOX.*/
	   if Length(temp_swift) < 4 then 
              temp_swift = "X" + temp_swift.

/*	      do j = 1 to (4 - Length(temp_swift)):
                 temp_swift = temp_swift + "X".
	      end.*/

	end.
  else temp_swift = "XXXX".	

def var our_corr_acct as char NO-UNDO.
def var our_corr_acct2 as char NO-UNDO.

/*temp_swift = "XXXX".*/	 /* временное решение, пока не придумаю как быть с райффайзен банком. */
if valuta = "RUB" then 
  DO:
   oTpl = new TTpl("pir_mm_swift.tpl").
   our_corr_acct = "30101810500000000491".
   our_corr_acct2 = "30101810500000000491".

  END.
else
   DO:
      
      oTpl = new TTpl("pir_mm_swift320v.tpl").
      IF valuta = "USD" then 
         DO:
            our_corr_acct  = "/70-55.094.767  RZBAATWW RAIFFEISEN BANK INTERNATIONAL AG VIENNA AT ACC. " + acc_1.
            our_corr_acct2 = "/70-55.094.767  RZBAATWW RAIFFEISEN BANK INTERNATIONAL AG VIENNA AT ACC. "  + int_2.
            corr_acct_plat = GEtXAttrValueEx("loan", bloan.contract + "," + bloan.cont-code, "Swift_57D_USD","").
         END.
      IF valuta = "EUR" then 
         DO:
            our_corr_acct  = "/1-55.094.767   RZBAATWW RAIFFEISEN BANK INTERNATIONAL AG VIENNA AT ACC. "  + acc_1.
            our_corr_acct2 = "/1-55.094.767   RZBAATWW RAIFFEISEN BANK INTERNATIONAL AG VIENNA AT ACC. "  + int_2.
            corr_acct_plat = GEtXAttrValueEx("loan", bloan.contract + "," + bloan.cont-code, "Swift_57D_EUR","").
         END.

   our_corr_acct = WrapIt(our_corr_acct).
   our_corr_acct2 = WrapIt(our_corr_acct2).
   corr_acct_plat =  WrapIt(corr_acct_plat).

   END.
/*    message temp_swift temp_swift1 VIEW-AS ALERT-BOX.  */
    oTpl:addAnchorValue("valuta",valuta).
    oTpl:addAnchorValue("swift_name",SUBSTRING(swift_name,1,8) + temp_swift).
    if fir eq yes then  oTpl:addAnchorValue("refer",refer). 
    else oTpl:addAnchorValue("refer",refer + CHR(10) + ":21:" + substring(refer,1,8)).
    oTpl:addAnchorValue("22B",b22).
    oTpl:addAnchorValue("22C","BPIRMM" + proc_ref + Substring(swift_name,1,4) + "MM").
    oTpl:addAnchorValue("swift_name1",SUBSTRING(swift_name,1,8) + temp_swift1).
    oTpl:addAnchorValue("77D",gen_sogl).
    oTpl:addAnchorValue("77D",gen_sogl).
    oTpl:addAnchorValue("77D_date",oSysClass:DATETIME2STR(gen_sogl_date,"%y%m%d")).
    oTpl:addAnchorValue("30T",oSysClass:DATETIME2STR(loan-cond.since,"%y%m%d")).
    oTpl:addAnchorValue("30V",oSysClass:DATETIME2STR(loan-cond.since,"%y%m%d")).
    oTpl:addAnchorValue("30P",oSysClass:DATETIME2STR(tempdate,"%y%m%d")).
    if fir eq yes then  oTpl:addAnchorValue("32B",Trim(STRING(summa_full,"x(19)"))).             
    else oTpl:addAnchorValue("32B",Trim(STRING(summa_prol,"x(19)")) + "," + CHR(10) + ":32H:" + valuta + "0").       
    oTpl:addAnchorValue("30X",oSysClass:DATETIME2STR(tempdate,"%y%m%d")).
    oTpl:addAnchorValue("34E",REPLACE(summa_proc,".",",")).
    oTpl:addAnchorValue("37G",proc).
    oTpl:addAnchorValue("corr_acct_plat",corr_acct_plat).
    oTpl:addAnchorValue("name_plat",name_plat).
    oTpl:addAnchorValue("inn_plat",inn_plat).
    oTpl:addAnchorValue("our_corr_acct",our_corr_acct).
    oTpl:addAnchorValue("our_corr_acct2",our_corr_acct2).

    oTpl:addAnchorValue("bic_plat",bic_plat).
    oTpl:addAnchorValue("acc_plat",acc_plat).
    oTpl:addAnchorValue("acc_1",acc_1).
    oTpl:addAnchorValue("int_2",int_2).
    oTpl:addAnchorValue("PeriodBase",PeriodBase).

/*    oTpl:addAnchorValue("t72t",gen_sogl).*/

                                

{setdest.i}
    oTpl:show().
{preview.i}

OS-COPY VALUE("_spool.tmp") VALUE("telex_tmp.txt").

MESSAGE
                                "Экспортировать данные?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE continue-ok AS LOGICAL .
/*out_file_name = "123.txt".*/
IF continue-ok THEN
DO:
  OUTPUT TO VALUE(out_file_name).
   display
    with NO-LABELS NO-UNDERLINE
   .
  OUTPUT CLOSE.

OS-COPY VALUE("telex_tmp.txt") VALUE(out_file_name).
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
END.                                        

DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.
