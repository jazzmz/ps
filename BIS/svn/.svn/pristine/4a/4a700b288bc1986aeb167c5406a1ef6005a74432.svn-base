/* ------------------------------------------------------
Copyright: ООО КБ "Пpоминвестрасчет"
Что делает:    Производит экспорт данных в формате AFX для договора инкассации/перевозки ценностей
Параметры:     Тип клиента (Ч/Ю), Полный путь к файлу экспорта
Место запуска: Броузер клиентов.
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

DEFINE VARIABLE cCustCat  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOutFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKlNum    AS CHARACTER NO-UNDO.
DEF VAR tmpStr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFstAcct  AS CHARACTER NO-UNDO.
DEFINE VARIABLE daFirstOp AS DATE      NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE      NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER NO-UNDO.

IF NUM-ENTRIES(iParam) GE 2 THEN
   ASSIGN
      cCustCat = ENTRY(1,iParam)
      cOutFile = ENTRY(2,iParam)
      NO-ERROR.
ELSE DO:
   MESSAGE "ОШИБКА! Проверь параметры процедуры!" VIEW-AS ALERT-BOX.
   RETURN.
END.

/** Задаем вывод в файл */
OUTPUT TO VALUE(cOutFile).

RUN OutStr("<data>").
RUN OutStr("<agreement>").
RUN OutStr("type=" + IF (cCustCat EQ "Ю") THEN "Инкасс" ELSE "ПЦФЛ").
RUN OutStr("date=" + STRING(TODAY, "99.99.9999")).
RUN OutStr("</agreement>").

RUN OutStr("<client>").

FIND FIRST tmprecid
   NO-ERROR.

IF (cCustCat EQ "Ю")
THEN DO:
   FIND FIRST cust-corp
      WHERE (RECID(cust-corp) = tmprecid.id)
      NO-LOCK NO-ERROR.

   cKlNum = STRING(cust-corp.cust-id).

   RUN OutStr("name="      + cust-corp.cust-stat + " " + cust-corp.name-corp).
   RUN OutStr("addressul=" + Kladr(cust-corp.country-id + ","
                           + GetXAttrValue("cust-corp", cKlNum, "КодРегГНИ"),
                             cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2])).
   RUN OutStr("inn="       + cust-corp.inn).
   RUN OutStr("ogrn="      + GetXAttrValue("cust-corp", cKlNum, "ОГРН")).
   RUN OutStr("phone="     + GetXAttrValue("cust-corp", cKlNum, "tel")).
   RUN OutStr("fax="       + cust-corp.fax).
   RUN OutStr("fio="       + GetXAttrValue("cust-corp", cKlNum, "ФИОрук")).
   RUN OutStr("post="      + GetXAttrValue("cust-corp", cKlNum, "ДолРук")).

   RUN FirstKlAcct("ЮЛ", INTEGER(cKlNum), OUTPUT cFstAcct, OUTPUT daFirstOp, OUTPUT daFirstCl, OUTPUT cUsrFirst).
   RUN OutStr("acct="      + cFstAcct).
END.
ELSE DO:
   FIND FIRST person
      WHERE (RECID(person) = tmprecid.id)
   NO-LOCK NO-ERROR.

   cKlNum = STRING(person.person-id).

   RUN OutStr("fio="       + person.name-last + " " + person.first-names).
   RUN OutStr("addressfl=" + Kladr(person.country-id + ","
                           + GetXAttrValue("person", cKlNum, "КодРегГНИ"),
                             person.address[1] + person.address[2])).
   RUN OutStr("document="  + GetCodeName("КодДокум", person.document-id) + ", N " + person.document + ", выдан "
                           + STRING(GetXAttrValue("person", cKlNum, "Document4Date_vid"), "99.99.9999") + ", "
                           + GetXAttrValue("person", cKlNum, "Document3Kem_Vid")).

   RUN FirstKlAcct("ФЛ", INTEGER(cKlNum), OUTPUT cFstAcct, OUTPUT daFirstOp, OUTPUT daFirstCl, OUTPUT cUsrFirst).
   RUN OutStr("acct="      + cFstAcct).
END.
RUN OutStr("</client>").

RUN OutStr("<order>").
RUN OutStr("date=" + STRING(TODAY, "99.99.9999")).

FIND FIRST _user
   WHERE (_user._userid = USERID)
   NO-LOCK NO-ERROR.

IF AVAIL _user
THEN
   IF (NUM-ENTRIES(_user._user-name, " ") EQ 3)
   THEN
      RUN OutStr("user=" + SUBSTR(ENTRY(2, _user._user-name, " "), 1, 1) + "."
                         + SUBSTR(ENTRY(3, _user._user-name, " "), 1, 1) + "."
                         + ENTRY(1, _user._user-name, " ")).
   ELSE
      RUN OutStr("user=" + ENTRY(2, _user._user-name, " ") + " "
                         + ENTRY(1, _user._user-name, " ")).

RUN OutStr("</order>").
RUN OutStr("</data>").

OUTPUT CLOSE.

MESSAGE "Данные экспортированы!" VIEW-AS ALERT-BOX.
