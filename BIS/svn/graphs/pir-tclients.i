/*
Формирование темп-тейбла из клиентов с прописанным доп.реком PIR-Group
для последующего формирования отчетов по взаимосвязанным клиентам.
*/

DEF VAR count AS INT INIT 0 NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

DEF TEMP-TABLE tClients NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field name       as char
	 field namefull   as char
         field FIORuk     as char
         field ucredOrg   as char 
         field SostavIKO  as char
	 field Rodstv	  as char
         field GVK        as char 
         field GID        as char
	 field sum-rub    as decimal
	 field sum-rubZ   as decimal
	 field sum-rubZR  as decimal
         INDEX iName name.

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

    tClients.FIORuk      =  GetTempXAttrValueEx("person", STRING(person.person-id), "ФИОрук", end-date, "").
    tClients.ucredOrg    =  GetTempXAttrValueEx("person", STRING(person.person-id), "УчредОрг", end-date, "").
    tClients.SostavIKO   =  GetTempXAttrValueEx("person", STRING(person.person-id), "СоставИКО", end-date, "").
    tClients.Rodstv      =  GetTempXAttrValueEx("person", STRING(person.person-id), "Родственники", end-date, "").
    tClients.GVK         =  GetTempXAttrValueEx("person", STRING(person.person-id), "ГВК", end-date, "").
    tClients.gid         =  GetTempXAttrValueEx("person", STRING(person.person-id), "PIR-Group", end-date, "").

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
	   tClients.namefull = cust-corp.cust-stat + " " + cust-corp.name-corp

    tClients.FIORuk      =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ФИОрук", end-date, "").
    tClients.ucredOrg    =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УчредОрг", end-date, "").
    tClients.SostavIKO   =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СоставИКО", end-date, "").
    tClients.GVK         =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ГВК", end-date, "").
    tClients.gid         =  GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "PIR-Group", end-date, "").

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

    tClients.FIORuk      =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "ФИОрук", end-date, "").
    tClients.ucredOrg    =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "УчредОрг", end-date, "").
    tClients.SostavIKO   =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "СоставИКО", end-date, "").
    tClients.GVK         =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "ГВК", end-date, "").
    tClients.gid         =  GetTempXAttrValueEx("banks", STRING(banks.bank-id), "PIR-Group", end-date, "").

    vLnTotalInt = vLnTotalInt + 1.

END.