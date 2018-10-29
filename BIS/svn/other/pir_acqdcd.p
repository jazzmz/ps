{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
     Filename:  pir_acqdcd.p
      Comment:  Перекодировка OK_TRAN.NNN при импорте dbf
   Parameters:  icFlName - имя файла
      Created:  16/06/2010 Borisov
     Modified:  
*/

{globals.i}           /** Глобальные определения */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE INPUT PARAM icFlName AS CHAR         NO-UNDO.

DEFINE VARIABLE cS        AS CHARACTER EXTENT 60 NO-UNDO.
DEFINE VARIABLE cTrz      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cStructOK AS CHARACTER           NO-UNDO.
DEFINE VARIABLE iI        AS INTEGER             NO-UNDO.
DEFINE VARIABLE cTmp      AS CHARACTER           NO-UNDO.
DEF STREAM impstr.
DEF STREAM expstr.

/********************************************************/
FUNCTION PoleTrz RETURNS CHARACTER
   (INPUT cPoleName AS CHARACTER) :

   RETURN cS[LOOKUP(cPoleName, cStructOK)].
END FUNCTION.

/******************************************* Реализация */

unix silent dbf 1 1 VALUE(icFlName) /dev/null > ./ok.d.
unix silent dbf 2 1 VALUE(icFlName) /dev/null > ./ok.df.

INPUT  STREAM impstr FROM  "./ok.df".
IMPORT STREAM impstr  ^.
MESSAGE "11="  VIEW-AS ALERT-BOX.
REPEAT:
   IMPORT STREAM impstr cS.
   {additem.i cStructOK CAPS(cS[2])}
END.
INPUT STREAM impstr CLOSE.

INPUT   STREAM impstr FROM  "./ok.d".
/* #2074 ТАК БЫЛО СО СТАРЫМ ФАЙЛОМ
OUTPUT  STREAM expstr TO VALUE(REPLACE(icFlName, "OK_TRAN", "OK_TRAN_txt")). 
*/
OUTPUT  STREAM expstr TO VALUE(REPLACE(icFlName, "OKTRAN", "OK_TRAN_txt")).
PUT STREAM expstr UNFORMATTED "*" SKIP.
iI = INTEGER(SUBSTRING(STRING(YEAR(TODAY)), 3, 2) + SUBSTRING(icFlName, LENGTH(icFlName) - 2, 3) + "000").

REPEAT:
   iI = iI + 1.
   IMPORT STREAM impstr cS.
   cTrz = STRING(" ", "x(479)") + "*".

   SUBSTRING(cTrz, 9, 10) = STRING(iI, "9999999999") + "PI".

   CASE PoleTrz("CT-ID"):
      WHEN "VISA" THEN cTmp = "VS".
      WHEN "EURO" THEN cTmp = "MC".
      WHEN "DCL"  THEN cTmp = "DC".
      WHEN "JCB"  THEN cTmp = "JC".
      WHEN "AMEX" THEN cTmp = "AE".
      WHEN "STB"  THEN cTmp = "ST".
      OTHERWISE        cTmp = "??".
   END CASE.
   SUBSTRING(cTrz, 54, 2) = cTmp.

   CASE PoleTrz("TRANS-TYPE"):
      WHEN "000" THEN cTmp = "05 ".
      WHEN "010" THEN cTmp = "05R".
      OTHERWISE       cTmp = "???".
   END CASE.
   SUBSTRING(cTrz,  57, 3) = cTmp.
   SUBSTRING(cTrz, 259, 1) = IF (cTmp EQ "05R") THEN "R" ELSE "D".

   SUBSTRING(cTrz, 127, 24) = STRING(PoleTrz("ACCEPT-ID"), "x(24)").
   SUBSTRING(cTrz, 221, 24) = STRING(PoleTrz("CARD-NO"), "x(24)").

   cTmp = PoleTrz("TRANS-DATE").
   SUBSTRING(cTrz, 245, 8) = SUBSTRING(cTmp, 7, 4) + SUBSTRING(cTmp, 1, 2) + SUBSTRING(cTmp, 4, 2).

   CASE PoleTrz("CURR-CODE"):
      WHEN "RUB" THEN cTmp = "810".
      WHEN "USD" THEN cTmp = "840".
      WHEN "EUR" THEN cTmp = "978".
      OTHERWISE       cTmp = "???".
   END CASE.
   SUBSTRING(cTrz, 260, 3) = cTmp.
   SUBSTRING(cTrz, 263, 3) = cTmp.
   SUBSTRING(cTrz, 266, 3) = cTmp.

   SUBSTRING(cTrz, 269, 15) = STRING(INTEGER(REPLACE(PoleTrz("AMOUNT"), ".", "")), "999999999999999").

   SUBSTRING(cTrz, 422, 6) = PoleTrz("AUTH-CODE").

   PUT STREAM expstr UNFORMATTED cTrz SKIP.

END.

PUT STREAM expstr UNFORMATTED "*" SKIP.
OUTPUT STREAM expstr CLOSE.
INPUT  STREAM impstr CLOSE.

unix silent rm ok.d*.
{intrface.del}
