/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: COMPILE.P
      Comment: ��������� 䠩���
   Parameters: ��᪠ 䠩��� ("norm*.p"),
               䠩� � ᯨ᪮� 䠩��� (��� ? - �᫨ ���� ���� ��ࠬ���),
               ��⠫�� r-�� (��� ? - ������ �� propath),
               ��뢠�� �� preview,
               ��� log-䠩�� (��� ?)
         Uses: promake.i, bar-beg.i, bar.i, justasec, on-esc
      Used by: promake.p
      Created: 03/07/97 Serge
     Modified: 06/07/97 Serge
     Modified: 11/07/97 Serge ��� - ��������� 䠩��� ��� ���७��
     Modified: 14/07/97 Serge ��ࠬ��� 䠩� � ᯨ᪮� 䠩��� ��� �������樨
     Modified: 15/07/97 Serge ᤥ��� ���� ��������㥬�� 䠩��� �᫨ ��� � 㪠������ ���
                              �뢮� PROPATH � log
        Last change:  SG    3 Dec 97    5:24 pm
    Modified:  25/06/2001 Om  ��ࠡ�⪠: ���������� ⥪�饣� ��� �
                                         ����� ��६����� PROPATH.
    Modified:  25/06/2001 Om  �訡��   : ���ࠫ��� ࠬ�� ����.
    Modified:  31/01/2003 Om  �訡��   : �� �������樨 ������ 䠩��
                                         �� �⮡ࠦ����� �।�०�����.
    Modified:  06/02/2003 Om  �訡��   : �� �������樨 ������ 䠩�� ��
                                         �ନ஢���� XREF 䠩�.
    Modified:  19/05/2003 Om  �訡��   : �� �������樨 ������ 䠩��
                                         �� ���⠫��� ᮮ�饭��.
     Modified: 22.12.2007 13:30 Ariz     ��ଠ�஢���� ����
     Modified: 21.07.2009 14:06 KSV      (0106191) ���ᮡ �뤠� ᮮ�饭�� ��
                                         �訡��� ᤥ��� ᮢ���⨬� � QBIS
     Modified: 14.09.2011 16:50 KSV      (0153100) ��ࠢ���� �訡�� � 
                                         �������樥� CLS 䠩���
     Modified: 07.10.2011 16:50 Stred    (0156664) ��������� ��������� HTML-䠩���
     Modified: 19.07.2012 16:50 Stred    (0175848) ��������� ��������� W-䠩���
     
*/
Form "~n@(#) COMPILE.P 1.0 Serge 03/07/97 Serge 03/07/97 ��������� 䠩���"
with frame sccs-id stream-io width 250.

/* ���� ��� �������樨. �᫨ dir eq ?, � ������� 䠩� � ᯨ᪮� �������樨. */
DEF INPUT PARAM dir         AS CHAR FORMAT "x(60)" LABEL "�����"            NO-UNDO.
DEF INPUT PARAM promake-dir AS CHAR FORMAT "x(60)" LABEL "���᮪ 䠩���"    NO-UNDO.
DEF INPUT PARAM rdir        AS CHAR FORMAT "x(30)" LABEL "�㤠 ������ R'��" NO-UNDO.
DEF INPUT PARAM preview     AS LOG  NO-UNDO. /* �⮡ࠦ��� �� १�����. */
DEF INPUT PARAM logfile     AS CHAR NO-UNDO.
DEF INPUT PARAM modpropath  AS LOG  NO-UNDO.

{compile.def &NoDef = "�� ��।�����"} /* ��।������ ��६����� ��� �������樨. */
{pick-val.i}  /* ��।������ ��६����� pick-value. */
{compile.pro} /* ������祭�� �����㬥�⮢ �������樨. */
{userfunc.i &cmp_CompileUserFunc = YES}  /* �����㬥��� ��� ���᪠ ����஥��� ��ଥ�஢. */

/* Commented by KSV: �몫�砥� ��������㥬�� ���� SYSCONF.I � ��� 
** �� �㤥� �������஢����� */
&GLOBAL-DEFINE NO_DISPSYSCONF

DEFINE VAR vPeaksChar      AS CHAR NO-UNDO. /* ����冷祭�� ᯨ᮪ ���設 �஥��. */
DEFINE VAR vSystemPathChar AS CHAR NO-UNDO. /* ���⥬�� ����. */

DEF VAR i        AS INT64  NO-UNDO.
DEF VAR j        AS INT64  NO-UNDO.
DEF VAR num      AS INT64  NO-UNDO. /* ������⢮ ��ࠡ�⠭��� 䠩���. */
DEF VAR numerr   AS INT64  NO-UNDO.
DEF VAR slash    AS CHAR NO-UNDO.
DEF VAR vFlagErr AS LOG  NO-UNDO. /* ���� �訡��, ��� ������ �訡��.  */
DEF VAR filename AS CHAR FORMAT "x(25)" NO-UNDO.
DEF VAR filedir  AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR filemask AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR prepath  AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR xrefname AS CHAR FORMAT "x(25)" INITIAL ? NO-UNDO.
DEF VAR dbo      AS LOGICAL INITIAL NO NO-UNDO. /* 䫠� �ᯮ�짮����� ��� */

DEF STREAM aaa.
DEFINE STREAM bb.

ASSIGN
   slash       =  IF opsys EQ "unix"
                  THEN "/"
                  ELSE "~\"
   /* ��⠫�� ��� R-��. */
   rdir        =  
&IF DEFINED(SESSION-REMOTE) &THEN
                  gWS_COMPDIR  
&ELSE
                  ENTRY (1, PROPATH)
&ENDIF
                  WHEN LENGTH (rdir) EQ 0
   /* ��ନ஢���� ����� log 䠩��. */
   logfile     =  
&IF DEFINED(SESSION-REMOTE) &THEN
                     string(right-trim(gWS_COMPDIR,"~/") + "/compile.log")
&ELSE
                  "compile.log"
&ENDIF
                  WHEN logfile EQ ?
   /* �᫨ ������������ 䠩�, � �뢮� �� �࠭. */
   preview     =  NO
                  WHEN promake-dir EQ ?
   /* ����祭�� �ਭ��, ����室��� ��� ����. */
   usr-printer =  getThisUserXAttrValue ('�ਭ��')
                  WHEN usr-printer EQ ""
.

/* ��ନ஢���� ������� ProPath. */
IF       modpropath
   AND   LENGTH (shFullPathChar) EQ 0
THEN RUN GetFullProPath (ProPath, OUTPUT shFullPathChar).

/* �� 㪠��� 䠩�(ᯨ᮪ 䠩���) ��� �������樨. */
IF promake-dir EQ ? AND
   DIR         EQ ?
THEN RETURN.

/* �᫨ ��⠭����� WebSpeed, � ���⠢�塞 䫠� ��� */
IF SEARCH("src/web/method/cgidefs.i") NE ? THEN dbo = YES.

{justasec}

/* �᫨ �� �室 ����� 䠩� � ᯨ᪮� 䠩��� ��� �������樨. */
IF promake-dir NE ?
THEN DO:
&IF DEFINED(SESSION-REMOTE) &THEN
   IF INDEX(promake-dir,"~/") = 0 THEN
      promake-dir = right-trim(gWS_COMPDIR,"~/") + "~/" + promake-dir.
&ENDIF

   /* ��७��ࠢ����� � ��⮪. */
   {setdest.i
      &filename = "logfile"
      &nodef    = "/*"
      &STREAM="stream bb"
   }
   
   PUT stream bb UNFORMATTED
      "Begin compilation on " TODAY " at " STRING(TIME,"hh:mm:ss") " by " USERID('bisquit') SKIP
      "Files being compiled: " DIR            SKIP
      "File with file list : " promake-dir    SKIP
      "R-files folder      : " rdir           SKIP
      "PROPATH             : " propath        SKIP
      "Log file name       : " logfile        SKIP (1)
   .

   INPUT STREAM aaa FROM VALUE(promake-dir).

   {bar-beg.i aaa}
   REPEAT:
      {on-esc LEAVE}

      IMPORT STREAM aaa filename.

/*** ��᫮� �. �. Maslov D. A. �६����� ��� ***/
      filename = TRIM(filename).

      IF filename EQ "" OR TRIM(filename) BEGINS "#"
      THEN NEXT.

      IF     SUBSTR(filename, LENGTH(filename) - 1, 2) NE ".p"
         AND SUBSTR(filename, LENGTH(filename) - 3, 4) NE ".cls"
         AND SUBSTR(filename, LENGTH(filename) - 4, 5) NE ".html"
         AND SUBSTR(filename, LENGTH(filename) - 1, 2) NE ".w"
      THEN NEXT.

      i = R-INDEX(filename,"/").

      IF i EQ 0
      THEN i = R-INDEX(filename,"~\").

      IF LENGTH (xrefdir) GT 0
      THEN ASSIGN
              xrefname = IF i EQ 0
                         THEN filename
                         ELSE SUBSTR(filename,i + 1)
              xrefname = xrefdir + slash + REPLACE(REPLACE(xrefname,".p",".xref"),".cls",".xref")
           .

      IF     SEARCH(filename)               EQ ?
         AND i                              GT 0
         AND SEARCH(SUBSTR(filename,i + 1)) NE ?
      THEN filename = SEARCH(SUBSTR(filename,i + 1)).

      IF NOT (filename MATCHES "*.p"
           OR filename MATCHES "*.cls"
           OR filename MATCHES "*.html"
           OR filename MATCHES "*.w")
      THEN NEXT.

      IF NOT dbo AND (filename MATCHES "*.html" OR filename MATCHES "*.w") THEN NEXT.

      PUT stream bb UNFORMATTED "Compiling " filename SKIP.

      PUT SCREEN
         ROW SCREEN-LINES + 1
         STRING("Compiling " + filename,"x(70)").

      num  = num + 1.

      /* ��������� 䠩��. ��� CLS 䠩��� ��������� � XREF �ਢ���� 
      ** � �訡�� 49 */
      IF filename MATCHES "*.html" OR filename MATCHES "*.w"
      THEN DO:
         OUTPUT STREAM bb CLOSE.
         RUN comphtml.pp(filename,rdir,logfile,INPUT-OUTPUT numerr) NO-ERROR.
         OUTPUT STREAM bb TO VALUE(logfile) APPEND.
      END.
      ELSE IF NOT filename MATCHES "*cls"
      THEN
         COMPILE
            VALUE(filename)
            NO-ATTR-SPACE
            SAVE
            INTO VALUE(rdir)
            XREF VALUE(xrefname)
            NO-ERROR
         .
      ELSE
         COMPILE
            VALUE(filename)
            NO-ATTR-SPACE
            SAVE
            INTO VALUE(rdir)
            NO-ERROR
         .


      i = ERROR-STATUS:NUM-MESSAGES.

      IF i GT 0 THEN
      DO:
         vFlagErr = YES.

         DO j = 1 TO i:
            IF     GetKeyWords (ERROR-STATUS:GET-MESSAGE(j)) EQ "error"
               AND vFlagErr
            THEN ASSIGN
                    numerr   = numerr + 1
                    vFlagErr = NO
                 .
            PUT stream bb UNFORMATTED ERROR-STATUS:GET-MESSAGE(j) SKIP.
         END.
      END.
      {bar.i aaa}
   END.

   PUT stream bb
      UNFORMATTED SKIP(1)
      "Finished compilation on " TODAY " at " STRING(TIME,"hh:mm:ss")
      (IF KEYFUNC(LASTKEY) = "end-error" THEN " by user break" ELSE "") SKIP
      "Total time        : " STRING(INT64(ETIME(NO) / 1000),"hh:mm:ss") SKIP
      "Number of files   : " num SKIP
      "Number of errors  : " numerr SKIP
      "Time per procedure: " TRIM(STRING(ETIME(NO) / 1000 / num,">>9.99 s"))
   SKIP.
   OUTPUT stream bb  CLOSE.
   INPUT STREAM aaa CLOSE.
END.

/* �᫨ �� �室 ����� 䠩� ��� �������樨. */
IF dir NE ?
THEN DO:
   /* ����祭�� ������������ 䠩��. */
   filename = dir.

   IF NOT (filename MATCHES "*.p"
        OR filename MATCHES "*.cls"
        OR filename MATCHES "*.html"
        OR filename MATCHES "*.w")
   THEN RETURN "-1".

   IF NOT dbo AND (filename MATCHES "*.html" OR filename MATCHES "*.w") THEN NEXT.

   IF LENGTH (xrefdir) GT 0
   THEN xrefname = xrefdir + slash + ENTRY (1, filename, ".") + ".xref".

   MESSAGE "������������ 䠩� " + filename + " � " + rdir.

   /* ��������� 䠩��. */
   IF filename MATCHES "*.html" OR filename MATCHES "*.w"
   THEN DO:
      OUTPUT STREAM bb CLOSE.
      RUN comphtml.pp(filename,rdir,logfile,INPUT-OUTPUT numerr) NO-ERROR.
      OUTPUT STREAM bb TO VALUE(logfile) APPEND.
   END.
   ELSE 
      COMPILE
         VALUE(filename)
         NO-ATTR-SPACE
         SAVE
         INTO VALUE(rdir)
         XREF VALUE(xrefname)
         NO-ERROR
      .

   IF ERROR-STATUS:NUM-MESSAGES NE 0
   THEN DO:
      RUN ShowErrors.
      IF COMPILER:ERROR
      THEN RETURN "-1".
   END.

   RETURN.
END.

/* �뢮� �� �࠭. */
IF preview
THEN DO:
   {preview.i &filename="logfile"}
END.
/* �����⨥ ��室���� ��⮪�. */
ELSE OUTPUT CLOSE.

RETURN.

/* �뢮��� ���祭� �訡��. */
PROCEDURE ShowErrors.
   DEFINE VAR vErrCountInt  AS INT64  NO-UNDO. /* ���稪 �訡��. */
   DEFINE VAR vErrorMsgChar AS CHAR NO-UNDO. /* ����ঠ��� �訡��. */

   /* �� �ᥬ �訡�窠�. */
   DO vErrCountInt = 1 TO ERROR-STATUS:NUM-MESSAGES:
      vErrorMsgChar =   IF vErrorMsgChar EQ ""
                        THEN ERROR-STATUS:GET-MESSAGE (vErrCountInt)
                        ELSE vErrorMsgChar + "~n" + ERROR-STATUS:GET-MESSAGE (vErrCountInt).
   END.

   RUN message.p ( vErrorMsgChar, "WHITE/RED", "error", "", "", NO  ).

   RETURN.
END PROCEDURE.
