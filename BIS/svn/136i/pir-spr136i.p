/*
               Банковская интегрированная система БИСквит
     Filename: ree-136i.p
      Comment: '136-И ' c 01/11/10
*/

FUNCTION StrDate RETURNS CHARACTER
   (INPUT inDat AS DATE):

   DEFINE VARIABLE cTMonths AS CHARACTER EXTENT 12
      INIT [" января ", " февраля ", " марта ", " апреля ", " мая ", " июня ",
            " июля ", " августа ", " сентября ", " октября ", " ноября ", " декабря "] NO-UNDO.

   RETURN STRING(DAY(inDat), "99") + cTMonths[MONTH(inDat)] + STRING(YEAR(inDat), "9999") + " года".
END FUNCTION.
/* -------------------------------------------------------------- */
{globals.i}
DEFINE VARIABLE mKasNum   AS INTEGER NO-UNDO.

/* запрос подразделений и пользователей */
PAUSE 0.
UPDATE
   mKasNum LABEL "Номер реестра     "
   WITH FRAME enter-cond
      WIDTH 60
      SIDE-LABELS
      CENTERED
      ROW 10
      TITLE "[ Выберете подразделение и пользователя ]"
      OVERLAY
   EDITING:

   READKEY.
   APPLY LASTKEY.
END.
HIDE FRAME enter-cond.


FIND _user
   WHERE (_user._userid EQ USERID)
   NO-LOCK NO-ERROR.

{setdest.i &cols=80}

{get-bankname.i}

PUT UNFORMATTED
   SKIP(3)
   "Полное (сокращенное)                " cBankName     SKIP
   "фирменное наименование"                                             SKIP
   "уполномоченного банка"                                              SKIP
   "(наименование филиала)"                                             SKIP(1)
   "Регистрационный номер               " FGetSetting("REGN","","")     SKIP
   "уполномоченного банка"                                              SKIP
   "(порядковый номер филиала)"                                         SKIP(1)
   "Местонахождение (адрес)             " FGetSetting("Адрес_пч","","") SKIP
   "уполномоченного банка"                                              SKIP
   "(филиала)"                                                          SKIP(1)
   "Наименование внутреннего            " cBankName     SKIP
   "структурного подразделения          " FGetSetting("Адрес_пч","","") SKIP
   "уполномоченного банка и его"                                        SKIP
   "местонахождение (адрес)"                                            SKIP(1)
   "Дата заполнения Справки             " gend-date                     SKIP
   "                                    День Месяц Год"                 SKIP(1)
   "Порядковый номер Справки            " STRING(mKasNum)               SKIP
   "в течение рабочего дня"                                             SKIP(2)
   "                                     СПРАВКА"                       SKIP
   "               об отсутствии операций с наличной валютой и чеками." SKIP(3)
   "       В течение рабочего дня " + StrDate(gend-date) + " операции с наличной валютой" SKIP
   "и чеками, подлежащие включению в Реестр (Приложение 1 к Инструкции Банка России"      SKIP
   "от 16.09.2010г. № 136-И), в кассе N " + STRING(mKasNum) + " отсутствовали."           SKIP(7)
   "Кассовый работник      __________________       "
   + ENTRY(1, _user._user-name, " ") + " "
   + SUBSTRING(ENTRY(2, _user._user-name, " "), 1, 1) + "."
   + SUBSTRING(ENTRY(3, _user._user-name, " "), 1, 1) + "." SKIP
   "                           (подпись)" SKIP
.
{preview.i}
