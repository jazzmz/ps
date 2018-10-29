/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2010 ЗАО "Банковские информационные системы"
     Filename: cjour.i
      Comment: Кассовые журналы 2481-У.
   Parameters:
         Uses:
      Used by:
      Created: 09.10.2010   krok
     Modified: <date> <who>
*/

{globals.i}
{intrface.get acct}
{intrface.get instrum}
{wordwrap.def}
{cjour.def}
&SCOPED-DEFINE stream STREAM ReportStream
DEFINE {&stream}.

/*PIR*/
DEFINE VARIABLE nightkas AS LOGICAL FORMAT "Да/Нет" INITIAL NO  NO-UNDO.
DEFINE VARIABLE nightdate AS DATE   LABEL  "ДАТА ВЕЧЕРНЕЙ КАССЫ"  NO-UNDO.
DEFINE VARIABLE mTotalsByCS AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE mTotalsByUI AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE mKurs AS LOGICAL INITIAL NO NO-UNDO.



{cjour.pro}






/*
{getdate.i &DispAfterDate = "SKIP~
                             ""Итоги по КС:""
                             AT ROW 2 COL 6
                             mTotalsByCS~
                                 LABEL """"~
                                 HELP  ""Подведение итогов в разрезе кассовых символов""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 2 COL 19"
           &UpdAfterDate  = "mTotalsByCS"}
*/
/*PIR*/

{getdate.i &DispAfterDate = "SKIP~
                             ""Курсовая разница""
                             AT ROW 2 COL 6
                             mKurs~
                                 LABEL """"~
                                 HELP  ""Подведение итогов с учетом курсовой разницы""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 2 COL 23			     
                             ""Вечерняя касса""
                             AT ROW 3 COL 6
                             nightkas~
                                 LABEL """"~
                                 HELP  ""Обработка только вечерней и послеоперационных касс""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 3 COL 23"
			     			     
           &UpdAfterDate  = "mKurs nightkas"}

ASSIGN mTotalsByCS = FALSE                         
.


/*message "Вечерняя касса ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.**/
nightdate = end-date.
IF nightkas THEN
DO:
  DISPLAY nightdate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
  SET nightdate WITH FRAME fSetDate.
  HIDE FRAME fSetDate.    
END.
/*PIR end*/

{deskjour.i &user-id   = YES
            &all-currs = YES
            &i2481-tt  = YES
            &DESK_ACCT = {&desk-acct}
            &CLNT_ACCT = {&clnt-acct}}
{setdest.i}
{strtout3.i}
FOR EACH tt-header
EXCLUSIVE-LOCK:

    tt-header.type = {&journal-type}.
    IF {assigned mOKUD} THEN
        tt-header.form-code = mOKUD.
    ELSE
        ASSIGN
            tt-header.form-code = "0401704" WHEN {&journal-type} = "приход"
            tt-header.form-code = "0401705" WHEN {&journal-type} = "расход"
        .

    RUN PrintReport(BUFFER tt-header, mTotalsByCS).
    PAGE {&stream}.
END.
{endout3.i}
{intrface.del}
