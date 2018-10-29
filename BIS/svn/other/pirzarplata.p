/* ------------------------------------------------------
Copyright: ООО КБ "Пpоминвестрасчет"
Что делает:    Производит экспорт данных в формате AFX для зарплатного договора 
Параметры:     Полный путь к файлу экспорта
Место запуска: Броузер договоров.
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

DEFINE VARIABLE cKlNum    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOPF      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKl       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFstAcct  AS CHARACTER NO-UNDO.
DEFINE VARIABLE daFirstOp AS DATE      NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE      NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAdrReg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAdrFact  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cT        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iT        AS INTEGER   NO-UNDO.
DEFINE BUFFER   lcard     FOR loan.
DEFINE BUFFER   card      FOR loan.
DEFINE BUFFER   lat       FOR cust-ident.

/** Задаем вывод в файл */
OUTPUT TO VALUE(iParam).

FOR FIRST tmprecid
   NO-LOCK,
   FIRST loan
      WHERE (RECID(loan)   EQ tmprecid.id)
        AND (loan.contract EQ "card-gr")
      NO-LOCK,
   FIRST cust-corp
      WHERE (cust-corp.cust-id EQ loan.cust-id)
      NO-LOCK:

   cKlNum = STRING(cust-corp.cust-id).

   RUN OutStr("<data>").

   RUN OutStr("<agreement>").
   RUN OutStr("date="   + STRING(loan.open-date, "99.99.9999")).
   RUN OutStr("number=" + loan.cont-code).
   RUN OutStr("proc="   + "").
   RUN OutStr("</agreement>").

   RUN OutStr("<client>").
/*   RUN OutStr("name="      + GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)) + " " + cust-corp.name-corp).
*/
   RUN OutStr("name="      + cust-corp.name-short).
   RUN OutStr("short="     + cust-corp.name-short).
   RUN OutStr("addressul=" + Kladr(cust-corp.country-id + ","
                           + GetXAttrValue("cust-corp", cKlNum, "КодРегГНИ"),
                             cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2])).
   RUN OutStr("fioruk="    + GetXAttrValue("cust-corp", cKlNum, "ФИОрук")).
   RUN OutStr("post="      + GetXAttrValue("cust-corp", cKlNum, "ДолРук")).
   RUN OutStr("fiobuh="    + GetXAttrValue("cust-corp", cKlNum, "ФИОбухг")).
   RUN OutStr("inn="       + cust-corp.inn).
   RUN OutStr("kpp="       + GetXAttrValue("cust-corp", cKlNum, "КПП")).
   RUN OutStr("ogrn="      + GetXAttrValue("cust-corp", cKlNum, "ОГРН")).
   RUN OutStr("phone="     + GetXAttrValue("cust-corp", cKlNum, "tel")).
   RUN OutStr("fax="       + cust-corp.fax).
   RUN OutStr("</client>").

   FOR EACH lcard
      WHERE (lcard.contract   EQ "card-pers")
        AND (lcard.cust-cat   EQ "Ч")
        AND (lcard.class-code EQ "card-loan-pers")
      NO-LOCK,
   FIRST card
      WHERE (card.contract         EQ "card")
        AND (card.parent-contract  EQ "card-pers")
        AND (card.parent-cont-code EQ lcard.cont-code)
      NO-LOCK,
   FIRST loan-acct
      WHERE (loan-acct.cont-code EQ lcard.cont-code)
        AND (loan-acct.contract  EQ 'card-pers')
        AND (loan-acct.currency  EQ lcard.currency)
        AND ((loan-acct.acct  BEGINS "40817")
          OR (loan-acct.acct  BEGINS "40820"))
      NO-LOCK,
   FIRST links
      WHERE (links.link-id    EQ 36)
        AND (links.source-id  EQ loan.contract  + ',' + loan.cont-code)
        AND (links.target-id  EQ lcard.contract + ',' + lcard.cont-code)
      NO-LOCK,
   FIRST person
      WHERE (person.person-id EQ lcard.cust-id)
      NO-LOCK:
/*
      FIND FIRST lat
         WHERE (lat.class-code EQ "tr-pers-ident")
           AND (lat.cust-cat   EQ "Ч")
           AND (lat.cust-id    EQ person.person-id)
           AND (lat.cust-code  BEGINS "UCS")
         NO-LOCK NO-ERROR.
*/
      cKlNum   = STRING(person.person-id).
      cAdrReg  = "".
      cAdrFact = "".

      RUN OutStr("<card>").

      RUN OutStr("familia="     + person.name-last).
      RUN OutStr("name="        + ENTRY(1, person.first-names, " ")).
      RUN OutStr("otchestvo="   + ENTRY(2, person.first-names, " ")).
/*
      RUN OutStr("namelat="     + ENTRY(3, lat.issue, CHR(4))).
      RUN OutStr("familialat="  + ENTRY(2, lat.issue, CHR(4))).
*/
      RUN OutStr("namelat="     + ENTRY(1, card.user-o[2], " ")).
      RUN OutStr("familialat="  + ENTRY(2, card.user-o[2], " ")).
      RUN OutStr("birthday="    + STRING(person.birthday, "99.99.9999")).
      RUN OutStr("birthplace="  + GetXAttrValue("person", cKlNum, "birthplace")).
      RUN OutStr("passdoc="     + GetCodeName("КодДокум", person.document-id)).
      RUN OutStr("passnum="     + person.document).
      cT = person.issue.
      iT = R-INDEX(cT, ",").
      RUN OutStr("passvydan="   + REPLACE(SUBSTRING(cT, 1, iT - 1), CHR(10) ,"" ) ).
      RUN OutStr("passkp="      + (IF  iT <> 0  THEN  REPLACE(SUBSTRING(cT, iT + 1), CHR(10) ,"" ) ELSE "" ) ).
      RUN OutStr("passdate="    + STRING(DATE(GetXAttrValue("person", cKlNum, "Document4Date_vid")), "99.99.9999")).

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
         RUN OutStr("addressreg=" + cAdrReg).
      END.
      ELSE RUN OutStr("addressreg=").

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
         RUN OutStr("addressfact=" + (IF (cAdrFact EQ cAdrReg) THEN "" ELSE cAdrFact)).
      END.
      ELSE RUN OutStr("addressfact=").

      RUN OutStr("sex="         + (IF person.gender THEN "мужской" ELSE "женский")).
      RUN OutStr("tel="         + ENTRY(1, person.phone[1])).
      cT = person.phone[2].
      RUN OutStr("mob="         + (IF (NUM-ENTRIES(cT) LT 2) THEN "" ELSE ENTRY(2, cT))).

      cT = GetXAttrValue("person", cKlNum, "country-id2").
      FIND FIRST country
         WHERE (country.country-id EQ cT)
         NO-LOCK NO-ERROR.

      RUN OutStr("resident="    + (IF (AVAIL country) THEN country.country-name ELSE "")).

      RUN OutStr("migrcard="    + "").
      RUN OutStr("cardtype="    + card.sec-code).
      RUN OutStr("cardcurr="    + card.currency).
      RUN OutStr("cardnum="     + card.doc-num).
      RUN OutStr("codeword="    + card.user-o[1]).
      RUN OutStr("acct810="     + loan-acct.acct).
      RUN OutStr("acctdate="    + STRING(loan-acct.since, "99.99.9999")).

      RUN OutStr("</card>").
   END.

   FOR LAST cust-role
      WHERE (cust-role.file-name  EQ "loan")
        AND (cust-role.surrogate  EQ loan.contract  + ',' + loan.cont-code)
        AND (cust-role.class-code EQ "Получатель")
      NO-LOCK,
   FIRST person
      WHERE (person.person-id     EQ INTEGER(cust-role.cust-id))
      NO-LOCK:

      cKlNum   = STRING(person.person-id).
      RUN OutStr("<attorney>").

      RUN OutStr("fio="         + person.name-last + " " + person.first-names).
      cT = person.issue.
      iT = R-INDEX(cT, ",").
      IF  iT <> 0  THEN  SUBSTRING(cT, iT, 1) = ", К/П " .
      RUN OutStr("pass="        + GetCodeName("КодДокум", person.document-id) + " N "
                                + person.document + ", выдан "
                                + STRING(DATE(GetXAttrValue("person", cKlNum, "Document4Date_vid")), "99.99.9999")
                                + " " + cT).

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
         RUN OutStr("addressreg=" + cAdrReg).
      END.
      ELSE RUN OutStr("addressreg=").

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
         RUN OutStr("addressfact=" + cAdrFact).
      END.
      ELSE RUN OutStr("addressfact=").

      RUN OutStr("tel="         + ENTRY(1, person.phone[1])).
      RUN OutStr("sex="         + (IF person.gender THEN "мужской" ELSE "женский")).

      RUN OutStr("</attorney>").
   END.

   RUN OutStr("</data>").
END.

OUTPUT CLOSE.

MESSAGE "Данные экспортированы!" VIEW-AS ALERT-BOX.
