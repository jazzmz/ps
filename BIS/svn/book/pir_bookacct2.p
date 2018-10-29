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
   WHEN 1 THEN mSewMode = "".
   WHEN 2 THEN mSewMode = "�".
   WHEN 3 THEN mSewMode = "�".
   WHEN 4 THEN mSewMode = "�".
   OTHERWISE RETURN.
END CASE.

/* 䫠� ���� ��������� �� ����� ��࠭�� ��� ������� ���.��� */
mBalAcNewPage = GetParamByNameAsChar(iParmStr, "����獮����", "���") EQ "��".
filePath = GetParamByNameAsChar(iParmStr, "����", mAcct).
mAcct    = GetParamByNameAsChar(iParmStr, "���", mAcct).



{pir_bookacct2.i }