/*
Формирование отчетов по клиентам с прописанным доп.реком PIR-Group
вида S*.xls из Анализа.
*/

{bislogin.i}
{globals.i}
/*{getdate.i}*/

{pir-tcacct.i}
{pir-sxls.i}

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

/*
OUTPUT TO VALUE("vklad.txt").
FOR EACH TClients WHERE INT(TClients.gid) = 0 BREAK BY TClients.gid BY TClients.sum-rub DESC:
FOR EACH TCAcct WHERE TCAcct.cust-id = TClients.cust-id AND TCAcct.cust-cat = TClients.cust-cat BREAK BY TCAcct.cust-id BY TCAcct.amt-rub DESC:
	IF FIRST-OF(TCAcct.cust-id) THEN PUT UNFORMATTED TClients.gid CHR(9) TRIM(TClients.namefull) " " TClients.sum-rub SKIP.
	PUT UNFORMATTED TCAcct.cust-id "  /  " TCAcct.acct "  /  " TCAcct.amt-rub "  /  " TCAcct.amt-val SKIP.
	allRows = allRows + 1.
	END.
END.
OUTPUT CLOSE.
*/

filepath = "/home2/bis/quit41d/imp-exp/gvk/" + STRING(year(end-date),'9999') + chr(47) + STRING(month(end-date),'99') + chr(47) + STRING(day(end-date),'99') + "/".

OUTPUT TO VALUE(filepath + "svg0_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP. 
FOR EACH TClients WHERE INT(TClients.gid) = 0 AND TClients.sum-rub <> 0 BREAK BY TClients.gid BY TClients.sum-rub DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcct WHERE TCAcct.cust-id = TClients.cust-id 
		AND TCAcct.cust-cat = TClients.cust-cat 
		AND TCAcct.amt-rub <> 0
		BREAK BY TCAcct.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcct.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcct.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,TCAcct.amt-rub,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,0,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
		IF LAST-OF(TCAcct.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rub) SKIP.
		END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "svg1_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP. 
FOR EACH TClients WHERE INT(TClients.gid) = 0 AND TClients.sum-rub = 0 BREAK BY TClients.gid BY TClients.sum-rub DESC:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcct WHERE TCAcct.cust-id = TClients.cust-id 
		AND TCAcct.cust-cat = TClients.cust-cat 
		/*AND TCAcct.amt-rub <> 0*/
		BREAK BY TCAcct.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcct.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.    	
		IF SUBSTRING(TRIM(TCAcct.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,TCAcct.amt-rub,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,0,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
		IF LAST-OF(TCAcct.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rub) SKIP.
		END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "svv0_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP.
FOR EACH tgroup WHERE tgroup.gid > 0 and tgroup.incnt > 1 and tgroup.sumgrp <> 0 BY tgroup.sumgrp DESC:
FOR EACH TClients WHERE INT(TClients.gid) = tgroup.gid BREAK BY TClients.gid /*BY TClients.sum-rub DESC*/:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcct WHERE TCAcct.cust-id = TClients.cust-id 
		AND TCAcct.cust-cat = TClients.cust-cat 
		AND TCAcct.amt-rub <> 0
		BREAK BY TCAcct.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcct.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcct.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,TCAcct.amt-rub,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,0,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
		IF LAST-OF(TCAcct.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rub) SKIP.
		END.
	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrp) SKIP.
END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "svv1_.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead0() SKIP.
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP. 
FOR EACH tgroup WHERE tgroup.gid > 0 and tgroup.incnt > 1 and tgroup.sumgrp = 0 BY tgroup.sumgrp DESC:
FOR EACH TClients WHERE INT(TClients.gid) = tgroup.gid BREAK BY TClients.gid /*BY TClients.sum-rub DESC*/:
	IF FIRST-OF(TClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(TClients.gid)) SKIP.
		icnt = 1.
		END.
	FOR EACH TCAcct WHERE TCAcct.cust-id = TClients.cust-id 
		AND TCAcct.cust-cat = TClients.cust-cat 
		/*AND TCAcct.amt-rub <> 0*/
		BREAK BY TCAcct.cust-id /*BY TCAcct.amt-rub DESC*/:
		IF FIRST-OF(TCAcct.cust-id) THEN DO:
			PUT UNFORMATTED XLAddClientRow(icnt,TClients.namefull,TClients.GVK,TClients.FIORuk,TClients.UcredOrg + TClients.Rodstv) SKIP.
			icnt = icnt + 1.
			END.
		IF SUBSTRING(TRIM(TCAcct.acct),6,3) = "810" THEN PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,TCAcct.amt-rub,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
			ELSE PUT UNFORMATTED XLAddAcctRow(TCAcct.acct,0,TCAcct.amt-val,TCAcct.amt-rub) SKIP.
		IF LAST-OF(TCAcct.cust-id) THEN PUT UNFORMATTED XLAddTotalByClient(TClients.sum-rub) SKIP.
		END.
	IF LAST-OF(TClients.gid) THEN PUT UNFORMATTED XLAddTotalByGroup(tgroup.sumgrp) SKIP.
END.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

{intrface.del}
