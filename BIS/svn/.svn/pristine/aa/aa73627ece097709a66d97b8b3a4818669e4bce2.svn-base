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
{get-bankname.i}
DEFINE BUFFER prevpos FOR acct-pos.

DEFINE VARIABLE i AS INTEGER NO-UNDO.

DEFINE VARIABLE in-name       AS CHARACTER FORMAT "x(35)" EXTENT 2  NO-UNDO.
DEFINE VARIABLE name          AS CHARACTER                EXTENT 10 NO-UNDO.
DEFINE VARIABLE acct-surr     AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE col1          AS CHARACTER FORMAT "x(16)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col2          AS CHARACTER FORMAT "x(40)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col3          AS CHARACTER FORMAT "x(18)"           NO-UNDO.
DEFINE VARIABLE col4          AS CHARACTER FORMAT "x(20)" EXTENT 10 NO-UNDO.
DEFINE VARIABLE col5          AS CHARACTER FORMAT "x(15)"           NO-UNDO.
DEFINE VARIABLE col6          AS CHARACTER FORMAT "x(17)"           NO-UNDO.
DEFINE VARIABLE ppnum         AS INTEGER   FORMAT ">>>>9"           NO-UNDO.
DEFINE VARIABLE mCustCat2     AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE mSewMode      AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE mBalAcNewPage AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE mAcct	      AS CHARACTER                          NO-UNDO.	
DEFINE VARIABLE mIskl	      AS CHARACTER                          NO-UNDO.

{book1par.def &inpar="iParmStr"}

{acc-file.i &file=acct}

{chkacces.i}
{wordwrap.def}
{getdates.i}
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
   WHEN 1 THEN  mSewMode = "".
   WHEN 2 THEN mSewMode = "Ю".
   WHEN 3 THEN mSewMode = "Ч".
   WHEN 4 THEN mSewMode = "В".
   OTHERWISE RETURN.
END CASE.

/* флаг печати заголовка на новой странице для каждого бал.счета */
mBalAcNewPage = GetParamByNameAsChar(iParmStr, "БалСчНовСтр", "Нет") EQ "Да".
/*mAcct = GetParamByNameAsChar(iParmStr,"Счет", mAcct).*/
mIskl = GetParamByNameAsChar(iParmStr, "Искл", mIskl).

FORM
   mAcct	FORMAT "X(60)"	LABEL  "Маски счетов"	HELP   "Маски счетов"
WITH FRAME fSet0 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ МАСКИ СЧЕТОВ ДЛЯ КНИГИ ]".

ON F1 OF mAcct DO:
   IF ( LASTKEY EQ 13  OR LASTKEY EQ 10)  AND pick-value NE ?  THEN 
	FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.

PAUSE 0.
UPDATE	mAcct   WITH FRAME fSet0.
HIDE FRAME fSet0 NO-PAUSE.
IF NOT ( KEYFUNC(LASTKEY) EQ "GO" OR KEYFUNC(LASTKEY) EQ "RETURN") THEN LEAVE.

{setdest.i &cols=220}

{pir_book5v.i "ОТ" "open" }
{pir_book5v.i "ЗА" "close" }

{preview.i}
