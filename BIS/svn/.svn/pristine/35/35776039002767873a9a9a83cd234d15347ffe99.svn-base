/*
Формирование отчета по клиентам с прописанным доп.реком PIR-Group
формата group.xls из Анализа.
*/

{bislogin.i}
{globals.i}
/*{getdate.i}*/

{pir-tclients.i}
{pir-groupxls.i}

{intrface.get xclass}

DEF VAR icnt AS INT NO-UNDO.
def var allRows AS int init 0 no-undo.
DEF VAR filepath AS CHAR NO-UNDO.

DEF TEMP-TABLE RtClients NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field name       as char
	 field namefull   as char
         field GVK        as char 
         field GID        as int
         INDEX iName name.

FOR EACH TClients WHERE TClients.gid <> ? and TClients.gid <> "":                       
CREATE RTClients.
	ASSIGN
         RTClients.cust-cat = TClients.cust-cat
         RTClients.cust-id  = TClients.cust-id
         RTClients.name     = TRIM(TClients.name)
	 RTClients.namefull = TRIM(TClients.namefull)
         RTClients.GVK      = TClients.GVK
         RTClients.GID      = INT(TClients.GID)
         allRows = allrows + 1.
END.

filepath = "/home2/bis/quit41d/imp-exp/gvk/" + STRING(year(end-date),'9999') + chr(47) + STRING(month(end-date),'99') + chr(47) + STRING(day(end-date),'99') + "/".

OUTPUT TO VALUE(filepath + "group.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP. 
FOR EACH RTClients WHERE RTClients.gid <> 0 AND RTClients.gid < 1000 BREAK BY RTClients.gid BY RTClients.name:
	IF FIRST-OF(RTClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(RTClients.gid)) SKIP.
		icnt = 1.
		END.
	PUT UNFORMATTED XLAddRow(STRING(RTClients.gid),icnt,RTClients.namefull,RTClients.GVK) SKIP.
	icnt = icnt + 1.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "group-razl.xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead(allRows) SKIP.
PUT UNFORMATTED XLTitle(end-date) SKIP. 
FOR EACH RTClients WHERE (RTClients.GVK <> "" and RTClients.gid = 0) or (RTClients.GVK = "" and RTClients.gid > 0 and RTClients.gid < 1000) 
	or (int(substring(RTClients.GVK,4,5)) <> RTClients.gid and RTClients.gid < 1000) BREAK BY RTClients.gid BY RTClients.name:
	IF FIRST-OF(RTClients.gid) THEN DO:
		PUT UNFORMATTED XLSubTitle(STRING(RTClients.gid)) SKIP.
		icnt = 1.
		END.
	PUT UNFORMATTED XLAddRow(STRING(RTClients.gid),icnt,RTClients.namefull,RTClients.GVK) SKIP.
	icnt = icnt + 1.
END.
PUT UNFORMATTED XLFoot() SKIP.
OUTPUT CLOSE.

/*
OUTPUT TO VALUE("0ids.txt"). /* поиск дублей с существ.клиентами */
FOR EACH RTClients WHERE RTClients.GVK = "ГВК15":
	PUT UNFORMATTED RTClients.name " с ID=" RTClients.cust-id SKIP.
END.
OUTPUT CLOSE.
*/

MESSAGE "Расчет связанных групп закончен, отчет group.xls сформирован." VIEW-AS ALERT-BOX.

{intrface.del}
