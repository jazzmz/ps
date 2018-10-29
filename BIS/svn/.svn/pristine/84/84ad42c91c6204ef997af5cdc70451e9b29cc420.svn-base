{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: exp_vip.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:20 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Процедура формирования окончательной выписки
Причина		    : Требование руководства
Параметры     : 
Автор         : $Author: anisimov $ 

----------------------------------------------------- */

{globals.i}
{sh-defs.i}
{get-bankname.i}

 
DEF TEMP-TABLE PrOp-entry NO-UNDO
   FIELD doc-date    AS DATE
   FIELD doc-num     AS CHAR
   FIELD acct        AS CHAR  
   FIELD name-kli    AS CHAR
   FIELD amt-rub     AS DECIMAL
   FIELD acct-ben    AS CHAR
   FIELD bank-code   AS CHAR   
   FIELD bank-name   AS CHAR  
   INDEX acct-idx acct doc-date.
.
DEF TEMP-TABLE OtOp-entry NO-UNDO
   FIELD doc-date    AS DATE
   FIELD doc-num     AS CHAR
   FIELD acct        AS CHAR  
   FIELD name-kli    AS CHAR
   FIELD amt-rub     AS DECIMAL
   FIELD acct-ben    AS CHAR
   FIELD bank-code   AS CHAR   
   FIELD bank-name   AS CHAR  
   INDEX acct-idx acct doc-date.
.
 
DEF VAR Clinm AS CHAR EXTENT 2 NO-UNDO.
DEF VAR vhod  as dec no-undo.
def var ishod as dec no-undo.
def var oborot-db as dec no-undo.
def var oborot-cr as dec no-undo.
def var n as int no-undo.
def var m as int no-undo.
def var num as int no-undo.
def var str as int no-undo.
def var name as char no-undo.
def var sp as char no-undo.
DEF VAR out_file_name AS CHAR. 
def var end-date as date no-undo.

find last op  where op.op-kind eq "i-ed101" and op.op-date LT today no-lock no-error.
/* end-date = today - 1. */
end-date = op.op-date.
out_file_name = "/home/bis/quit41d/imp-exp/doc/vipiska.bol" . 

FOR EACH op-entry WHERE op-entry.op-date eq end-date and
                        op-entry.acct-db eq "30102810900000000491"
                        no-lock,
                    
      FIRST op OF op-entry NO-LOCK,
      FIRST op-bank OF op   WHERE 
            op-bank.op-bank-type   EQ "" AND
            op-bank.bank-code-type EQ "МФО-9" no-lock,
     first banks-code where banks-code.bank-code eq op-bank.bank-code no-lock,
     first banks where banks.bank-id eq banks-code.bank-id use-index bank-id
            NO-LOCK:         

						FIND FIRST acct WHERE acct.acct EQ op-entry.acct-cr NO-LOCK NO-ERROR.
						{getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}
						clinm[1] = clinm[1] + " " + clinm[2].
						
	          CREATE PrOp-entry.
            ASSIGN PrOp-entry.doc-date  =  end-date
            			 PrOp-entry.doc-num   =  op.doc-num
            			 PrOp-entry.acct      =  op-entry.acct-cr
            			 PrOp-entry.name-kli  =  clinm[1]
            			 PrOp-entry.amt-rub   =  op-entry.amt-rub
            			 PrOp-entry.acct-ben  =  op.ben-acct 
            			 PrOp-entry.bank-code =  op-bank.bank-code
            			 PrOp-entry.bank-name =  banks.name
            			 
            .


END.

FOR EACH op-entry WHERE op-entry.op-date eq end-date and
                        op-entry.acct-cr eq "30102810900000000491"
                        no-lock,
                    
      FIRST op OF op-entry NO-LOCK,
      FIRST op-bank OF op   WHERE 
            op-bank.op-bank-type   EQ "" AND
            op-bank.bank-code-type EQ "МФО-9"  NO-LOCK,
      first banks-code where banks-code.bank-code eq op-bank.bank-code no-lock,
      first banks where banks.bank-id eq banks-code.bank-id use-index bank-id
            NO-LOCK:         

						FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db NO-LOCK NO-ERROR.
						{getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}
						clinm[1] = clinm[1] + " " + clinm[2].

            CREATE OtOp-entry.
            ASSIGN OtOp-entry.doc-date  =  beg-date
            			 OtOp-entry.doc-num   =  op.doc-num
            			 OtOp-entry.acct      =  op-entry.acct-db
            			 OtOp-entry.name-kli  =  clinm[1]
            			 OtOp-entry.amt-rub   =  op-entry.amt-rub
            			 OtOp-entry.acct-ben  =  op.ben-acct 
            			 OtOp-entry.bank-code =  op-bank.bank-code
            			 OtOp-entry.bank-name =  banks.name
            			 
            .


END.


run acct-pos in h_base ("30102810900000000491", "", end-date, end-date, "К").


{chkacces.i}
{setdest.i &cols=135}
OUTPUT TO VALUE(out_file_name).
str = 1.
num = 8.
put unformatted 
chr(27)"(3R"chr(27)"(s0p16.67h8.5v0s0b3T"chr(27)"&l6.5c"
"                                                      " + cBankName skip
"                                   Окончательная выписка по корреспондентскому счету за " string(end-date) skip
"___________________________________________________________________________________________________________________________________" skip
"  N      Расчетный счет                                                    Расчетный счет    БИК банка     Наименование банка" skip
"докум       клиента          Наименование клиента           СУММА          корреспондента     корресп.       корреспондента" skip
"___________________________________________________________________________________________________________________________________" skip
"___________________________________________________________________________________________________________________________________" skip
"1. ПЛАТЕЖНЫЕ ДОКУМЕНТЫ, СРЕДСТВА ПО КОТОРЫМ ЗАЧИСЛЕНЫ НА К/СЧ И Л/СЧ КЛИЕНТОВ" skip.


FOR EACH PrOp-entry by PrOp-entry.acct:
   
    {on-esc return}

  n = 45 - length(trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99"))). 
  name = substring(PrOp-entry.name-kli,1,n) .
  m = 46 - length(trim(name)) - length(trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99"))).
  name = name  +  fill(" ",m) + trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99")).
/* нумерация страниц */
	if num = 75 THEN
	DO:
	  str = str + 1.
	  num = 1.
	  put unformatted 
    chr(12) skip
    "-" at 65  string(str,">9") "-" at 69 skip(1)
    .
  END.
  
      DISPLAY 
        ""
        PrOp-entry.doc-num  format "x(3)"  	
        PrOp-entry.acct FORMAT "99999999999999999999"
        name format "x(46)"
        PrOp-entry.acct-ben FORMAT "99999999999999999999"
        PrOp-entry.bank-code format "x(9)"
        PrOp-entry.bank-name format "x(28)"
 
        WITH NO-LABELS NO-UNDERLINE WIDTH 135
        .

     ACCUMULATE PrOp-entry.amt-rub (TOTAL).
     ACCUMULATE PrOp-entry.doc-num (COUNT).
     num = num + 1.

END.


if num < 71 then num = num + 5. else num = 75.

PUT UNFORMATTED   
					 skip(1)
           "ПРИХОД: Количество документов:" +
           STRING(accum count PrOp-entry.doc-num,">>>9") + FILL(" ",10) +
           "на сумму:" + FILL(" ",3) +
           STRING(ACCUM TOTAL PrOp-entry.amt-rub,"-z,zzz,zzz,zz9.99") skip           
           " _____________________________________________________________________________________________________________________________" skip
           " 2. ПЛАТЕЖНЫЕ ДОКУМЕНТЫ, СРЕДСТВА ПО КОТОРЫМ СПИСАНЫ С К/СЧ И Л/СЧ КЛИЕНТОВ" skip

          .
          oborot-cr = ACCUM TOTAL PrOp-entry.amt-rub.
          
FOR EACH OtOp-entry by otOp-entry.acct:
   
{on-esc return}
  n = 45 - length(trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99"))). 
  name = substring(OtOp-entry.name-kli,1,n) .
  m = 46 - length(trim(name)) - length(trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99"))).
  name = name  +  fill(" ",m) + trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99")).

/* нумерация страниц */
	if num = 75 THEN
	DO:
	  str = str + 1.
	  num = 1.
	  put unformatted 
    chr(12) skip
    "-" at 65  string(str,">9") "-" at 69 skip(1)
    .
  END.


      DISPLAY 
        OtOp-entry.doc-num  format "x(3)"  	
        OtOp-entry.acct FORMAT "99999999999999999999"
        name format "x(46)"
        OtOp-entry.acct-ben FORMAT "99999999999999999999"
        OtOp-entry.bank-code format "x(9)"
        otOp-entry.bank-name format "x(28)"
        WITH NO-LABELS NO-UNDERLINE WIDTH 135
        .

     ACCUMULATE OtOp-entry.amt-rub (TOTAL).
     ACCUMULATE OtOp-entry.doc-num (COUNT).
		 num = num + 1.
		 
END.          
				oborot-db = ACCUM TOTAL OtOp-entry.amt-rub.
PUT UNFORMATTED   
					 skip(1)
           "РАСХОД: Количество документов:" +
           STRING(accum count OtOp-entry.doc-num,">>>9") + FILL(" ",10) +
           "на сумму:" + FILL(" ",3) +
           STRING(ACCUM TOTAL OtOp-entry.amt-rub,"-z,zzz,zzz,zz9.99") skip           
           "_____________________________________________________________________________________________________________________________" skip
           "==============================================================================================================================" skip
           "   ВХОДЯЩИЙ ОСТАТОК : " string(sh-in-bal,"-z,zzz,zzz,zz9.99") skip
           "   ПОСТУПИЛО НА СЧЕТ: " STRING(oborot-cr,"-z,zzz,zzz,zz9.99") skip
           "   СПИСАНО  СО СЧЕТА: " STRING(oborot-db,"-z,zzz,zzz,zz9.99") skip
           "   ИСХОДЯЩИЙ ОСТАТОК: " string(sh-bal,   "-z,zzz,zzz,zz9.99") skip
           "_______________________________________________________________________________________________________________________________" skip
           "_______________________________________________________________________________________________________________________________" skip
                     
            .          
   
  OUTPUT CLOSE.
  OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
