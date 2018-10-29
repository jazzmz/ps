{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: book4.p
      Comment: Ведомость открытия/закрытия лицевых счетов
               (с INN и запросом периода)
   Parameters:
         Uses:
      Used by:
      Created: 28.12.1997 Olenka
     Modified: 30.10.2001 NIK Неверное формирование 8 колонки
     Modified: 27.01.2004 kraw (0022373)
*/

{globals.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

DEFINE BUFFER prevpos FOR acct-pos.

DEFINE VARIABLE i AS INTEGER NO-UNDO.

DEFINE VARIABLE in-name       AS CHARACTER FORMAT "x(35)" EXTENT 2  NO-UNDO.
DEFINE VARIABLE name          AS CHARACTER                EXTENT 10 NO-UNDO.
DEFINE VARIABLE col1          AS CHARACTER FORMAT "x(16)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col2          AS CHARACTER FORMAT "x(40)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col3          AS CHARACTER FORMAT "x(18)"           NO-UNDO.
DEFINE VARIABLE col4          AS CHARACTER FORMAT "x(20)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col5          AS CHARACTER FORMAT "x(15)"           NO-UNDO.
DEFINE VARIABLE col6          AS CHARACTER FORMAT "x(15)"           NO-UNDO.
DEFINE VARIABLE ppnum         AS INTEGER   FORMAT ">>>>9"           NO-UNDO.
DEFINE VARIABLE mCustCat2     AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE mSewMode      AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE mBalAcNewPage AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE mAcct      AS CHARACTER                          NO-UNDO.

DEFINE VARIABLE cAcctCloseDate AS CHARACTER INITIAL "".

DEF VAR filePath AS CHAR NO-UNDO.

{book1par.def &inpar="iParmStr"}

{acc-file.i &file=acct}

{chkacces.i}
{wordwrap.def}
{getdate.i}
{op-flt.i new}

/* запрос типа сшива */
RUN messmenu.p(
       10,
       "[Типы счетов]",
       "",
       "Все," +
       "Юридические," +
       "Физические," +
       "Внутрибанковские"
).
CASE INTEGER(pick-value):
   WHEN 1 THEN mSewMode = "".
   WHEN 2 THEN mSewMode = "Ю".
   WHEN 3 THEN mSewMode = "Ч".
   WHEN 4 THEN mSewMode = "В".
   OTHERWISE RETURN.
END CASE.

/* флаг печати заголовка на новой странице для каждого бал.счета */
mBalAcNewPage = GetParamByNameAsChar(iParmStr, "БалСчНовСтр", "Нет") EQ "Да".
filePath = GetParamByNameAsChar(iParmStr, "Путь", mAcct).
mAcct    = GetParamByNameAsChar(iParmStr, "Счет", mAcct).



{pir_bookacct2.i }