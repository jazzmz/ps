/*
Формирование отчетов по клиентам с прописанным доп.реком PIR-Group
вида S*.xls из Анализа.
*/

{bislogin.i}
{globals.i}
/*{getdate.i}*/

{pir-tcacctz.i}
{pir-szxls.i}

{intrface.get xclass}

DEF VAR icnt AS INT NO-UNDO.
def var allRows AS int init 0 no-undo.
DEF VAR filepath AS CHAR NO-UNDO.

DEF TEMP-TABLE RtClients NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field name       as char
	 field namefull   as char
         field GID        as int
	 field sumrub     as decimal init 0
         INDEX iName name.

FOR EACH TClients WHERE INT(TClients.gid) = 0:
allRows = allRows + 1.
END.
allRows = allRows * 10.

filepath = "/home2/bis/quit41d/imp-exp/gvk/" + STRING(year(end-date),'9999') + chr(47) + STRING(month(end-date),'99') + chr(47) + STRING(day(end-date),'99') + "/".

OUTPUT TO VALUE(filepath + "sng0_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle("крупным кредитам",end-date) SKIP. 
FOR EACH TClients WHERE INT(TClients.gid) = 0 AND TClients.sum-rubZR <> 0 BREAK BY TClients.gid BY TClients.sum-rubZR DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcctZ WHERE TCAcctZ.cust-id = TClients.cust-id 
		AND TCAcctZ.cust-cat = TClients.cust-cat 
		AND TCAcctZ.amt-rub <> 0
		BREAK BY TCAcctZ.cust-id /*BY TCAcctZ.amt-rub DESC*/:
		IF FIRST-OF(TCAcctZ.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcctZ.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,TCAcctZ.amt-rub,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,0,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
		IF LAST-OF(TCAcctZ.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rubZR) SKIP.
		END.
/*	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrpZR) SKIP.*/
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "sng1_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle("крупным кредитам",end-date) SKIP. 
FOR EACH TClients WHERE INT(TClients.gid) = 0 AND TClients.sum-rubZR = 0 BREAK BY TClients.gid BY TClients.sum-rubZR DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcctZ WHERE TCAcctZ.cust-id = TClients.cust-id 
		AND TCAcctZ.cust-cat = TClients.cust-cat 
		AND TCAcctZ.amt-rub <> 0
		BREAK BY TCAcctZ.cust-id /*BY TCAcctZ.amt-rub DESC*/:
		IF FIRST-OF(TCAcctZ.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcctZ.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,TCAcctZ.amt-rub,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,0,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
		IF LAST-OF(TCAcctZ.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rubZR) SKIP.
		END.
/*	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrpZR) SKIP.*/
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "svz0_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle("взаимосвязанным заемщикам",end-date) SKIP.
FOR EACH tgroup WHERE tgroup.gid > 0 /*and tgroup.incnt > 1*/ and tgroup.sumgrpZR <> 0 BY tgroup.sumgrpZR DESC:
FOR EACH TClients WHERE INT(TClients.gid) = tgroup.gid /*AND TClients.sum-rubZR <> 0*/ BREAK BY TClients.gid BY TClients.sum-rubZR DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcctZ WHERE TCAcctZ.cust-id = TClients.cust-id 
		AND TCAcctZ.cust-cat = TClients.cust-cat 
		AND TCAcctZ.amt-rub <> 0
		BREAK BY TCAcctZ.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcctZ.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcctZ.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,TCAcctZ.amt-rub,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,0,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
		IF LAST-OF(TCAcctZ.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rubZR) SKIP.
		END.
	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrpZR) SKIP.
END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "svz1_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle("взаимосвязанным заемщикам",end-date) SKIP.
FOR EACH tgroup WHERE tgroup.gid > 0 /*and tgroup.incnt > 1*/ and tgroup.sumgrpZR = 0 BY tgroup.sumgrpZR DESC:
FOR EACH TClients WHERE INT(TClients.gid) = tgroup.gid /*AND TClients.sum-rubZR = 0*/ BREAK BY TClients.gid BY TClients.sum-rubZR DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcctZ WHERE TCAcctZ.cust-id = TClients.cust-id 
		AND TCAcctZ.cust-cat = TClients.cust-cat 
		AND TCAcctZ.amt-rub <> 0
		BREAK BY TCAcctZ.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcctZ.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcctZ.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,TCAcctZ.amt-rub,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcctZ.acct,0,TCAcctZ.amt-val,TCAcctZ.amt-rub,(TCAcctZ.amt-rub - TCAcctZ.reserve) * TCAcctZ.risk) SKIP.
		IF LAST-OF(TCAcctZ.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rubZR) SKIP.
		END.
	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrpZR) SKIP.
END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

{intrface.del}
