{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{ulib.i}

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE INPUT PARAMETER iStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cXL   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCat  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iI    AS INTEGER   NO-UNDO.

{getdate.i}

{pir_exf_exl.i}
/*
{exp-path.i &exp-filename = "'ul.xls'"}
*/
cXL = STRING(YEAR(end-date)) + STRING(MONTH(end-date), "99") + STRING(DAY(end-date), "99").
cXL = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/OST" + cXL + ".xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create}
   LEAVE.
END.

/******************************************* Реализация */
PUT UNFORMATTED XLHead("ul", "ICCCNCCCC", "38,150,30,150,110,300,50,30,95").

cXL = XLCell("Информация об остатках на лицевых счетах по состоянию на " + STRING(end-date, "99.99.9999")).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

cXL = XLCell("N п/п")
    + XLCell("Лицевой счет")
    + XLCell("А/П")
    + XLCell("Наименование клиента")
    + XLCell("Сумма, руб")
    + XLCell("Мотивированное суждение о характере операции")
    + XLCell("Отнесение к требованиям КО/ЮЛ/ФЛ")
    + XLCell("Категория качества")
    + XLCell("Срок возврата")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

iI = 1.

FOR EACH tmprecid 
   NO-LOCK,
   FIRST acct
      WHERE RECID(acct) EQ tmprecid.id
   NO-LOCK
   BY acct.acct:

   RUN acct-pos IN h_base(acct.acct, acct.currency, end-date, end-date, cXL).

   cCat = IF (acct.cust-cat NE "В") THEN acct.cust-cat
                                    ELSE GetXAttrValue("acct", acct.acct + "," + acct.currency, "ТипКл").
   CASE cCat:
      WHEN "Ю" THEN cCat = "ЮЛ".
      WHEN "Ч" THEN cCat = "ФЛ".
      WHEN "Б" THEN cCat = "КО".
      OTHERWISE     cCat = "".
   END CASE.

   IF NOT ((iStr      EQ "НЕТ")
       AND (sh-in-bal EQ 0))
   THEN DO:
      cXL = XLNumCell(iI)
          + XLCell(acct.acct)
          + XLCell(acct.side)
          + XLCell(GetAcctClientName_UAL(acct.acct, NO))
          + XLNumCell(sh-in-bal)
          + XLCell(acct.details)
          + XLCell(cCat)
          + XLCell(GetXAttrValue("acct", acct.acct + "," + acct.currency, "ГрРиска"))
          .
      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

      iI = iI + 1.
   END.
END.

FIND FIRST _user
   WHERE (_user._userid = USERID)
   NO-LOCK NO-ERROR.

IF AVAIL _user
THEN DO:
   cXL = XLCell("Исполнитель  ______________________________ / "
       + SUBSTRING(ENTRY(2, _user._user-name, " "), 1, 1) + "."
       + SUBSTRING(ENTRY(3, _user._user-name, " "), 1, 1) + "."
       +           ENTRY(1, _user._user-name, " ")        + " /").
   PUT UNFORMATTED XLRow(0)     XLRowEnd().
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
END.

PUT UNFORMATTED XLEnd().

{intrface.del}
