/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: ree-113i.p
      Comment: '113-� ����� ॥��� �� �஢������ ������'
   Parameters:
         Uses: 
      Used by:
      Created: 15.06.2004 0031886 ABKO
     Modified: 22/06/2004 kolal   ������஢���� ���� ����� ॥���. ��� 32158.
     Modified: 04.07.2004 abko 0032166 + 0032274 + 0032304 + 0032371 + 0032652 .
     Modified: 15/07/2004 kolal   �ᯮ�짮����� �⠭�. �����㬥�⮢ ��� ����祭�� 
                                  ����� ॥���. ��� 32158.
     Modified: 10.08.2004 abko 0034008 ��ࠢ���� ��� ॥���.
     Modified: 25.11.2005 kraw (0047185) ����������� ��⮭㬥�樨 �� ����� Counters
     Modified: 28.11.2005 kraw (0054939) ��� �ࠦ����⢠ ������ᨬ� �� �㬬�
     Modified: 21.03.2006 kraw (0059487) �ࠢ���� �⡮� �� "�����犠�"
     Modified: 13.10.2006 vasov(0065774) ��ᥢ �஢���� �� ��⠬ �����ᨩ;
                                         ��ᥢ ���㬥�⮢, 㦥 �ᯥ�⠭��� � ��㣮� ॥���;
                                         �⪫�祭�� ��⮬���.�ନ஢���� ����� ॥���
*/

{globals.i}
{wordwrap.def}
{tmprecid.def}
{intrface.get xclass}
{intrface.get count}
{pir_anketa.fun}       /* Borisov A.V. - function Kladr */

DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.

DEFINE VARIABLE mNumDate AS DATE NO-UNDO.

FIND FIRST tmprecid
   NO-LOCK NO-ERROR.

IF NOT AVAIL tmprecid
THEN DO:
   MESSAGE "�� ��࠭� ���㬥���" VIEW-AS ALERT-BOX.
   RETURN.
END.

{ree-113i.def}

DEFINE VARIABLE mAcctPer     AS CHARACTER      NO-UNDO.
DEFINE VARIABLE mBreakReport AS LOGICAL        NO-UNDO.
DEFINE VARIABLE mBreakFlag   AS LOGICAL        NO-UNDO.
DEFINE VARIABLE mReeNum      AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE mOpReeNum    AS CHARACTER      NO-UNDO.
DEFINE VARIABLE cReg         AS CHARACTER      NO-UNDO.

{tmprecid.def
   &PREF = "tt-"
   &NGSH = YES
}

DEF TEMP-TABLE tt-itog NO-UNDO
   FIELD vidop AS CHARACTER
   FIELD val5  AS CHARACTER
   FIELD val7  AS CHARACTER
   FIELD val11 AS CHARACTER
   FIELD sum6  AS DECIMAL
   FIELD sum8  AS DECIMAL
   FIELD sum12 AS DECIMAL
   .

DEFINE TEMP-TABLE ttBreakInfo
   FIELD m5     AS CHARACTER
   FIELD m7     AS CHARACTER
   FIELD sprate AS DECIMAL 
.

before:
DO TRANSACTION:
   /*********/
   ASSIGN
      mNaznSchKas = FGetSetting("�����犠�","","")
      mScetKomis  = FGetSetting("�113","��⊮���","")
      mCodNVal    = FGetSetting("�����悠�","","")
      mAcctPer    = FGetSetting ("�113","�珥ॢ����","")
      mOpGr15     = FGetSetting ("�113","����15","")
   .
   mSummKon113 = DEC(FGetSetting("�113","�㬬����113","")) NO-ERROR.
   IF    ERROR-STATUS:ERROR 
      OR mSummKon113 EQ 0
   THEN
      mSummKon113 = 600000.

   mSumm1626 = DECIMAL(FGetSetting("�113","�㬬�1626","")) NO-ERROR.
   IF    ERROR-STATUS:ERROR 
      OR mSumm1626 = 0
   THEN mSumm1626 = 600000.

   IF NUM-ENTRIES(iParam,";") >= 1
   THEN
      ASSIGN
         mParam[1]   = ENTRY(1,iParam,";")
         mBranchMask = mParam[1]
      .

   IF NUM-ENTRIES(iParam,";") >= 2
   THEN
      ASSIGN
         mParam[2] = ENTRY(2,iParam,";")
         mUserMask = mParam[2]
      .

   IF     NUM-ENTRIES(iParam,";")   GT 3
      AND TRIM(ENTRY(4,iParam,";")) EQ "��"
   THEN
      mPrintOpNum = TRUE. 

   IF     NUM-ENTRIES (iParam, ";") GE 5
      AND TRIM (ENTRY (5, iParam, ";")) EQ "��"
   THEN
      mBreakReport = TRUE.

   /* ��࠭�� ��� ���㬥��� */
   RUN rid-rest.p (OUTPUT TABLE tt-tmprecid).
   {empty tmprecid}

   FIND FIRST tt-tmprecid.
   FIND FIRST op
      WHERE RECID(op) EQ tt-tmprecid.id
      NO-LOCK NO-ERROR.

   DEFINE VARIABLE prefix AS CHARACTER.
   DEFINE VARIABLE in-end-date LIKE op.op-date.

   in-end-date = op.op-date.

   mNumDate = TODAY.

   IF AVAILABLE op
   THEN
      mNumDate = op.op-date.

   /* ����� ���ࠧ������� � ���짮��⥫�� */
   PAUSE 0.
   UPDATE 
      mBranchMask
      mUserMask
      mReeNum LABEL "����� ॥���     "
   WITH FRAME enter-cond
      WIDTH 60
      SIDE-LABELS
      CENTERED
      ROW 10
      TITLE "[ �롥�� ���ࠧ������� � ���짮��⥫� ]"
      OVERLAY
   EDITING:

   READKEY.
   IF    FRAME-FIELD EQ "mBranchMask"
      AND LASTKEY = 301
   THEN DO:
      RUN browseld.p ("branch",    /* ����� ��ꥪ�. */
                      "parent-id", /* ���� ��� �।��⠭����. */
                      "*",         /* ���᮪ ���祭�� �����. */
                      ?,           /* ���� ��� �����஢��. */
                      4).          /* ��ப� �⮡ࠦ���� �३��. */

      IF keyfunc(lastkey) NE "end-error"
      THEN DO:
         ASSIGN
            mBranchMask = pick-value
            mBranchMask:SCREEN-VALUE = pick-value.
            RELEASE branch.
         END.
      END.
      ELSE DO:
         IF     FRAME-FIELD EQ "mUserMask"
            AND LASTKEY = 301
         THEN DO:
            RUN browseld.p ("_user",   /* ����� ��ꥪ�. */
                            "_userid", /* ���� ��� �।��⠭����. */
                            "*",       /* ���᮪ ���祭�� �����. */
                            ?,         /* ���� ��� �����஢��. */
                            6).        /* ��ப� �⮡ࠦ���� �३��. */

            IF keyfunc(lastkey) NE "end-error"
            THEN DO:
               ASSIGN
                  mUserMask = pick-value
                  mUserMask:SCREEN-VALUE = pick-value
               .
               RELEASE _user.
            END.
         END.
         ELSE DO:
            IF LASTKEY EQ 27
            THEN DO:
               /* ����⠭���� recid's �� ��� ���㬥��� */
               {empty tmprecid}

               FOR EACH tt-tmprecid:
                  CREATE tmprecid.
                  tmprecid.id = tt-tmprecid.id.
               END.
               HIDE FRAME enter-cond.
               RETURN.
            END.
            ELSE
               APPLY LASTKEY.
         END.
      END.
   END.
   HIDE FRAME enter-cond.

   /* ����⠭���� recid's �� ��� ���㬥��� */
   {empty tmprecid}
   
   FOR EACH tt-tmprecid:
      CREATE tmprecid.
      tmprecid.id = tt-tmprecid.id.
   END.

   {get-bankname.i}

   ASSIGN
      mNameBank  = cBankName
      mREGN      = FGetSetting("REGN","","")
      mAdres-pch = FGetSetting("����_��","","")
   .

   IF mBranchMask EQ "*"
   THEN
      mAdres-kass = mAdres-pch.
   ELSE
      mAdres-kass = GetXAttrValueEx("branch", STRING(mBranchMask), "����_��", mAdres-pch).

END. /*before*/


/* ----------------------------------------------------------------------------------------------------------------------------------- */
prefix = "ree" + "_" + userid + "_" + STRING(mReeNum).

IF (mBranchMask EQ "00002")
THEN
   prefix ="ree_p".

{pirraproc.def}
{pirraproc.i &arch_file_name = ".txt" &prefix = "yes"}
{setdest.i &cols=242 &filename = arch_file_name}
{justamin}

mBreakFlag = FALSE.

RUN PrintHeader. /* �뢮� ��������� */
ASSIGN
   mDocNum    = 1.

DEFINE BUFFER history1 FOR history.

FOR EACH tmprecid
   NO-LOCK,
   FIRST op
      WHERE RECID(op) EQ tmprecid.id
        AND CAN-DO(mUserMask,op.user-id)
      NO-LOCK,
   LAST history1
      WHERE history1.file-name EQ "op"
        AND history1.field-ref EQ STRING(op.op)
        AND history1.modify = "w"
        AND history1.field-value MATCHES "*op-status*"
      NO-LOCK,
   EACH op-entry OF op
      NO-LOCK
   BREAK BY history1.modif-time
         BY op.op
   :


   /*----------------------------------------------- �롮ઠ ---------------------*/
   mOpReeNum = GetXattrValue("op", STRING (op.op), "�����������").

   IF     mOpReeNum NE ""
      AND mOpReeNum NE STRING(mReeNum) /* ���㬥�� 㦥 ����祭 � ��㣮� ॥��� */
   THEN NEXT.

   {ree-113i.sel}

   IF NOT (   CAN-DO(mBranchMask,acct-cr.branch-id)
           OR CAN-DO(mBranchMask,acct-db.branch-id)
           )
   THEN NEXT.

   IF    CAN-DO(mScetKomis,op-entry.acct-cr)
      OR CAN-DO(mScetKomis,op-entry.acct-db)
   THEN NEXT.

   /* ����祭�� ������
      ������ ��ப� ���� ᮤ�ন� ���ଠ�� �� �⤥�쭮� ���㬥�� � (����)�஢�����, 
      �易���� � ���. �᫨ � ���㬥�� ���� ��� ����஢����, � ������������� ���. 
      �᫨ �� ����� ����, � ������������� ���� �஢����, � ������ ��������� ���� 
      ����� � �।��.
   */

   ASSIGN
      m5  = ""
      m6  = 0
      m7  = ""
      m8  = 0
      m10 = 0
      m11 = ""
      m12 = 0
      m13 = ""
      m15 = ""
      mFIO[1] = ""
      m17[1]  = ""
      mADR[1] = ""
      mDocId  = ""
   .

   IF (       CAN-DO(mNaznSchKas, acct-db.contract)
      AND NOT CAN-DO("20203*", acct-db.acct))
   THEN DO:
      IF (acct-db.currency EQ "")
      THEN
         ASSIGN
            m5 = mCodNVal
            m6 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN
            m5 = acct-db.currency
            m6 = op-entry1.amt-cur
         .
   END.

   IF (    CAN-DO(mNaznSchKas, acct-cr.contract)
      AND NOT CAN-DO("20203*",acct-cr.acct))
   THEN DO:
      IF (acct-cr.currency EQ "")
      THEN
         ASSIGN
            m7 = mCodNVal
            m8 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN
            m7 = acct-cr.currency
            m8 = op-entry2.amt-cur
         .
   END.

   IF (acct-db.acct BEGINS "20203")
   THEN DO:
      m10 = op-entry1.qty.

      IF (acct-db.currency EQ "")
      THEN
         ASSIGN
            m11 = mCodNVal
            m12 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN
            m11 = acct-db.currency
            m12 = op-entry1.amt-cur
         .
   END.

   IF (acct-cr.acct BEGINS "20203")
   THEN DO:
      m10 = op-entry2.qty.

      IF (acct-cr.currency EQ "")
      THEN
         ASSIGN
            m11 = mCodNVal
            m12 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN
            m11 = acct-cr.currency
            m12 = op-entry2.amt-cur
         .
   END.

   IF     NOT CAN-DO(mNaznSchKas, acct-cr.contract)
      AND acct-cr.cust-cat EQ "�"
   THEN
      m13  = acct-cr.acct.
   ELSE
      IF     NOT CAN-DO(mNaznSchKas, acct-db.contract)
         AND acct-db.cust-cat EQ "�"
      THEN
         m13 = acct-db.acct.

   IF CAN-DO (mAcctPer, m13) THEN
      m13 = "".

   IF acct-db.cust-cat EQ "�"
   THEN
      FIND FIRST person
         WHERE (person.person-id EQ acct-db.cust-id)
         NO-LOCK NO-ERROR.
   ELSE
      IF acct-cr.cust-cat EQ "�"
      THEN
         FIND FIRST person
            WHERE (person.person-id EQ acct-cr.cust-id)
            NO-LOCK NO-ERROR.

   m15 = "".
   IF    op-entry.amt-rub GE mSumm1626
      OR (   op-entry.amt-rub LT mSumm1626
         AND NOT CAN-DO(mOpGr15, mVidOpNalV))
   THEN DO:
                    
         m15 = GetXAttrValue("op", STRING(op-entry.op), "country-rec").

         IF m15 EQ ""
         THEN
            m15 = GetXAttrValue("op", STRING(op-entry.op), "country-send").

         IF m15 EQ ""
         THEN
            m15 = GetXAttrValue("op", STRING(op-entry.op), "country-pers").

		 IF m15 EQ "" AND  AVAILABLE person
		 THEN
      		m15 = GetXAttrValue("person", STRING(person.person-id), "country-id2").

         IF m15 EQ "" AND  AVAILABLE person
		 THEN
      		m15 = person.country-id.
      

      IF    m15 EQ "999"
         OR m15 EQ "nnn"
      THEN m15 = "".
   END.

   ASSIGN
      mFIO[1] = ""
      m17[1]  = ""
      mDocId  = ""
      mADR[1] = ""
   .

   IF    op-entry.amt-rub >= mSummKon113
      OR (   op-entry.amt-rub  < mSummKon113
         AND op-entry.amt-rub >= mSumm1626
         AND GetXattrValueEx("op",STRING(op.op),"���113","���") EQ "��"
         )
      OR (   op-entry.amt-rub < mSummKon113
         AND NOT CAN-DO(mOpGr15,mVidOpNalV)
         )
   THEN DO:
      IF AVAILABLE person
      THEN DO:
/*
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ "�")
              AND (cust-ident.cust-id        EQ person.person-id)
              AND (cust-ident.class-code     EQ "p-cust-ident")
              AND (cust-ident.cust-code-type EQ "��ᯮ��")
            NO-LOCK NO-ERROR.
         IF NOT (AVAILABLE cust-ident)
         THEN DO:
            FIND LAST cust-ident
               WHERE (cust-ident.cust-cat       EQ "�")
                 AND (cust-ident.cust-id        EQ person.person-id)
                 AND (cust-ident.class-code     EQ "p-cust-ident")
               NO-LOCK NO-ERROR.
         END.

         IF (AVAILABLE cust-ident)
         THEN DO:
            mDocId = cust-ident.cust-code-type + ','
                   + cust-ident.cust-code      + ','
                   + STRING(cust-ident.cust-type-num).
            mDocId = GetXAttrValue("cust-ident", mDocId, "���ࠧ�").
            m17[1] = ", N " + cust-ident.cust-code
                   + ", �뤠� " + STRING(cust-ident.open-date, "99.99.9999")
                   + ", " + cust-ident.issue
                   + (IF (mDocId EQ "") THEN "" ELSE (", �/� " + mDocId)).
            mDocId = GetCodeName("�������", cust-ident.cust-code-type).
         END.
         ELSE
*/
            ASSIGN
               m17[1] = ", N " + person.document + ", �뤠� " 
                      + GetXAttrValue("person", STRING(person.person-id), "Document4Date_vid")
                      + ", " + person.issue
               mDocId = GetCodeName("�������", person.document-id)
            .

         ASSIGN
            mFIO[1] = person.name-last + " " + person.first-names
                    + (IF (op-entry.amt-rub GE 600000)
                       THEN (" " + STRING(person.birthday, "99.99.9999"))
                       ELSE "")
            cReg    = GetXAttrValue("person", STRING(person.person-id), "country-id2") + ","
                    + GetXAttrValue("person", STRING(person.person-id), "���������")
            mADR[1] = Kladr(cReg, person.address[1] + person.address[2])
         .
      END.

      mFIO[1] = GetXAttrValueEx("op", STRING(op.op), "���",         mFIO[1])
              + GetXAttrValueEx("op", STRING(op.op), "���쐮��",    "").
      mDocId  = GetXAttrValueEx("op", STRING(op.op), "document-id", mDocId).
      m17[1]  = GetXAttrValueEx("op", STRING(op.op), "����",       m17[1]).
      mADR[1] = GetXAttrValueEx("op", STRING(op.op), "����",       mADR[1]).
   END.

   IF AVAILABLE person
   THEN
      RELEASE person.

   IF  m15 NE ""
   THEN DO:
      FIND FIRST country
         WHERE country.country-id EQ m15
         NO-LOCK NO-ERROR.

      IF AVAILABLE country
      THEN
         m15 = STRING(country.country-alt-id).
   END.

   msprate    = DECIMAL(GetXAttrValueEx("op", STRING(op-entry.op), "sprate", "0")) NO-ERROR.
   mDover     = GetXAttrValueEx("op", STRING(op-entry.op), "�����", "���").
   mDover     = IF mDover NE "���"
                THEN "X"
                ELSE " ".
   m9         = IF ((mVidOpNalV EQ "16") OR (mVidOpNalV EQ "17"))
                THEN "X"
                ELSE " ".

   FIND LAST history
      WHERE history.file-name EQ "op" 
        AND history.field-ref EQ STRING(op.op)
        AND history.modify    EQ "W"
        AND history.field-value MATCHES "*op-status*"
        NO-LOCK NO-ERROR.

   IF AVAIL history 
   THEN
      mOpTime = STRING(history.modif-time,"HH:MM").
   ELSE
      mOpTime = "".

   m17[1] = mDocId + " " + m17[1].

   {wordwrap.i &s=mFIO &l=20 &n=10}
   {wordwrap.i &s=mADR &l=30 &n=10}
   {wordwrap.i &s=m17  &l=18 &n=10}

   IF mBreakReport
   THEN DO:
      /*  �஢����, �㦭� �� ࠧ������  */
      FIND FIRST ttBreakInfo
         WHERE (   m5 NE ""
               AND m7 NE ""
               AND ttBreakInfo.m5 EQ m5
               AND ttBreakInfo.m7 EQ m7
               )
            OR (   m5 NE ""
               AND m7 EQ ""
               AND ttBreakInfo.m5 EQ m5
               AND ttBreakInfo.m7 EQ m11
               )
            OR (   m5 EQ ""
               AND m7 NE ""
               AND ttBreakInfo.m5 EQ m11
               AND ttBreakInfo.m7 EQ m7
               )
         NO-LOCK NO-ERROR.

      IF NOT AVAIL ttBreakInfo
      THEN DO:
         CREATE ttBreakInfo.
         ASSIGN
            ttBreakInfo.m5     = IF (m5 NE "") THEN m5 ELSE m11
            ttBreakInfo.m7     = IF (m7 NE "") THEN m7 ELSE m11
            ttBreakInfo.sprate = msprate
         .
      END.
      ELSE
         mBreakFlag = msprate NE ttBreakInfo.sprate.
   END.

   IF mBreakFlag
   THEN DO:      /* ����� ���� ॥��� */
      RUN PrintTotals&Footer. /* �뢮� �⮣�� */
      /* ���᫥��� ������ ����� ॥���*/
      ASSIGN
         mReeNum = mReeNum + 1
         mDocNum = 1
      .

      RUN PrintHeader.     /* �뢮� ��������� */

      {empty ttBreakInfo}
      CREATE ttBreakInfo.
      ASSIGN
         ttBreakInfo.m5        = IF (m5 NE "") THEN m5 ELSE m11
            ttBreakInfo.m7     = IF (m7 NE "") THEN m7 ELSE m11
            ttBreakInfo.sprate = msprate
      .
      {empty tt-itog}
      mBreakFlag = FALSE.
   END.

   RUN put-itog(mVidOpNalV).
   RUN put-itog("**").
   UpdateSigns("opb", STRING(op.op), "�����������", STRING(mReeNum), ?).

   IF mPrintOpNum
   THEN
       UpdateSigns("opb", STRING(op.op), "���������", op.doc-num, ?).
   ELSE
       UpdateSigns("opb", STRING(op.op), "���������", STRING(mDocNum), ?).

   PUT UNFORMATTED
       "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������͹" SKIP
   .

   IF mPrintOpNum
   THEN
      PUT UNFORMATTED "�"   STRING(op.doc-num, "x(6)") .
   ELSE
      PUT UNFORMATTED "�"   STRING(mDocNum, ">>>>>9").

   PUT UNFORMATTED "� " STRING(mOpTime, "x(5)") "� "   STRING(mVidOpNalV, "x(2)")       "  ".
   IF msprate GT 0
   THEN
      PUT UNFORMATTED
         "� "   STRING(msprate, ">,>>9.9999")    " "
      .
   ELSE
      PUT UNFORMATTED
         "�            "
      .

   PUT UNFORMATTED
      "� "  STRING(m5, "x(3)")              " "
      "� "  STRING(m6, ">,>>>,>>>,>>9.99")  " "
      "� "  STRING(m7, "x(3)")              " "
      "� "  STRING(m8, ">,>>>,>>>,>>9.99")  " "
      "�  " STRING(m9, "x(1)")              "  " 
      "�"   STRING(m10, ">>>>,>>9")         " "
      "� "  STRING(m11, "x(3)")             " "
      "� "  STRING(m12, ">,>>>,>>>,>>9.99") " "
      "� "  STRING(m13, "x(20)")            " "
      "�  " STRING(mDover, "x(1)")          "   " 
      "�  " STRING(m15, "x(3)")             "  "
      "� "  STRING(mFIO[1], "x(20)")        " "
      "� "  STRING(m17[1], "x(18)")         " "
      "� "  STRING(mADR[1], "x(30)")        " "
      "�"   SKIP
   .

   DO mI = 2 to 10:
      IF    mADR[mI] NE "" 
         OR mFIO[mI] NE ""
         OR m17[mI]  NE ""
      THEN
         PUT UNFORMATTED
            "�      "
            "�      "
            "�     "
            "�            "
            "�     "
            "�                  "
            "�     "
            "�                  "
            "�     "
            "�         "
            "�     "
            "�                  "
            "�                      "
            "�      "
            "�       "
            "� "   STRING(mFIO[mI], "x(20)") " "
            "� "   STRING(m17[mI], "x(18)")  " "
            "� "   STRING(mADR[mI], "x(30)") " "
            "�"    SKIP
         .
      ELSE LEAVE.
   END.

   /*
   1  - ����� ���㬥�� op.doc-num
   2  - �६� ����� ���㬥�� � ��⥬�.
   3  - �������⥫�� ४����� ���㬥�� "���������".
   4  - ���祭�� �������⥫쭮�� ४����� "sprate".
   5  - ��� ����砥��� ������. ��� ������ �� �஢���� ��� ����஢����, � ���ன ���
        � �����祭��� �� ����஥筮�� ��ࠬ���"�����犠�" �⮨� �� ������,
        �� �᪫�祭��� ��⮢ 20203*.
   6  - �㬬� ����砥��� ������. �㬬� � ����� ���� 5 �� �஢���� ��� ����஢����, 
        � ���ன ��� � �����祭��� �� ����஥筮�� ��ࠬ���"�����犠�" �⮨� �� ������,
        �� �᪫�祭��� ��⮢ 20203*.
   7  - ��� �뤠������ ������. ��� ������ �� �஢���� ��� ����஢����, � ���ன ���
        � �����祭��� �� ����஥筮�� ��ࠬ���"�����犠�" �⮨� �� �।���,
        �� �᪫�祭��� ��⮢ 20203*.
   8  - �㬬� �뤠������ ������. �㬬� � ����� ���� 7 �� �஢���� ��� ����஢����,
        � ���ன ��� � �����祭��� �� ����஥筮�� ��ࠬ���"�����犠�" �⮨� �� �।���,
        �� �᪫�祭��� ��⮢ 20203*.
   9  - ���� �� ����������.
   10 - ������⢮ ���� op-entry.qty �� �஢���� � ���ன ��� 20203* �⮨� �� ������
        ��� �� �।���.
   11 - ��� ������ �� �஢���� � ���ன ��� 20203* �⮨� �� ������ ��� �� �।���.
   12 - �㬬� � ����� �� ���� 11 �஢���� � ���ன ��� 20203* �⮨� �� ������ ��� �� �।���.
   13 - �᫨ ��� ����� ����ᯮ������ � ���㬥�� � ��⮬, ����� �� ���� ��⮬ �����,
        � �뢮����� ��� ����ᯮ������騩 ���. �᫨ ��� ��� ����� ��⠬� �����,
        � � ���� ��祣� �� �뢮�����.
   14 - ���祭�� �������⥫쭮�� ४����� "�����".
   15 - �᫨ ��� ����� ����ᯮ������ � ���㬥�� � ��⮬, �����⮬ ���ண� ���� 
        䨧��᪮� ���, � �� ���� person.country-id ������, �易����� � ��⮬.
        ���� - ���祭�� ������������ �������⥫쭮�� ४����� "country-rec" ��� "country-send".
   16 - �᫨ ��� ����� ����ᯮ������ � ���㬥�� � ��⮬, �����⮬ ���ண� ���� 
        䨧��᪮� ���, � �� ��� ������� ������. ���� ���祭�� �������⥫쭮�� ४����� "���".
   17 - �᫨ ��� ����� ����ᯮ������ � ���㬥�� � ��⮬, �����⮬ ���ண� ����
        䨧��᪮� ���, � �� ⨯ � ����� ���㬥�� ������� ������.
        ���� ���祭�� �������⥫쭮�� ४����� "����".
   18 - �᫨ ��� ����� ����ᯮ������ � ���㬥�� � ��⮬, �����⮬ ���ண� ����
        䨧��᪮� ���, � �� ���� ������� ������.
        ���� ���祭�� �������⥫쭮�� ४����� "����".
   */

   mDocNum = mDocNum + 1.
END.

/* ��᫥���� �⮣� */
RUN PrintTotals&Footer.

{preview.i &filename=arch_file_name}

/* ---------------------------------------------------------------------------------------------------------------------------------- */
PROCEDURE PrintHeader:

   PAGE.

   DISP "������������ 㯮�����祭���� �����                                 "
      mNameBank VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL
      "  (䨫���� 㯮�����祭���� �����)                                  " SKIP
      "�������樮��� ����� 㯮�����祭���� �����                        "
      mREGN VIEW-AS EDITOR SIZE 35 BY 1 NO-LABEL         SKIP
      "/���浪��� ����� 䨫���� 㯮�����祭���� �����                    " SKIP
      "���� 㯮�����祭���� �����                                        "
      mAdres-pch VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL    SKIP
      "(䨫���� 㯮�����祭���� �����)                                    " SKIP
      "���� ����樮���� �����                                           "
      mAdres-kass VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
      "��� ���������� ������                                            "
      op.op-date   NO-LABEL                              SKIP
      "                                                                   ���� ����� ��� " SKIP
      "���浪��� ����� ������ � �祭�� ࠡ�祣� ��� ����樮���� ����� "
      STRING(mReeNum) NO-LABEL                           SKIP(1)
      WITH FRAME mA1 SIZE 160 BY 10.

   PUT UNFORMATTED 
      SPACE(50) "������ �������� � �������� ������� � ������" SKIP(1).

   PUT UNFORMATTED
      "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������ͻ" SKIP
      "�����-��६� � ��� �   ����     �            ������ ������� �।�⢠           � ���-��ਭ�� (�뤠��) ���ᮢ� ࠡ�⭨-�     ����� ���      � ����-�  ���  � �.�.�. 䨧��᪮��   � ���㬥��, 㤮�⮢�-� ���� ���� ��⥫��⢠ (����  �" SKIP
      "����� �ᮢ��-� �����(����-����)�������������������������������������������������͹ ⥦-���� 祪�� (� ⮬ �᫥ ��஦���   �                      � ७- ���࠭� �         ���         �   ���騩 ��筮���  � �ॡ뢠���)                    �" SKIP
      "������ �襭�� � ���-�  �����-    �       �ਭ��          �         �뤠��         � ��� �祪��), �������쭠�  �⮨����� ��-�                      � ����� �ࠦ- �                      �                    �                                �" SKIP
      "�����-�����-��樨�  ࠭���    �  ���ᮢ� ࠡ�⭨���   �  ���ᮢ� ࠡ�⭨���   � ���-����� 㪠���� � �����࠭��� ����⥺                      �      �����⢠�                      �                    �                                �" SKIP
      "� 樨  �樨   �     �  ������    �������������������������������������������������͹ �  ����������������������������������͹                      �      � 䨧�- �                      �                    �                                �" SKIP
      "�      �      �     �            � ��� �      �㬬�       � ��� �      �㬬�       �     � ����-   � ��� �      �㬬�       �                      �      ��᪮���                      �                    �                                �" SKIP
      "�      �      �     �            �����-�                  �����-�                  �     � ��⢮  �����-�                  �                      �      � ���  �                      �                    �                                �" SKIP
      "�      �      �     �            � ��  �                  � ��  �                  �     �  祪��  � ��  �                  �                      �      �       �                      �                    �                                �" SKIP
      "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������͹" SKIP
      "�  1   �  2   �  3  �      4     �  5  �         6        �  7  �         8        �  9  �   10    � 11  �       12         �          13          �  14  �   15  �          16          �         17         �              18                �" SKIP
   .

END PROCEDURE.


PROCEDURE PrintTotals&Footer:

   FOR EACH tt-itog:
      IF tt-itog.vidop EQ "**"
      THEN NEXT.

      PUT UNFORMATTED
         "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������͹" SKIP
         "� ������      "
         "� "   STRING(tt-itog.vidop, "X(2)") "  "
         "�            "
         "� "   STRING(tt-itog.val5, "x(3)")             " "
         "� "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
         "� "   STRING(tt-itog.val7, "x(3)")             " "
         "� "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
         "�     "
         "�         "
         "� "   STRING(tt-itog.val11, "x(3)")            " "
         "� "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
         "� "   FILL(" " ,21)
         "�      " 
         "�       "
         "� "   FILL(" " ,21)
         "� "   FILL(" " ,19)
         "� "   FILL(" " ,31)
         "�"    SKIP
      .
   END.

   PUT UNFORMATTED
      "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������ͼ"
      SKIP(1)
   .

   IF     NUM-ENTRIES(iParam,";")   GT 2 
      AND TRIM(ENTRY(3,iParam,";")) EQ "��"
   THEN DO:

      PUT UNFORMATTED
         "            ������� �����" SKIP
         "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������ͻ" SKIP
         "�  1   �  2   �  3  �      4     �  5  �        6         �  7  �       8          �  9  �    10   � 11  �        12        �          13          �  14  �   15  �          16          �         17         �              18                �" SKIP
      .

      FOR EACH tt-itog
         WHERE tt-itog.vidop EQ "**":

         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������͹" SKIP
            "� ������      "
            "� �� "
            "�            "
            "� "   STRING(tt-itog.val5, "x(3)")             " "
            "� "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
            "� "   STRING(tt-itog.val7, "x(3)")             " "
            "� "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
            "�     "
            "�         "
            "� "   STRING(tt-itog.val11, "x(3)")            " "
            "� "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
            "� "   FILL(" " ,21)
            "�      " 
            "�       "
            "� "   FILL(" " ,21)
            "� "   FILL(" " ,19)
            "� "   FILL(" " ,31)
            "�"    SKIP
         .
      END.

      PUT UNFORMATTED
         "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������ͼ"
         SKIP(1)
      .
   END.

   {signatur.i &user-only=yes}
END PROCEDURE.

PROCEDURE put-itog:
   DEFINE INPUT PARAMETER iVidOpNalV AS CHAR.

   FIND FIRST tt-itog
      WHERE tt-itog.vidop EQ iVidOpNalV
        AND tt-itog.val5  EQ m5
        AND tt-itog.val7  EQ m7
        AND tt-itog.val11 EQ m11
      NO-ERROR.

   IF NOT AVAIL tt-itog
   THEN DO:
      CREATE tt-itog.
      ASSIGN
         tt-itog.vidop = iVidOpNalV
         tt-itog.val5  = m5
         tt-itog.val7  = m7
         tt-itog.val11 = m11
      .
   END.

   ASSIGN 
      tt-itog.sum6  = tt-itog.sum6  + m6
      tt-itog.sum8  = tt-itog.sum8  + m8
      tt-itog.sum12 = tt-itog.sum12 + m12
   .
   RELEASE tt-itog.
END PROCEDURE.
