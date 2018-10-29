/*здесь буду разрабатывать функцию для определения взаимосвязанных клиентов.
функция в результате должна стать доработанным аналогом функции в программе АНАЛИЗ*/

{bislogin.i}
{globals.i}
{getdate.i}
{intrface.get xclass}

/*DEF INPUT PARAM iend-date AS DATE NO-UNDO.*/
/*end-date = iend-date.          */

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var varNames AS CHAR.

def var iInn as DECIMAL NO-UNDO.
DEF VAR count AS INT INIT 0 NO-UNDO.
DEF VAR ic AS INT NO-UNDO.
DEF VAR icz AS INT NO-UNDO.
DEF VAR flag AS CHAR NO-UNDO.
DEF VAR tproc AS DECIMAL NO-UNDO.
DEF VAR tstr AS CHAR NO-UNDO.
DEF VAR toblsurr AS CHAR NO-UNDO.
DEF VAR cName AS CHAR NO-UNDO.
DEF VAR zName AS CHAR NO-UNDO.
DEF VAR filepath AS CHAR NO-UNDO.

DEF VAR GID_COUNT AS INT INIT 1001 NO-UNDO.

DEF TEMP-TABLE tClients NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field name       as char
	 field namefull   as char
         field FIORuk     as char
         field ucredOrg   as char 
         field SostavIKO  as char
         field SovDir     as char
	 field Rodstv	  as char
         field inn        as char 
         field dbirth     as char
         field GVK        as char 
	 field GIDiskl	  as int
	 field UNK	  as int
         field GID        as int
         INDEX iName name
         INDEX idxinn name inn.

DEF TEMP-TABLE TUcred NO-UNDO
         field cust-cat   as char
         field cust-id    as char
         field name       as char
	 field namefull   as char
	 field proc	  as char
	 field Rodstv	  as char
         field ucredOrg   as char 
         field FIORuk     as char
	 field GVK        as char 
         field GID        as int.

def buffer bTClients for tClients.
def buffer bTUcred for TUcred.

PROCEDURE CreateGroup.
DEF INPUT PARAM tattr AS CHAR NO-UNDO.
         IF tClients.GVK = "" and btClients.GVK <> "" THEN tClients.gid = btClients.gid.
         IF tClients.GVK <> "" and btClients.GVK = "" THEN bTClients.gid = tClients.gid.
         IF tClients.GVK = "" and btClients.GVK = "" THEN 
            DO:
               if tClients.gid = 0 and btClients.gid <> 0 THEN tClients.gid = btClients.gid.
               if tClients.gid <> 0 and btClients.gid = 0 THEN btClients.gid = tClients.gid.
               if tClients.gid < btClients.gid THEN btClients.gid = tClients.gid.
               if tClients.gid > btClients.gid THEN tClients.gid = btClients.gid.
               if tClients.gid = 0 and btClients.gid = 0  THEN 
                 DO:
                    GID_COUNT = GID_COUNT + 1.
                    tClients.gid = GID_COUNT.
		    btClients.gid = GID_COUNT.
                 END.
            END.       
CASE tattr:
	WHEN "fl" THEN UpdateTempSignsEx("person",STRING(bTClients.cust-id),"PIR-Group",end-date,STRING(bTClients.gid),NO).
	WHEN "flpor" THEN UpdateTempSignsEx("person",STRING(TClients.cust-id),"PIR-Group",end-date,STRING(TClients.gid),NO).
	WHEN "rod" THEN DO:
		UpdateTempSignsEx("person",STRING(TClients.cust-id),"PIR-Group",end-date,STRING(TClients.gid),NO).
		UpdateTempSignsEx("person",STRING(bTClients.cust-id),"PIR-Group",end-date,STRING(bTClients.gid),NO).
		END.
	WHEN "ruk" THEN DO:
		UpdateTempSignsEx("cust-corp",STRING(bTClients.cust-id),"PIR-Group",end-date,STRING(bTClients.gid),NO).
		UpdateTempSignsEx("person",STRING(TClients.cust-id),"PIR-Group",end-date,STRING(TClients.gid),NO).
		END.
	WHEN "ul" THEN DO:
		UpdateTempSignsEx("cust-corp",STRING(bTClients.cust-id),"PIR-Group",end-date,STRING(bTClients.gid),NO).	
		UpdateTempSignsEx("banks",STRING(bTClients.cust-id),"PIR-Group",end-date,STRING(bTClients.gid),NO).	
		END.
	WHEN "ulpor" THEN DO:
		UpdateTempSignsEx("cust-corp",STRING(TClients.cust-id),"PIR-Group",end-date,STRING(TClients.gid),NO).	
		UpdateTempSignsEx("banks",STRING(TClients.cust-id),"PIR-Group",end-date,STRING(TClients.gid),NO).	
		END.
END.
END PROCEDURE.

PROCEDURE CreateGroup2.
DEF INPUT PARAM tattr AS CHAR NO-UNDO.
DEF INPUT PARAM tid AS CHAR NO-UNDO.

         IF tClients.GVK = "" and tUcred.GVK <> "" THEN tClients.gid = tUcred.gid.
         IF tClients.GVK <> "" and tUcred.GVK = "" THEN tUcred.gid = tClients.gid.
         IF tClients.GVK = "" and tUcred.GVK = "" THEN 
            DO:
               if tClients.gid = 0 and tUcred.gid <> 0 THEN tClients.gid = tUcred.gid.
               if tClients.gid <> 0 and tUcred.gid = 0 THEN tUcred.gid = tClients.gid.
               if tClients.gid < tUcred.gid THEN tUcred.gid = tClients.gid.
               if tClients.gid > tUcred.gid THEN tClients.gid = tUcred.gid.
               if tClients.gid = 0 and tUcred.gid = 0  THEN 
                 DO:
                    GID_COUNT = GID_COUNT + 1.
                    tClients.gid = GID_COUNT.
		    tUcred.gid = GID_COUNT.
                 END.
            END.                                     	
CASE tattr:
	/*WHEN "fl" THEN UpdateTempSignsEx("person",STRING(tid),"PIR-Group",end-date,STRING(tUcred.gid),NO).*/
	/*WHEN "fl" THEN UpdateTempSignsEx("person",STRING(tid),"PIR-Group",end-date,STRING(tClients.gid),NO).*/
	/*WHEN "fl" THEN UpdateTempSignsEx("person",STRING(TClients.gid),"PIR-Group",end-date,STRING(tUcred.gid),NO).*/
	WHEN "fl" THEN UpdateTempSignsEx("person",STRING(tid),"PIR-Group",end-date,STRING(tUcred.gid),NO).
	WHEN "ul" THEN DO:
		UpdateTempSignsEx("cust-corp",STRING(tid),"PIR-Group",end-date,STRING(tUcred.gid),NO).	
		UpdateTempSignsEx("banks",STRING(tid),"PIR-Group",end-date,STRING(tUcred.gid),NO).
		END.
END.
END PROCEDURE.

FUNCTION CheckShare RETURNS CHAR (INPUT tempstr AS CHAR):
DEF VAR i AS INTEGER NO-UNDO.
tproc = 0.
CASE NUM-ENTRIES(tempstr,":"):
	WHEN 1 THEN DO:
		tproc = 1 / NUM-ENTRIES(TClients.ucredOrg,";") * 100.
		RETURN ENTRY(1,tempstr,":").
		END.
	WHEN 2 THEN DO:
		ENTRY(2,tempstr,":") = REPLACE(ENTRY(2,tempstr,":"),",",".").
		tproc = decimal(TRIM(REPLACE(ENTRY(2,tempstr,":"),"%",""))) NO-ERROR.
		RETURN ENTRY(1,tempstr,":").
		END.
	WHEN 3 THEN DO:
		ENTRY(3,tempstr,":") = REPLACE(ENTRY(3,tempstr,":"),",",".").
		tproc = decimal(TRIM(REPLACE(ENTRY(3,tempstr,":"),"%",""))) NO-ERROR.
		/*MESSAGE tempstr VIEW-AS ALERT-BOX.*/
		/*IF TClients.name = ENTRY(1,tempstr,";") THEN RETURN ENTRY(2,tempstr,":").
			ELSE RETURN ENTRY(1,tempstr,":").*/
		IF ENTRY(2,tempstr,":") <> "" THEN RETURN ENTRY(2,tempstr,":").
			ELSE RETURN ENTRY(1,tempstr,":").
		END.
END.
END FUNCTION.

FUNCTION GetName RETURNS CHAR:
   DEF VAR vRes AS CHAR INIT "" NO-UNDO.
   DEF VAR TempNames AS CHAR INIT "" NO-UNDO.   	
   DEF VAR cElement AS CHAR INIT "" NO-UNDO.
   DEF VAR i AS INT INIT 0 NO-UNDO.
   find first person where person.person-id = tClients.cust-id NO-LOCK NO-ERROR.

   do i = 1 to NUM-ENTRIES(TRIM(person.first-names)," "):
	cElement = ENTRY(i,person.first-names," ").
	TempNames = TempNames + " " + SUBSTRING(cElement,1,1).
   end.

   vRes = person.name-last + " " + TempNames + "," + person.name-last + " " + REPLACE(TempNames," ",".") + "," + person.name-last + " " + TRIM(REPLACE(TempNames," ",". ")).
   RETURN vRes.
END FUNCTION.

/*сначала запишем всех в темп-тейбл, нас интересуют только те клиенты, у которых есть хотя бы один не закрытый счет*/

FOR EACH person NO-LOCK,

    first acct where acct.cust-cat = "Ч" and acct.cust-id = person.person-id and (acct.close-date = ? or acct.close-date > end-date) and acct.open-date <= end-date NO-LOCK.
    count = count + 1.
    CREATE tClients.
    ASSIGN 
           tClients.cust-cat = "Ч"
           tClients.cust-id  = person.person-id
           tClients.name     = person.name-last + " " + person.first-names
	   tClients.namefull = person.name-last + " " + person.first-names
	   tClients.dbirth   = string(person.birthday)
           tClients.inn      = person.inn.

    tClients.GIDIskl	 =  INT(GetXAttrValueEx("person", STRING(person.person-id), "PIR-GroupIskl", "")).
    tClients.UNK	 =  INT(GetXAttrValueEx("person", STRING(person.person-id), "УНК", "")).
    tClients.GVK         =  GetTempXAttrValueEx("person", STRING(person.person-id), "ГВК", end-date, "").
    tClients.Rodstv      =  GetTempXAttrValueEx("person", STRING(person.person-id), "Родственники", end-date, "").
    UpdateTempSignsEx("person",STRING(TClients.cust-id),"PIR-Group",end-date,"0",NO).
    tClients.gid         =  IF REPLACE(tClients.GVK,"ГВК","") = "" THEN 0 ELSE INT(REPLACE(tClients.GVK,"ГВК","")).

    vLnTotalInt = vLnTotalInt + 1.

END.


FOR EACH cust-corp NO-LOCK,
    first acct where acct.cust-cat = "Ю" and acct.cust-id = cust-corp.cust-id and (acct.close-date = ? or acct.close-date > end-date) and acct.open-date <= end-date NO-LOCK.
    count = count + 1.

    CREATE tClients.
    ASSIGN 
           tClients.cust-cat = "Ю"
           tClients.cust-id  = cust-corp.cust-id
           tClients.name     = cust-corp.name-short
/*	   tClients.namefull = cust-corp.cust-stat + " " + cust-corp.name-corp*/
	   tClients.namefull = cust-corp.name-corp
           tClients.inn      = cust-corp.inn.

    tClients.FIORuk      =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ФИОрук", end-date, "").
    tClients.ucredOrg    =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УчредОрг", end-date, "").
    tClients.SostavIKO   =  GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СоставИКО", "").
    tClients.SovDir      =  GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ИсполнОрган", "").
    tClients.dbirth      =  string(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", "")).
    tClients.GIDIskl	 =  INT(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "PIR-GroupIskl", "")).
    tClients.UNK	 =  INT(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УНК", "")).
    tClients.GVK         =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ГВК", end-date, "").
    UpdateTempSignsEx("cust-corp",STRING(TClients.cust-id),"PIR-Group",end-date,"0",NO).
    tClients.gid         =  IF REPLACE(tClients.GVK,"ГВК","") = "" THEN 0 ELSE INT(REPLACE(tClients.GVK,"ГВК","")).

    vLnTotalInt = vLnTotalInt + 1.

END.

FOR EACH banks NO-LOCK,
    first acct  where acct.cust-cat = "Б" and acct.cust-id = banks.bank-id and (acct.close-date = ? or acct.close-date > end-date) and acct.open-date <= end-date NO-LOCK.
    count = count + 1.

    CREATE tClients.
    ASSIGN 
           tClients.cust-cat = "Б"
           tClients.cust-id  = banks.bank-id
           tClients.name     = banks.short-name
           tClients.namefull = banks.name
           tClients.inn      = banks.inn.

    tClients.FIORuk      =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "ФИОрук", end-date, "").
    tClients.ucredOrg    =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "УчредОрг", end-date, "").
    tClients.SostavIKO   =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "СоставИКО", end-date, "").
    tClients.SovDir      =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "ИсполнОрган", end-date, "").
    tClients.GVK         =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "ГВК", end-date, "").
    UpdateTempSignsEx("banks",STRING(TClients.cust-id),"PIR-Group",end-date,"0",NO).
    tClients.gid         =  IF REPLACE(tClients.GVK,"ГВК","") = "" THEN 0 ELSE INT(REPLACE(tClients.GVK,"ГВК","")).

    vLnTotalInt = vLnTotalInt + 1.

END.

vLnTotalInt = vLnTotalInt * 6.

FOR EACH tClients where tClients.name <> "" and TClients.ucredOrg <> ?
and (TClients.cust-cat = "Ю" or TClients.cust-cat = "Б") and TClients.ucredOrg <> "" and TClients.ucredOrg <> "?":

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

    DO ic = 1 TO NUM-ENTRIES(TClients.ucredOrg,";"):
	tstr = TRIM(ENTRY(ic,TClients.ucredOrg,";")).
	cName = TRIM(CheckShare(tstr)).
    	IF cName <> ? and cName <> "" THEN DO:
		FIND FIRST TUcred WHERE TUcred.name = cName NO-ERROR.
		IF AVAILABLE TUcred THEN DO:
			ASSIGN TUcred.cust-id = TUcred.cust-id + "," + STRING(TClients.cust-id).
			ASSIGN TUcred.proc = TUcred.proc + "," + STRING(INT(tproc)).
			END.
		ELSE DO: 
		CREATE TUcred.
		ASSIGN TUcred.name = cName.
		ASSIGN TUcred.cust-id = STRING(TClients.cust-id).
		ASSIGN TUcred.cust-cat = STRING(TClients.cust-cat).
		ASSIGN TUcred.proc = STRING(INT(tproc)).
		/*ASSIGN TUcred.gid = TClients.gid.
		ASSIGN TUcred.GVK = TClients.GVK.*/
		END.
	END.
	END.

    vLnCountInt = vLnCountInt + 1.    

END.

OS-COMMAND silent VALUE("mkdir -p -m 777 /home2/bis/quit41d/imp-exp/gvk/" + STRING(year(end-date),'9999') + "/" +  STRING(month(end-date),'99') + "/" + STRING(day(end-date),'99') + "/logs/").

filepath = "/home2/bis/quit41d/imp-exp/gvk/" + STRING(year(end-date),'9999') + chr(47) + STRING(month(end-date),'99') + chr(47) + STRING(day(end-date),'99') + chr(47) + "logs/".

OUTPUT TO VALUE(filepath + "ptclients.txt").
for each TUcred by TUcred.name:
	/* отбор всех учредителей и связанных с ними контор */
	DO icz = 1 TO NUM-ENTRIES(TUcred.cust-id):
	FIND FIRST TClients WHERE (TClients.cust-cat = "Ю" or TClients.cust-cat = "Б") and TClients.cust-id = INT(ENTRY(icz,TUcred.cust-id))
		and TClients.cust-cat = TUcred.cust-cat NO-ERROR.
	IF AVAILABLE TClients THEN DO:
		IF INT(ENTRY(icz,TUcred.proc)) >= 20 THEN RUN CreateGroup2("ul",ENTRY(icz,TUcred.cust-id)).
		PUT UNFORMATTED TUcred.gid "/" TClients.gid CHR(9)  TUcred.name " В конторах: " TClients.name "(" TClients.cust-id ") В процентах: " STRING(ENTRY(icz,TUcred.proc)) SKIP.
		END.
	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor.txt"). /* Учредитель является клиентом банка */
FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
	/* совпадение наим-я учредителя и клиента банка */ 
	FOR EACH TUcred WHERE TUcred.name = TClients.name:
	DO icz = 1 TO NUM-ENTRIES(TUcred.cust-id):
		IF INT(ENTRY(icz,TUcred.proc)) >= 20 THEN DO:
		RUN CreateGroup2("fl",TClients.cust-id).
		PUT UNFORMATTED TClients.gid "/" TUcred.gid CHR(9) CHR(9) TUcred.name CHR(9) "учредитель=клиент ID=" TClients.cust-id SKIP.
		END.
	END.
	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor1.txt"). /* Клиент-ФЛ-учредитель с долей более 20% является руководителем другого ЮЛ */
FOR EACH TClients WHERE TClients.cust-cat = "Ю" or TClients.cust-cat = "Б" and TClients.FIORuk <> ? and TClients.FIORuk <> "":                       
	/* совпадение ФИО руков. и ФИО учред. с долей >= 20% */ 
	/*FOR EACH TUcred WHERE CAN-DO(TUcred.name,TClients.FIORuk):*/
	FOR EACH TUcred WHERE TClients.FIORuk = TUcred.name:
	zName = TClients.name.
	DO icz = 1 TO NUM-ENTRIES(TUcred.cust-id):
		IF INT(ENTRY(icz,TUcred.proc)) >= 20 and INT(ENTRY(icz,TUcred.proc)) <> TClients.cust-id and zName <> "" THEN DO:
			RUN CreateGroup2("ul",ENTRY(icz,TUcred.cust-id)).
			RUN CreateGroup2("ul",TClients.cust-id).
			PUT UNFORMATTED	TClients.gid "/" TUcred.gid CHR(9) CHR(9) TUcred.name CHR(9) "учредитель (" ENTRY(icz,TUcred.proc) ") = ФИОРук в " TClients.name SKIP.
			zName = "".
			END.
	END.
	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor2.txt"). /* родственники клиента-ФЛ являются нашими клиентами или руководителями ЮЛ */
FOR EACH TClients WHERE TClients.cust-cat = "Ч" and TClients.Rodstv <> "" and TClients.Rodstv <> ?:                       
	/* отбор родственников учредителей и запуск поиска по ним */ 
	FOR EACH bTClients WHERE bTClients.name <> TClients.name:
	DO icz = 1 TO NUM-ENTRIES(TClients.Rodstv,";"):
		IF ENTRY(icz,TClients.Rodstv,";") <> "" and ENTRY(icz,TClients.Rodstv,";") = bTClients.FIORuk THEN DO:
			RUN CreateGroup("ul").
			PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) ENTRY(icz,TClients.Rodstv,";") CHR(9) "родственник у " TClients.name " = ФИОРук в " bTClients.name SKIP.
			END.
		IF ENTRY(icz,TClients.Rodstv,";") <> "" and ENTRY(icz,TClients.Rodstv,";") = bTClients.name THEN DO:
			RUN CreateGroup("rod").
			PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) ENTRY(icz,TClients.Rodstv,";") CHR(9) "родственник у " TClients.name " = наш клиент " bTClients.name SKIP.
			END.
	END.
	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor3.txt"). /* клиент-ФЛ связывается с клиентом-ИП или нотариусом */

FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
iInn = DECIMAL(TRIM(tclients.inn)) NO-ERROR.
IF tClients.inn <> "" and tClients.inn <> ? and tClients.inn <> "-" and iInn <> 0 THEN DO:
	for each bTClients where tClients.inn = btClients.inn and tClients.name <> btClients.name:
		RUN CreateGroup("ruk").
	        PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.name " = " tClients.inn " = " bTClients.name SKIP.
       		END.
  	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.

PUT UNFORMATTED "----------------------------------" SKIP.

FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
	for each bTClients where btClients.cust-cat = "Ю" and date(btClients.dbirth) = date(tClients.dbirth) and tClients.name = btClients.namefull:
		RUN CreateGroup("ruk").
	        PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.namefull " = " tClients.inn " = " bTClients.namefull SKIP.
       		END.
END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor4.txt"). /* клиент-ФЛ является руководителем ЮЛ */
FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
	for each bTClients where (bTClients.cust-cat = "Ю" or bTClients.cust-cat = "Б") and bTClients.FIORuk = TClients.name:
		RUN CreateGroup("ruk").
	        PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.name " руководитель в " bTClients.name SKIP.
		END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor5.txt"). /* клиент-ФЛ в Составе ИКО или Совете директоров, исполнит. органе ЮЛ */
FOR EACH TClients WHERE TClients.cust-cat = "Ч":                           
	for each bTClients where bTClients.cust-cat = "Ю" and bTClients.SostavIKO <> ? and bTClients.SostavIKO <> "" and bTClients.SostavIKO <> "нет":
		IF CAN-DO(CHR(42) + TClients.name + CHR(42),bTClients.SostavIKO)
			OR CAN-DO(CHR(42) + TClients.name + CHR(42),bTClients.SovDir) THEN DO:
			RUN CreateGroup("ul").
	        	PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.name " в составе ИКО: " bTClients.name SKIP.
			END.
	END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

OUTPUT TO VALUE(filepath + "ptclients-otbor6.txt"). /* поручительство */
FOR EACH TClients:                           
	for each loan where loan.contract = "Кредит" and loan.cust-cat = TClients.cust-cat
		and loan.open-date <= end-date
		and (loan.close-date = ? or loan.close-date > end-date)
		and loan.cust-id = TClients.cust-id NO-lock,
		each term-obl where term-obl.contract = loan.contract and term-obl.cont-code =
		loan.cont-code and term-obl.idnt = 5 and term-obl.end-date > end-date NO-LOCK.
		find first bTClients WHERE bTClients.cust-cat = term-obl.symbol AND bTClients.cust-id = term-obl.fop
			and bTClients.cust-id <> TClients.cust-id NO-LOCK NO-ERROR.
		toblsurr = term-obl.contract + "," + term-obl.cont-code + "," + string(term-obl.idnt) + "," + string(term-obl.end-date) + "," + string(term-obl.nn).
		IF AVAILABLE bTClients and GetXAttrValueEx("term-obl",toblsurr,"ВидДогОб","") BEGINS "КредГар" THEN DO:
			IF bTClients.cust-cat = "Ч" and TClients.cust-cat = "Ч" THEN DO:
				RUN CreateGroup("fl").
				RUN CreateGroup("flpor").
				END.
			IF bTClients.cust-cat = "Ч" and (TClients.cust-cat = "Ю" or TClients.cust-cat = "Б") THEN DO:
				RUN CreateGroup("fl").
				RUN CreateGroup("ulpor").
				END.
			IF (bTClients.cust-cat = "Ю" or bTClients.cust-cat = "Б") and TClients.cust-cat = "Ч" THEN DO:
				RUN CreateGroup("ul").
				RUN CreateGroup("flpor").
				END.
			IF (bTClients.cust-cat = "Ю" or bTClients.cust-cat = "Б") and (TClients.cust-cat = "Ю" or TClients.cust-cat = "Б") THEN DO:
				RUN CreateGroup("ulpor").
				RUN CreateGroup("ul").
				END.
			PUT UNFORMATTED TClients.namefull " является поручителем у: " term-obl.fop " " term-obl.symbol " / " bTClients.namefull " / " TClients.gid " / " bTClients.gid SKIP.
			toblsurr = "".
			END.
		end.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

/*
OUTPUT TO VALUE(filepath + "ptclients-otbor7.txt").
FOR EACH TClients WHERE TClients.name <> "" AND TClients.cust-cat = "Ю" AND TClients.FIORuk <> "" 
	AND TClients.UcredOrg <> "" AND TClients.gid <> 0:                           
	for each bTClients where bTClients.cust-cat = "Ю" and bTClients.name <> "" and bTClients.name <> TClients.name AND bTClients.gid = 0:
		/*RUN CreateGroup("ul").*/
	        IF tClients.FIORuk = bTClients.FIORuk and TClients.FIORuk <> "" THEN DO:
			RUN CreateGroup("ul").
			PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.name " = руков. = " bTClients.name CHR(9) bTClients.FIORuk " " bTClients.cust-id SKIP.
			END.
		IF tClients.UcredOrg = bTClients.UcredOrg and TClients.UcredOrg <> "" THEN DO:
			RUN CreateGroup("ul").
			PUT UNFORMATTED TClients.gid "/" bTClients.gid CHR(9) CHR(9) tClients.name " = учред. = " bTClients.name CHR(9) bTClients.UcredOrg SKIP.
			END.
	END.
END.
OUTPUT CLOSE.
*/

/* выкидываем однофамильцев */
FOR EACH TClients WHERE TClients.cust-cat = "Ч" AND TClients.GIDIskl = 1:
UpdateTempSignsEx("person",string(TClients.cust-id),"PIR-Group",end-date,"0",NO).
END.

FOR EACH TClients WHERE TClients.cust-cat = "Ю" AND TClients.GIDIskl = 1:
UpdateTempSignsEx("cust-corp",string(TClients.cust-id),"PIR-Group",end-date,"0",NO).
END.

/* подвязываем исключения */
FOR EACH TClients WHERE TClients.cust-cat = "Ч" AND TClients.GIDIskl > 1:
find first bTClients WHERE TClients.GIDIskl = bTClients.UNK.
if available bTClients THEN UpdateTempSignsEx("person",string(TClients.cust-id),"PIR-Group",end-date,string(bTClients.gid),NO).
END.

FOR EACH TClients WHERE TClients.cust-cat = "Ю" AND TClients.GIDIskl > 1:
find first bTClients WHERE TClients.GIDIskl = bTClients.UNK.
if available bTClients THEN UpdateTempSignsEx("cust-corp",string(TClients.cust-id),"PIR-Group",end-date,string(bTClients.gid),NO).
END.

IF Search("pir-tclients.r") <> ? then run value("pir-tclients.r").
	else RUN Value("pir-tclients.p").

{intrface.del}
