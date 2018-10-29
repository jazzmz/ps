/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2010 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: cjour.i
      Comment: ���ᮢ� ��ୠ�� 2481-�.
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
DEFINE VARIABLE nightkas AS LOGICAL FORMAT "��/���" INITIAL NO  NO-UNDO.
DEFINE VARIABLE nightdate AS DATE   LABEL  "���� �������� �����"  NO-UNDO.
DEFINE VARIABLE mTotalsByCS AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE mTotalsByUI AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE mKurs AS LOGICAL INITIAL NO NO-UNDO.



{cjour.pro}






/*
{getdate.i &DispAfterDate = "SKIP~
                             ""�⮣� �� ��:""
                             AT ROW 2 COL 6
                             mTotalsByCS~
                                 LABEL """"~
                                 HELP  ""���������� �⮣�� � ࠧ१� ���ᮢ�� ᨬ�����""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 2 COL 19"
           &UpdAfterDate  = "mTotalsByCS"}
*/
/*PIR*/

{getdate.i &DispAfterDate = "SKIP~
                             ""���ᮢ�� ࠧ���""
                             AT ROW 2 COL 6
                             mKurs~
                                 LABEL """"~
                                 HELP  ""���������� �⮣�� � ��⮬ ���ᮢ�� ࠧ����""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 2 COL 23			     
                             ""������ ����""
                             AT ROW 3 COL 6
                             nightkas~
                                 LABEL """"~
                                 HELP  ""��ࠡ�⪠ ⮫쪮 ���୥� � ��᫥����樮���� ����""~
                             VIEW-AS TOGGLE-BOX~
                             AT ROW 3 COL 23"
			     			     
           &UpdAfterDate  = "mKurs nightkas"}

ASSIGN mTotalsByCS = FALSE                         
.


/*message "������ ���� ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.**/
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
            tt-header.form-code = "0401704" WHEN {&journal-type} = "��室"
            tt-header.form-code = "0401705" WHEN {&journal-type} = "��室"
        .

    RUN PrintReport(BUFFER tt-header, mTotalsByCS).
    PAGE {&stream}.
END.
{endout3.i}
{intrface.del}
