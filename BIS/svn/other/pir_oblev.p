{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir_oblev.p,v $ $Revision: 1.8 $ $Date: 2009-08-27 12:09:13 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Причина       : ТЗ от 07.04.2008, Отдел кредитный, Левкин В.В.
Назначение    : Оборотно-сальдовая ведомотость по счетам
Место запуска : КиД/Печать/Оборотно-сальдовая ведомость по счетам.
Автор         : $Author: borisov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.7  2008/09/22 10:02:52  borisov
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.6  2008/09/17 13:51:20  borisov
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.1  2008/05/20 09:36:36  kuntash
Изменения     : razrabotka levkin
Изменения     : Борисов - добавлен бесконечный цикл
Изменения     : Борисов - Выводится имя клиента, а не счета
Изменения     : Борисов - добавлена выгрузка в файл XL

------------------------------------------------------ */

DEFINE VARIABLE suppress AS LOGICAL FORMAT "Да/Нет" INIT YES NO-UNDO.
DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-recid  AS RECID     NO-UNDO.
DEFINE VARIABLE ss       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE Valuta   AS CHARACTER NO-UNDO.
DEFINE STREAM   xl.
DEFINE VARIABLE nFxl     AS INTEGER   NO-UNDO. /* Номер итерации для формирования имени файла */
DEFINE VARIABLE cFxl     AS CHARACTER NO-UNDO. /* Имя файла с номером итерации */
DEFINE VARIABLE cCat     AS CHARACTER NO-UNDO. /* Katalog */

{globals.i}
{tmprecid.def}
{sh-defs.i}

DEFINE temp-table w no-undo
  FIELD branch-id as char
  FIELD name      as char
  FIELD bal       like acct.bal-acct
  FIELD acct      as char
  FIELD acct-cor  as char    initial "" format "x(20)"           column-label "Корресп.счет"
  FIELD currency  as char
  FIELD date      as date              format "99.99.9999"       column-label "ДатаDate" 
  FIELD datec     as CHAR              format "x(14)"            column-label "Дата"  /* для печати только */
  FIELD sort      as char    initial "5"
  FIELD in-ost    as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "Вх.остаток"
  FIELD db        as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "Обороты!ДБ"
  FIELD cr        as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "Обороты!КР"
  FIELD out       as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "Исх.ост."
  index main acct currency date sort
.
DEFINE temp-table ws NO-UNDO /* обороты по счетам для подавления печати счетов с нулевыми оборотами */
  FIELD w-recid  as RECID
  FIELD days-db  as decimal
  FIELD days-cr  as decimal
  index main w-recid
.

{pir_exf_exl.i}
{getdates.i}

MESSAGE "Подавлять пустые сроки ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE suppress.

/*********************************************/
PROCEDURE PrShapka:

  put unformatted "Оборотно-сальдовая ведомость за период с " beg-date " по " end-date skip(2).
  put unformatted "┌────────────────────────────────┬──────────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┐" skip.
  put unformatted "│             КЛИЕНТ             │     Номер счета      │    Вх.остаток   │   Обороты  ДБ   │   Обороты  КР   │     Исх.ост.    │" skip.

  PUT STREAM xl UNFORMATTED XLHead(STRING(nFxl), "CCNNNN", "").
  PUT STREAM xl UNFORMATTED XLRow(0).
  PUT STREAM xl UNFORMATTED XLCell("КЛИЕНТ")     XLCell("Номер счета") XLCell("Вх.остаток")
                            XLCell("Обороты ДБ") XLCell("Обороты КР")  XLCell("Исх.остаток") XLRowEnd().

END PROCEDURE.

PROCEDURE PrZagol:
  DEFINE INPUT PARAMETER c1 AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER c2 AS CHAR NO-UNDO.

  PUT UNFORMATTED "╞════════════════════════════════╪══════════════════════╪═════════════════╪═════════════════╪═════════════════╪═════════════════╡" SKIP.
  PUT UNFORMATTED "│" c1 FORMAT "x(32)"            "│" c2 FORMAT "x(22)"  "│" SPACE (17)    "│" SPACE (17)    "│" SPACE (17)    "│" SPACE (17)    "│" SKIP .

  PUT STREAM xl UNFORMATTED XLRow(2) XLCell(c1) XLCell(c2) XLRowEnd().

END PROCEDURE.

PROCEDURE PrStroka:
  DEFINE INPUT PARAMETER c1 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c2 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c3 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c4 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c5 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c6 AS DECIMAL NO-UNDO.

  PUT UNFORMATTED "├────────────────────────────────┼──────────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP .
  PUT UNFORMATTED "│" c1 FORMAT "x(32)"            "│ " c2 FORMAT "x(21)" "│"
                      string(c3,"->,>>>,>>>,>>9.99") "│"
                      string(c4,"->,>>>,>>>,>>9.99") "│"
                      string(c5,"->,>>>,>>>,>>9.99") "│"
                      string(c6,"->,>>>,>>>,>>9.99") "│" SKIP .

  PUT STREAM xl UNFORMATTED XLRow(0) XLCell(c1) XLCell(c2) XLNumCell(c3)
                            XLNumCell(c4) XLNumCell(c5) XLNumCell(c6) XLRowEnd().
END PROCEDURE.

PROCEDURE PrItogVal:
  DEFINE INPUT PARAMETER c2 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c3 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c4 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c5 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c6 AS DECIMAL NO-UNDO.

  PUT UNFORMATTED "╞════════════════════════════════╪══════════════════════╪═════════════════╪═════════════════╪═════════════════╪═════════════════╡" SKIP.
  PUT UNFORMATTED "│  ИТОГО :                       │" c2 FORMAT "x(22)"  "│"
                   string(c3,"->,>>>,>>>,>>9.99")  "│"
                   string(c4,"->,>>>,>>>,>>9.99")  "│"
                   string(c5,"->,>>>,>>>,>>9.99")  "│"
                   string(c6,"->,>>>,>>>,>>9.99")  "│" SKIP .

  PUT STREAM xl UNFORMATTED XLRow(1) XLCell("  ИТОГО :") XLCell(c2) XLNumCell(c3)
                            XLNumCell(c4) XLNumCell(c5) XLNumCell(c6) XLRowEnd().
END PROCEDURE.

PROCEDURE PrKonec:
  put unformatted "└────────────────────────────────┴──────────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┘" skip.
  PUT STREAM xl UNFORMATTED XLRow(2) XLRowEnd() XLEnd().

END PROCEDURE.

/* переводит неопределенное значение в знак "вопрос" ("?") */
FUNCTION GetNotEmpty CHAR (ipString AS CHAR):
   RETURN (IF (ipString EQ ?) THEN "?" ELSE (IF (ipString EQ "") THEN "--" ELSE ipString)).
END FUNCTION.

/*********************************************/

/* &GLOBAL-DEFINE ONLY-DEF-TABLE YES */
/* {flt-file.i NEW}   Определение таблиц фильтра. */

nFxl = 0.

REPEAT:

  {tempacct.i  &tempacct_i = "YES"}

  FOR EACH tmprecid,
    FIRST acct WHERE (RECID(acct) EQ TmpRecId.id) NO-LOCK:

    RUN acct-pos IN h_base (acct.acct, acct.currency, beg-date, end-date, ?).

    cName = "".

    CASE acct.cust-cat:
       WHEN "Ю" THEN DO:
          FIND cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL cust-corp THEN 
             cName = TRIM(GetNotEmpty(cust-corp.name-short)).
       END.

       WHEN "Ч" THEN DO:
          FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL person THEN
             cName = TRIM(GetNotEmpty(person.name-last)) + " " +
                     TRIM(GetNotEmpty(person.first-names)).
       END.

       WHEN "Б" THEN DO:
          FIND banks WHERE banks.bank-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL banks THEN
             cName = TRIM(GetNotEmpty(banks.short-name)). 
       END.

       WHEN "В" THEN DO:
          cName = "*" + TRIM(acct.Details). 
       END.
    END CASE.

    IF acct.currency = "" THEN DO:
      IF NOT (suppress AND (sh-in-bal eq 0) AND (sh-db eq 0) AND (sh-cr eq 0) AND (sh-bal eq 0)) THEN DO:
        CREATE   w.
        ASSIGN   w.branch   = acct.branch-id
                 w.name     = cName /* substring(cName, 1, 32) */
                 w.bal      = acct.bal-acct
                 w.acct     = acct.acct  
                 w.currency = acct.currency
                 w.date     = beg-date
                 w.datec    = STRING(beg-date)
                 w.sort     = "0"
                 w.in-ost   = sh-in-bal
                 w.db       = sh-db
                 w.cr       = sh-cr
                 w.out      = sh-bal
        .
      END.
    END.
    ELSE
      IF NOT (suppress AND (sh-in-val eq 0) AND (sh-vdb eq 0) AND (sh-vcr eq 0) AND (sh-val eq 0)) THEN DO:
        create   w.
        assign   w.branch   = acct.branch-id
                 w.name     = cName /* substring(cName, 1, 32) */
                 w.bal      = acct.bal-acct
                 w.acct     = acct.acct  
                 w.currency = acct.currency
                 w.date     = beg-date
                 w.datec    = STRING(beg-date)
                 w.sort     = "0"
                 w.in-ost   = sh-in-val
                 w.db       = sh-vdb
                 w.cr       = sh-vcr
                 w.out      = sh-val
        .
      END.
  END. /* FOR EACH tmprecid */

  /* Вывод в поток */

  nFxl = nFxl + 1.
  cFxl = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/po" + STRING(nFxl) + ".xls".

  REPEAT:
     {getfile.i &filename = cFxl &mode = create} 
     LEAVE.
  END.

  OUTPUT STREAM xl THROUGH unix-dos > VALUE(fname).

  {setdest.i &cols=80}

/* Сохранение настроек фильтра. */
/* {flt-attr.sav}
  PUT UNFORMATTED LENGTH(tt-table.tt-value) SKIP.
  PUT UNFORMATTED LENGTH(tt-table.tt-code)  SKIP.
  PUT UNFORMATTED LENGTH(flt-value) SKIP.
  PUT UNFORMATTED LENGTH(flt-code)  SKIP.
*/

  RUN PrShapka.

  FOR EACH w, 
    FIRST acct   WHERE ((acct.acct = w.acct) AND (acct.currency = w.currency)) no-lock 
    BREAK BY w.currency BY w.bal BY w.name:
       
    IF FIRST-OF (w.currency) THEN DO:
      IF (w.currency EQ "") THEN valuta = "RUB".
        ELSE DO:
          FIND currency WHERE (currency.currency EQ w.currency) NO-LOCK NO-ERROR.
          valuta = IF (AVAIL currency) THEN CAPS(currency.i-currency) ELSE "НЕИЗВЕСТНАЯ".
        END.
      RUN PrZagol("  ВАЛЮТА", valuta).
    END.

    IF FIRST-OF (w.bal) THEN
      RUN PrZagol("  БАЛАНСОВЫЙ СЧЕТ", string(w.bal)).

    accumulate w.in-ost   (sub-total by w.bal  by w.currency)
               w.db       (sub-total by w.bal  by w.currency)
               w.cr       (sub-total by w.bal  by w.currency)
               w.out      (sub-total by w.bal  by w.currency)
    . 

    RUN PrStroka(caps(w.name), w.acct, w.in-ost, w.db, w.cr, w.out).

    IF LAST-OF(w.bal) THEN
      RUN PrItogVal("БАЛ.СЧЕТ " + string(w.bal), ACCUM SUB-TOTAL BY w.bal w.in-ost, ACCUM SUB-TOTAL by w.bal w.db,
                                               ACCUM SUB-TOTAL BY w.bal w.cr,     ACCUM SUB-TOTAL by w.bal w.out).

    IF LAST-OF(w.currency) THEN
      RUN PrItogVal("ВАЛЮТА " + valuta, ACCUM SUB-TOTAL by w.currency w.in-ost, ACCUM SUB-TOTAL by w.currency w.db,
                                      ACCUM SUB-TOTAL by w.currency w.cr,     ACCUM SUB-TOTAL by w.currency w.out).

  END. /* FOR EACH w */

  RUN PrKonec.
  OUTPUT STREAM xl CLOSE.

  {preview.i}

  FOR EACH w:
    DELETE w.
  END.

END.

