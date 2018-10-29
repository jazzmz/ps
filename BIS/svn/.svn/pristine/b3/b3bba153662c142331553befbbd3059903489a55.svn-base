{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: ved-acct.p
      Comment: Ведомости расчетных счетов (открытых, не работающих более года,
               счетов, по кот. осуществл. только безнал. операции
   Parameters:  - если "РасчСчета", то ведомость расчетных счетов
                      - если "НеРабСчета", то счета, не работающие более года
                      - если "РСчетаБезнал", то открытые счета только с безналич.
                        операциями
         Uses:
      Used by:
      Created: 17/04/1003 kolal (из pos-nal2.p)
     Modified: 17/04/2003 kolal Заявка 13134.
     Modified: 16/07/2003 kolal Исправлено простановка поля "телефон". Заявка 13134.
     Modified: 24/05/2004 ABKO 28659 - изменена сортировка для "НеРабСчета","РСчетаБезнал"
     Modified: 12/01/2006 kraw (0056474) "НеРабСчета" теперь названия печатаются правильно
     Modified: 27.04.2006 TSL  Корректный доступ к данным фильтра счетов
*/
&SCOP DEFAULT_MASK "401*,402*,403*,404*,405*,406*,407*,408*,409*,42*"
DEFINE INPUT PARAMETER iParam AS CHARACTER NO-UNDO. /* Строка входных параметров */

{globals.i}             /* Глобальные переменные сессии. */
{flt-val.i}    
{tmprecid.def}          /* Таблица отметок. */

DEFINE VARIABLE mCustName AS CHARACTER /* Наименование клиента */
   FORMAT "x(40)"
   EXTENT 10
   NO-UNDO.
DEFINE VARIABLE mIndex        AS INTEGER NO-UNDO. /* Счетчик для вывода полного
                                                 имени клиента */
DEFINE VARIABLE mBegDate      AS DATE    NO-UNDO. /* Начальная дата для остатков */
DEFINE VARIABLE mLastMove     AS DATE    NO-UNDO. /* Дата последнего движения */
DEFINE VARIABLE mKassAcct     AS CHARACTER INIT "202*,406*" NO-UNDO.
                                              /* Маска счета для проверки
                                                 наличных операций */
DEFINE VARIABLE mBalAcctMask  AS CHARACTER NO-UNDO. /**/
DEFINE VARIABLE mTelephone    AS CHARACTER NO-UNDO. /* телефон клиента */
DEFINE VARIABLE mOst          AS DEC NO-UNDO.
DEFINE VARIABLE mCountOst          AS DEC NO-UNDO.

DEFINE VARIABLE mCurrBalAcct  AS INTEGER NO-UNDO. /* Текущее значение для fbal-acct */
DEFINE VARIABLE mCountBalAcct AS INTEGER NO-UNDO. /* Счетчик счетов а группе */
DEFINE VARIABLE mCountAll     AS INTEGER NO-UNDO. /* Счетчик счетов */
DEFINE var      mAll          as logical no-undo.

DEFINE TEMP-TABLE tmprwd
   FIELD fBal-acct AS INTEGER /* Счет 1-го порядка */
   FIELD fRwd      AS ROWID   /* Для выбора по фильтру */
   FIELD fName     AS CHAR    /* Для сортировки */
  INDEX idxB fBal-acct.

{getdate.i}
{wordwrap.def}
{sh-defs.i}

mCountOst = 0.

/* Редактируем маску */
IF iParam = "РСчетаБезнал" THEN
DO:
   PAUSE 0.
   DO
      ON ERROR UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE
      WITH FRAME KassAcctFrame:

      UPDATE
         mKassAcct FORMAT "x(100)"
            LABEL "Счета наличных операций"
            HELP  "Введите маску для счетов наличных операций"
            VIEW-AS FILL-IN SIZE 20 BY 1
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS
         COLOR messages TITLE "[ ЗАДАЙТЕ МАСКУ СЧЕТОВ ]"
      EDITING:
         READKEY.
         APPLY LASTKEY.
      END.
   END.

   HIDE FRAME KassAcctFrame NO-PAUSE.

   IF KEYFUNC(LASTKEY) = "end-error" THEN
      RETURN.
END.

/* Выборка в списке счетов может быть открыта
   не с той сортировкой, или по ДР.
   Поэтому перекинем все в ТТ                   */
mBalAcctMask = IF GetFltVal("bal-acct") NE "*"
               THEN GetFltVal("bal-acct")
               ELSE {&DEFAULT_MASK}.

                        /* Формируем счета для отчета. */
FOR EACH TmpRecId,
FIRST acct WHERE
         RECID (acct) EQ TmpRecId.id
   AND   CAN-DO (mBalAcctMask, STRING(acct.bal-acct))
NO-LOCK:
   CREATE tmprwd.
   ASSIGN
      tmprwd.fRwd       = ROWID (acct)
      tmprwd.fBal-acct  = INT (SUBSTRING (STRING (acct.bal-acct), 1, 3))
   .
END.

DEFINE NEW GLOBAL SHARED VARIABLE usr-printer LIKE PRINTER.PRINTER NO-UNDO.
/* Из setdest.i для избежания повторного определения */
IF iParam = "РасчСчета" THEN
DO:
   {setdest.i &nodef="/*" &cols=120}
END.
ELSE
DO:
   {setdest.i &nodef="/*" &cols=68}
END.

PUT UNFORMATTED name-bank SKIP(1).
CASE iParam:
   WHEN "РасчСчета" THEN
      PUT UNFORMATTED
         "Ведомость расчетных счетов на которые не правильно открыты Договора на " + STRING(end-date,"99/99/9999") SKIP.
   WHEN "НеРабСчета" THEN
      PUT UNFORMATTED
         "Ведомость счетов, не работающих более года на " + STRING(end-date,"99/99/9999") SKIP.
   WHEN "РСчетаБезнал" THEN
      PUT UNFORMATTED
         "Ведомость счетов предприятий, по счетам которых осуществляются операции" SKIP
         "в безналичном порядке и не осуществляются операции с наличными деньгами" SKIP
         "на " + STRING(end-date,"99/99/9999") SKIP.
END CASE.

IF iParam = "РасчСчета" THEN
   PUT UNFORMATTED "╒═════════════════════════╤════════════════════════════════════════╤════════╤═══════════════╤══════════════════════════╕" SKIP
                   "│     Расчетный счет      │        Наименование клиента            │ Открыт │    Статус     │   Остаток на счете       │" SKIP
                   "╞═════════════════════════╪════════════════════════════════════════╪════════╪═══════════════╪══════════════════════════╡" SKIP.
ELSE
   PUT UNFORMATTED "╒═════════════════════════╤════════════════════════════════════════╕" SKIP
                   "│     Расчетный счет      │        Наименование клиента            │" SKIP
                   "╞═════════════════════════╪════════════════════════════════════════╡" SKIP.

IF iParam = "РасчСчета" THEN
DO:
mAll = no.
FOR EACH tmprwd,
   FIRST acct WHERE ROWID(acct) = tmprwd.fRwd
                AND (acct.close-date GT end-date
                OR   acct.close-date EQ ?)
      NO-LOCK /*,
   each loan where  loan.cont-code EQ acct.acct
      no-lock*/
   BREAK BY tmprwd.fBal-acct:
   
  
/*		FIND FIRST loan where  loan.cust-id = acct.cust-id and
		                       loan.cont-code EQ acct.acct
		                       use-index loan-cust
		                          no-lock no-error.

			IF AVAIL loan then next.  */
			
			 FIND FIRST loan-acct where  loan-acct.acct EQ acct.acct and
			 														 loan-acct.contract eq "dps"
		                               use-index acct
		                               no-lock no-error.

			IF AVAIL loan-acct then 
			do:
			IF loan-acct.cont-code EQ loan-acct.acct and acct.branch-id = "0000" then next.            
			else mAll = yes.
		  end.
		  
   /* Доп. условия отбора */
/* message "" loan-acct.cont-code loan-acct.acct loan-acct.acct-type loan-acct.contract mAll.*/
  IF mCurrBalAcct <> tmprwd.fBal-acct THEN
   DO:
      IF mCountBalAcct NE 0 THEN
      DO:
         PUT UNFORMATTED
"├─────────────────────────┼────────────────────────────────────────┼────────┼───────────────┼──────────────────────────┤" SKIP.
         PUT UNFORMATTED "│" +
                         FILL(" ", 25) +
                         "│    Итого по счетам " +
                         STRING(mCurrBalAcct, "999") +
                         ": " +
                         STRING(mCountBalAcct, ">>>>9") +
                         " счетов   " +
                         "│" +
                         FILL(" ", 8) +
                         "│" +
                         FILL(" ", 15) +
                         "│                          │"
                         SKIP.
         PUT UNFORMATTED
"├─────────────────────────┼────────────────────────────────────────┼────────┼───────────────┼──────────────────────────┤" SKIP.
      END.
      ASSIGN
         mCurrBalAcct = tmprwd.fBal-acct
         mCountBalAcct = 0
      .
   END.

 
   {getcust.i &name="mCustName" &OFFinn = "/*"}
   mCustName[1] = mCustName[1] + " " + mCustName[2].
   {wordwrap.i &s=mCustName &n=10 &l=40}

  
         FIND person WHERE person.person-id = acct.cust-id
            NO-LOCK
            NO-ERROR.
         IF AVAIL person THEN
         DO:
            mTelephone = person.phone[1].
            IF    mTelephone = ?
               OR mTelephone = "" THEN
               mTelephone = person.phone[2].
            IF    mTelephone = ?
               OR mTelephone = "" THEN
               mTelephone = person.fax.
         END.
         IF    mTelephone = ?
            OR mTelephone = "" THEN
            mTelephone = "".
   
       IF mAll = yes then mTelephone = "НЕ КОРРЕКТЕН". else mTelephone = "ОТСУТСТВУЕТ".
       IF acct.branch-id ne "0000" then mTelephone = "КОД ПОДРАЗДЕЛЕНИЯ".
       run acct-pos IN h_base (acct.acct, acct.currency, end-date, end-date, ?).
       mOst = abs(if acct.currency eq ""
                           then sh-bal
                           else sh-val).
    /*   if mOst = 0 then next.*/
       
    ASSIGN
      mCountBalAcct = mCountBalAcct + 1
      mCountAll = mCountAll + 1
      mCountOst = mCountOst + mOst.
   .
     
   PUT UNFORMATTED "│" +
                   STRING(acct.acct, "x(25)") +
                   "│" +
                   STRING(mCustName[1], "x(40)") +
                   "│" +
                   STRING(acct.open-date, "99/99/99") +
                   "│" +
                   STRING(mTelephone, "x(15)") +
                   "│" +
                   STRING(mOst,">>>,>>>,>>>,>>>,>>>,>>9.99") +            
                   "│"
                   SKIP.

   mIndex = 2.
   DO WHILE mCustName[mIndex] NE ""
      AND mIndex LE 10 :
      PUT UNFORMATTED "│" +
                      FILL(" ", 25) +
                      "│" +
                      STRING(mCustName[mIndex], "x(40)") +
                      "│" +
                      FILL(" ", 8) +
                      "│" +
                      FILL(" ", 15) +
                      "│                          │"
                      SKIP.
      mIndex = mIndex + 1.
   END.

END.
END.

IF mCountBalAcct GT (IF iParam EQ "РасчСчета" THEN 0 ELSE 1) THEN
DO:
   PUT UNFORMATTED (IF iParam EQ "РасчСчета" THEN
"├─────────────────────────┼────────────────────────────────────────┼────────┼───────────────┼──────────────────────────┤"
                    ELSE
"├─────────────────────────┼────────────────────────────────────────┤") SKIP.
   PUT UNFORMATTED (IF iParam = "РасчСчета" THEN
                       "│" +
                       FILL(" ", 25) +
                       "│    Итого по счетам " +
                       STRING(mCurrBalAcct, "999") +
                       ": " +
                       STRING(mCountBalAcct, ">>>>9") +
                       " счетов   " +
                       "│" +
                       FILL(" ", 8) +
                       "│" +
                       FILL(" ", 15) +
                       "│" +
                       STRING(mCountOst,">>>,>>>,>>>,>>>,>>>,>>9.99") +
                       "│"
                    ELSE "│" +
                         FILL(" ", 25) +
                         "│    Итого счетов : " +
                         STRING(mCountBalAcct, ">>>>9") +
                         FILL(" ", 16) +
                         "│"
                   ) SKIP.
 
   PUT UNFORMATTED (IF iParam = "РасчСчета" THEN
"└─────────────────────────┴────────────────────────────────────────┴────────┴───────────────┴──────────────────────────┘"
                    ELSE
"└─────────────────────────┴────────────────────────────────────────┘") SKIP.
END.
/*
PUT UNFORMATTED (IF iParam = "РасчСчета" THEN
"├─────────────────────────┼────────────────────────────────────────┼────────┼───────────────┼──────────────────────────┤"
                       ELSE
"├─────────────────────────┼────────────────────────────────────────┤") SKIP.
END.
*/
{signatur.i}
{preview.i}
