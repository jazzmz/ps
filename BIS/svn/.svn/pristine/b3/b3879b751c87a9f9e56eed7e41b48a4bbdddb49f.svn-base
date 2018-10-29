{bislogin.i}
{globals.i}
{getdate.i}
{ulib.i}
{pir_anketa.fun}
{intrface.get xclass}

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var varNames AS CHAR.

def var iInn as DECIMAL NO-UNDO.
DEF VAR count AS INT INIT 0 NO-UNDO.
DEF VAR icount AS INT INIT 1 NO-UNDO.

DEF VAR cT AS CHAR NO-UNDO.
DEF VAR cAdrReg AS CHAR NO-UNDO.
DEF VAR cAdrFact AS CHAR NO-UNDO.

DEF VAR GID_COUNT AS INT INIT 1001 NO-UNDO.

DEF TEMP-TABLE tClients NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field name       as char
	 field namefull   as char
         field inn        as char 
         field dbirth     as char
	 field passp	  as char
	 field addr       as char
	 field UNK	  as int
         INDEX iName name
         INDEX idxinn name inn.

def buffer bTClients for tClients.

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
	   tClients.passp    = person.document-id + " " + person.document + " выдан: " + person.issue
	   /*
	   tClients.addr     = (IF person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
		               (IF person.address[2] = ? THEN "" ELSE person.address[2]).
	   */
           tClients.inn      = person.inn.

    tClients.UNK	 =  INT(GetXAttrValueEx("person", STRING(person.person-id), "УНК", "")).

    vLnTotalInt = vLnTotalInt + 1.

      FIND FIRST cust-ident
         WHERE (cust-ident.cust-cat       EQ "Ч")
           AND (cust-ident.cust-id        EQ person.person-id)
           AND (cust-ident.cust-code-type EQ "АдрПроп")
           AND (cust-ident.class-code     EQ "p-cust-adr")
           AND (cust-ident.close-date     EQ ?)
         NO-ERROR.
      IF (AVAIL cust-ident)
      THEN DO:
         cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
            + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
         cAdrReg = Kladr(cT, cust-ident.issue).
      END.

      FIND FIRST cust-ident
         WHERE (cust-ident.cust-cat       EQ "Ч")
           AND (cust-ident.cust-id        EQ person.person-id)
           AND (cust-ident.cust-code-type EQ "АдрФакт")
           AND (cust-ident.class-code     EQ "p-cust-adr")
           AND (cust-ident.close-date     EQ ?)
         NO-ERROR.
      IF (AVAIL cust-ident)
      THEN DO:
         cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
            + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
         cAdrFact = Kladr(cT, cust-ident.issue).
      END.

	ASSIGN tClients.addr = IF (cAdrReg = cAdrFact) THEN cAdrReg ELSE (cAdrReg + " / " + cAdrFact).

END.


FOR EACH cust-corp NO-LOCK,
    first acct where acct.cust-cat = "Ю" and acct.cust-id = cust-corp.cust-id and (acct.close-date = ? or acct.close-date > end-date) and acct.open-date <= end-date NO-LOCK.
    count = count + 1.

    CREATE tClients.
    ASSIGN 
           tClients.cust-cat = "Ю"
           tClients.cust-id  = cust-corp.cust-id
           tClients.name     = cust-corp.name-short
	   tClients.namefull = cust-corp.name-corp
           tClients.inn      = cust-corp.inn.

    tClients.dbirth      =  string(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", "")).
    tClients.UNK	 =  INT(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УНК", "")).
    tClients.passp       =  string(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document-id", "")) + " "
			    + string(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document", "")) + " выдан: " 
			    + string(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "issue", "")). 

      FIND FIRST cust-ident
         WHERE (cust-ident.cust-cat       EQ "Ю")
           AND (cust-ident.cust-id        EQ cust-corp.cust-id)
           AND (cust-ident.cust-code-type EQ "АдрЮр")
           AND (cust-ident.class-code     EQ "p-cust-adr")
           AND (cust-ident.close-date     EQ ?)
         NO-ERROR.
      IF (AVAIL cust-ident)
      THEN DO:
         cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
            + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
         cAdrReg = Kladr(cT, cust-ident.issue).
      END.

      FIND FIRST cust-ident
         WHERE (cust-ident.cust-cat       EQ "Ю")
           AND (cust-ident.cust-id        EQ cust-corp.cust-id)
           AND (cust-ident.cust-code-type EQ "АдрФакт")
           AND (cust-ident.class-code     EQ "p-cust-adr")
           AND (cust-ident.close-date     EQ ?)
         NO-ERROR.
      IF (AVAIL cust-ident)
      THEN DO:
         cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
            + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
              + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
         cAdrFact = Kladr(cT, cust-ident.issue).
      END.

	ASSIGN tClients.addr = IF (cAdrReg = cAdrFact) THEN cAdrReg ELSE (cAdrReg + " / " + cAdrFact).

    vLnTotalInt = vLnTotalInt + 1.

END.

vLnTotalInt = vLnTotalInt * 1.6.

{setdest.i}

PUT UNFORMATTED "--- ПРОХОД ПО СОПОСТАВЛЕНИЮ ИНН ---" SKIP SKIP.

FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
iInn = DECIMAL(TRIM(tclients.inn)) NO-ERROR.
IF tClients.inn <> "" and tClients.inn <> ? and tClients.inn <> "-" and iInn <> 0 THEN DO:
	for each bTClients where tClients.inn = btClients.inn and tClients.name <> btClients.name:
	        PUT UNFORMATTED icount ") " tClients.name SKIP.
	        IF tClients.inn <> btClients.inn THEN PUT UNFORMATTED "ИНН ФЛ: " tClients.inn SKIP "ИНН ИП: " bTClients.inn SKIP.		
	        IF tClients.passp <> btClients.passp THEN PUT UNFORMATTED "ФЛ: " tClients.passp SKIP "ИП: " bTClients.passp SKIP.
		IF tClients.addr <> btClients.addr THEN PUT UNFORMATTED "ФЛ: " tClients.addr SKIP "ИП: " btClients.addr SKIP.
		PUT UNFORMATTED " " SKIP.
		icount = icount + 1.
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

PUT UNFORMATTED "--- ПРОХОД ПО СОПОСТАВЛЕНИЮ ДАТ РОЖДЕНИЯ ---" SKIP SKIP.

FOR EACH TClients WHERE TClients.cust-cat = "Ч":                       
	for each bTClients where btClients.cust-cat = "Ю" and date(btClients.dbirth) = date(tClients.dbirth) and tClients.name = btClients.namefull:
	        PUT UNFORMATTED icount ") " TClients.namefull SKIP.
	        IF tClients.inn <> btClients.inn THEN PUT UNFORMATTED "ИНН ФЛ: " tClients.inn SKIP "ИНН ИП: " bTClients.inn SKIP.		
	        IF tClients.passp <> btClients.passp THEN PUT UNFORMATTED "ФЛ: " tClients.passp SKIP "ИП: " bTClients.passp SKIP.
		IF tClients.addr <> btClients.addr THEN PUT UNFORMATTED "ФЛ: " tClients.addr SKIP "ИП: " btClients.addr SKIP.
		PUT UNFORMATTED " " SKIP.
		icount = icount + 1.
       		END.

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    vLnCountInt = vLnCountInt + 1.    

END.

{preview.i}
{intrface.del}