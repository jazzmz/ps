
{pirsavelog.p}

/*
        Comment: ОЭД. Печать отчета об экспорта документов.
 	Modified: 26.07.11 SStepanov добавлена проверка на наличие счетов
		корреспондирующих с корсчетом и выдача ошибки при отсутствии
*/


{globals.i}
{sh-defs.i}
{getdate.i}

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
def var name as char no-undo.
def var sp as char no-undo.


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
	IF AVAIL acct THEN DO:
		{getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}
		clinm[1] = clinm[1] + " " + clinm[2].
	END.
	ELSE DO:
		MESSAGE COLOR ERROR
		  "Документ N" op.doc-num op-entry.acct-db op-entry.acct-cr op-entry.amt-rub SKIP
		  "отсутствует счет" op-entry.acct-cr
			VIEW-AS ALERT-BOX ERROR.
		clinm[1] = "".
	END.
						
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

	FIND FIRST acct
	  WHERE acct.acct EQ op-entry.acct-db
	  NO-LOCK NO-ERROR.
		IF AVAIL acct
		  THEN DO:
		{getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}
		clinm[1] = clinm[1] + " " + clinm[2].
	END.
	ELSE DO:
		MESSAGE COLOR ERROR
		  "Документ N" op.doc-num op-entry.acct-db op-entry.acct-cr op-entry.amt-rub SKIP
		  "отсутствует счет" op-entry.acct-db
			VIEW-AS ALERT-BOX ERROR.
		clinm[1] = "".
	END.

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


put unformatted  
"                                                    " + cBankName skip
"                                   Окончательная выписка по корреспондентскому счету за " string(end-date) skip
"___________________________________________________________________________________________________________________________________" skip
"  N      Расчетный счет                                                    Расчетный счет    БИК банка     Наименование банка" skip
"докум       клиента          Наименование клиента           СУММА          корреспондента     корресп.       корреспондента" skip
"___________________________________________________________________________________________________________________________________" skip
"___________________________________________________________________________________________________________________________________" skip
"1. ПЛАТЕЖНЫЕ ДОКУМЕНТЫ, СРЕДСТВА ПО КОТОРЫМ ЗАЧИСЛЕНЫ НА К/СЧ И Л/СЧ КЛИЕНТОВ" skip.


FOR EACH PrOp-entry by PrOp-entry.acct:
   
    {on-esc return}
/*
form header
"-" at 67 PAGE-NUMBER format "z9" to 70  "-" at 73 skip(1)
with WIDTH 135 no-box.
{chkpage 3}
  */  

  n = 46 - length(trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99"))). 
  name = substring(PrOp-entry.name-kli,1,n) .
  m = 47 - length(trim(name)) - length(trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99"))).
  name = name  +  fill(" ",m) + trim(string(PrOp-entry.amt-rub,"->>>,>>>,>>9.99")).


      DISPLAY 
        PrOp-entry.doc-num  format "x(3)"  	
        PrOp-entry.acct FORMAT "99999999999999999999"
        name format "x(47)"
        PrOp-entry.acct-ben FORMAT "99999999999999999999"
        PrOp-entry.bank-code format "x(9)"
        PrOp-entry.bank-name format "x(28)"
 
        WITH NO-LABELS NO-UNDERLINE WIDTH 135
        .

     ACCUMULATE PrOp-entry.amt-rub (TOTAL).
     ACCUMULATE PrOp-entry.doc-num (COUNT).

END.

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
  n = 46 - length(trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99"))). 
  name = substring(OtOp-entry.name-kli,1,n) .
  m = 47 - length(trim(name)) - length(trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99"))).
  name = name  +  fill(" ",m) + trim(string(OtOp-entry.amt-rub,"->>>,>>>,>>9.99")).

      DISPLAY 
        OtOp-entry.doc-num  format "x(3)"  	
        OtOp-entry.acct FORMAT "99999999999999999999"
        name format "x(47)"
        OtOp-entry.acct-ben FORMAT "99999999999999999999"
        OtOp-entry.bank-code format "x(9)"
        otOp-entry.bank-name format "x(28)"
        WITH NO-LABELS NO-UNDERLINE WIDTH 135
        .

     ACCUMULATE OtOp-entry.amt-rub (TOTAL).
     ACCUMULATE OtOp-entry.doc-num (COUNT).

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
          

{preview.i}
