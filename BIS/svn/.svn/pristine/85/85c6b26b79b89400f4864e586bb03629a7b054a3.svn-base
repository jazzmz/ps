{pirsavelog.p}
/** 
                ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка клиентов(ИП) для экспорта .
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

{exp-path.i &exp-filename = "'ip.xls'"}

/******** Сотрудник, делавший отчет *********************/
FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValueEx("_user", _user._userid, "Должность", "").

/******************************************* Реализация */
PUT UNFORMATTED XLHead("ip", "CCDCDCCCCCCCCCCDDDDCCCCCDCCCCCCCDDDDDCCCC", ",150").
PUT UNFORMATTED XLRow(0) .

cTmpStr = XLCell("Наименование") +
          XLCell("Счет") +
          XLCell("Дата движения") +
          XLCell("Клиент-банк") +
          XLCell("Дата рождения") +
          XLCell("Место рождения") +
          XLCell("Гражданство") +
          XLCell("Лицензия") +
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
          XLCell("ОГРН") +
          XLCell("Дата регистрации") +
          XLCell("Место регистрации") +
          XLCell("ИНН") +
          XLCell("Телефон") +
          XLCell("Факс") +
          XLCell("Легализация(риск)") +
          XLCell("pirOtherBanks") +
          XLCell("Оценка риска") +
          XLCell("Дата первого счета") +
          XLCell("Дата начала") +
          XLCell("Дата последнего изменения") +
          XLCell("Дата открытия счета") +
          XLCell("Дата закрытия счета") +
          XLCell("Работник, открывший счет") +
          XLCell("Должность") +
          XLCell("Работник, составивший отчет") +
          XLCell("Должность").

PUT UNFORMATTED cTmpStr XLRowEnd() .

FOR EACH tmprecid NO-LOCK,
   FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:

   cId = STRING(cust-corp.cust-id).

   IF (cust-corp.cust-stat EQ "ИП") OR 
      (cust-corp.cust-stat EQ "ПБОЮЛ") OR
      (GetXAttrValueEx("cust-corp", cId, "Предприниматель", "") EQ "Предпр")
   THEN DO:

/******************************************* . */
      FirstStr = YES.

      FOR EACH acct WHERE  acct.cust-cat EQ "Ю"  AND 
                           acct.cust-id EQ cust-corp.cust-id
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

         cNShort = cust-corp.name-corp.

         /** Найдем Клиент-банк */
         FIND FIRST mail-user WHERE (LOOKUP(acct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
         cKlb = (IF AVAIL mail-user THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").

         PUT UNFORMATTED XLRow(0) .

         IF FirstStr THEN DO:
            cDate = STRING(DATE(GetXAttrValueEx("cust-corp", cId, "FirstAccDate", "")),"99.99.9999").
            cTmpStr = XLCell(cust-stat + " " + TRIM(ENTRY(1, cNShort, " ") + " " +
                         (IF NUM-ENTRIES(cNShort, " ") > 1 THEN (ENTRY(2, cNShort, " ") + " ") ELSE "") +
                         (IF NUM-ENTRIES(cNShort, " ") > 2 THEN ENTRY(3, cNShort, " ") ELSE ""))) +
                      XLCell(TRIM(acct.acct)) +
                      XLDateCell(lastmove) +
                      XLCell(cKlb) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "BirthDay", ""))) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "BirthPlace", "")).

            /** Найдем гражданство */
            FIND FIRST country WHERE country.country-id = cust-corp.country-id NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL country THEN country.country-name ELSE "").

            /** найдем первую лицензию  */
            FIND FIRST cust-ident WHERE cust-ident.cust-cat EQ "Ю"
                                    AND cust-ident.cust-id  EQ cust-corp.cust-id
                                    AND cust-ident.class-code = "cust-lic" NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL cust-ident THEN
                              (GetCodeName("ВидЛицДеят", cust-ident.cust-code-type) + " " +
                               cust-ident.cust-code + " " + STRING(cust-ident.open-date, "99.99.9999") + " " +
                               cust-ident.issue     + " " + STRING(cust-ident.close-date,"99.99.9999")) ELSE "").

            /** Найдем документ */
            cTmpStr = cTmpStr +
                      XLCell((IF GetXAttrValueEx("cust-corp", cId, "document-id", "") <> "" 
                               THEN GetCodeName("КодДокум", GetXAttrValueEx("cust-corp", cId, "document-id", "")) 
                               ELSE " ") + " " + 
                              GetXAttrValueEx("cust-corp", cId, "document", "") + " выдан " +
                              (IF DATE(GetXAttrValueEx("cust-corp", cId, "Document4Date_vid", "")) EQ ? 
                               THEN " " 
                               ELSE STRING(DATE(GetXAttrValueEx("cust-corp", cId, "Document4Date_vid", "")), "99.99.9999")) + " " +
                              GetXAttrValueEx("cust-corp", cId, "issue", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "МигрКарт", "")).

            IF GetCodeName("VisaType", GetXAttrValueEx("cust-corp", cId, "VisaType", "")) <> ? THEN 
            cTmpStr = cTmpStr +
                      XLCell(GetCodeName("VisaType",GetXAttrValueEx("cust-corp", cId, "VisaType", "")) 
                              + " " + GetXAttrValueEx("cust-corp", cId, "Visa", "")) +
                      XLCell(IF NUM-ENTRIES(GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ") > 1 
                              THEN ENTRY(2, GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ") 
                              ELSE " " ) +
                      XLCell(ENTRY(1, GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ")).
            ELSE
            cTmpStr = cTmpStr +
                      XLEmptyCell() +
                      XLEmptyCell() +
                      XLEmptyCell().

            /** Найдем гражданство по визе */
            FIND FIRST country WHERE country.country-id = GetXAttrValueEx("cust-corp", cId, "country-id2", "") NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL country THEN country.country-name ELSE "") +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "МигрЦельВизита", "")) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "МигрПребывС", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "МигрПребывПо", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "МигрПравПребС", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "МигрПравПребПо", ""))).

            FIND FIRST cust-ident WHERE
                     cust-ident.cust-cat       EQ 'Ю'
                 AND cust-ident.cust-id        EQ cust-corp.cust-id
                 AND cust-ident.cust-code-type EQ 'АдрЮр'
                 AND cust-ident.class-code     EQ "p-cust-adr"
                 AND cust-ident.close-date     EQ ?
            NO-ERROR.
            cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

            cTmpStr = cTmpStr +
                      XLCell(cAdr) +
                      XLCell(DelDoubleChars((IF cust-corp.addr-of-low[1] = cust-corp.addr-of-low[2] 
                              THEN cust-corp.addr-of-low[1] ELSE cust-corp.addr-of-low[1] + "," + cust-corp.addr-of-low[2]),",")).

            FIND FIRST cust-ident WHERE
                     cust-ident.cust-cat       EQ 'Ю'
                 AND cust-ident.cust-id        EQ cust-corp.cust-id
                 AND cust-ident.cust-code-type EQ 'АдрФакт'
                 AND cust-ident.class-code     EQ "p-cust-adr"
                 AND cust-ident.close-date     EQ ?
            NO-ERROR.
            cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

            cTmpStr = cTmpStr +
                      XLCell(cAdr) +
                      XLCell(DelDoubleChars(GetXAttrValueEx("cust-corp", cId, "PlaceOfStay", ""),",")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "ОГРН", "")) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "RegDate", ""))) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "RegPlace", "")) +
                      XLCell(cust-corp.inn) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "tel", "")) +
                      XLCell(cust-corp.fax) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "РискОтмыв", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "pirOtherBanks", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "ОценкаРиска", "")) +
                      XLDateCell(DATE(cDate)) +
                      XLDateCell(IF cDate = "" THEN cust-corp.date-in ELSE DATE(cDate)) +
                      XLDateCell(GetLastHistoryDate("cust-corp", cId)).

            FirstStr = NO.    
         END.
         ELSE DO:
            cTmpStr = XLCell(cust-stat + " " + TRIM(ENTRY(1, cNShort, " ") + " " +
                         (IF NUM-ENTRIES(cNShort, " ") > 1 THEN (ENTRY(2, cNShort, " ") + " ") ELSE "") +
                         (IF NUM-ENTRIES(cNShort, " ") > 2 THEN ENTRY(3, cNShort, " ") ELSE ""))) +
                      XLCell(TRIM(acct.acct)) +
                      XLDateCell(lastmove) +
                      XLCell(cKlb) +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell().
         END.

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
END.

PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

{intrface.del}
