/*
Формирование темп-тейбла из счетов клиентов с прописанным доп.реком PIR-Group
для последующего формирования отчетов по взаимосвязанным клиентам.
*/

{sh-defs.i}
{pir-tclients.i}

DEF VAR ivAcctA AS CHAR NO-UNDO.
DEF VAR ivAcctP AS CHAR NO-UNDO.
DEF VAR ivAcct AS CHAR NO-UNDO.
DEF VAR izAcctA AS CHAR NO-UNDO.
DEF VAR izAcctP AS CHAR NO-UNDO.
DEF VAR izAcct AS CHAR NO-UNDO.
DEF VAR cCont-code AS CHAR NO-UNDO.
DEF VAR cCont-type AS CHAR NO-UNDO.
DEF VAR cCont-id AS INT INIT 0 NO-UNDO.
DEF VAR trisk AS CHAR NO-UNDO.
DEF VAR tempacct AS CHAR NO-UNDO.
DEF VAR taccttype AS CHAR NO-UNDO.
DEF VAR tsum AS DECIMAL NO-UNDO.
DEF VAR trsv AS DECIMAL NO-UNDO.
DEF VAR loansum AS DECIMAL NO-UNDO.

ivAcctA = "".
ivAcctP = "40*,41*,42*,30601*".
ivAcct = "438*,439*,47405*,47422*".

izAcctA = "47802*,90907*".
izAcctP = "47425*,91316*,91317*,91315*". /* 10000П,20000П,30000П */
izAcct = "450*,451*,452*,453*,454*,455*,456*,457*,458*".

DEF TEMP-TABLE tCacct NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field acct       as char
	 field amt-rub    as decimal
         field amt-val    as decimal.

DEF TEMP-TABLE tCacctZ NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field acct       as char
	 field amt-rub    as decimal
         field amt-val    as decimal
         field reserve    as decimal
	 field risk	  as decimal.

DEF TEMP-TABLE tgroup NO-UNDO
         field gid      as int
	 field incnt    as int
	 field sumgrp   as decimal
	 field sumgrpZR as decimal.

DEF BUFFER bloan-acct FOR loan-acct.
DEF BUFFER cloan-acct FOR loan-acct.
DEF BUFFER tloan-acct FOR loan-acct.

FUNCTION CalcPOSreserve RETURNS DECIMAL (INPUT iCont-id AS INT).
DEF VAR tresrv AS DECIMAL INIT 0 NO-UNDO.

FOR EACH loan WHERE loan.cont-code BEGINS ENTRY(1,loan-acct.cont-code," ")
	AND loan.contract = "Кредит"
	AND (loan.close-date = ? or loan.close-date > end-date) NO-LOCK,
LAST loan-var WHERE loan-var.cont-code = loan.cont-code
	AND loan-var.contract = "Кредит"
	AND loan-var.since <= end-date
	AND loan-var.amt-id = iCont-id.
IF AVAILABLE loan-var THEN /*DO:*/ tresrv = tresrv + ABS(loan-var.balance). /*MESSAGE loan.cont-code " / " acct.acct " / " tresrv VIEW-AS ALERT-BOX. END.*/
END.
RETURN tresrv.
END FUNCTION.

			                                                       /*Некрасова Наталья Николаевна Колосова Ольга Вячеславовна*/
FOR EACH TClients WHERE TClients.gid <> ? and TClients.gid <> "" /*AND TClients.name = "Пилип Марк Михайлович"*/:                       
	/* поиск по счетам вкладчиков */

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

	FOR EACH acct WHERE acct.cust-cat = TClients.cust-cat 
		AND acct.cust-id = TClients.cust-id
		AND (acct.close-date = ? or acct.close-date >= end-date)
		AND (CAN-DO(ivAcct,acct.acct) 
			or (acct.side = "А" and CAN-DO(ivAcctA,acct.acct)) 
			or (acct.side = "П" and CAN-DO(ivAcctP,acct.acct))) NO-LOCK:
		CREATE TCAcct.
		ASSIGN
	         TCAcct.cust-cat = TClients.cust-cat
        	 TCAcct.cust-id  = TClients.cust-id
		 TCAcct.acct = acct.acct.
		RUN acct-pos IN h_base(acct.acct,acct.currency,end-date,end-date,?).
        	 ASSIGN 
		  TCAcct.amt-rub  = ABS(sh-bal)
        	  TCAcct.amt-val  = ABS(sh-val)
		  TClients.sum-rub = TClients.sum-rub + ABS(sh-bal).
	END.

	FIND FIRST tgroup WHERE tgroup.gid = INT(TClients.gid) NO-ERROR.
	IF AVAILABLE tgroup THEN DO:
		ASSIGN
		 tgroup.incnt = tgroup.incnt + 1
		 tgroup.sumgrp = tgroup.sumgrp + TClients.sum-rub
		 tgroup.sumgrpZR = tgroup.sumgrpZR + TClients.sum-rubZR.
		END.
		ELSE DO:
		CREATE tgroup.
		ASSIGN 
		 tgroup.gid = INT(TClients.gid)
 		 tgroup.incnt = 1
		 tgroup.sumgrp = TClients.sum-rub
		 tgroup.sumgrpZR = TClients.sum-rubZR.	
		END.

    vLnCountInt = vLnCountInt + 1.    

END.

/* если в группе состоит 1 клиент, то переводим его в группу 0 */
FOR EACH TClients WHERE TClients.gid <> ? and TClients.gid <> "" and INT(TClients.gid) > 1000:
	FIND FIRST tgroup WHERE tgroup.gid = INT(TClients.gid) NO-ERROR.	
	IF AVAILABLE tgroup AND tgroup.incnt = 1 THEN TClients.gid = "0".
END.
/*
OUTPUT TO VALUE("group.txt").
FOR EACH tgroup by tgroup.gid:
PUT UNFORMATTED tgroup.gid " кол-во в группе: " tgroup.incnt SKIP.
END.
OUTPUT CLOSE.
*/