/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: deskjour.i
      Comment: ����� �㡫���� ���ᮢ�� ��ୠ��� �� ��室� � ��室�.
   Parameters:
      &bal-begin   = <bal-acct>                   /* �����ᮢ� ��� - ��砫�                    */
      &bal-finis   = <bal-acct>                   /* �����ᮢ� ��� - �����                     */
      &v-symbol    = <symbol>                     /* ᨬ��� ���ᯫ���                            */
      &acct-str    = <acct>                       /* ��楢�� ���                                */
      &acct-sort   = <��ࠦ���� ���஢��>       /* ���஢�� ���ᮢ�� ��ୠ���                */
      &user-id     = <user-id>                    /* �����䨪��� ���짮�⥫�                   */
      &group-clnt  = no                           /* �믮����� ��㯯�஢�� �� ���� ������      */
      &group-ui    = no                           /* ��㯯�஢�� � �஬. �⮣� �� ����. ࠡ�⭨��� */ 
      &DESK_ACCT   = <���>                       /* ��� �����                                  */
      &CLNT_ACCT   = <���>                       /* ��� ������                                */
      &JOUR_NAME   = <���>                        /* ������������ ��ୠ��                        */
      &all-currs                                  /* ��� ������ (�� ⮫쪮 �㡫�)               */
      &i2481-tt                                   /* ⮫쪮 ��������� �६����� ⠡���� ���
                                                     ���ᮢ�� ��ୠ��� �� 2481-�                 */
         Uses:
      Used by:
      Created: ?
     Modified:  18.01.2005 abko (0037234) ��।������ ���ய�ࠬ��� &user-inspector ��� ����
                                         ���� � ࠧ������ �� ����஫�ࠬ
     Modified:  01.06.2005 abko (0046877) �� �������� ����஢���� �� defined(acct-str)
     Modified:  28.12.2010 kraa (131079) ������� �ਭ樯 �ନ஢���� ���� tt-header.author.
     Modified: 
     
*/
&GLOBAL-DEFINE end-date end-date



&IF DEFINED(user-direct) > 0 &THEN
   &IF DEFINED(user-id) = 0 &THEN
      &SCOPED-DEFINE user-id YES
   &ENDIF
   &IF DEFINED(user-inspector) > 0 &THEN
      &UNDEFINE user-inspector
   &ENDIF
   &IF DEFINED(group-ui) > 0 &THEN
      &UNDEFINE group-ui
   &ENDIF
&ENDIF

&IF DEFINED(group-ui) &THEN
   &GLOBAL-DEFINE user-id
   &IF DEFINED(user-inspector) &THEN
     &UNDEFINE user-inspector
   &ENDIF  
&ENDIF

/* =====�믮����� ⮫쪮 ������� �६����� ⠡���===== */

&IF DEFINED(main_work) = 0 &THEN
{intrface.get op}
{korder.i}

DEFINE TEMP-TABLE mTT-Doc NO-UNDO 
   FIELD num AS INT64. /* ��� ����� �� ����������� ����஢ ���㬥�⮢ */
   
&IF DEFINED(user-id) > 0 AND
    (DEFINED(user-inspector) > 0 OR DEFINED(user-direct) > 0)
&THEN
DEFINE TEMP-TABLE ttOpEntryByUser NO-UNDO
   FIELD user-id LIKE op.user-id
   FIELD Rwd     AS   ROWID
INDEX ByUI IS PRIMARY user-id Rwd.
&ENDIF

DEFINE TEMP-TABLE tt-op-entry
    FIELD rwd AS ROWID

    INDEX rwd
    IS PRIMARY UNIQUE
        rwd
.   
&IF DEFINED(user-id) &THEN
   DEFINE VARIABLE mCurrentUser AS CHAR NO-UNDO.
   DEFINE VARIABLE mI           AS INT64 NO-UNDO.

   {jour-par.i}
&ELSE
   &IF DEFINED(std-jour-par) &THEN
      {std-jour-par.i}
   &ENDIF
&ENDIF
 
&ENDIF

/* =====�᭮���� ࠡ��===== */

&IF DEFINED(proc_def) = 0 &THEN

DEFINE BUFFER xop-entry FOR op-entry.
DEFINE VARIABLE long-acct   AS CHARACTER FORMAT "X(25)"
                                         COLUMN-LABEL "������� ����" NO-UNDO.
DEFINE VARIABLE f-acct      AS logical   NO-UNDO.
DEFINE VARIABLE mRealSymbol AS CHARACTER NO-UNDO.
DEFINE VARIABLE mSign   AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE mAcct      LIKE acct.acct     NO-UNDO.
DEFINE VARIABLE mCAcct     LIKE acct.acct     NO-UNDO.
DEFINE VARIABLE mCCurrency LIKE acct.currency NO-UNDO.
/* ��� ���㬥�⮢ ��८業�� */
DEF VAR LstRePrice      AS CHAR    NO-UNDO.
DEF VAR mLgTakeOverrite AS LOGICAL NO-UNDO. /* ����-�� ��८業�� � ���� */
DEFINE VARIABLE mDigital LIKE doc-type.digital NO-UNDO.

DEFINE VARIABLE mSchetDoc AS INT64 NO-UNDO. /* ����稪 ���㬥�⮢ */

ASSIGN
   LstRePrice      = FGetSetting( "��८業��", ?, "" )
   mLgTakeOverrite = fGetSetting( "�����", "��८抠���", "��") EQ "��"
.

/*PIR*/
ASSIGN  
  mLgTakeOverrite = mKurs
.


FOR EACH acct WHERE acct.contract BEGINS "����"
            &IF DEFINED(bal-begin) NE 0 &THEN
                AND acct.bal-acct GE {&bal-begin}
            &ENDIF
            &IF DEFINED(bal-finis) NE 0 &THEN
                AND acct.bal-acct LE {&bal-finis}
            &ENDIF
                AND acct.acct-cat    EQ "b"
            &IF DEFINED(all-currs) = 0 &THEN
                AND acct.currency    EQ ""
            &ENDIF
                AND (acct.close-date EQ ? OR acct.close-date GE end-date)
                AND (   shMode <> YES
                     OR (    shMode         = YES
                         AND acct.filial-id = shFilial))
            &IF DEFINED(acct-by-branch) &THEN
                AND CAN-DO({&acct-by-branch},acct.branch-id)
            &ENDIF                   
            NO-LOCK
            USE-INDEX acct-cont
            {&acct-sort} :

&IF DEFINED(user-id) &THEN                   /* �஢���� ����稥 ����権 �� ���짮��⥫�   */
   {justamin}

   &IF DEFINED(user-inspector) > 0 OR DEFINED(user-direct) > 0 &THEN
      {empty ttOpEntryByUser}
      FOR EACH op WHERE op.op-status >= gop-status
                    AND op.op-date    = end-date
      NO-LOCK,
      &IF DEFINED(user-direct) &THEN
      FIRST signs WHERE signs.file-name = "op"
                    AND signs.code      = "user-direct"
                    AND signs.surrogate = STRING(op.op)
      NO-LOCK,
      &ENDIF
      EACH op-entry OF op WHERE op-entry.{&DESK_ACCT} = acct.acct
                            AND (   mLgTakeOverrite  /* ��६ ��८�? */ 
                                 OR NOT (    op-entry.currency <> "" /* �᪫�砥� ��८業�� */
                                         AND op-entry.amt-cur   = 0))
      NO-LOCK:
         &IF DEFINED(user-inspector) > 0 &THEN
         mCurrentUser = op.user-inspector.
         &ELSEIF DEFINED(user-direct) > 0 &THEN
         mCurrentUser = GetXAttrValue("op",
                                      STRING(op.op),
                                      "user-direct").
         &ENDIF
         IF {assigned mCurrentUser}
         THEN DO mI = 1 TO NUM-ENTRIES(mCurrentUser):
            IF NOT CAN-FIND(FIRST ttOpEntryByUser WHERE ttOpEntryByUser.user-id = ENTRY(mI,mCurrentUser)
                                                    AND ttOpEntryByUser.Rwd     = ROWID(op-entry) NO-LOCK)
            THEN DO:
               CREATE ttOpEntryByUser.
               ASSIGN
                  ttOpEntryByUser.user-id = ENTRY(mI,mCurrentUser)
                  ttOpEntryByUser.Rwd     = ROWID(op-entry)
               .
            END.
         END.
      END.
   &ENDIF

   DO mI = 1 TO entries: /* �� �ᯮ���⥫� ⥯��� ����� ����� ��᪮�쪮 */
      mCurrentUser = ENTRY(mI,list-id).
      &IF DEFINED(user-inspector) > 0 OR DEFINED(user-direct) > 0 &THEN
         IF NOT CAN-FIND(FIRST ttOpEntryByUser WHERE ttOpEntryByUser.user-id = mCurrentUser) THEN NEXT.
      &ELSE
         FIND FIRST op-entry WHERE op-entry.{&DESK_ACCT} EQ acct.acct
                               AND op-entry.op-status    GE gop-status
                               AND op-entry.op-date      EQ end-date
                               AND op-entry.user-id      EQ mCurrentUser
                               AND (   mLgTakeOverrite  /* ��६ ��८�? */ 
                                    OR NOT (    op-entry.currency NE "" /* �᪫�砥� ��८業�� */
                                            AND op-entry.amt-cur  EQ 0))
              NO-LOCK NO-ERROR.
         IF NOT AVAILABLE(op-entry) THEN
            NEXT.
      &ENDIF
      FIND FIRST _User WHERE _User._Userid EQ mCurrentUser
         NO-LOCK NO-ERROR.
&ENDIF
&IF DEFINED(i2481-tt) = 0 &THEN
   {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
   long-acct = {out-fmt.i acct.acct fmt}.

   DISPLAY                    /* �뢥�� ��������� ��ୠ��                    */
      CAPS(name-bank) @ name-bank "      " mOKUD SKIP
      "�����"
      long-acct
      ";"
      {&JOUR_NAME}             FORMAT "X(20)"
      " ��" end-date           
      {&extra-header}
      SKIP(2)
      &IF DEFINED(user-id) &THEN
         &IF DEFINED(user-inspector) > 0 &THEN
            "����஫��   :"
         &ELSEIF DEFINED(user-direct) > 0 &THEN
            "�⢥ত��騩:"
         &ELSE
            "�ᯮ���⥫� :"
         &ENDIF 
                           (IF AVAILABLE _user THEN _User._User-Name ELSE "") FORMAT "x(50)"    SKIP(1)
      &ENDIF
      WITH NO-BOX COL 4 FRAME top NO-LABEL.

   FORM WITH FRAME body DOWN COL 4.
&ELSE
   FIND FIRST tt-header
   WHERE
       tt-header.acct     = acct.acct AND
       tt-header.currency = acct.currency
   NO-LOCK NO-ERROR.
   IF NOT AVAILABLE tt-header THEN DO:
       CREATE tt-header.
       ASSIGN
           tt-header.author    = dept.name-bank
/*pir*/    tt-header.date      = nightdate
           tt-header.acct      = acct.acct
           tt-header.currency  = acct.currency
       .
   END.     
   ASSIGN
       mCAcct     = acct.acct
       mCCurrency = acct.currency
   .
   RELEASE tt-header.
&ENDIF
   mSchetDoc=0.
   {empty mTT-Doc}
   &IF DEFINED(user-id) > 0 AND
       (DEFINED(user-inspector) > 0 OR DEFINED(user-direct) > 0)
   &THEN
   FOR EACH ttOpEntryByUser WHERE ttOpEntryByUser.user-id = mCurrentUser NO-LOCK,
   FIRST op-entry WHERE ROWID(op-entry) = ttOpEntryByUser.Rwd AND
   &ELSE
   FOR EACH op-entry WHERE
   &ENDIF
                       op-entry.{&DESK_ACCT} EQ acct.acct
                       AND op-entry.op-status    GE gop-status
                       AND op-entry.op-date      EQ end-date
                   &IF DEFINED(acct-str) NE 0 &THEN
                       AND (   CAN-DO({&acct-str}, STRING(op-entry.{&CLNT_ACCT}))
                            OR op-entry.{&CLNT_ACCT} EQ ?) /* ����஢���� */
                   &ENDIF
                   &IF DEFINED(user-id) &THEN
                   &IF DEFINED(user-inspector) = 0 AND DEFINED(user-direct) = 0 &THEN
                       AND op-entry.user-id      EQ mCurrentUser
                   &ENDIF
                   &ENDIF
                       AND (   mLgTakeOverrite  /* ��६ ��८�? */ 
                            OR NOT (    op-entry.currency NE "" /* �᪫�砥� ��८業�� */
                                    AND op-entry.amt-cur  EQ 0))
             NO-LOCK,
             &IF DEFINED(user-direct) > 0 &THEN
             FIRST signs WHERE
                signs.file-name = "op"                  AND
                signs.code      = "user-direct"         AND
                CAN-DO(signs.xattr-value, mCurrentUser) AND
                signs.surrogate = STRING(op-entry.op)
             NO-LOCK,
             &ENDIF
             &IF DEFINED(user-direct) &THEN
             FIRST op WHERE STRING(op.op) = signs.surrogate
             &ELSE
             FIRST op OF op-entry
             &ENDIF

	     /*PIR*/
	        WHERE (IF nightkas and op.doc-type <> "04" 
		       THEN op.doc-date < op-entry.op-date
  		       ELSE 
  		       IF not(nightkas) and op.doc-type = "04" THEN op.doc-date <= op-entry.op-date 
                       else op.doc-date = op-entry.op-date)
         AND NOT CAN-DO('����,���줮,���,����1',op.op-kind)
        
                &IF DEFINED(user-inspector) &THEN
                    AND op.user-inspector EQ mCurrentUser
                &ENDIF
             NO-LOCK
      BREAK
      &IF DEFINED (group-ui) &THEN
        BY op-entry.user-id BY op.user-inspector 
      &ELSE
         &IF DEFINED(user-id) &THEN
            &IF DEFINED(user-inspector) &THEN
               BY op.user-inspector
            &ELSE
               BY op-entry.user-id
            &ENDIF
         &ENDIF
      &ENDIF
      &IF DEFINED(group-clnt) NE 0 &THEN
          BY op-entry.{&CLNT_ACCT}
      &ELSE
          BY op-entry.amt-rub
      &ENDIF
      &IF DEFINED(i2481-tt) = 0 &THEN
      ON ENDKEY UNDO, RETURN WITH FRAME body:
      &ELSE
      ON ENDKEY UNDO, LEAVE:
      &ENDIF

      &IF DEFINED(user-direct) > 0 &THEN
      IF CAN-FIND(FIRST tt-op-entry WHERE
                      ROWID(op-entry) = tt-op-entry.rwd)
      THEN
          NEXT.
      CREATE tt-op-entry.
      tt-op-entry.rwd = ROWID(op-entry).
      &ENDIF

      mRealSymbol = FRealSymbol (ROWID (op-entry),"{&DESK_ACCT}" EQ "acct-db").
   &IF DEFINED (v-symbol) NE 0 &THEN
      IF NOT CAN-DO ({&v-symbol},mRealSymbol) THEN
         NEXT.
   &ENDIF
      &IF DEFINED(i2481-tt) = 0 &THEN
      DOWN WITH FRAME body.
      &ENDIF

      RELEASE xop-entry.
      IF op-entry.{&CLNT_ACCT} EQ ? THEN
      DO:
         FIND FIRST xop-entry OF op WHERE xop-entry.{&DESK_ACCT} EQ ? NO-LOCK NO-ERROR.
         &IF DEFINED(acct-str) NE 0 &THEN
         IF     AVAIL xop-entry
            AND NOT CAN-DO({&acct-str}, STRING(xop-entry.{&CLNT_ACCT})) THEN
            NEXT.
         &ENDIF
      END.
      
      &IF DEFINED (group-ui) &THEN
          ACCUMULATE op-entry.amt-rub (TOTAL BY op.user-inspector).
      &ELSE
          ACCUMULATE op-entry.amt-rub (TOTAL).
      &ENDIF

   &IF DEFINED(group-clnt) NE 0 &THEN
      IF FIRST-OF(op-entry.{&CLNT_ACCT}) THEN
         f-acct = YES.
      ELSE
         f-acct = NO.
   &ELSE
      f-acct = YES.
   &ENDIF

      RUN GetCashDocTypeDigital IN h_op (BUFFER op-entry,
                                         acct.acct,
                                         OUTPUT mDigital).
      &IF DEFINED(i2481-tt) = 0 &THEN
      DISPLAY
         {out-fmt.i op-entry.{&CLNT_ACCT}  fmt} WHEN op-entry.{&CLNT_ACCT} NE ?
                                                 AND f-acct     @ acct.acct
         {out-fmt.i xop-entry.{&CLNT_ACCT} fmt} WHEN op-entry.{&CLNT_ACCT} EQ ?
                                                 AND AVAILABLE(xop-entry)
                                                 AND f-acct     @ acct.acct
         mDigital @ op.doc-type /* ��� �� */
         op.doc-num FORMAT "x(7)"
         mRealSymbol @ op-entry.symbol
         op-entry.amt-rub COLUMN-LABEL "����� �!���. ������"
         mSign        COLUMN-LABEL "�������!�������"
         WITH FRAME body.
      &ELSE
      IF f-acct THEN DO:
          mAcct = op-entry.{&CLNT_ACCT}.
          IF mAcct = ? AND AVAIL xop-entry THEN
              mAcct = xop-entry.{&CLNT_ACCT}.
      END.
      CREATE tt-journal-rec.
      ASSIGN
          tt-journal-rec.c-acct   = mCAcct
          tt-journal-rec.doc-num  = op.doc-num
          tt-journal-rec.acct     = mAcct
          tt-journal-rec.doc-code = mDigital
          tt-journal-rec.amt      = op-entry.amt-rub WHEN mCCurrency =  ""
          tt-journal-rec.amt      = op-entry.amt-cur WHEN mCCurrency <> ""
          tt-journal-rec.symbol   = mRealSymbol
          tt-journal-rec.alt-amt  = op-entry.amt-rub WHEN mCCurrency <> ""
/*PIR*/   tt-journal-rec.user-insp = op.user-inspector
      .
      &ENDIF
      /* ������� ������⢠ ���㬥�⮢ */
      FIND mTT-Doc WHERE 
         mTT-Doc.num EQ op-entry.op NO-LOCK NO-ERROR.
      IF NOT AVAIL (mTT-Doc) THEN 
      DO:
         CREATE mTT-Doc.
         mTT-Doc.num= op-entry.op.
      END.
      
&IF DEFINED(i2481-tt) = 0 &THEN
      &IF DEFINED (group-ui) &THEN
      IF LAST-OF (op.user-inspector) THEN DO:    /* �஬������ �⮣� */
          DOWN WITH FRAME body.
          UNDERLINE
             acct.acct
             op.doc-type
             op.doc-num
             op-entry.symbol
             op-entry.amt-rub
             mSign
          WITH FRAME body.
          DOWN WITH FRAME body.
          DISPLAY
             "�⮣�" @ acct.acct
              ACCUM TOTAL BY op.user-inspector op-entry.amt-rub @ op-entry.amt-rub
              op.user-inspector @ mSign
          WITH FRAME body.
          IF NOT LAST-OF (op-entry.user-id) THEN
              UNDERLINE
                 acct.acct
                 op.doc-type
                 op.doc-num
                 op-entry.symbol
                 op-entry.amt-rub
                 mSign
              WITH FRAME body.
      END.
      &ENDIF

&ENDIF
   END.           /* FOR EACH op-entry WHERE op-entry.acct-cr   eq acct.acct                    */

&IF DEFINED(i2481-tt) = 0 &THEN
   DOWN WITH FRAME body.
   UNDERLINE
      acct.acct
      op.doc-num
      op-entry.amt-rub
      mSign
   WITH FRAME body.
   DOWN WITH FRAME body.
&ENDIF
    
   FOR EACH mTT-Doc NO-LOCK:
      mSchetDoc = mSchetDoc + 1.
   END.

&IF DEFINED(i2481-tt) = 0 &THEN
   DISPLAY
      "�����" @ acct.acct
       ACCUM TOTAL op-entry.amt-rub @ op-entry.amt-rub
       mSchetDoc @ op.doc-num
       mSign
   WITH FRAME body.

   {signatur.i}

   IF PAGE-SIZE NE 0 THEN
      PAGE.
   ELSE
      PUT UNFORMATTED
         SKIP(3)
         FILL("-",40)
      .
&ENDIF
&IF DEFINED(user-id) &THEN
   END. /*DO i = 1 TO entries*/
&ENDIF
END.               /* FOR EACH acct WHERE acct.contract BEGINS "����"                           */
/*************************************************************************************************/
&ENDIF
