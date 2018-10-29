/* ------------------------------------------------------
Copyright: ООО КБ "Пpоминвестрасчет"
Что делает:    Производит экспорт данных в формате AFX для договора банковского счета ЮЛ
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

DEFINE BUFFER bTrAcct FOR acct.

IF (NUM-ENTRIES(iParam) GT 0)
THEN cOutFile = ENTRY(1,iParam).
ELSE DO:
   MESSAGE "ОШИБКА! Проверь параметры процедуры!" VIEW-AS ALERT-BOX.
   RETURN.
END.

/** Задаем вывод в файл */
OUTPUT TO VALUE(cOutFile).

FOR FIRST tmprecid
   NO-LOCK,
   FIRST acct
      WHERE (RECID(acct)   EQ tmprecid.id)
        AND (acct.cust-cat EQ "Ю")
      NO-LOCK,
   FIRST cust-corp
      WHERE (cust-corp.cust-id EQ acct.cust-id)
      NO-LOCK:

   cKlNum = STRING(cust-corp.cust-id).
   cDogLS = GetXAttrValue("acct", acct.acct + "," + acct.currency, "ДогОткрЛС").

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
      RUN OutStr("allacct=" + cAllAcct).
   END.

   RUN OutStr("</agreement>").
   RUN OutStr("<client>").
   RUN OutStr("name="      + GetXAttrValue("cust-corp", cKlNum, "FullName")).
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
   RUN OutStr("</client>").
   RUN OutStr("</data>").
END.

OUTPUT CLOSE.

MESSAGE "Данные экспортированы!" VIEW-AS ALERT-BOX.
