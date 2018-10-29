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
*/

{globals.i}             /* �������� ��६���� ��ᨨ. */
{history.def}

{intrface.get widg}     /* ������⥪� ��� ࠡ��� � �����⠬�. */
{intrface.get xclass}     /* ��� ࠡ��� � ����奬�� */

FUNCTION modifName RETURN CHAR (INPUT mType AS CHAR):
   IF INDEX ('{&hi-all}',mType) = 0 THEN
      RETURN '???'.
      ELSE RETURN SUBSTR(ENTRY(INDEX('{&hi-all}',mType),'{&hi-modify}'),1,4).
END FUNCTION.

DEFINE VARIABLE mLockCatList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE mCat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mBarId       AS CHAR       NO-UNDO.
DEFINE VARIABLE mCnt         AS INTEGER    NO-UNDO.
DEFINE VARIABLE vTable       AS CHARACTER  NO-UNDO.


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
   mBegDate = gBeg-Date
   mEndDate = gEnd-Date
   mCat     = "b"
   mClass   = "op*"
   mTable   = "op,op-entry,op-bank"
   mField   = "doc-num,name-ben,op-status,acct-cr,acct-db,amt-cur,amt-rub,details," + GetXattrInit("opb","HistoryFields")
   mUser    = "*"
   mDetails = YES
.

FORM
   mBegDate
      FORMAT "99/99/9999"
      LABEL  "��砫쭠� ���" 
      HELP   "��砫쭠� ��� ���⭮�� ��ਮ��"
   mEndDate
      FORMAT "99/99/9999"
      LABEL  "����筠� ���"  
      HELP   "����筠� ��� ���⭮�� ��ਮ��"
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

ON F1 OF mBegDate,mEndDate DO:
   RUN calend.p.
   IF    (   LASTKEY EQ 13 
          OR LASTKEY EQ 10) 
      AND pick-value NE ?
   THEN FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.

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

PAUSE 0.
UPDATE
   mBegDate
   mEndDate
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
/* ���� ���� � �६��� ��ࢮ�� ������� ���भ� 
----------------------------------------------------------------------------------------------------*/

FOR EACH op-date WHERE 
         op-date.op-date GE mBegDate 
     AND op-date.op-date LE mEndDate NO-LOCK,
    EACH history WHERE 
         history.FILE-NAME   EQ "op-date" 
     AND history.field-ref   EQ STRING(op-date.op-date) 
     AND history.modify      EQ "w" 
     AND history.field-value MATCHES "*�����⨥*"
NO-LOCK BY history.FILE-NAME BY history.modif-date BY history.modif-time: 
   mLockCatList = SUBSTRING(history.field-value,
                            INDEX(history.field-value,"�����⨥") + 18,
                            LENGTH(RIGHT-TRIM(history.field-value)) - 18 - INDEX(history.field-value,"�����⨥")
                            ).
   DO mCount = 1 TO NUM-ENTRIES(mLockCatList):
      IF CAN-DO(mCat,ENTRY(mCount,mLockCatList))
         AND NOT CAN-FIND(FIRST tt-DayLockHist WHERE
                             tt-DayLockHist.t-cat EQ ENTRY(mCount,mLockCatList) AND
                             tt-DayLockHist.t-op-date EQ op-date.op-date NO-LOCK)
      THEN DO:
         CREATE tt-DayLockHist.
         ASSIGN
            tt-DayLockHist.t-op-date    = op-date.op-date
            tt-DayLockHist.t-modif-date = history.modif-date
            tt-DayLockHist.t-modif-time = history.modif-time
            tt-DayLockHist.t-cat        = ENTRY(mCount,mLockCatList)
         .
      END.
   END.
END.
/*--------------------------------------------------------------------------------------------------*/
/* ���� ���������� ��᫥ ������� ���भ� ���㬥�⮢
----------------------------------------------------------------------------------------------------*/
mCount = 0.
FOR EACH tt-dayLockHist NO-LOCK: 
   /* ���㬥��� ����� �����﫨�� */
   FOR EACH op WHERE op.op-date  EQ tt-dayLockHist.t-op-date AND
                     op.acct-cat EQ tt-DayLockHist.t-cat AND
                     CAN-DO(mClass,op.class-code) AND 
                     /* ��ᥪ��� �� �㦭� ���㬥��� */
                     NOT CAN-DO("����,���줮,���,����1",op.op-kind)
                     NO-LOCK:

      DO mCnt = 1 TO NUM-ENTRIES(mTable):
          vTable = ENTRY(mCnt,mTable).
          
          FOR FIRST  history WHERE 
             history.file-name           EQ     vTable             /* �㦭� ��� ��������� ������ */
             AND history.field-ref           BEGINS STRING (op.op) /* �㦭� ��� ��������� ������ */ 
             AND ENTRY(1,history.field-ref)  EQ     STRING (op.op) /* �㦭� ��� �⡮� ������ */
             AND CAN-DO(mUser,history.user-id) 
             AND (  
                     (history.modif-date GT tt-DayLockHist.t-modif-date)
                  OR (history.modif-date EQ tt-DayLockHist.t-modif-date AND
                      history.modif-time GE tt-DayLockHist.t-modif-time)
                 )
             NO-LOCK :
          END.
          IF AVAILABLE history THEN LEAVE. 
      END.
      IF NOT AVAILABLE history THEN  NEXT. 

      CREATE tt-ModOpOfOp-date.
      ASSIGN
         mCount                     = mCount + 1
         tt-ModOpOfOp-date.op       = op.op
         tt-ModOpOfOp-date.op-date  = op.op-date
         tt-ModOpOfOp-date.modify   = history.modify
         tt-ModOpOfOp-date.t-cat    = tt-dayLockHist.t-cat
         tt-ModOpOfOp-date.doc-num  = op.doc-num
         tt-ModOpOfOp-date.doc-date = STRING(OP.doc-date)
      .
   END.
   /* ���㬥���, ����� 㤠�﫨�� */
   /* �ࠫ �ࠢ �� 㤠����� �� � ���� ���, �� �ਢ�� ᨫ쭮 */
/*   FOR EACH history WHERE
         (      
            (history.file-name  EQ 'op' AND 
             history.modif-date GT tt-DayLockHist.t-modif-date)
         OR (history.file-name  EQ 'op' AND
             history.modif-date EQ tt-DayLockHist.t-modif-date AND
             history.modif-time GE tt-DayLockHist.t-modif-time)
         )
      AND history.modify     EQ "d" 
      !!!!AND DATE(ENTRY(LOOKUP("op-date",history.field-val) + 1,history.field-val)) EQ tt-DayLockHist.t-op-date
      AND ENTRY(LOOKUP("acct-cat",history.field-val) + 1,history.field-val) EQ tt-DayLockHist.t-cat 
      AND CAN-DO(mClass,ENTRY(LOOKUP("class-code",history.field-val) + 1,history.field-val)) 
      AND NOT CAN-FIND(FIRST tt-ModOpOfOp-date WHERE 
                               tt-ModOpOfOp-date.op EQ INT(history.field-ref) NO-LOCK)
   NO-LOCK:
   
   message "ok11" tt-DayLockHist.t-op-date ENTRY(LOOKUP("op-date",history.field-val) + 1,history.field-val) ENTRY(LOOKUP("doc-num",history.field-val) + 1,history.field-val). pause.
   
    IF NOT CAN-DO("�*",ENTRY(LOOKUP("doc-num",history.field-val) + 1,history.field-val)) THEN
     DO:
      CREATE tt-ModOpOfOp-date.
      ASSIGN
         mCount                     = mCount + 1
         tt-ModOpOfOp-date.op       = INT(history.field-ref)
         tt-ModOpOfOp-date.op-date  = DATE(ENTRY(LOOKUP("op-date",history.field-val) + 1,history.field-val))
         tt-ModOpOfOp-date.modify   = history.modify
         tt-ModOpOfOp-date.t-cat    = tt-dayLockHist.t-cat
         tt-ModOpOfOp-date.doc-num  = ENTRY(LOOKUP("doc-num",history.field-val) + 1,history.field-val)
         tt-ModOpOfOp-date.doc-date = ENTRY(LOOKUP("doc-date",history.field-val) + 1,history.field-val)
      .
     END. 
   END.*/
END.
/*--------------------------------------------------------------------------------------------------*/
/* ���� ��������� � ���������� �६����� ⠡���
----------------------------------------------------------------------------------------------------*/
RUN InitBar (mCount, "��ࠡ�⪠ ���ਨ ���������...", OUTPUT mBarId).
mCount = 0.
OUTPUT TO "ttt.txt".

FOR EACH tt-DayLockHist NO-LOCK ,
    EACH tt-ModOpOfOp-date WHERE tt-ModOpOfOp-date.op-date EQ tt-DayLockHist.t-op-date AND
                                 tt-ModOpOfOp-date.t-cat   EQ tt-dayLockHist.t-cat
NO-LOCK:
   RUN ProgressBar (mBarId, mCount).
   DO mCnt = 1 TO NUM-ENTRIES(mTable):
      vTable = ENTRY(mCnt,mTable).
      FOR EACH history WHERE 
         /* �㦭� ��� ��������� ������ */
         history.file-name            EQ       vtable                 
         /* �㦭� ��� ��������� ������ */
         AND history.field-ref            BEGINS   STRING (tt-ModOpOfOp-date.op)
         /* �㦭� ��� �⡮� ������ */
         AND ENTRY(1,history.field-ref)   EQ       STRING (tt-ModOpOfOp-date.op)
         AND CAN-DO(mUser,history.user-id)
         AND (   
                (history.modif-date GT tt-DayLockHist.t-modif-date)
             OR (history.modif-date EQ tt-DayLockHist.t-modif-date AND 
                 history.modif-time GE tt-DayLockHist.t-modif-time)
             )
      NO-LOCK BY history.file-name BY history.modif-date BY history.modif-time:
         
IF history.modify ne "C"       /* ࠡ�⠥� � ��ࠢ����묨 ���㬥�⠬� */
     THEN 
      DO:
         DO mNum = 1 TO NUM-ENTRIES(history.field-value) / 2:

             IF CAN-DO(mField,LEFT-TRIM(ENTRY(2 * mNum - 1,history.field-value),"*"))
                    THEN
                        DO:
    					   mNewfield = "".
       					   mRekvizit = "".

                            IF history.modify  NE "d" THEN 
                                 DO:
                                    FIND FIRST op WHERE op.op eq INT(ENTRY(1,history.field-ref)) no-lock no-error.
                                    FIND FIRST op-entry of op no-lock no-error.

                                    CASE ENTRY(2 * mNum - 1,history.field-value):
                                			WHEN "doc-num"   THEN DO: mNewfield = string(op.doc-num).       mRekvizit = "����� �-�". END.
                                   			WHEN "name-ben"  THEN DO: mNewfield = string(op.name-ben).      mRekvizit = "�����⥫�". END.
                                   			WHEN "op-status" THEN DO: mNewfield = string(op.op-status).     mRekvizit = "�����". END.
                                   			WHEN "amt-rub"   THEN DO: mNewfield = string(op-entry.amt-rub). mRekvizit = "�㬬�(��)". END. 
                                  			WHEN "amt-cur"   THEN DO: mNewfield = string(op-entry.amt-cur). mRekvizit = "�㬬�(���)". END.
                                   			WHEN "acct-cr"   THEN DO: mNewfield = string(op-entry.acct-cr). mRekvizit = "��� �-�". END.
                                   			WHEN "acct-db"   THEN DO: mNewfield = string(op-entry.acct-db). mRekvizit = "��� �-�". END.
                                            OTHERWISE DO:  mRekvizit = ENTRY(2 * mNum - 1,history.field-value). mNewfield = getXAttrValue("op",STRING(op.op) ,REPLACE(mRekvizit,"*","")). END.
                                      END CASE.			

                                 END.  /*  �� 㤠����� */
                     
                          CREATE ttop.


                           ASSIGN
                              ttOp.doc-num    = tt-ModOpOfOp-date.doc-num
                              ttOp.doc-date   = if tt-ModOpOfOp-date.doc-date eq ? then "       ?" else tt-ModOpOfOp-date.doc-date
                              ttOp.tmodify    = modifName(history.modify)
                              ttOp.op         = INT(ENTRY(1,history.field-ref))
                              ttop.tcat       = tt-DayLockHist.t-Cat
                              ttOp.op-date    = tt-DayLockHist.t-op-date
                              ttOp.modif-date = history.modif-date
                              ttOp.modif-time = history.modif-time
                              ttOp.user-id    = history.user-id
                              ttOp.file-name  = history.file-name
                              ttOp.tField     = mRekvizit
                              ttOp.tValue     = ENTRY(2 * mNum,history.field-value)
                              ttOp.tNewField  = mNewField
                           .
                        END. /* �室�� � ���� ⠡���� */
               END. /* �� �ᥬ� ᮤ�ন���� ���ਨ */
          END. /* ��������� */
         ELSE 
            DO:
         /* ࠡ�⠥� � ����� ᮧ����묨 ���㬥�⠬� */
         	FIND FIRST ttOp WHERE ttOp.op eq INT(ENTRY(1,history.field-ref)) no-lock no-error.  

         	IF NOT AVAIL ttOp then
                  DO:       
                          if history.file-name eq "op" then
                				  DO:
             			    			 mNewfield = "".
                                         FIND FIRST op WHERE op.op eq INT(ENTRY(1,history.field-ref)) no-lock no-error.

                                        FIND FIRST op-entry of op no-lock no-error.

                                        DO mNum = 1 TO NUM-ENTRIES(history.field-value) / 2:
      
                                      CASE ENTRY(2 * mNum - 1,history.field-value):
                                   			WHEN "doc-num"   THEN DO: mNewfield = string(op.doc-num).       mRekvizit = "����� �-�". END.
                                   			WHEN "name-ben"  THEN DO: mNewfield = string(op.name-ben).      mRekvizit = "�����⥫�". END.
                                   			WHEN "op-status" THEN DO: mNewfield = string(op.op-status).     mRekvizit = "�����". END.
                                   			WHEN "amt-rub"   THEN DO: mNewfield = string(op-entry.amt-rub). mRekvizit = "�㬬�(��)". END. 
                                   			WHEN "amt-cur"   THEN DO: mNewfield = string(op-entry.amt-cur). mRekvizit = "�㬬�(���)". END.
                                   			WHEN "acct-cr"   THEN DO: mNewfield = string(op-entry.acct-cr). mRekvizit = "��� �-�". END.
                                   			WHEN "acct-db"   THEN DO: mNewfield = string(op-entry.acct-db). mRekvizit = "��� �-�". END.
                                           OTHERWISE DO:  mRekvizit = ENTRY(2 * mNum - 1,history.field-value). mNewfield = getXAttrValue("op",STRING(op.op) ,REPLACE(mRekvizit,"*","")). END.
                                     END CASE.			

                                   CREATE ttop.
        
                                ASSIGN
                                       ttOp.doc-num    = tt-ModOpOfOp-date.doc-num
                                       ttOp.doc-date   = if tt-ModOpOfOp-date.doc-date eq ? then "       ?" else tt-ModOpOfOp-date.doc-date
                                       ttOp.tmodify    = modifName(history.modify)
                                       ttOp.op         = INT(ENTRY(1,history.field-ref))
                                       ttop.tcat       = tt-DayLockHist.t-Cat
                                       ttOp.op-date    = tt-DayLockHist.t-op-date
                                       ttOp.modif-date = history.modif-date
                                       ttOp.modif-time = history.modif-time
                                       ttOp.user-id    = history.user-id
                                       ttOp.file-name  = history.file-name
                                       ttOp.tField     = mRekvizit
                                       ttOp.tValue     = ENTRY(2 * mNum,history.field-value)
                                       ttOp.tNewField  = mNewField
                            .
                                         END. /* ����� ���㬥�� ᮧ��� */
                                       END. /* ����� �� ���ਨ */                                         
                                END. /* ����� ����� �� ���㬥��� */
                             END. /* ����� ���㬥�� �� ����᫥� � ttOp */

         RELEASE ttop. 
        END. /* ����� �᫨ ���㬥�� ᮧ��� */
      END.  /* ����� �� ���ਨ */
   END. /* ����� �� ��� */
   mCount = mCount + 1.
RUN ClearBar (mBarId).
/*--------------------------------------------------------------------------------------------------*/

{setdest.i}

PUT UNFORMATTED '����� �� ���������� ����� �������� �� ����������.'  SKIP(1).
PUT UNFORMATTED '�������� ��� ����. ����: ' mBegDate ' - ' mEndDate  SKIP.
PUT UNFORMATTED '              ���������: ' mCat                     SKIP.
PUT UNFORMATTED '                 ������: ' mClass   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '                �������: ' mTable   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '              ���������: ' mField   FORMAT "x(60)" SKIP.
PUT UNFORMATTED '           ������������: ' mUser    FORMAT "x(60)" SKIP.
PUT UNFORMATTED '            �����������: ' mDetails FORMAT "��/���" SKIP(2).


FOR EACH tt-DayLockHist NO-LOCK BY tt-DayLockHist.t-op-date BY tt-DayLockHist.t-cat:
   PUT UNFORMATTED "����. ���� " tt-DayLockHist.t-op-date.
   PUT UNFORMATTED " ��������� " tt-DayLockHist.t-cat.
   PUT UNFORMATTED " ���� ������� " tt-DayLockHist.t-modif-date " � " STRING(tt-DayLockHist.t-modif-time,'hh:mm:ss') SKIP(1).

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

   FOR EACH ttOp WHERE ttop.op-date EQ tt-DayLockHist.t-op-date AND
                       ttop.tcat    EQ tt-DayLockHist.t-cat
   NO-LOCK BREAK BY ttOp.doc-num
                 BY ttOp.modif-date
                 BY ttOp.modif-time
                 BY ttOp.user-id
                 BY ttOp.file-name:
      IF FIRST-OF(ttOp.doc-num)
         THEN PUT UNFORMATTED ttOp.doc-num FORMAT "x(6)" " " ttOp.doc-date " ".
         ELSE PUT UNFORMATTED "                ".
      PUT UNFORMATTED ttOp.modif-date " " STRING(ttOp.modif-time,'hh:mm:ss') " " ttOp.user-id FORMAT "x(8)" " ".
      IF mDetails
         THEN PUT UNFORMATTED ttop.tmodify FORMAT "x(4)" " " ttOp.FILE-NAME FORMAT "x(8)" " " ttOp.tField FORMAT "x(15)" " " ttOp.tvalue FORMAT "x(20)" " " ttOp.tNewField FORMAT "x(20)".
         PUT UNFORMATTED "" SKIP.

   END.
   PUT UNFORMATTED ""  SKIP(2).
END.
{signatur.i}
{preview.i}
RETURN.
