{pirsavelog.p}
/** 
                ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка клиентов(Банков) для экспорта .
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
DEF VAR cAdr     AS CHAR             NO-UNDO. /* Новые адреса              */

{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{exp-path.i &exp-filename = "'bnk.xls'"}

/******** Сотрудник, делавший отчет *********************/
FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValueEx("_user", _user._userid, "Должность", "").

/******************************************* Реализация */
PUT UNFORMATTED XLHead("bnk", "CCDCCCCDCCCCCCCCCCCCCCCCCDDDDDCCCC", ",150").
PUT UNFORMATTED XLRow(0) .

cTmpStr = XLCell("Наименование") +
          XLCell("Счет") +
          XLCell("Дата движения") +
          XLCell("Сокращенное наименование") +
          XLCell("Английское наименование") +
          XLCell("Орган.прав.форма") +
          XLCell("ОГРН") +
          XLCell("Дата регистрации") +
          XLCell("Место регистрации") +
          XLCell("Юридический адрес") +
          XLCell("Юридический адрес (старый)") +
          XLCell("Фактический адрес") +
          XLCell("Фактический адрес (старый)") +
          XLCell("Телефон") +
          XLCell("Факс") +
          XLCell("ИНН") +
          XLCell("Лицензия") +
          XLCell("БИК") +
          XLCell("ОКПО") +
          XLCell("ИИН") +
          XLCell("Структура") +
          XLCell("Капитал") +
          XLCell("Присутствие органа управления") +
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
   FIRST banks WHERE RECID(banks) = tmprecid.id NO-LOCK:

   FirstStr = YES.

   FOR EACH acct WHERE  acct.cust-cat EQ "Б"  AND
                        acct.cust-id EQ banks.bank-id
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

      cNShort = banks.name.
      cId     = STRING(banks.bank-id).
      PUT UNFORMATTED XLRow(0) .
      IF FirstStr THEN DO:

         cDate = GetXAttrValueEx("banks", cId, "FirstAccDate", "").
         cTmpStr = XLCell(cNShort) +
                   XLCell(TRIM(acct.acct)) +
                   XLDateCell(lastmove) +
                   XLCell(banks.short-name) +
                   XLCell(GetXAttrValueEx("banks", cId, "engl-name", "")) +
                   XLCell(GetCodeName("КодПредп", GetXAttrValueEx("banks", cId, "bank-stat", ""))) +
                   XLCell(GetXAttrValueEx("banks", cId, "ОГРН", "")) +
                   XLDateCell(DATE(GetXAttrValueEx("banks", cId, "RegDate", ""))) +
                   XLCell(GetXAttrValueEx("banks", cId, "RegPlace", "")).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ 'Б'
              AND cust-ident.cust-id        EQ banks.bank-id
              AND cust-ident.cust-code-type EQ 'АдрЮр'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(banks.law-address, "," )).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ 'Б'
              AND cust-ident.cust-id        EQ banks.bank-id
              AND cust-ident.cust-code-type EQ 'АдрФакт'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(banks.mail-address, "," )) +
                   XLCell(GetXAttrValueEx("banks", cId, "tel", "")) +
                   XLCell(GetXAttrValueEx("banks", cId, "fax", "")).

         /** Найдем ИНН и БИК */
         FIND FIRST cust-ident WHERE cust-ident.cust-cat = "Б" 
                               AND   cust-ident.cust-id  = banks.bank-id
                               AND   cust-ident.cust-code-type = "ИНН"    NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL cust-ident THEN cust-ident.cust-code ELSE "").

         /** найдем первую лицензию  */
         FIND FIRST cust-ident WHERE cust-ident.cust-cat EQ "Б"
                               AND   cust-ident.cust-id  EQ banks.bank-id 
                               AND   cust-ident.class-code = "cust-lic"   NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL cust-ident THEN
                           (GetCodeName("ВидБанкЛиц", cust-ident.cust-code-type) + " " +
                            cust-ident.cust-code + " " + STRING(cust-ident.open-date,"99.99.9999") + " " + 
                            cust-ident.issue + " " + STRING(cust-ident.close-date,"99.99.9999")) ELSE "").

        FIND FIRST banks-code WHERE banks-code.bank-id = banks.bank-id AND banks-code.bank-code-type = "МФО-9" NO-LOCK NO-ERROR.
        cTmpStr = cTmpStr +
                  XLCell(IF AVAIL banks-code THEN banks-code.bank-code ELSE "") +
                  XLCell(GetXAttrValueEx("banks", cId, "okpo", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "ИИН", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "СтруктОрг", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "УставКап", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "ПрисутОргУправ", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "РискОтмыв", "")) +
                  XLCell(GetXAttrValueEx("banks", cId, "ОценкаРиска", "")) +
                  XLDateCell(DATE(cDate)) +

                  XLDateCell(DATE(IF cDate = "" THEN GetXAttrValueEx("banks", cId, "date-in", "") ELSE cDate)) +
                  XLDateCell(GetLastHistoryDate("banks", cId)).

                  FirstStr = NO.
        END.
      ELSE DO:
        cTmpStr = XLCell(cNShort) +
                  XLCell(TRIM(acct.acct)) +
                  XLDateCell(lastmove) +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                  XLEmptyCell().
      END.

      cTmpStr = cTmpStr +
                XLDateCell(acct.open-date) +
                XLDateCell(acct.close-date).

      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK NO-ERROR.
      cTmpStr = cTmpStr +
                XLCell(IF AVAIL _user THEN _user._user-name ELSE "") +
                XLCell(IF AVAIL _user THEN GetXAttrValueEx("_user", _user._userid, "Должность", "") ELSE "").

      cTmpStr = cTmpStr +
                XLCell(cUser) +
                XLCell(cDolgn).

      PUT UNFORMATTED cTmpStr XLRowEnd() .
   END.
   END.
END.

PUT UNFORMATTED XLEnd().

put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
