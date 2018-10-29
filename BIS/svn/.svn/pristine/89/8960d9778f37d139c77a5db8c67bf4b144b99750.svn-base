{pirsavelog.p}
/** 
                ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка клиентов(ФЛ) для экспорта .
                Анисимов А.А., 23.10.2007
*/


/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

{sh-defs.i}
{pir_exf_vrt.i}

/******************************************* Определение переменных и др. */
DEF VAR FirstStr AS LOGICAL          NO-UNDO.
DEF VAR cTmpStr  AS CHAR             NO-UNDO. 
DEF VAR symb     AS CHAR INITIAL "-" NO-UNDO.
DEF VAR cNShort  AS CHAR             NO-UNDO. /* Название клиента */
DEF VAR cId      AS CHAR             NO-UNDO.
DEF VAR cDate    AS CHAR             NO-UNDO.
DEF VAR cUser    AS CHAR             NO-UNDO. /* Сотрудник, делавший отчет */
DEF VAR cDolgn   AS CHAR             NO-UNDO. /* его должность             */
DEF VAR cKlb     AS CHAR             NO-UNDO. /* Клиент-банк               */
DEF VAR cAdr     AS CHAR             NO-UNDO. /* Новые адреса              */

{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{exp-path.i &exp-filename = "'fl.xls'"}

/******** Сотрудник, делавший отчет *********************/
FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValueEx("_user", _user._userid, "Должность", "").

/******************************************* Реализация */
PUT UNFORMATTED XLHead("fl", "CCDCDCCCCCCCCCDDDDCCCCCCCCCDDDDDCCCC", ",150").
PUT UNFORMATTED XLRow(0) .

cTmpStr = XLCell("ФИО") +
          XLCell("Счет") +
          XLCell("Дата движения") +
          XLCell("Клиент-банк") +
          XLCell("Дата рождения") +
          XLCell("Место рождения") +
          XLCell("Гражданство") +
          XLCell("Паспортные данные") +
          XLCell("Миграционная карта") +
          XLCell("Виза") +
          XLCell("Виза серия(номер)") +
          XLCell("Виза номер") +
          XLCell("Гражданство по визе") +
          XLCell("Цель Визита") +
          XLCell("Начало визита") +
          XLCell("Конец визита") +
          XLCell("МигрПравПребС") +
          XLCell("МигрПравПребПо") +
          XLCell("Адрес") +
          XLCell("Адрес (старый)") +
          XLCell("Фактический адрес") +
          XLCell("Фактический адрес (старый)") +
          XLCell("ИНН") + 
          XLCell("Телефон") +
          XLCell("Факс") +
          XLCell("Легализация(риск)") +
          XLCell("Оценка риска") +
          XLCell("Дата первого счета") +
          XLCell("Дата начала") +
          XLCell("Дата последнего изменеия") +
          XLCell("Дата открытия счета") +
          XLCell("Дата закрытия счета") +
          XLCell("Работник, открывший счет") +
          XLCell("Должность") +
          XLCell("Работник, составивший отчет") +
          XLCell("Должность").

PUT UNFORMATTED cTmpStr XLRowEnd() .

FOR EACH tmprecid NO-LOCK,
   FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK:

   FirstStr = YES.

   FOR EACH acct WHERE  acct.cust-cat EQ "Ч"  AND 
                        acct.cust-id EQ person.person-id
                        NO-LOCK BREAK BY acct :

   IF VrTest(acct.acct, acct.currency, acct.open-date, acct.close-date)
   THEN DO:

      put screen col 1 row 24 "Обрабатывается " + TRIM(acct.acct) + STRING(" ","X(45)").
      put screen col 77 row 24 "(" + symb + ")" .
      CASE symb :
         WHEN "\\"  THEN symb = "|".
         WHEN "|"   THEN symb = "/".
         WHEN "/"   THEN symb = "-".
         WHEN "-"   THEN symb = "\\".
      END CASE.

      cNShort = person.name-last + " " + person.first-names.
      cId     = STRING(person.person-id).

      /** Найдем Клиент-банк */
      FIND FIRST mail-user WHERE (LOOKUP(acct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
      cKlb = (IF AVAIL mail-user THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").

      PUT UNFORMATTED XLRow(0) .

      IF FirstStr THEN DO:
         cDate = GetXAttrValueEx("person", cId, "FirstAccDate", "").

         cTmpStr = XLCell(cNShort) +
/*                      person.name-last + " " + ENTRY(1, person.first-names, " ") + " " + 
                        (IF NUM-ENTRIES(person.first-names, " ") > 1 THEN ENTRY(2, person.first-names, " ") ELSE "")
*/
                   XLCell(TRIM(acct.acct)) +
                   XLDateCell(lastmove) +
                   XLCell(cKlb) +
                   XLDateCell(person.birthday) +
                   XLCell(GetXAttrValueEx("person", cId, "BirthPlace", "")).

         /** Найдем гражданство */
         FIND FIRST country WHERE country.country-id = person.country-id NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL country THEN country.country-name ELSE "").

         /** Найдем документ */
         FIND FIRST cust-ident
            WHERE cust-ident.cust-cat   = "Ч"
              AND cust-ident.Class-code = "p-cust-ident"
              AND cust-ident.cust-id    = person.person-id
              AND cust-ident.close-date EQ ?
            NO-LOCK NO-ERROR.

/* Отлавливал неправильные договора 03.06.2009
DEFINE VARIABLE cT AS CHARACTER NO-UNDO.
IF AVAIL cust-ident
THEN DO:

   cT = GetCodeName("КодДокум", cust-ident.cust-code-type) + " "
      + cust-ident.cust-code + " выдан "
      + STRING(cust-ident.open-date, "99.99.9999") + " "
      + REPLACE(cust-ident.issue,'\n','').
   IF cT EQ ? THEN
      MESSAGE cNShort SKIP
              GetCodeName("КодДокум", cust-ident.cust-code-type) SKIP
              cust-ident.cust-code SKIP
              STRING(cust-ident.open-date, "99.99.9999") SKIP
              REPLACE(cust-ident.issue,'\n','') SKIP
         VIEW-AS ALERT-BOX ERROR.
END.
*/
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL cust-ident THEN (GetCodeName("КодДокум", cust-ident.cust-code-type) + " " + cust-ident.cust-code
                           + " выдан " + STRING(cust-ident.open-date, "99.99.9999") + " " + REPLACE(cust-ident.issue,'\n','')) ELSE "") +
                   XLCell(GetXAttrValueEx("person", cId, "МигрКарт", "")).

         IF GetCodeName("VisaType", GetXAttrValueEx("person", cId, "VisaType", "")) <> ? THEN 
            cTmpStr = cTmpStr +
                      XLCell(GetCodeName("VisaType",GetXAttrValueEx("person", cId, "VisaType", "")) 
                             + " " + GetXAttrValueEx("person", cId, "Visa", "")) +
                      XLCell(IF NUM-ENTRIES(GetXAttrValueEx("person", cId, "VisaNum", ""), " ") > 1
                             THEN ENTRY(2, GetXAttrValueEx("person", cId, "VisaNum", ""), " ") ELSE " " ) +
                      XLCell(ENTRY(1, GetXAttrValueEx("person", cId, "VisaNum", ""), " ")).
         ELSE
            cTmpStr = cTmpStr +
                      XLEmptyCell() +
                      XLEmptyCell() +
                      XLEmptyCell().

         /** Найдем гражданство по визе */
         FIND FIRST country WHERE country.country-id = GetXAttrValueEx("person", cId, "country-id2", "") NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL country THEN country.country-name ELSE "") +
                   XLCell(GetXAttrValueEx("person", cId, "МигрЦельВизита", "")) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "МигрПребывС", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "МигрПребывПо", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "МигрПравПребС", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "МигрПравПребПо", ""))).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ 'Ч'
              AND cust-ident.cust-id        EQ person.person-id
              AND cust-ident.cust-code-type EQ 'АдрЮр'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(IF person.address[1] = person.address[2] THEN person.address[1] 
                                         ELSE (person.address[1] + "," + person.address[2]), ",")).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ 'Ч'
              AND cust-ident.cust-id        EQ person.person-id
              AND cust-ident.cust-code-type EQ 'АдрФакт'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(GetXAttrValueEx("person", cId, "PlaceOfStay", ""), ",")) +
                   XLCell(person.inn) + 
                   XLCell(TRIM(person.phone[1] + " " + person.phone[2])) +
                   XLCell(person.fax) +
                   XLCell(GetXAttrValueEx("person", cId, "РискОтмыв", "")) +
                   XLCell(if GetCode("PirОценкаРиска", GetXAttrValueEx("person", cId, "ОценкаРиска", "")) = ? 
                          then GetXAttrValueEx("person", cId, "ОценкаРиска", "") 
                          else GetCode("PirОценкаРиска", GetXAttrValueEx("person", cId, "ОценкаРиска", ""))) +
                   XLDateCell(DATE(cDate)) +
                   XLDateCell(DATE(IF cDate = "" THEN GetXAttrValueEx("person", cId, "date-in", "") ELSE cDate)) +
                   XLDateCell(GetLastHistoryDate("person", cId)) .

         FirstStr = NO.
      END.
      ELSE
         cTmpStr = XLCell(cNShort) +
                   XLCell(TRIM(acct.acct)) +
                   XLDateCell(lastmove) +
                   XLCell(cKlb) +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell().

      cTmpStr = cTmpStr +
                XLDateCell(acct.open-date) +
                XLDateCell(acct.close-date).

      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK NO-ERROR.
      IF AVAIL _user THEN 
         cTmpStr = cTmpStr +
                   XLCell(_user._user-name) +
                   XLCell(GetXAttrValueEx("_user", _user._userid, "Должность", "")).
      ELSE
         cTmpStr = cTmpStr +
                   XLEmptyCell() +
                   XLEmptyCell().

      cTmpStr = cTmpStr +
                XLCell(cUser) +
                XLCell(cDolgn).

      PUT UNFORMATTED cTmpStr XLRowEnd().
   END.
   END.
END.

PUT UNFORMATTED XLEnd().

put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
