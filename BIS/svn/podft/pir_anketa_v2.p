{pirsavelog.p}
/** 
   ОТЧЕТ.
   ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Формирование анкеты клиента.
   Борисов А.В., 15.12.2009
Modified: 30/08/11 SStepanov для представителя Банка - сокр.наименование из ДР, ИНН из cust-ident по запросу Капитановой
	  09/09/11 SStepanov Если попадалась запятая в названии клиента, то она воспринималась как разделитель полей.
	  04/10/11 SStepanov Если счет закрыт, то не заполнять поле 1.14 "без открытия счета"
		#843 задача на стыке интересов ПОДФТ(pir_krupnye*.p) и открытие счетов и платстики(pir_anketa.p)
		ПОДФТ запросило, чтобы у них была другая функциональность по версия для ПОДФТ всегда показывает дату открытия счета
		PROCEDURE FirstKlAcctPODFT :
		версия для всех кроме ПОДФТ не показывает дату открытия счета если он закрыт PROCEDURE FirstKlAcct :
	  22/02/12 SStepanov паспорт ищется теперь по индексу. Раньше его не было и когда 2 паспорта тянулся произвольный;
	  02/03/12 SStepanov для ФЛ ищется паспорт или ВремУдРФ;
	  06/03/12 SStepanov проверка лицензия ищется с датой закрытия пустой или меньше или равной даты окончания из глобальных настоечных параметров;
	  28/03/12 SStepanov доработки для открытия счетов - четвертый параметр bIsBOS;
	  24/01/13 AGoncharov доработка и новые поля анкеты физиков (#48#, #49#, #77#, #78#, #90#);
	  25/01/13 AGoncharov доработка анкеты выгодоприобретателя (#79#).
	  06/02/13 AGoncharov добавил поля #77 и #78 для ИП
	  28/02/13 AGoncharov изменил обработку адресов регистрации для физиков и юриков (поля #17, #18, #19). Заявка #1194.
*/

{globals.i}           /* Глобальные определения */
{tmprecid.def}        /* Используем информацию из броузера */
{wordwrap.def}        /* Будем использовать перенос по словам */
{parsin.def}
{intrface.get xclass} /* Функции для работы с метасхемой */
{intrface.get strng}  /* Функции для работы со строками */
{getdate.i} 
{pir_anketa.fun}


/******************************************* Определение переменных и др. */

DEFINE INPUT PARAMETER iParam AS CHAR NO-UNDO.

/* типы документов, которые искользуются в первую очередь */
DEF VAR v_cust-code-type  AS CHARACTER NO-UNDO INIT "ВремУдРФ,Паспорт".

DEFINE VARIABLE cKl       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cVp       AS CHARACTER INIT ""           NO-UNDO.
DEFINE VARIABLE cUser     AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKladr    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE bIsBOS    AS LOG       INIT NO           NO-UNDO .

DEFINE VARIABLE iKl       AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cKlNum    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlType   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlTabl   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cKlPoleL  AS CHARACTER EXTENT 9
   /* ФЛ */ INIT ["5,18,19,24,25,27,37,38,41,42,44,46,47,48,49,60,63,61,62,64,65,66,77,78,90",
   /* ИП */       "2,12,14,15,16,17,19,20,21,22,26,30,35,36,37,38,40,42,43,45,47,48,49,60,61,63,62,64,65,66,77,78,90",
   /* ЮЛ */       "1,9,11,12,14,15,16,17,19,21,22,26,29,30,31,33,34,35,36,37,38,60,61,63,62,64,65,66",
   /*  Б */       "8,10,11,13,14,15,16,17,19,21,23,28,29,30,32,33,34,37,38,51,60,61,63,62,64,65,66",
   /* ФЛ ВП */    "5,18,19,24,25,27,41,42,44,46,47,65,66,74",
   /* ИП ВП */    "2,12,14,15,16,17,19,20,21,22,26,30,40,42,43,45,47,65,66,74,79",
   /* ЮЛ ВП */    "1,9,11,12,14,15,16,17,19,21,22,26,29,30,31,33,34,65,66,74,79",
   /* ФЛ П  */    "70,71,72,73,74,75,76,5,18,19,24,25,27,41,42,44,46,47,61,62,65,66",
   /* ЮЛ П  */    "70,71,72,73,74,75,76,1,9,11,12,14,15,16,17,19,21,22,26,29,30,31,33,61,62,65,66"]             NO-UNDO.

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

DEFINE VARIABLE cTmp48    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmp49_1  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmp49_2  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmp77    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cTmp78    AS CHARACTER                   NO-UNDO.

DEFINE VARIABLE iTmpI     AS INTEGER                     NO-UNDO.
DEFINE VARIABLE daLast    AS DATE                        NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cUsrLast  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cFstAcct  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE daFirstOp AS DATE                        NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE                        NO-UNDO.

DEFINE VARIABLE iI        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cUserFIO  AS CHARACTER                   NO-UNDO.
/* >> было
DEFINE VARIABLE cPredWho  AS CHARACTER                   NO-UNDO.
     << было */
/* >> стало */
DEFINE VARIABLE cPredWho_Name		AS CHARACTER	NO-UNDO.
DEFINE VARIABLE cPredWho_INN		AS CHARACTER	NO-UNDO.
DEFINE VARIABLE cPredWho_MainAcct	AS CHARACTER	NO-UNDO.

DEFINE VARIABLE ChCount		        AS INTEGER      INIT 7        NO-UNDO.
/* << стало */

/******************************************* Реализация */
/* NEW - params:
   1 = "Ч,Ю,Б,ВП,П"
   2 = cUser
   3 = cKladr              */

/** Разбор входного параметра */
cKl     = ENTRY(1, iParam). /* "Ч,Ю,Б,ВП,П" */
cUser   = ENTRY(2, iParam). /*  */
cKladr  = ENTRY(3, iParam). /*  */
bIsBOS  = NUM-ENTRIES(iParam) > 3. /* анкета для Без Открытия Счета */

FIND FIRST tmprecid
   NO-ERROR.

CASE cKl:
   WHEN "Ч" THEN DO:
      FIND FIRST person
         WHERE (RECID(person) EQ tmprecid.id)
         NO-ERROR.
      cKlNum = STRING(person.person-id).
      cKl    = "ФЛ".
      iKl    = 1.
   END.
   WHEN "Ю" THEN DO:
      FIND FIRST cust-corp
         WHERE (RECID(cust-corp) EQ tmprecid.id)
         NO-ERROR.
      cOPF   = cust-corp.cust-stat.
      cKl    = IF CAN-DO("ИП,ПБОЮЛ,Адвокат,Нотариус,ГКХ", cOPF) THEN "ИП" ELSE "ЮЛ".
      iKl    = IF (cKl EQ "ИП") THEN 2 ELSE 3.
      cOPF   = GetCodeName("КодПредп",GetCodeVal("КодПредп", cOPF)).
      cKlNum = STRING(cust-corp.cust-id).
   END.
   WHEN "Б" THEN DO:
      FIND FIRST banks
         WHERE (RECID(banks) EQ tmprecid.id)
         NO-ERROR.
      cKlNum = STRING(banks.bank-id).
      iKl    = 4.
   END.
   WHEN "ВП" THEN DO:
      cVp     = "ВП". /*  */

      FIND FIRST cust-role
         WHERE (RECID(cust-role) EQ tmprecid.id)
         NO-ERROR.
      IF NOT (cust-role.class-code BEGINS "ВыгодоПриобретатель")
      THEN RETURN.

      cKlNum = cust-role.cust-id.

      FIND FIRST cust-corp
          WHERE (cust-corp.cust-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

      CASE cust-role.file-name:
         WHEN "cust-corp" THEN DO:
   
		cPredWho_Name		= cust-corp.name-short.
		cPredWho_INN		= cust-corp.inn.
		cPredWho_MainAcct	= KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), cust-corp.cust-stat).

	END.

         WHEN "person" THEN DO:
            FIND FIRST person
               WHERE (person.person-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

            cTmpS  = person.inn.

            cPredWho_Name	= person.first-names + " " + person.name-last.
            cPredWho_INN        = (IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS).
            cPredWho_MainAcct   = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").

         END.
/*         WHEN "banks" THEN DO:
            FIND FIRST banks
               WHERE (banks.bank-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

	    FIND FIRST cust-ident
		WHERE cust-ident.cust-cat  	= "Б"
		  AND cust-ident.cust-id  	= banks.bank-id
		  AND cust-ident.cust-code-type = "ИНН"
		NO-LOCK NO-ERROR.

            cPredWho_Name     = (IF AVAIL banks THEN GetXAttrValue("banks", STRING(banks.bank-id), "pirShortName") ELSE ""). /* banks.short-name */
	    cPredWho_INN      = (IF AVAIL cust-ident THEN cust-ident.cust-code ELSE ""). /* banks.inn */
	    cPredWho_MainAcct = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
         END.
*/

      END CASE.


      IF (cust-role.cust-cat EQ "Ч")
      THEN DO:
         FIND FIRST person
            WHERE (person.person-id EQ INTEGER(cKlNum))
            NO-ERROR.
         cKl    = "ФЛ".
         iKl    = 5.
      END.
      ELSE DO:
         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ INTEGER(cKlNum))
            NO-ERROR.
         cOPF   = cust-corp.cust-stat.
         cKl    = IF CAN-DO("ИП,ПБОЮЛ,Адвокат,Нотариус", cOPF) THEN "ИП" ELSE "ЮЛ".
         iKl    = IF (cKl EQ "ИП") THEN 6 ELSE 7.
         cOPF   = GetCodeName("КодПредп",GetCodeVal("КодПредп", cOPF)).
      END.
   END.
   WHEN "П" THEN DO:
      FIND FIRST cust-role
         WHERE (RECID(cust-role) EQ tmprecid.id)
         NO-ERROR.

      CASE cust-role.file-name:
         WHEN "cust-corp" THEN DO:
            FIND FIRST cust-corp
               WHERE (cust-corp.cust-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

/* >> было
            cPredWho = cust-corp.name-short + "," + cust-corp.inn + ","
                     + KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), cust-corp.cust-stat).
   << было */
/* >> стало */
		cPredWho_Name		= cust-corp.name-short.
		cPredWho_INN		= cust-corp.inn.
		cPredWho_MainAcct	= KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), cust-corp.cust-stat).
/* << стало */
         END.
         WHEN "person" THEN DO:
            FIND FIRST person
               WHERE (person.person-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

            cTmpS  = person.inn.
/* >> было
            cPredWho = person.first-names + " " + person.name-last + ","
                     + (IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS) + ","
                     + KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
   << было */
/* >> стало */
            cPredWho_Name	= person.first-names + " " + person.name-last.
            cPredWho_INN        = (IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS).
            cPredWho_MainAcct   = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
/* << стало */
         END.
         WHEN "banks" THEN DO:
            FIND FIRST banks
               WHERE (banks.bank-id EQ INT(cust-role.surrogate))
               NO-LOCK NO-ERROR.

	    FIND FIRST cust-ident
		WHERE cust-ident.cust-cat  	= "Б"
		  AND cust-ident.cust-id  	= banks.bank-id
		  AND cust-ident.cust-code-type = "ИНН"
		NO-LOCK NO-ERROR.

/* >> было
            cPredWho = 
			(IF AVAIL banks THEN GetXAttrValue("banks", STRING(banks.bank-id), "pirShortName") ELSE "") /* banks.short-name */
		+ "," + (IF AVAIL cust-ident THEN cust-ident.cust-code ELSE "") /* banks.inn */
		+ "," + KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
   << было */
/* >> стало */
            cPredWho_Name     = (IF AVAIL banks THEN GetXAttrValue("banks", STRING(banks.bank-id), "pirShortName") ELSE ""). /* banks.short-name */
	    cPredWho_INN      = (IF AVAIL cust-ident THEN cust-ident.cust-code ELSE ""). /* banks.inn */
	    cPredWho_MainAcct = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
         END.
/* << стало */
      END CASE.

      cKlNum = cust-role.cust-id.

      IF (cust-role.cust-cat EQ "Ч")
      THEN DO:
         FIND FIRST person
            WHERE (person.person-id EQ INTEGER(cKlNum))
            NO-ERROR.
         cKl    = "ФЛ".
         iKl    = 8.
      END.
      ELSE DO:
         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ INTEGER(cKlNum))
            NO-ERROR.
         cOPF   = cust-corp.cust-stat.
         cKl    = IF CAN-DO("ИП,ПБОЮЛ,Адвокат,Нотариус", cOPF) THEN "ИП" ELSE "ЮЛ".
         iKl    = IF (cKl EQ "ИП") THEN 9 ELSE 9.
         cOPF   = GetCodeName("КодПредп",GetCodeVal("КодПредп", cOPF)).
      END.
   END.
END CASE.

cKlType = KlType(cKl). /*  */
cKlTabl = KlTabl(cKl). /*  */
cKlPole = cKlPoleL[iKl].

{pir_anketa_v2.i}

IF (iKl LT 5)
THEN DO:
   daFirstOp = ?.
   RUN FirstKlAcct(cKl, INTEGER(cKlNum), OUTPUT cFstAcct, OUTPUT daFirstOp, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   IF (cFstAcct EQ "")
   THEN DO:
      MESSAGE "Не открывались клиентские счета"
         VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
/*      RETURN. */
   END.
   ELSE DO:
      IF (daFirstCl NE ?)
      THEN DO:
         MESSAGE "Все клиентские счета закрыты"
            VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
/*         RETURN. */
      END.

      cTmpS = SUBSTRING(cFstAcct, 6, 3).
      cTmpS = IF (cTmpS EQ "810") THEN "" ELSE cTmpS.
      cUser = GetXAttrValue("acct", cFstAcct + "," + cTmpS, "СотрУтвСч").
/*
      ELSE DO:
         IF (NUM-ENTRIES(cUser, ";") GT 1)
         THEN DO:
            IF (cKl EQ "Б")
            THEN DO:
               IF (SUBSTRING(cFstAcct, 1, 3) EQ "301")
               THEN cUser = ENTRY(1, cUser, ";").
               ELSE cUser = ENTRY(2, cUser, ";").
            END.
            ELSE DO:
               cUserFIO = "".
               DO iI = 1 TO NUM-ENTRIES(cUser, ";"):
                  FIND FIRST _user
                     WHERE (_user._userid = ENTRY(iI, cUser, ";"))
                     NO-LOCK NO-ERROR.
                  cUserFIO = cUserFIO + "," + (IF AVAIL _user THEN _user._user-name ELSE "-").
               END.

               cUserFIO = TRIM(cUserFIO, ",").
               pick-value = "1".
               run messmenu.p(9, "Сотрудник, утвердивший открытие счета:", "", cUserFIO).

               IF (pick-value EQ "0")
               THEN RETURN.

               cUser = ENTRY(INTEGER(pick-value), cUser, ";").
            END.
         END.
      END.
*/
   END.
END.

RUN GetLastAnketaDate( /* cVp + */ cKl, INTEGER(cKlNum), OUTPUT daLast, OUTPUT cUsrLast).

/******************************************* Присвоение значений переменным и др. */

DO iPI = 1 TO NUM-ENTRIES(cKlPole):

   cP = ENTRY(iPI, cKlPole).

   CASE cP:
      WHEN "1" THEN DO:
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "FullName").
         cKlP   = PrintStringInfo(
                  IF (cTmpS EQ "") THEN (cOPF + " " + cust-corp.name-corp) ELSE cTmpS).
      END.
      WHEN "2" THEN DO:
         cKlP   = PrintStringInfo(
                  cust-corp.name-corp).
      END.
/*
      WHEN "3" THEN DO:
         cKlP   = PrintStringInfo(
                  IF (NUM-ENTRIES(cust-corp.name-corp, " ") > 1) THEN ENTRY(2, cust-corp.name-corp, " ") ELSE "").
      END.
      WHEN "4" THEN DO:
         cKlP   = PrintStringInfo(
                  IF (NUM-ENTRIES(cust-corp.name-corp, " ") > 2) THEN ENTRY(3, cust-corp.name-corp, " ") ELSE "").
      END.
*/
      WHEN "5" THEN DO:
         cKlP   = PrintStringInfo(
                  person.name-last + " " + person.first-names).
      END.
/*
      WHEN "6" THEN DO:
         cKlP   = PrintStringInfo(
                  ENTRY(1, person.first-names, " ")).
      END.
      WHEN "7" THEN DO:
         cKlP   = PrintStringInfo(
                  IF (NUM-ENTRIES(person.first-names, " ") > 1) THEN ENTRY(2, person.first-names, " ") ELSE "").
      END.
*/
      WHEN "8" THEN DO:
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "pirFullName").
         cKlP   = PrintStringInfo(
                    IF {assigned cTmpS} THEN cTmpS ELSE banks.name).
      END.
      WHEN "9" THEN DO:
         cKlP   = PrintStringInfo(
                  cust-corp.name-short).
      END.
      WHEN "10" THEN DO:
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "pirShortName").
         cKlP   = PrintStringInfo(
                  IF {assigned cTmpS} THEN cTmpS ELSE banks.short-name).
      END.
      WHEN "11" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "engl-name")).
      END.
      WHEN "12" THEN DO:
         cKlP   = PrintStringInfo(
                  cOPF).
      END.
      WHEN "13" THEN DO:
         cKlP   = PrintStringInfo(
                  GetCodeName("КодПредп", GetXAttrValue(cKlTabl, cKlNum, "bank-stat"))).
      END.
      WHEN "14" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "ОГРН")).
      END.
      WHEN "15" THEN DO:
         cKlP   = PrintDateInfo(
                  DATE(GetXAttrValue(cKlTabl, cKlNum, "RegDate"))).
      END.
      WHEN "16" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "RegPlace")).
      END.
      WHEN "17" THEN DO:
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрЮр")
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
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
      WHEN "18" THEN DO:

         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрПроп")
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
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
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрФакт")
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
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
      WHEN "20" THEN DO:
         FIND FIRST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "АдрПочт")
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
      WHEN "21" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "tel")).
      END.
      WHEN "22" THEN DO:
         cKlP   = PrintStringInfo(
                  cust-corp.fax).
      END.
      WHEN "23" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "fax")).
      END.
      WHEN "24" THEN DO:
         cKlP   = PrintStringInfo(
                  TRIM(TRIM(person.phone[1], ",") + " " + TRIM(person.phone[2], ","), ",")).
      END.
      WHEN "25" THEN DO:
         cKlP   = PrintStringInfo(
                  person.fax).
      END.
      WHEN "26" THEN DO:
         cKlP   = PrintStringInfo(
                  cust-corp.inn).
      END.
      WHEN "27" THEN DO:
         cTmpS  = person.inn.
         cKlP   = PrintStringInfo(
                  IF ((cTmpS EQ "000000000000") OR (cTmpS = "0")) THEN "" ELSE cTmpS).
      END.
      WHEN "28" THEN DO:
         FIND FIRST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND (cust-ident.cust-code-type EQ "ИНН")
            NO-LOCK NO-ERROR.
         cKlP   = PrintStringInfo(
                  IF (AVAIL cust-ident) THEN cust-ident.cust-code ELSE "").
      END.
      WHEN "29" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "ИИН")).
      END.
      WHEN "30" THEN DO:
         cTmpS  = "".
         FOR EACH cust-ident
            WHERE (cust-ident.cust-cat   EQ cKlType)
              AND (cust-ident.cust-id    EQ INTEGER(cKlNum))
              AND (cust-ident.class-code EQ "cust-lic")
              AND (   (cust-ident.close-date =  ?)
                   OR (cust-ident.close-date >= gend-date))
            NO-LOCK:

            cTmpS = cTmpS
                  + "|      Вид лицензируемой деятельности: "
                  + PrintStringInfo(IF (cKlType EQ "Ю")
                    THEN GetCodeName("ВидЛицДеят", cust-ident.cust-code-type)
                    ELSE GetCodeName("ВидБанкЛиц", cust-ident.cust-code-type))
                  + "|      Номер: "
                  + PrintStringInfo(cust-ident.cust-code)
                  + "|      Дата выдачи лицензии: "
                  + PrintDateInfo(cust-ident.open-date)
                  + "|      Кем выдана: "
                  + PrintStringInfo(cust-ident.issue)
                  + "|      Срок действия до: "
                  + PrintDateInfo(cust-ident.close-date).
         END.
         cKlP   = PrintStringInfo(cTmpS).
      END.
      WHEN "31" THEN DO:
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "ИсполнОрган").
         cTmpS2 = GetXAttrValue(cKlTabl, cKlNum, "ОбщСобрание").
         IF ((cTmpS + cTmpS2) EQ "")
         THEN DO:
            cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "СоставСД").
            cTmpS2 = GetXAttrValue(cKlTabl, cKlNum, "СоставИКО").
            cKlP   = GetXAttrValue(cKlTabl, cKlNum, "СтруктОрг").
            cKlP   = cKlP
                   + (IF (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "нет") THEN ";" ELSE "")
                   + IF ((cTmpS  EQ "") OR (cTmpS  EQ "нет"))
                     THEN "" ELSE ("|      Совет директоров: " + cTmpS).
            cKlP   = cKlP
                   + (IF (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "нет") THEN ";" ELSE "")
                   + IF ((cTmpS2 EQ "") OR (cTmpS2 EQ "нет"))
                     THEN "" ELSE ("|      " + cTmpS2).
            cKlP   = PrintStringInfo(cKlP).
         END.
         ELSE DO:
            cKlP   = IF ((cTmpS  EQ "") OR (cTmpS  EQ "нет"))
                     THEN "" ELSE cTmpS.
            cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "СоставСД").
            cKlP   = cKlP
                   + (IF (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "нет") THEN ";" ELSE "")
                   + IF ((cTmpS  EQ "") OR (cTmpS  EQ "нет"))
                     THEN "" ELSE ("|      Совет директоров: " + cTmpS).
            cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "СоставИКО").
            cKlP   = cKlP
                   + (IF (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "нет") THEN ";" ELSE "")
                   + IF ((cTmpS  EQ "") OR (cTmpS  EQ "нет"))
                     THEN "" ELSE ("|      " + cTmpS).
            cKlP   = cKlP
                   + (IF (cKlP NE "") AND (cTmpS2 NE "") AND (cTmpS2 NE "нет") THEN ";" ELSE "")
                   + IF ((cTmpS2 EQ "") OR (cTmpS2 EQ "нет"))
                     THEN "" ELSE ("|      " + cTmpS2 + "|").
            cKlP   = PrintStringInfo(cKlP).
         END.
      END.
      WHEN "32" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "СтруктОрг")).
      END.
      WHEN "33" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "УставКап")).
      END.
      WHEN "34" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "ПрисутОргУправ")).
      END.
      WHEN "35" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "pirOtherBanks")).
      END.
      WHEN "36" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "pirBusImage")).
      END.
      WHEN "37" THEN DO: /* 1.12 */
         cTmpS  = IF bIsBOS THEN "низкий" ELSE GetXAttrValue(cKlTabl, cKlNum, "РискОтмыв").
         cKlP   = PrintStringInfo(cTmpS).
      END.
      WHEN "38" THEN DO: /* 1.13 */
	IF bIsBOS 
	  THEN cTmpS2 = "Банковские операции клиента не вызывают подозрения и не связаны с легализацией (отмыванием) доходов, полученных преступным путем, или финансированием терроризма".
	ELSE DO:
          cTmpS2 = GetXAttrValue(cKlTabl, cKlNum, "ОценкаРиска").
          IF (cTmpS2 EQ "")
          THEN
            cTmpS2 = GetCode("PirОценкаРиска", cTmpS).
	END.
        cKlP   = PrintStringInfo(cTmpS2).
      END.
      WHEN "39" THEN DO: /* не используется. Теперь 74 */
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "СведВыгДрЛица")).
      END.
      WHEN "40" THEN DO:
         cKlP   = PrintDateInfo(
                  DATE(GetXAttrValue(cKlTabl, cKlNum, "BirthDay"))).
      END.
      WHEN "41" THEN DO:
         cKlP   = PrintDateInfo(
                  person.birthday).
      END.
      WHEN "42" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "BirthPlace")).
      END.
      WHEN "43" THEN DO:
         FIND FIRST country 
            WHERE (country.country-id EQ cust-corp.country-id)
            NO-LOCK NO-ERROR.
         cKlP   = PrintStringInfo(
                  IF (AVAIL country) THEN country.country-name ELSE ?).
      END.
      WHEN "44" THEN DO:
         cTmpS = GetXAttrValue(cKlTabl, cKlNum, "country-id2").
         FIND FIRST country
            WHERE (country.country-id EQ cTmpS)
            NO-LOCK NO-ERROR.
         cKlP   = PrintStringInfo(
                  IF (AVAIL country) THEN country.country-name ELSE ?).
      END.
      WHEN "45" THEN DO:
         cKlP   = PrintStringInfo(
                  GetCodeName("КодДокум", GetXAttrValue(cKlTabl, cKlNum, "document-id"))
                + ", N " + GetXAttrValue(cKlTabl, cKlNum, "document")
                + ", выдан " + STRING(DATE(GetXAttrValue(cKlTabl, cKlNum, "Document4Date_vid")), "99.99.9999")
                + ", " + GetXAttrValue(cKlTabl, cKlNum, "issue")).
      END.
      WHEN "46" THEN DO:
         FIND LAST cust-ident
            WHERE /* (cust-ident.close-date EQ ? OR cust-ident.close-date >= 01/01/2001)
              AND */ (cust-ident.class-code     EQ "p-cust-ident")
              AND (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
              AND CAN-DO(v_cust-code-type, cust-ident.cust-code-type)
            NO-LOCK USE-INDEX open-date NO-ERROR.
         IF NOT (AVAIL cust-ident)
         THEN DO:
            FIND LAST cust-ident
               WHERE /* (cust-ident.close-date EQ ? OR cust-ident.close-date >= 01/01/2001)
                 AND */ (cust-ident.class-code     EQ "p-cust-ident")
                 AND (cust-ident.cust-cat       EQ cKlType)
                 AND (cust-ident.cust-id        EQ INTEGER(cKlNum))
               NO-LOCK USE-INDEX open-date NO-ERROR.
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

      WHEN "48" THEN DO:
         cTmp48  = GetTempXAttrValueEx(cKlTabl, cKlNum, "Статус_ИПДЛ", end-date, "").
           IF (cTmp48 NE "") AND (TRIM(CAPS(cTmp48)) NE "НЕТ" AND LENGTH(cTmp48)>ChCount) THEN DO:
		cklP = "Д А".
              END.
	    ELSE 
		cklP = "НЕТ".
                /*         cKlP   = IF (cTmp48 NE "") THEN "Д А" ELSE "НЕТ". */
     END.
      WHEN "49" THEN DO:
         cTmp49_1 = GetTempXAttrValueEx(cKlTabl, cKlNum, "ОтнОкруж_ИПДЛ", end-date, "").
         cTmp49_2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "СтепРодст_ИПДЛ", end-date, "").
           IF (cTmp49_1 NE "") AND (TRIM(CAPS(cTmp49_1)) NE "НЕТ" AND LENGTH(cTmp49_1)>ChCount) AND (cTmp49_2 NE "") AND (TRIM(CAPS(cTmp49_2)) NE "НЕТ" AND LENGTH(cTmp49_2)>ChCount)THEN DO:
		cklP = "Д А".
              END.
	    ELSE 
		cklP = "НЕТ".
     END.



      WHEN "51" THEN DO:
         FIND FIRST banks-code
            WHERE (banks-code.bank-id        EQ banks.bank-id)
              AND (banks-code.bank-code-type EQ "МФО-9")
            NO-LOCK NO-ERROR.
         cKlP   = PrintStringInfo(
                  IF (AVAIL banks-code) THEN banks-code.bank-code ELSE "").
      END.
      WHEN "60" THEN DO:	/* 1.14 */
/*
         cTmpS  = GetXAttrValue(cKlTabl, cKlNum, "FirstAccDate").
         cKlP   = PrintDateInfo(DATE(cTmpS)).
         cKlP   = PrintStringInfo(IF (cTmpS NE "") THEN cTmpS ELSE "без открытия счета").
*/
         cKlP   = IF bIsBOS
		    THEN "без открытия счета"
		    ELSE PrintStringInfo(IF (daFirstOp NE ?) THEN STRING(daFirstOp, "99.99.9999") ELSE "без открытия счета").

      END.
      WHEN "61" THEN DO:        /* 1.15 !!! */
         cKlP = PrintDateInfo(
                IF (cKlType EQ "Ю") THEN cust-corp.date-in ELSE (
                IF (cKlType EQ "Ч") THEN person.date-in
                                    ELSE banks.date-in)).
      END.
      WHEN "62" THEN DO:	/* 1.16 */
         cKlP   = IF bIsBOS THEN "01.01.2099" ELSE PrintDateInfo(daLast).
      END.
      WHEN "63" THEN DO:	/* 1.17 */
         IF (daFirstOp NE ?) AND NOT bIsBOS
         THEN
            cKlP   = UserFIO(cUsrFirst).
         ELSE
            cKlP   = UserFIO("").
      END.
      WHEN "64" THEN DO:	/* 1.18 */
         IF (daFirstOp NE ?) AND NOT bIsBOS
         THEN
            cKlP   = UserFIO(cUser).
         ELSE
            cKlP   = UserFIO("").
      END.
      WHEN "65" THEN DO:	/* 1.19 */
         IF bIsBOS
           THEN DO:
		DEF VAR oLastDate AS DATE.
		DEF VAR oUser     AS CHARACTER.
	     RUN GetLastHistoryDateSince("ФЛ", person.person-id, person.date-in, OUTPUT oLastDate, OUTPUT oUser).
/* message oLastDate oUser view-as alert-box. */
	     cKlP   = UserFIO(oUser).
	   END.
           ELSE cKlP   = UserFIO(cUsrLast).
      END.
      WHEN "66" THEN DO:        /* 1.20 */
         cKlP   = UserFIO(USERID).
      END.
      WHEN "70" THEN DO:
/* >> было
         cKlP   = PrintStringInfo(ENTRY(1, cPredWho)).
   << было */
/* >> стало */
         cKlP   = cPredWho_Name.
/* << стало */
      END.
      WHEN "71" THEN DO:
/* >> было
         cKlP   = PrintStringInfo(ENTRY(2, cPredWho)).
   << было */
/* >> стало */
         cKlP   = cPredWho_INN.
/* << стало */
      END.
      WHEN "72" THEN DO:
/* >> было
         cKlP   = PrintStringInfo(ENTRY(3, cPredWho)).
   << было */
/* >> стало */
         cKlP   = cPredWho_MainAcct.
/* << стало */
      END.
      WHEN "73" THEN DO:
         FIND FIRST class
            WHERE (class.class-code EQ cust-role.class-code)
            NO-LOCK NO-ERROR.
         cKlP   = class.name.
      END.
      WHEN "74" THEN DO:
         cKlP   = PrintStringInfo(
                  GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "PIRosnovanie")).
      END.
      WHEN "75" THEN DO:
         cKlP   = PrintDateInfo(cust-role.open-date).
      END.
      WHEN "76" THEN DO:
         cKlP   = PrintDateInfo(cust-role.close-date).
      END.
      WHEN "77" THEN DO:
         cTmp77 = GetTempXAttrValueEx(cKlTabl, cKlNum, "Статус_ПМО", end-date, "").
           IF (cTmp77 NE "") AND (TRIM(CAPS(cTmp77)) NE "НЕТ" AND LENGTH(cTmp77)>ChCount) THEN DO:
		cklP = "Д А".
              END.
	    ELSE 
		cklP = "НЕТ".
     END.
      WHEN "78" THEN DO:
          cTmp78 = GetTempXAttrValueEx(cKlTabl, cKlNum, "Статус_РПДЛ", end-date, "").
           IF (cTmp78 NE "") AND (TRIM(CAPS(cTmp78)) NE "НЕТ" AND LENGTH(cTmp78)>ChCount) THEN DO:		
		cklP = "Д А".
              END.
	    ELSE 
		cklP = "НЕТ".
     END.

     WHEN "79" THEN DO:

         cKlP   = cPredWho_Name.

     END.

      WHEN "90" THEN DO:
       cKlP  = "". 
           IF (cTmp48 NE "") AND (TRIM(CAPS(cTmp48)) NE "НЕТ" AND LENGTH(cTmp48)>ChCount) THEN DO:
               IF (NUM-ENTRIES (cTmp48, ";") NE 3) AND (TRIM(CAPS(cTmp48)) NE "НЕТ") THEN DO:
                   MESSAGE "Ошибка в доп. реквизите Статус_ИПДЛ!" VIEW-AS ALERT-BOX.
		   Return.
               END.
            cKlP  = cKlP 
                         + "| "
			 + "|  1. Является иностранным публичным должностным лицом: "
                         + "|а) Организация: "
                         + PrintStringInfo(ENTRY(1, cTmp48, ";"))
                         + "|б) Занимаемая должность: "
                         + PrintStringInfo(ENTRY(2, cTmp48, ";")) 
                         + "|в) Наименование государства: "
                         + PrintStringInfo(ENTRY(3, cTmp48, ";"))
                         + "| ". 
         END.
           IF (cTmp49_1 NE "") AND (TRIM(CAPS(cTmp49_1)) NE "НЕТ" AND LENGTH(cTmp49_1)>ChCount) AND (cTmp49_2 NE "") AND (TRIM(CAPS(cTmp49_2)) NE "НЕТ" AND LENGTH(cTmp49_2)>ChCount)THEN DO:
               IF (NUM-ENTRIES (cTmp49_1, ";") NE 3) THEN DO:
                   MESSAGE "Ошибка заполнения доп. реквизита ОтнОкруж_ИПДЛ!" VIEW-AS ALERT-BOX.
		   Return.
               END.
            cKlP  = cKlP 
			 + "|  2. Имеет отношение к иностранному публичному должностному лицу: "
                         + "|а) Организацию: "
                         + PrintStringInfo(ENTRY(1, cTmp49_1, ";"))
                         + "|б) Занимаемую должность: "
                         + PrintStringInfo(ENTRY(2, cTmp49_1, ";")) 
                         + "|в) Наименование государства: "
                         + PrintStringInfo(ENTRY(3, cTmp49_1, ";")).
               IF (NUM-ENTRIES (cTmp49_2, ";") NE 2) THEN DO:
                   MESSAGE "Ошибка заполнения доп. реквизита СтепРодст_ИПДЛ!" VIEW-AS ALERT-BOX.
		   Return.
               END.
                         cKlP  = cKlP 
                         + "|г) Степень родства или иное отношение: "
                         + PrintStringInfo(ENTRY(1, cTmp49_2, ";"))
                         + "|д) Фамилия, Имя и (при наличии) отчество должностного лица: "
                         + PrintStringInfo(ENTRY(2, cTmp49_2, ";"))
                         + "| ". 
        END. /* 49 */

          IF (cTmp77 NE "") AND (TRIM(CAPS(cTmp77)) NE "НЕТ" AND LENGTH(cTmp77)>ChCount) THEN DO:
               IF (NUM-ENTRIES (cTmp77, ";") NE 2) THEN DO:
                   MESSAGE "Ошибка заполнения доп. реквизита Статус_ПМО!" NUM-ENTRIES (cTmp77, ";")  VIEW-AS ALERT-BOX.
		   Return.
               END.
            cKlP  = cKlP 
			 + "|  3. Является должностным лицом публичной международной организации: "
                         + "|а) Организация: "
                         + PrintStringInfo(ENTRY(1, cTmp77, ";"))
                         + "|б) Занимаемая должность: "
                         + PrintStringInfo(ENTRY(2, cTmp77, ";")) 
                         + "| ". 
      END. /* 77 */

          IF (cTmp78 NE "") AND (TRIM(CAPS(cTmp78)) NE "НЕТ" AND LENGTH(cTmp78)>ChCount) THEN DO:
               IF (NUM-ENTRIES (cTmp78, ";") NE 2) THEN DO:
                   MESSAGE "Ошибка заполнения доп. реквизита Статус_РДПЛ!" VIEW-AS ALERT-BOX.
		   Return.
               END.
            cKlP  = cKlP 
			 + "|  4. Является: российским публичным должностным лицом: "
                         + "|а) Организация: "
                         + PrintStringInfo(ENTRY(1, cTmp78, ";"))
                         + "|б) Занимаемая должность: "
                         + PrintStringInfo(ENTRY(2, cTmp78, ";")) 
                         + "|в) Наименование государства: Российская Федерация"
                         + "| ". 
      END. /* 78 */
     END. /* WHEN 90  */

   END CASE.

/* MESSAGE cP cKlP
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

