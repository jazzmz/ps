/* ------------------------------------------------------
Copyright: ООО КБ "Пpоминвестрасчет"
Что делает:    Производит экспорт данных в формате AFX для договора банковского счета
Параметры:     
Место запуска: Броузер счетов.
Изменения:
------------------------------------------------------ */

{globals.i}
{tmprecid.def} /** Используем информацию из броузера */
{intrface.get strng}
{intrface.get xclass}
{ulib.i}
{pir_anketa.fun}

/** Подпрограмма печати строки */
PROCEDURE OutStr:
   DEFINE  INPUT PARAMETER inStr AS CHARACTER.

   PUT UNFORMATTED StrToWin_ULL(inStr + CHR(13) + CHR(10)).
END PROCEDURE.

/**************************************************** */
/** Реализация */

DEF INPUT PARAM iParam AS CHAR.

DEFINE VARIABLE cOutFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKlNum    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDogLS    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTrAcct   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAllAcct  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cT        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDocum    AS CHARACTER NO-UNDO.

DEFINE BUFFER bTrAcct FOR acct.

IF (NUM-ENTRIES(iParam) LT 3)  /* Ф, Ю, ИП */
THEN DO:
   MESSAGE "ОШИБКА! Проверьте параметры процедуры!" VIEW-AS ALERT-BOX.
   RETURN.
END.

FOR FIRST tmprecid
   NO-LOCK,
   FIRST acct
      WHERE (RECID(acct)   EQ tmprecid.id)
      NO-LOCK:

   cDogLS = GetXAttrValue("acct", acct.acct + "," + acct.currency, "ДогОткрЛС").

   CASE acct.cust-cat:
      WHEN "Ю" THEN DO:
         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ acct.cust-id)
            NO-LOCK NO-ERROR.

         IF (AVAIL cust-corp)
         THEN DO:
            cKlNum = STRING(cust-corp.cust-id).

            IF    (cust-corp.cust-stat EQ "ИП")
               OR (cust-corp.cust-stat EQ "Адвокат")
               OR (cust-corp.cust-stat EQ "Нотариус")
            /* ======================================================================================= */
            THEN DO:
               OUTPUT TO VALUE(ENTRY(3,iParam)).

               RUN OutStr("<data>").
               RUN OutStr("<agreement>").
               RUN OutStr("no="     + ENTRY(2, cDogLS)).
               RUN OutStr("date="   + STRING(DATE(ENTRY(1, cDogLS)), "99.99.9999")).
               RUN OutStr("dsdate=" + STRING(TODAY, "99.99.9999")).
               RUN OutStr("acct="   + acct.acct).

               IF (SUBSTRING(acct.acct, 6, 3) EQ "810")
               THEN RUN OutStr("type=" + "RUR").
               ELSE DO:
                  RUN OutStr("type="   + "VAL").
                  RUN OutStr("number=" + SUBSTRING(acct.acct, 17, 4)).
                  RUN OutStr("val="    + SUBSTRING(acct.acct, 6, 3)).

                  cTrAcct = acct.acct.
                  SUBSTRING(cTrAcct,  9, 1) = ".".
                  SUBSTRING(cTrAcct, 14, 1) = "7".

                  FIND FIRST bTrAcct
                     WHERE (bTrAcct.cust-id EQ cust-corp.cust-id)
                       AND CAN-DO(cTrAcct, bTrAcct.acct)
                     NO-LOCK NO-ERROR.

                  IF (AVAIL bTrAcct)
                  THEN RUN OutStr("tracct=" + bTrAcct.acct).
               END.

               cAllAcct = "".
               FOR EACH bTrAcct
                  WHERE (bTrAcct.cust-id EQ cust-corp.cust-id)
                    AND CAN-DO("40802*", bTrAcct.acct)
                  NO-LOCK
                  BY bTrAcct.acct:

                  cAllAcct = cAllAcct + "," + bTrAcct.acct.
               END.
               RUN OutStr("allacct=" + TRIM(cAllAcct, ",")).

               RUN OutStr("</agreement>").
               RUN OutStr("<client>").
               RUN OutStr("status="    + GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat))).
               RUN OutStr("fio="       + cust-corp.name-corp).
/*
               RUN OutStr("address="   + Kladr(cust-corp.country-id + ","
                                       + GetXAttrValue("cust-corp", cKlNum, "КодРегГНИ"),
                                         cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2])).
*/
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
                  RUN OutStr("address=" + Kladr(cT, cust-ident.issue)).
               END.
               ELSE RUN OutStr("address=").

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
                  RUN OutStr("address2=" + Kladr(cT, cust-ident.issue)).
               END.
               ELSE RUN OutStr("address2=").

               RUN OutStr("document="  + GetCodeName("КодДокум", GetXAttrValue("cust-corp", cKlNum, "document-id"))
                                       + ", N " + GetXAttrValue("cust-corp", cKlNum, "document") + ", выдан "
                                       + STRING(DATE(GetXAttrValue("cust-corp", cKlNum, "Document4Date_vid")), "99.99.9999")
                                       + ", " + GetXAttrValue("cust-corp", cKlNum, "issue")).
               RUN OutStr("phone="     + GetXAttrValue("cust-corp", cKlNum, "tel")).
               RUN OutStr("birthday="  + STRING(DATE(GetXAttrValue("cust-corp", cKlNum, "BirthDay")), "99.99.9999")).
               RUN OutStr("inn="       + cust-corp.inn).
               RUN OutStr("ogrn="      + GetXAttrValue("cust-corp", cKlNum, "ОГРН")).
               RUN OutStr("</client>").
               RUN OutStr("</data>").
            END.
            /* ======================================================================================= */
            ELSE DO:
               OUTPUT TO VALUE(ENTRY(2,iParam)).

               RUN OutStr("<data>").
               RUN OutStr("<agreement>").
               RUN OutStr("number=" + ENTRY(2, cDogLS)).
               RUN OutStr("date="   + STRING(DATE(ENTRY(1, cDogLS)), "99.99.9999")).
               RUN OutStr("dsdate=" + STRING(TODAY, "99.99.9999")).
               RUN OutStr("acct="   + acct.acct).

               IF (SUBSTRING(acct.acct, 1, 5) EQ "40821")
               THEN RUN OutStr("type="    + "Агент").
               ELSE DO:
                  IF (SUBSTRING(acct.acct, 6, 3) EQ "810")
                  THEN RUN OutStr("type=" + "RUR").
                  ELSE DO:
                     RUN OutStr("type="   + "VAL").
                     RUN OutStr("number=" + SUBSTRING(acct.acct, 17, 4)).
                     RUN OutStr("val="    + SUBSTRING(acct.acct, 6, 3)).

                     cTrAcct = acct.acct.
                     SUBSTRING(cTrAcct,  9, 1) = ".".
                     SUBSTRING(cTrAcct, 14, 1) = "7".

                     FIND FIRST bTrAcct
                        WHERE (bTrAcct.cust-id EQ cust-corp.cust-id)
                          AND CAN-DO(cTrAcct, bTrAcct.acct)
                        NO-LOCK NO-ERROR.

                     IF (AVAIL bTrAcct)
                     THEN RUN OutStr("tracct=" + bTrAcct.acct).
                  END.

                  cAllAcct = "".
                  FOR EACH bTrAcct
                     WHERE (bTrAcct.cust-id EQ cust-corp.cust-id)
                       AND CAN-DO("4070.810*,4070.840.....2*,4070.978.....2*", bTrAcct.acct)
                     NO-LOCK
                     BY bTrAcct.acct:

                     cAllAcct = cAllAcct + "," + bTrAcct.acct.
                  END.
                  RUN OutStr("allacct=" + TRIM(cAllAcct, ",")).
               END.

               RUN OutStr("</agreement>").
               RUN OutStr("<client>").
               RUN OutStr("name="      + GetXAttrValue("cust-corp", cKlNum, "FullName")).
               RUN OutStr("short="     + cust-corp.name-short).
/*
               RUN OutStr("addressul=" + Kladr(cust-corp.country-id + ","
                                       + GetXAttrValue("cust-corp", cKlNum, "КодРегГНИ"),
                                         cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2])).
*/
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
                  cT = Kladr(cT, cust-ident.issue).
                  RUN OutStr("addressul=" + cT).
               END.
               ELSE RUN OutStr("addressul=").

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
                  cT = Kladr(cT, cust-ident.issue).
                  RUN OutStr("addressfact=" + cT).
               END.
               ELSE RUN OutStr("addressfact=").

               RUN OutStr("fioruk="    + GetXAttrValue("cust-corp", cKlNum, "ФИОрук")).
               RUN OutStr("post="      + GetXAttrValue("cust-corp", cKlNum, "ДолРук")).
               RUN OutStr("fiobuh="    + GetXAttrValue("cust-corp", cKlNum, "ФИОбухг")).
               RUN OutStr("inn="       + cust-corp.inn).
               RUN OutStr("kpp="       + GetXAttrValue("cust-corp", cKlNum, "КПП")).
               RUN OutStr("ogrn="      + GetXAttrValue("cust-corp", cKlNum, "ОГРН")).
               RUN OutStr("phone="     + GetXAttrValue("cust-corp", cKlNum, "tel")).
               RUN OutStr("</client>").
               RUN OutStr("</data>").
            END.
         END.
         ELSE DO:
            MESSAGE "NO cust-corp!" VIEW-AS ALERT-BOX.
            RETURN.
         END.
      END.
      /* ======================================================================================= */
      WHEN "Ч" THEN DO:
         FIND FIRST person
            WHERE (person.person-id EQ acct.cust-id)
            NO-LOCK NO-ERROR.

         IF AVAIL person
         THEN DO:
            cKlNum = STRING(person.person-id).

            OUTPUT TO VALUE(ENTRY(1,iParam)).

            RUN OutStr("<data>").
            RUN OutStr("<agreement>").
            RUN OutStr("no="       + ENTRY(2, cDogLS)).
            RUN OutStr("date="     + STRING(DATE(ENTRY(1, cDogLS)), "99.99.9999")).
            RUN OutStr("</agreement>").
            RUN OutStr("<acct>").
            RUN OutStr("acct="     + acct.acct).
            RUN OutStr("cur="      + (IF acct.currency = "" THEN "810" ELSE acct.currency)).
            RUN OutStr("</acct>").
            RUN OutStr("<client>").
            RUN OutStr("fio="      + person.name-last + " " + person.first-names).
            RUN OutStr("address="  + Kladr(person.country-id + ","
                                   + GetXAttrValue("person", cKlNum, "КодРегГНИ"),
                                     person.address[1] + person.address[2])).

/* 23.03.2012 Sitov S.A.: By letter Kapitanova */
/*            RUN OutStr("document=" + GetClientInfo_ULL("Ч," + cKlNum, "ident:Паспорт;ДокНерез;ЗагрПаспорт;ВремУдРФ;", false)).
*/
            FIND LAST cust-ident         
               WHERE cust-ident.cust-code-type = person.document-id
               AND (cust-ident.close-date EQ ? OR cust-ident.close-date >= gend-date) 
               AND cust-ident.class-code EQ 'p-cust-ident' 
               AND cust-ident.cust-cat = "Ч"
               AND cust-ident.cust-id = person.person-id
            NO-LOCK NO-ERROR.

            IF (AVAIL cust-ident)
            THEN DO:            
                  cDocum = GetXAttrValueEx("cust-ident", cust-ident.cust-code-type + "," + cust-ident.cust-code + ","  + STRING(cust-ident.cust-type-num),"Подразд", "").  
                  cDocum = GetCodeName("КодДокум", cust-ident.cust-code-type) + ": " 
	            	+ cust-ident.cust-code 
        	    	+ ". Выдан: " + REPLACE(REPLACE(cust-ident.issue, CHR(10), ""), CHR(13), "") + " "
            		+ cDocum + " " + STRING(cust-ident.open-date, "99.99.9999").
            END.
            ELSE	            
                  cDocum = "".
            RUN OutStr("document=" + cDocum ).

            RUN OutStr("phone="    + TRIM(person.phone[1] + "," + person.phone[2], ",")).
            RUN OutStr("birthday=" + STRING(person.birthday, "99/99/9999")).

/* 18.01.2012 Sitov S.A.: By letter Kapitanova fixed output AddrFakt */
/*            RUN OutStr("address2=" + DelDoubleChars(GetClientInfo_ULL("Ч," + cKlNum, "addr:АдрФакт", false), ",")).
*/
            FIND LAST cust-ident WHERE
                cust-ident.cust-code-type = "АдрФакт"
                AND (cust-ident.close-date EQ ? OR cust-ident.close-date >= gend-date) 
                AND cust-ident.class-code EQ 'p-cust-adr'
                AND cust-ident.cust-cat EQ 'Ч'
                AND cust-ident.cust-id EQ person.person-id
            NO-LOCK NO-ERROR.
            IF (AVAIL cust-ident)
              THEN 
                  cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                       + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                     + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                       + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
              ELSE
                  cT = "".
            RUN OutStr("address2="  + Kladr(cT,cust-ident.issue) ).
            RUN OutStr("</client>").
            RUN OutStr("</data>").
         END.
      END.
      OTHERWISE DO:
         
      END.
   END CASE.
END.

OUTPUT CLOSE.

MESSAGE "Данные экспортированы!"
   VIEW-AS ALERT-BOX.
