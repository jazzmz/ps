{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: book4.p
      Comment: ��������� ������/������� ��楢�� ��⮢
               (� INN � ����ᮬ ��ਮ��)
   Parameters:
         Uses:
      Used by:
      Created: 28.12.1997 Olenka
     Modified: 30.10.2001 NIK ����୮� �ନ஢���� 8 �������
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

/* ����� ⨯� �訢� */
RUN messmenu.p(
       10,
       "[���� ��⮢]",
       "",
       "��," +
       "�ਤ��᪨�," +
       "�����᪨�," +
       "����ਡ�����᪨�"
).
CASE INTEGER(pick-value):
   WHEN 1 THEN  mSewMode = "".
   WHEN 2 THEN mSewMode = "�".
   WHEN 3 THEN mSewMode = "�".
   WHEN 4 THEN mSewMode = "�".
   OTHERWISE RETURN.
END CASE.

/* 䫠� ���� ��������� �� ����� ��࠭�� ��� ������� ���.��� */
mBalAcNewPage = GetParamByNameAsChar(iParmStr, "����獮����", "���") EQ "��".
/*mAcct = GetParamByNameAsChar(iParmStr,"���", mAcct).*/
mIskl = GetParamByNameAsChar(iParmStr, "�᪫", mIskl).

FORM
   mAcct	FORMAT "X(60)"	LABEL  "��᪨ ��⮢"	HELP   "��᪨ ��⮢"
WITH FRAME fSet0 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ����� ������ ��� ����� ]".

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

{pir_book5v.i "��" "open" }
{pir_book5v.i "��" "close" }

{preview.i}
