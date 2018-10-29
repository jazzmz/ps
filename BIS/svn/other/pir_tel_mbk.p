{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: 
      Comment: ����� �࠭��� ���.
   Parameters:
         Uses:
      Used by: 
      Created: 20/09/2001 Om
     Modified: 
*/

form "~n@(#) lcondfrm.p 1.0 Om 20/09/2001"
with frame sccs-id stream-io width 250.

/* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.

/* ���� ��ࠬ��� */
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
def var date_n     as char no-undo. /* ��� ��砫� */
def var date_mat   as char no-undo. /* ��� ������ */
def var proc       as char no-undo. /* ��業⭠� �⠢�� */
def var acc_1      as char no-undo. /* �᭮���� ��� */
def var int_2      as char no-undo. /* ��� �᭮���� ��業⮢ */
def var int_3      as char no-undo. /* ��� ���᫥���� ��業⮢ */
def var valuta     as char no-undo.    /* ����� ᤥ��� */
def var di-sum     as decimal no-undo. /* �㬬� ᤥ��� ��� ���⮢ */
def var summa      as char no-undo.    /* �㬬� ᤥ���  ��ப���� */
def var i          as int  no-undo.
def var summa_pr_dec      as decimal no-undo. /* �㬬� ��業⮢ */
def var summa_pr_os_dec   as decimal no-undo. /* �㬬� �᭮���� ��業⮢ */
def var summa_pr_nach_dec as decimal no-undo. /* �㬬� ���᫥���� ��業⮢ */
def var summa_proc        as char no-undo. /* �㬬� ��業⮢ */
def var summa_proc_os     as char no-undo. /* �㬬� �᭮���� ��業⮢ */
def var summa_proc_nach   as char no-undo. /* �㬬� ���᫥���� ��業⮢ */
def var period          as int  no-undo. /* ���-�� ���� */
def var period_os       as int  no-undo. /* ���-�� ���� ��� �᭮����*/
def var period_nach     as int  no-undo. /* ���-�� ����  ��� ���᫥����*/
def var summa_full as char no-undo. /*������ �������� */
def var summa_prol as char no-undo. /* �㬬� �஫����樨 */
def var test_key   as char no-undo.


def buffer l-cond#  for loan-cond.
def buffer cond for loan-cond.
/*
{mysh.i}
*/
{globals.i}
{svarloan.def}
{intrface.get date}
/* ���� ⥪�饣� �᫮��� */
find first loan-cond where
    recid (loan-cond) eq rid-t
no-lock no-error.

if not avail loan-cond
then return.

/* ���� �ॢ��� �᫮��� */
find first cond where cond.cont-code eq loan-cond.cont-code and
                      cond.since LT loan-cond.since
no-lock no-error.
if not avail cond then fir = yes. else fir = no.

/* ���� ������� */
find first loan where loan.cont-code eq loan-cond.cont-code
no-lock no-error.

/* ���� ������ */

find first banks where banks.bank-id eq loan.cust-id
no-lock no-error.

IF not avail banks then 
			do:
			MESSAGE "�������� ���� �� ��������!" skip
 							"��� ������ �� ���� ������."	
   		VIEW-AS ALERT-BOX.
      RETURN.
      end.

/* �������� ���⥫�騪� */
IF GetXAttrValueEx("banks",string(banks.bank-id),"engl-name","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"engl-name","") eq ? then
   		do:
   		MESSAGE "����������� ������᪮� �������� �����!" skip
 							"�������⥫�� ४����� engl-name �� ������."	
   		VIEW-AS ALERT-BOX.
      RETURN.
      end.
else  
name_plat  = CAPS(TRIM(GetXAttrValueEx("banks",
                         string(banks.bank-id),
                         "engl-name",""))) + ",".
                         
/* ���� ���⥫�騪� */
IF GetXAttrValueEx("banks",string(banks.bank-id),"telex-address","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"telex-address","") eq ? then
   		do:
   		MESSAGE "���������� ������᪨� ���� �����!" skip
 							"�������⥫�� ४����� telex-address �� ������ (��த,��࠭�)."	
   		VIEW-AS ALERT-BOX.
      RETURN.
      end.
else   
adr_plat  = CAPS(TRIM(GetXAttrValueEx("banks",
                         string(banks.bank-id),
                         "telex-address",""))) + ",".       
                                       
 /* telex ���⥫�騪� ��� ���㧪� ����� 䠩�� */ 
IF GetXAttrValueEx("banks",string(banks.bank-id),"telex-name","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"telex-name","") eq ? then
   		do:
   		MESSAGE "���������� TELEX �����!" skip
 							"�������⥫�� ४����� telex-name �� ������."	
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

/* ��� ᤥ��� */
if fir eq yes then
date_sd = string(year(loan-cond.since),"9999") + string(month(loan-cond.since),"99") + string(day(loan-cond.since),"99").
else
date_sd = string(year(loan-cond.since),"9999") + string(month(loan-cond.since),"99") + string(day(loan-cond.since - 1),"99").

/* ��७� */

refer = date_sd + "/" + substring(loan-cond.cont-code,6,3).
/*
refer = loan-cond.cont-code.
refer = sw-trans("�����",YES,"111111").
*/
/* ���  ������ */
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

/* ��� �᭮���� */
FIND last loan-acct where   loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "�।��" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then acc_1 = loan-acct.acct.



/* ��� �᭮���� ��業⮢ */
FIND last loan-acct where  loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "�।����" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then int_2 = loan-acct.acct.

/* ��� ���᫥���� ��業⮢ */
FIND last loan-acct where  loan-acct.cont-code eq loan-cond.cont-code and
														loan-acct.acct-type eq "�।�" and 
														loan-acct.since LE loan-cond.since
no-lock no-error.
if avail loan-acct then int_3 = loan-acct.acct.


/* ����� */
IF loan.currency eq "" then valuta = "RUB".
 else
  DO:
 	find currency where currency.currency eq loan.currency 
 	no-lock no-error.
 	IF avail currency then valuta = currency.i-currency.
 	END.

/* �㬬� */
FIND LAST term-obl {wh-t &f=term-obl &c="/*" }
      AND term-obl.idnt      = 2
      AND term-obl.end-date <= loan-cond.since NO-LOCK NO-ERROR.

IF NOT AVAILABLE term-obl THEN
   FIND FIRST term-obl {wh-t &f=term-obl &c="/*" }
          AND term-obl.idnt = 2
      NO-LOCK NO-ERROR.

di-sum = IF AVAILABLE term-obl THEN term-obl.amt ELSE ?.
  /* �᫨ �᫮��� ��᫥���� */
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


/* ���� ��業⭮� �⠢�� */
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

/* ���� �㬬� ��業⮢ */
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


/* ���� �㬬 ������� �������� � �஫����樨 */
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


/* �᫨ ���� ���� */
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
        if GetXAttrValueEx("banks",string(banks.bank-id),"telex-key","") eq "��" 
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
        "               BIC"FGetSetting("�������",?,"") format "x(9)" ", INN" at 29 
                            FGetSetting("���",?,"") format "x(10)" "," at 45 skip
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
				"��ᯮ��஢��� �����?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE continue-ok AS LOGICAL .

IF continue-ok THEN
DO:
  OUTPUT TO VALUE(out_file_name).
   display
    with NO-LABELS NO-UNDERLINE
   .
  OUTPUT CLOSE.
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "����� �ᯥ譮 �ᯮ��஢���!" VIEW-AS ALERT-BOX.
END.
