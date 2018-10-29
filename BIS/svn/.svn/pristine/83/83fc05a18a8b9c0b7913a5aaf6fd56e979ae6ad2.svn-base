{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: 
      Comment: Печать экранной формы.
   Parameters:
         Uses:
      Used by: 
      Created: 20/09/2001 Om
     Modified: 
*/

form "~n@(#) lcondfrm.p 1.0 Om 20/09/2001"
with frame sccs-id stream-io width 250.

/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR. 

def var incontr as char no-undo.
def var incontc as char no-undo.
def var insince as date no-undo.

def var name_plat  as char no-undo.
def var adr_plat   as char no-undo.
def var telex_name as char no-undo.
def var date_sd    as char no-undo.
def var refer      as char no-undo.
def var fir        as log  no-undo.
def var perehod    as log  no-undo.
def var date_n     as char no-undo. /* дата начала */
def var date_mat   as char no-undo. /* дата возврата */
def var proc       as char no-undo. /* процентная ставка */
def var acc_1      as char no-undo. /* основной счет */
def var int_2      as char no-undo. /* счет основных процентов */
def var int_3      as char no-undo. /* счет начисленных процентов */
def var valuta     as char no-undo.    /* валюта сделки */
def var di-sum     as decimal no-undo. /* сумма сделки для расчетов */
def var summa      as char no-undo.    /* сумма сделки  строковая */
def var i          as int  no-undo.
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
def var test_key   as char no-undo.


def buffer l-cond#  for loan-cond.
def buffer cond for loan-cond.
/*
{mysh.i}
*/
{globals.i}
{svarloan.def}
{intrface.get date}
/* поиск текущего условия */
find first loan-cond where
    recid (loan-cond) eq rid-t
no-lock no-error.

if not avail loan-cond
then return.

/* поиск превого условия */
find first cond where cond.cont-code eq loan-cond.cont-code and
                      cond.since LT loan-cond.since
no-lock no-error.
if not avail cond then fir = yes. else fir = no.

/* поиск договора */
find first loan where loan.cont-code eq loan-cond.cont-code
no-lock no-error.

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

/* название плательщика */
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
                         
/* адрес плательщика */
IF GetXAttrValueEx("banks",string(banks.bank-id),"telex-address","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"telex-address","") eq ? then
   		do:
   		MESSAGE "Незаполнен английский адрес Банка!" skip
 							"Дополнительный реквизит telex-address на клиенте (город,страна)."	
   		VIEW-AS ALERT-BOX.
      RETURN.
      end.
else   
adr_plat  = CAPS(TRIM(GetXAttrValueEx("banks",
                         string(banks.bank-id),
                         "telex-address",""))) + ",".       
                                       
 /* telex плательщика для выгрузки имени файла */ 
IF GetXAttrValueEx("banks",string(banks.bank-id),"telex-name","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"telex-name","") eq ? then
   		do:
   		MESSAGE "Незаполнен TELEX Банка!" skip
 							"Дополнительный реквизит telex-name на клиенте."	
   		VIEW-AS ALERT-BOX.
      RETURN.
      end.
else   
/* out_file_name  = ENTRY(1,iParam) +  "/"  + string(today,"999999") + "_" +
                  entry(1,string(time,"HH:MM"),":") + entry(2,string(time,"HH:MM"),":") + "_" +
                  entry(2,GetXAttrValue("banks",
                         string(banks.bank-id),
                         "telex-name")," ") + ".txt".                        */
 
 out_file_name  = ENTRY(1,iParam) +  "/"  + string(today,"999999") + "_" +
                  entry(2,GetXAttrValue("banks",
                         string(banks.bank-id),
                         "telex-name")," ") +  "_" +
                         substring(loan-cond.cont-code,6,3) +
                         ".txt".                        
                         
perehod = no.
date_n = if fir eq yes then string(loan-cond.since,"99.99.9999") else string(loan-cond.since - 1,"99.99.9999").

/* дата сделки */
if fir eq yes then
date_sd = string(year(loan-cond.since),"9999") + string(month(loan-cond.since),"99") + string(day(loan-cond.since),"99").
else
date_sd = string(year(loan-cond.since),"9999") + string(month(loan-cond.since),"99") + string(day(loan-cond.since - 1),"99").

/* референс */

refer = date_sd + "/" + substring(loan-cond.cont-code,6,3).
/*
refer = loan-cond.cont-code.
refer = sw-trans("абвгд",YES,"111111").
*/
/* дата  возврата */
find first l-cond# where
    l-cond#.contract  eq loan-cond.contract and
    l-cond#.cont-code eq loan-cond.cont-code and
    l-cond#.since     gt loan-cond.since
no-lock no-error.

if avail l-cond# then 
   do:
   date_mat = string(l-cond#.since - 1,"99.99.9999").
   period = if fir = yes then l-cond#.since - loan-cond.since - 1 else l-cond#.since - loan-cond.since.
   end.
   else 
       if loan.end-date = ?
       then date_mat = "".
       else 
       do:
       date_mat = string(loan.end-date,"99.99.9999").
			 period = if fir = yes then loan.end-date - loan-cond.since else loan.end-date - loan-cond.since + 1.
			 end.

/* счет основной */
FIND last loan-acct where   loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "Кредит" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then acc_1 = loan-acct.acct.



/* счет основных процентов */
FIND last loan-acct where  loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "КредПРоц" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then int_2 = loan-acct.acct.

/* счет начисленных процентов */
FIND last loan-acct where  loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "КредТ" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then int_3 = loan-acct.acct.


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
proc = trim(string(inrate[1],">9.99")).

/* расчет суммы процентов */
summa_pr_dec =round(di-sum / 100 * inrate[1] / 365 * period,2).
summa_proc = trim(string(di-sum / 100 * inrate[1] / 365 * period,">>>,>>>,>>9.99")).

 if period > 1 and (month(date(date_mat)) ne month(date(date_n))) then
   do:
      perehod = yes.
      period_nach = LastMonDate(date(date_n)) - date(date_n). 
      period_os = date(date_mat) - FirstMonDate(date(date_mat)) + 1. 

      summa_pr_nach_dec = round(di-sum / 100 * inrate[1] / 365 * period_nach,2).
      summa_proc_nach = trim(string(summa_pr_nach_dec,">>>,>>>,>>9.99")).

      summa_pr_os_dec = summa_pr_dec - summa_pr_nach_dec.
      summa_proc_os = trim(string(summa_pr_os_dec,">>>,>>>,>>9.99")).

   end.


/* расчет сумм полного движения и пролонгации */
if fir eq yes then
  do:
  summa_full = trim(string(di-sum,"->>>,>>>,>>>,>>9.99")).
  summa_prol = "0.00".
  end.
else 
  do:
  summa_full = "0.00".
  summa_prol = trim(string(di-sum,"->>>,>>>,>>>,>>9.99")).
  end.


/* если есть ключи */
test_key = "TEST KEY:                " + "ON " + date_sd + " "+ summa.


form
with frame browse.


{setdest.i}
    display
        "TO:" name_plat  format "x(50)" at 11 skip
              adr_plat   format "x(50)" at 11 skip(1)
        "FROM:     PROMINVESTRASCHET" skip
        "          MOSCOW,RUSSIA" skip(1)       
              
        "ATTN:DEALING DEPARTMENT AND BACK OFFICE" skip(3)
        "DATE:" date_sd skip(2)
        if GetXAttrValueEx("banks",string(banks.bank-id),"telex-key","") eq "Да" 
        then test_key else "" format "x(60)" skip(1)
        "REFERENCE:" refer format "x(30)" skip
        "WE CONFIRM LENDING FUNDS IN DEPOSIT WITH YOU" skip
        "CURRENCY:" valuta at 19 skip
        "PRINCIPAL AMOUNT:"  summa format "x(30)" at 19 skip
        "INTEREST RATE:"  proc format "x(5)" at 19 "PCT" skip
        "INTEREST AMOUNT:" summa_proc format "x(30)" at 19 skip
        "TRADE DATE:"    if fir eq yes then string(loan-cond.since,"99.99.9999") 
        								 else string(loan-cond.since - 1,"99.99.9999") format "x(10)"  at 19 skip
        "VALUE DATE:"    if fir eq yes then string(loan-cond.since,"99.99.9999") 
        							   else string(loan-cond.since - 1,"99.99.9999") format "x(10)"  at 19 skip
        "MATURITY DATE:" date_mat format "x(10)"  at 19 skip
        "FULL MOVEMENT:" summa_full format "x(30)" at 19 skip
        "WHITHOUT MOVEMENT:" summa_prol format "x(30)" at 19 skip
        "ARRANGED BY:      PHONE" skip
        "OUR PAYMENT:" skip
        "         ACCORDING YOUR INSRUCTIONS" skip(2)
        "YOUR PAYMENT:" skip
        "         /30101810500000000491" skip
        "               WITH PROMINVESTRASCHET, MOSCOW" skip
        "               BIC"FGetSetting("БанкМФО",?,"") format "x(9)" ", INN" at 29 
                            FGetSetting("ИНН",?,"") format "x(10)" "," at 45 skip
        "               ACC" acc_1 format "x(20)" "," at 40 skip
        "               INT ACC" if perehod eq yes then int_3 + " RUB " + summa_proc_nach else int_2 format "x(40)" skip 
        "                  " if perehod eq yes then "ACC " + int_2 + " RUB " + summa_proc_os else "" format "x(40)" skip(1) 
/*        "               INT ACC" if perehod eq no then int_2 else "" format "x(20)" skip(1) */
        "IN CASE OF ANY DISCREPANCY PLEASE DO NOT HESITATE TO CONTACT US" skip(1)
        "BEST REGARDS," skip
        "PROMINVESTRASCHET" skip
        "+7 (495) 755 61 41" skip                    
               
    with NO-LABELS NO-UNDERLINE
            .


{preview.i}

MESSAGE
				"Экспортировать данные?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE continue-ok AS LOGICAL .

IF continue-ok THEN
DO:
  OUTPUT TO VALUE(out_file_name).
   display
    with NO-LABELS NO-UNDERLINE
   .
  OUTPUT CLOSE.
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
END.
