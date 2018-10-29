{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: opd-rep.p
      Comment: ��������� ���㬥�⮢ ��᫥ ��ࢮ�� ������� ���भ�.
   Parameters:
         Uses:
      Used by:
      Created: 20.01.2005 18:06 Koag    
     Modified: 06.04.2005 15:02 Koag     
     Modified: 20.03.2006 ILVI     
     Modified: 28.05.2006 16:27 KSV      (0059104) ��⨬����� �����ᮢ
                                         history. �⪠� �� ������
                                         date-time-file.
     Modified: 27.10.2006 15:24 Daru     <comment>
     Modified: 20.06.2007 Kuntashev  �� ��� �14, ����ᮢ��.
****************************************************************
*
* �⮡ࠦ��� ��������� � ��襤�� �� ��� ���㬥���.
* ����: ���ᮢ �. �.
* ���㠫쭮���: 19.12.2011
*
*/

{globals.i}             /* �������� ��६���� ��ᨨ. */
{history.def}
{tmprecid.def}

{intrface.get widg}     /* ������⥪� ��� ࠡ��� � �����⠬�. */
{intrface.get xclass}     /* ��� ࠡ��� � ����奬�� */

FUNCTION modifName RETURN CHARACTER
   (INPUT mType AS CHAR):

   IF INDEX ('{&hi-all}',mType) = 0
   THEN RETURN '???'.
   ELSE RETURN SUBSTR(ENTRY(INDEX('{&hi-all}',mType),'{&hi-modify}'),1,4).

END FUNCTION.

DEFINE VARIABLE mLockCatList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mBarId       AS CHAR       NO-UNDO.
DEFINE VARIABLE mCnt         AS INTEGER    NO-UNDO.
DEFINE VARIABLE vTable       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE daBeg        AS DATE INIT ? NO-UNDO.
DEFINE VARIABLE daEnd        AS DATE INIT ? NO-UNDO.

DEF TEMP-TABLE tt-DayLockHist NO-UNDO
   FIELD t-op-date      AS DATE
   FIELD t-modif-date   AS DATE
   FIELD t-modif-time   AS INT
   FIELD t-cat          AS CHAR
   INDEX ind IS PRIMARY t-op-date t-cat
.

DEF TEMP-TABLE tt-ModOpOfOp-date NO-UNDO
   FIELD op          AS INT
   FIELD op-date     AS DATE
   FIELD modify      AS CHAR
   FIELD t-cat       AS CHAR
   FIELD doc-date    AS CHAR
   FIELD doc-num     AS CHAR
   INDEX ind IS PRIMARY op 
   INDEX ind2 op-date t-cat 
.

DEF BUFFER xhistory FOR history. /* ���������� ����. */

DEFINE VARIABLE mBegDate  AS DATE      NO-UNDO.
DEFINE VARIABLE mEndDate  AS DATE      NO-UNDO.
DEFINE VARIABLE mClass    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mTable    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mField    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mNewField AS CHARACTER NO-UNDO. /*����� ���祭��*/
DEFINE VARIABLE mRekvizit AS CHARACTER NO-UNDO. /*�����஢�� ४����� */
DEFINE VARIABLE mUser     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDetails  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mTmp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE mNum      AS INTEGER   NO-UNDO.
DEFINE VARIABLE mNOp      AS INTEGER   NO-UNDO.

DEFINE NEW SHARED VARIABLE list-id AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE txattr NO-UNDO
   FIELD record AS RECID. /* ����ন� recid ४����⮢ */

DEFINE NEW GLOBAL SHARED TEMP-TABLE tclass NO-UNDO
   FIELD record AS RECID.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tmethod NO-UNDO
   FIELD record AS RECID.

DEFINE TEMP-TABLE ttOp  NO-UNDO
   FIELD op         LIKE op.op
   FIELD doc-num    LIKE op.doc-num
   FIELD doc-date   AS CHARACTER
   FIELD op-date    LIKE op.op-date
   FIELD modif-date LIKE history.modif-date LABEL "���� ���"  FORMAT "99/99/9999"
   FIELD modif-time LIKE history.modif-time LABEL "����� ���" 
   FIELD user-id    LIKE history.user-id    LABEL "���������"
   FIELD file-name  LIKE history.FILE-NAME  LABEL "����."
   FIELD tField     AS CHARACTER            LABEL "��������"  FORMAT "x(9)"
   FIELD tValue     AS CHARACTER            LABEL "������ ��������" FORMAT "x(100)"
   FIELD tcat       AS CHARACTER
   FIELD tmodify    AS CHARACTER            LABEL "���." FORMAT "x(4)"
   FIELD tNewField  AS CHARACTER
INDEX indOp IS PRIMARY op modif-date modif-time. 

{empty txattr}

ASSIGN
   mCat     = "b"
   mClass   = "op*"
   mTable   = "op,op-entry,op-bank"
   mField   = "doc-num,name-ben,acct-cr,acct-db,amt-cur,amt-rub,details" /*+ GetXattrInit("opb","HistoryFields")*/
/*   mField   = "!op-status,!��������㬥��,!��������,!�।�����⥫�,!�।���⥫�騪�,!PIR*,!kau-db,!kau-cr,!������,!F407,"
            + "!CardStatus,!user-inspector,!������,!���,!��������117,!contract-date,!country-send,!op-value-date,*"
*/
   mUser    = "*"
   mDetails = YES
.

FORM
   mCat
      FORMAT "x(300)" VIEW-AS FILL-IN SIZE 30 by 1
      LABEL  "��⥣�ਨ"
      HELP   ""
   mClass
      FORMAT "x(300)" VIEW-AS FILL-IN SIZE 30 by 1
      LABEL  "������"  
      HELP   "���᮪ �����⨬�� ����ᮢ ���㬥�⮢"
   mTable
      FORMAT "x(300)" VIEW-AS FILL-IN SIZE 30 by 1
      LABEL  "�������"  
      HELP   "���᮪ �����⨬�� ����ᮢ ���㬥�⮢"
   mField
      FORMAT "x(300)" VIEW-AS FILL-IN SIZE 30 by 1
      LABEL "���������"  
      HELP  "���᮪ �᭮���� � �������⥫��� ����ᮢ ���㬥�⮢"
   mUser
      FORMAT "x(3000)" VIEW-AS FILL-IN SIZE 30 by 1 
      LABEL  "����㤭���"  
      HELP   "���᮪ ���㤭����"
   mDetails
      FORMAT "��/���"
      LABEL  "��⠫�����"  
      HELP   "�뢮���� ᢥ����� �� ���������� ४������?"
WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ������]".

ON F1 OF mTable DO:
   RUN histfrep.p(FRAME-VALUE,4).
   IF     LASTKEY EQ 10 
      AND pick-value NE ?
   THEN DISPLAY pick-value @ mTable WITH FRAME frParam.
   RETURN NO-APPLY.
END.

ON F1 OF mClass DO:
   DO TRANSACTION:
      RUN getclass.p(?,"op",YES,"R",2).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ?
   THEN DISPLAY pick-value @ mClass WITH FRAME frParam.
   RETURN NO-APPLY.
END.

ON F1 OF mField DO:
   {empty txattr}
   RUN shxattr.p(mClass:SCREEN-VALUE,'all',5).
   IF    (   LASTKEY EQ 13 
          OR LASTKEY EQ 10) THEN DO:
      FOR EACH txattr NO-LOCK,
         FIRST xattr WHERE RECID(xattr) EQ txattr.record NO-LOCK:
         {additem.i mTmp xattr.Xattr-Code}
      END.
      DISPLAY mTmp @ mField WITH FRAME frParam.
   END.
   RETURN NO-APPLY.
END.

ON F1 OF mUser DO:
   list-id   = FRAME-VALUE.
   DO TRANSACTION:
      RUN op-user1.p(4).
   END.
   IF LASTKEY EQ 10 THEN 
      DISPLAY list-id @ mUser WITH FRAME frParam.
   RETURN NO-APPLY.
END.

ON F1," " OF mDetails DO:
   mDetails:SCREEN-VALUE = (IF mDetails:SCREEN-VALUE EQ "��" 
                  THEN "���" 
                  ELSE "��").
   RETURN NO-APPLY.
END.

/*
PAUSE 0.
UPDATE
   mCat
   mClass
   mTable
   mField
   mUser
   mDetails
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.
IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE.
*/
/*--------------------------------------------------------------------------------------------------*/
/* ���� ���������� ���㬥�⮢
----------------------------------------------------------------------------------------------------*/
mNOp = 0.

FOR EACH tmprecid NO-LOCK,
   FIRST op
      WHERE recid(op) = tmprecid.id
        AND CAN-DO(mClass, op.class-code)
        AND NOT CAN-DO("����,���줮,���,����1",op.op-kind) /* ��ᥪ��� ���㦭� ���㬥��� */
      NO-LOCK,
   FIRST op-entry of op  NO-LOCK:

   mNOp = mNOp + 1.
   put screen col 1 row 24 "��ࠡ��뢠���� " + STRING(mNOp) + " : doc N " + STRING(op.doc-num) + "       ".

   IF (daBeg EQ ?)
   THEN daBeg = op.op-date.
   ELSE daBeg = MINIMUM(daBeg, op.op-date).

   IF (daEnd EQ ?)
   THEN daEnd = op.op-date.
   ELSE daEnd = MAXIMUM(daEnd, op.op-date).

   DO mCnt = 1 TO NUM-ENTRIES(mTable):
      vTable = ENTRY(mCnt,mTable).

      FOR EACH history
         WHERE (history.file-name         EQ vtable)
               /* CAN-DO(mTable, history.file-name)  */     /* �㦭� ��� ��������� ������ */
           AND (history.field-ref      BEGINS STRING (op.op)) /* �㦭� ��� ��������� ������ */
           AND (ENTRY(1,history.field-ref) EQ STRING (op.op)) /* �㦭� ��� �⡮� ������ */
           AND CAN-DO(mUser,history.user-id)
         NO-LOCK
         BY history.file-name
         BY history.modif-date
         BY history.modif-time:

         IF (history.modify NE "C")       /* ࠡ�⠥� � ��ࠢ����묨 ���㬥�⠬� */
         THEN DO mNum = 1 TO NUM-ENTRIES(history.field-value) / 2:

               IF CAN-DO(mField,LEFT-TRIM(ENTRY(2 * mNum - 1,history.field-value),"*"))
               THEN DO:
                  mNewfield = "".
                  mRekvizit = "".

                  IF (history.modify  NE "d")
                  THEN DO:
/*
                     FIND FIRST op
                        WHERE op.op eq INT(ENTRY(1,history.field-ref))
                        no-lock no-error.

                     FIND FIRST op-entry of op
                        no-lock no-error.
*/
                     CASE ENTRY(2 * mNum - 1,history.field-value):
                        WHEN "details"    THEN DO: mNewfield = string(op.details).          mRekvizit = "����ঠ��� ��".  END.
                        WHEN "doc-num"    THEN DO: mNewfield = string(op.doc-num).          mRekvizit = "����� ���-�".   END.
                        WHEN "doc-type"   THEN DO: mNewfield = string(op.doc-type).         mRekvizit = "��� ���-�".     END.
                        WHEN "name-ben"   THEN DO: mNewfield = string(op.name-ben).         mRekvizit = "�����⥫�".     END.
                        WHEN "op-status"  THEN DO: mNewfield = string(op.op-status).        mRekvizit = "�����".         END.
                        WHEN "amt-rub"    THEN DO: mNewfield = string(op-entry.amt-rub).    mRekvizit = "�㬬�(��)".     END.
                        WHEN "amt-cur"    THEN DO: mNewfield = string(op-entry.amt-cur).    mRekvizit = "�㬬�(���)".     END.
                        WHEN "acct-cr"    THEN DO: mNewfield = string(op-entry.acct-cr).    mRekvizit = "��� �-�".       END.
                        WHEN "acct-db"    THEN DO: mNewfield = string(op-entry.acct-db).    mRekvizit = "��� �-�".       END.
                        WHEN "kau-cr"     THEN DO: mNewfield = string(op-entry.kau-cr).     mRekvizit = "��� ����.��.��". END.
                        WHEN "kau-db"     THEN DO: mNewfield = string(op-entry.kau-db).     mRekvizit = "��� ����.��.��". END.
                        WHEN "currency"   THEN DO: mNewfield = string(op-entry.currency).   mRekvizit = "���.�஢����".   END.

                        WHEN "doc-date"   THEN DO: mNewfield = string(op.doc-date).         mRekvizit = "��� ���-�".    END.
                        WHEN "op-date"    THEN DO: mNewfield = string(op.op-date).          mRekvizit = "��� �஢����".  END.
                        WHEN "due-date"   THEN DO: mNewfield = string(op.due-date).         mRekvizit = "�ப ���⥦�".   END.
                        WHEN "value-date" THEN DO: mNewfield = string(op-entry.value-date). mRekvizit = "���� �� ����".   END.
                        OTHERWISE DO:             mNewfield = getXAttrValue("op",STRING(op.op) ,REPLACE(mRekvizit,"*","")).
                                                  mRekvizit = ENTRY(2 * mNum - 1,history.field-value).                END.
                     END CASE.
                  END.  /*  �� 㤠����� */

                  CREATE ttop.

                  ASSIGN
                     ttOp.doc-num    = op.doc-num
                     ttOp.doc-date   = if (op.doc-date eq ?) then "       ?" else STRING(op.doc-date)
                     ttOp.tmodify    = modifName(history.modify)
                     ttOp.op         = INT(ENTRY(1,history.field-ref))
                     ttop.tcat       = "b" /* tt-DayLockHist.t-Cat */
                     ttOp.op-date    = op.op-date
                     ttOp.modif-date = history.modif-date
                     ttOp.modif-time = history.modif-time
                     ttOp.user-id    = history.user-id
                     ttOp.file-name  = history.file-name
                     ttOp.tField     = mRekvizit
                     ttOp.tValue     = ENTRY(2 * mNum,history.field-value)
                     ttOp.tNewField  = mNewField
                  .
               END. /* �室�� � ���� ⠡���� */
         END. /* ��������� */

         RELEASE ttop.
      END.
   END.
END. /* ����� �� ��� */

RUN ClearBar (mBarId).
/*--------------------------------------------------------------------------------------------------*/
put screen col 1 row 24 color normal STRING(" ","X(80)").

{setdest.i}

PUT UNFORMATTED '����� �� ���������� � ���������� ' +
    (IF (daEnd EQ daBeg) THEN ("�� " + STRING(daEnd, "99.99.9999"))
     ELSE ("�� ������ � " + STRING(daBeg, "99.99.9999") + " �� " + STRING(daEnd, "99.99.9999")))
SKIP(1).
/*
PUT UNFORMATTED '              ���������: ' mCat                    SKIP.
PUT UNFORMATTED '                 ������: ' mClass   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '                �������: ' mTable   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '              ���������: ' mField   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '           ������������: ' mUser    FORMAT "x(60)" SKIP.
PUT UNFORMATTED '            �����������: ' mDetails FORMAT "��/���" SKIP(2).
*/


/* PUT UNFORMATTED "����. ���� " tt-DayLockHist.t-op-date. */
/* PUT UNFORMATTED " ��������� " "b" */ /* tt-DayLockHist.t-cat */.

PUT UNFORMATTED      "       ����     ����     �����".
IF mDetails
   THEN PUT UNFORMATTED "             ��� ".

PUT UNFORMATTED SKIP "N ���. ���.     ���.     ���.     �������. ".
IF mDetails
   THEN PUT UNFORMATTED "���. �������  ��������        ������ ��������      ����� ��������".

PUT UNFORMATTED SKIP "------ -------- -------- -------- -------- ".
IF mDetails
   THEN PUT UNFORMATTED "---- -------- --------------- -------------------- -----------------".

PUT UNFORMATTED "" SKIP.

   FOR EACH ttOp
   NO-LOCK BREAK BY ttOp.modif-date
                 BY ttOp.doc-num
                 BY ttOp.modif-time
                 BY ttOp.user-id
                 BY ttOp.file-name:

      IF FIRST-OF(ttOp.doc-num)
         THEN PUT UNFORMATTED ttOp.doc-num FORMAT "x(6)" " " ttOp.doc-date " ".
         ELSE PUT UNFORMATTED "                ".
      PUT UNFORMATTED ttOp.modif-date " " STRING(ttOp.modif-time,'hh:mm:ss') " " ttOp.user-id FORMAT "x(8)" " ".
      IF mDetails
         THEN PUT UNFORMATTED ttop.tmodify FORMAT "x(4)" " " ttOp.file-name FORMAT "x(8)" " " ttOp.tField FORMAT "x(15)" " " ttOp.tvalue FORMAT "x(20)" " " ttOp.tNewField FORMAT "x(20)".
      PUT UNFORMATTED "" SKIP.

   END.
   PUT UNFORMATTED ""  SKIP(2).

{signatur.i}
{preview.i}
RETURN.
