{pirsavelog.p}
/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir_anketa_pk.p
      Comment: Печать анкеты представителя по договору ПК (У11)
		Процедура создана на основе pir_anketa.p и специально выведена в отдельный файл
		Скорее всего это анкету больше использовать не будут
		Использует: pir_anketa.fun ,pir_anketa_pk.i
   Parameters: 
       Launch: БМ - Клиенты ФЛ - Связные субъекты - Ctrl+G - (ПИР) Анкета представителя по договору ПК (У11)
         Uses:
      Created: Sitov S.A., 13.07.2012
	Basis: Отдельное ТЗ и заявка #843 
     Modified:  
*/
/* ========================================================================= */


{globals.i}           /* Глобальные определения */
{tmprecid.def}        /* Используем информацию из броузера */
{wordwrap.def}        /* Будем использовать перенос по словам */
{parsin.def}
{intrface.get xclass} /* Функции для работы с метасхемой */
{intrface.get strng}  /* Функции для работы со строками */

{pir_anketa.fun}

/******************************************* Определение переменных и др. */

DEFINE INPUT PARAMETER iParam AS CHAR.

DEFINE VARIABLE cKl       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cVp       AS CHARACTER INIT ""           NO-UNDO.
DEFINE VARIABLE cUser     AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKladr    AS CHARACTER                   NO-UNDO.

DEFINE VARIABLE iKl       AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cKlNum    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlType   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlTabl   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlPoleL  AS CHARACTER EXTENT 1
	INIT [
   /* ФЛ П2 */    "70,71,72,73,74,75,76,5,18,19,24,25,27,41,42,44,46,47,61,62,65,66"
	]  NO-UNDO.

DEFINE VARIABLE cKlPole   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlP      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cP        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE iPI       AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cAnketa   AS CHARACTER                   NO-UNDO.

DEFINE VARIABLE iwwI      AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cPrLine   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE iLineW    AS INTEGER   INIT 80           NO-UNDO.

DEFINE VARIABLE cOPF      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmpS     AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmpS2    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE iTmpI     AS INTEGER                     NO-UNDO.
DEFINE VARIABLE daLast    AS DATE                        NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cUsrLast  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cFstAcct  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE daFirstOp AS DATE                        NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE                        NO-UNDO.

DEFINE VARIABLE iI        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cUserFIO  AS CHARACTER                   NO-UNDO.

DEFINE VARIABLE cPredWho_Name		AS CHARACTER	NO-UNDO.
DEFINE VARIABLE cPredWho_INN		AS CHARACTER	NO-UNDO.
DEFINE VARIABLE cPredWho_MainAcct	AS CHARACTER	NO-UNDO.
DEFINE VARIABLE cPredWho_MainAcctCur	AS CHARACTER	NO-UNDO.


/******************************************* Реализация */
/* NEW - params:
   1 = "Ч,Ю,Б,ВП,П"
   2 = cUser
   3 = cKladr              */

/** Разбор входного параметра */
cKl     = ENTRY(1, iParam). /* "Ч,Ю,Б,ВП,П,П2" */
cUser   = ENTRY(2, iParam). /*  */
cKladr  = ENTRY(3, iParam). /*  */

FIND FIRST tmprecid
   NO-ERROR.

CASE cKl:
   WHEN "П2" THEN DO:
      FIND FIRST cust-role
         WHERE (RECID(cust-role) EQ tmprecid.id)
         NO-ERROR.

      CASE cust-role.file-name:
         WHEN "cust-corp" THEN DO:
            FIND FIRST cust-corp
               WHERE (cust-corp.cust-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

		cPredWho_Name		= cust-corp.name-short.
		cPredWho_INN		= cust-corp.inn.
		cPredWho_MainAcct	= GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "acct-list").
         END.
         WHEN "person" THEN DO:
            FIND FIRST person
               WHERE (person.person-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

            cTmpS  = person.inn.

            cPredWho_Name	= person.first-names + " " + person.name-last.
            cPredWho_INN        = (IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS).
            cPredWho_MainAcct	= GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "acct-list").
         END.
      END CASE.

      cKlNum = cust-role.cust-id.

      IF (cust-role.cust-cat EQ "Ч")
      THEN DO:
         FIND FIRST person
            WHERE (person.person-id EQ INTEGER(cKlNum))
            NO-ERROR.
         cKl    = "ФЛ".
         iKl    = 1.
      END.
   END.
END CASE.

cKlType = KlType(cKl). /*  */
cKlTabl = KlTabl(cKl). /*  */
cKlPole = cKlPoleL[iKl].

{pir_anketa_pk.i}


RUN GetLastAnketaDate( /* cVp + */ cKl, INTEGER(cKlNum), OUTPUT daLast, OUTPUT cUsrLast).

/******************************************* Присвоение значений переменным и др. */

DO iPI = 1 TO NUM-ENTRIES(cKlPole):

   cP = ENTRY(iPI, cKlPole).

   CASE cP:

      WHEN "5" THEN DO:
         cKlP   = PrintStringInfo(
                  person.name-last + " " + person.first-names).
      END.

      WHEN "18" THEN DO:
         FIND FIRST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрПроп")
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND (cust-ident.close-date     EQ ?)
            NO-ERROR.
         IF (AVAIL cust-ident)
         THEN DO:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
            cKlP = PrintStringInfo(
                   IF (cKladr = "KLADR") THEN Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         END.
         ELSE cKlP = PrintStringInfo(?).
      END.
      WHEN "19" THEN DO:
         FIND FIRST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрФакт")
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND (cust-ident.close-date     EQ ?)
            NO-ERROR.
         IF (AVAIL cust-ident)
         THEN DO:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
            cKlP = PrintStringInfo(
                   IF (cKladr = "KLADR") THEN Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         END.
         ELSE cKlP = PrintStringInfo(?).
      END.

      WHEN "24" THEN DO:
         cKlP   = PrintStringInfo(
                  TRIM(TRIM(person.phone[1], ",") + " " + TRIM(person.phone[2], ","), ",")).
      END.
      WHEN "25" THEN DO:
         cKlP   = PrintStringInfo(
                  person.fax).
      END.

      WHEN "27" THEN DO:
         cTmpS  = person.inn.
         cKlP   = PrintStringInfo(
                  IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS).
      END.

      WHEN "41" THEN DO:
         cKlP   = PrintDateInfo(
                  person.birthday).
      END.
      WHEN "42" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "BirthPlace")).
      END.

      WHEN "44" THEN DO:
         cTmpS = GetXAttrValue(cKlTabl, cKlNum, "country-id2").
         FIND FIRST country
            WHERE (country.country-id EQ cTmpS)
            NO-LOCK NO-ERROR.
         cKlP   = PrintStringInfo(
                  IF (AVAIL country) THEN country.country-name ELSE ?).
      END.

      WHEN "46" THEN DO:
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.class-code     EQ "p-cust-ident")
              AND (cust-ident.cust-code-type EQ "Паспорт")
            NO-LOCK NO-ERROR.
         IF NOT (AVAIL cust-ident)
         THEN DO:
            FIND LAST cust-ident
               WHERE (cust-ident.cust-cat       EQ cKlType)
                 AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
                 AND (cust-ident.class-code     EQ "p-cust-ident")
               NO-LOCK NO-ERROR.
         END.

         IF (AVAIL cust-ident)
         THEN DO:
            cTmpS = cust-ident.cust-code-type + ','
                  + cust-ident.cust-code      + ','
                  + STRING(cust-ident.cust-type-num).
            cTmpS = GetXAttrValue("cust-ident", cTmpS, "Подразд").
            cKlP  = PrintStringInfo(
                    GetCodeName("КодДокум", cust-ident.cust-code-type)
                  + ", N " + cust-ident.cust-code
                  + ", выдан " + STRING(cust-ident.open-date, "99.99.9999")
                  + ", " + cust-ident.issue
                  + (IF (cTmpS EQ "") THEN "" ELSE (", К/П " + cTmpS))).
         END.
         ELSE cKlP = PrintStringInfo(?).
      END.
      WHEN "47" THEN DO:
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "МигрКарт").
         cTmpS2 = GetXAttrValue(cKlTabl, cKlNum, "VisaNum").

         IF ((cTmpS + cTmpS2) EQ "")
         THEN cKlP = ": " + PrintStringInfo("").
         ELSE DO:
            cKlP   = ". Номер миграционной карты: " + cTmpS
                   + "|      Данные документа, подтверждающего право на пребывание (проживание) в РФ|      Серия: "
                   + PrintStringInfo(ENTRY(1, cTmpS2, " "))
                   + "|      Номер документа: "
                   + IF (NUM-ENTRIES(cTmpS2, " ") > 1) THEN ENTRY(2, cTmpS2, " ") ELSE "".

            cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "country-id2").
            FIND FIRST country
               WHERE (country.country-id EQ cTmpS)
               NO-LOCK NO-ERROR.

            cKlP   = cKlP
                   + "|      Гражданство: "
                   + PrintStringInfo(IF (AVAIL country) THEN country.country-name ELSE "")
                   + "|      Цель визита: "
                   + PrintStringInfo(GetXAttrValue(cKlTabl, cKlNum, "МигрЦельВизита"))
                   + "|      Срок пребывания с "
                   + PrintDateInfo(DATE(GetXAttrValue(cKlTabl, cKlNum, "МигрПребывС")))
                   + " до "
                   + PrintDateInfo(DATE(GetXAttrValue(cKlTabl, cKlNum, "МигрПребывПо")))
                   + "|      Срок действия права пребывания с "
                   + PrintDateInfo(DATE(GetXAttrValue(cKlTabl, cKlNum, "МигрПравПребС")))
                   + " до "
                   + PrintDateInfo(DATE(GetXAttrValue(cKlTabl, cKlNum, "МигрПравПребПо"))).
         END.
      END.

      WHEN "61" THEN DO:
	 IF (cKlType EQ "Ч") THEN
            cKlP = PrintDateInfo(person.date-in) .
	 IF (cKlType EQ "Ю") THEN
            cKlP = PrintDateInfo(cust-corp.date-in) .
      END.
      WHEN "62" THEN DO:
         cKlP   = PrintDateInfo(daLast).
      END.

      WHEN "65" THEN DO:
         cKlP   = UserFIO(cUsrLast).
      END.
      WHEN "66" THEN DO:
         cKlP   = UserFIO(USERID).
      END.

      WHEN "70" THEN DO:
         cKlP   = cPredWho_Name.
      END.
      WHEN "71" THEN DO:
         cKlP   = cPredWho_INN.
      END.
      WHEN "72" THEN DO:
         cKlP   = cPredWho_MainAcct.
      END.
      WHEN "73" THEN DO:
         FIND FIRST class
            WHERE (class.class-code EQ cust-role.class-code)
            NO-LOCK NO-ERROR.
         cKlP   = class.name.
      END.
      WHEN "74" THEN DO:
         IF ( ENTRY(1, iParam) EQ "П2") THEN 
            DO:
               IF substr(cPredWho_MainAcct,6,3) = "810" THEN
			cPredWho_MainAcctCur = "".
               ELSE 	
			cPredWho_MainAcctCur = substr(cPredWho_MainAcct,6,3).
               cKlP   = GetEntries(2,GetXattrValueEx("acct",(cPredWho_MainAcct + "," + cPredWho_MainAcctCur ),"ДогОткрЛС",""),",","")
			+ " от " + GetEntries(1,GetXattrValueEx("acct",(cPredWho_MainAcct + "," + cPredWho_MainAcctCur ),"ДогОткрЛС",""),",","") + "г." .
            END. 
         ELSE	
            cKlP   = PrintStringInfo(
                     GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "PIRosnovanie")).
      END.
      WHEN "75" THEN DO:
         cKlP   = PrintDateInfo(cust-role.open-date).
      END.
      WHEN "76" THEN DO:
         IF ( ENTRY(1, iParam) EQ "П2") THEN 
            DO:
               cKlP   = PrintDateInfo(
			DATE(GetEntries(3,(KlientCardPoAcct(cPredWho_MainAcct,person.person-id)),",","")) ).
            END. 
         ELSE	
	    cKlP   = PrintDateInfo(cust-role.close-date).
      END.

   END CASE.
/*
MESSAGE cP cKlP
   VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
*/
   cAnketa = REPLACE(cAnketa, "#" + cP + "#", cKlP).

END.

/******************************************* печат анкеты ***********************/

{setdest.i}
DO WHILE (LENGTH(cAnketa) GT 0):

   IF (INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), "|") NE 0)
   THEN
      ASSIGN
         cPrLine = SUBSTRING(cAnketa, 1, INDEX(cAnketa, "|") - 1)
         cAnketa = SUBSTRING(cAnketa, INDEX(cAnketa, "|") + 1)
      .
   ELSE
      ASSIGN
         iwwI    = MAX(R-INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), " "),
                       R-INDEX(SUBSTRING(cAnketa, 1, iLineW    ), ","))
         iwwI    = (IF (iwwI GT 0) THEN iwwI ELSE iLineW)
         cPrLine = SUBSTRING(cAnketa, 1, iwwI)
         cAnketa = "      " + SUBSTRING(cAnketa, iwwI + 1)
      .
   IF (LENGTH(cPrLine) GT iLineW)
   THEN cPrLine = SUBSTRING(cPrLine, 1, iLineW).

   PUT UNFORMATTED cPrLine SKIP.
END.

{preview.i}
{intrface.del}

