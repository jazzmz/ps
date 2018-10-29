/**********************************************
 *                                            *
 * �࠭����� �� XML 䠩�� ᮧ���� ���㬥���. *
 *                                            *
 **********************************************
 * ���� : ��᫮� �. �.                       *
 * ���: #2604                              *
 * ���  : 09.04.2013                         *
 **********************************************/
 {globals.i}

 {g-defs.i}
 {a-defs.i}
 {def-wf.i new}
 {defframe.i new} 

 {intrface.get count}



 DEF INPUT  PARAM in-op-date  AS DATE        NO-UNDO.
 DEF INPUT  PARAM oprid       AS RECID       NO-UNDO.

 {details.def}



 /**
  * ��楤��-⮫��� ��� ��ࠡ��稪� ᮡ��� onBefRowRead.
  * @param HANDLE iCurrTable  ��뫪� �� ⠡���� XML
  * @param HANDLE iCurrBuffer ��뫪� �� ⥪���� ��ப�
  * @param HANDLE iTrBuffer   ��뫪� �� ⥪���� �࠭�����
  * @return VOID
  **/
 PROCEDURE onBefRowRead:
  DEF INPUT PARAM iCurrTable  AS HANDLE NO-UNDO.
  DEF INPUT PARAM iCurrBuffer AS HANDLE NO-UNDO.
  DEF INPUT PARAM iTrBuffer   AS HANDLE NO-UNDO.
  DEF INPUT PARAM iCurrDate   AS CHAR   NO-UNDO.
  DEF INPUT PARAM iProc       AS CHAR   NO-UNDO.


  DEF VAR oSysClass           AS TSysClass NO-UNDO.

    oSysClass = NEW TSysClass().

      RUN VALUE(oSysClass:whatShouldIRun(iProc)) (iCurrTable,iCurrBuffer,iTrBuffer,iCurrDate).

    DELETE OBJECT oSysClass.
 END PROCEDURE. 

 /**
  * ��楤��-⮫��� ��� ��ࠡ��稪� ᮡ��� onEndRowRead.
  * @param HANDLE iCurrTable  ��뫪� �� ⠡���� XML
  * @param HANDLE iCurrBuffer ��뫪� �� ⥪���� ��ப�
  * @param HANDLE iTrBuffer   ��뫪� �� ⥪���� �࠭�����
  * @return VOID
  **/
 PROCEDURE onEndRowRead:
  DEF INPUT PARAM iCurrTable  AS HANDLE NO-UNDO.
  DEF INPUT PARAM iCurrBuffer AS HANDLE NO-UNDO.
  DEF INPUT PARAM iTrBuffer   AS HANDLE NO-UNDO.
  DEF INPUT PARAM iCurrDate   AS CHAR   NO-UNDO.
  DEF INPUT PARAM iProc       AS CHAR   NO-UNDO.


  DEF VAR oSysClass           AS TSysClass NO-UNDO.

    oSysClass = NEW TSysClass().
   
     RUN VALUE(oSysClass:whatShouldIRun(iProc)) (iCurrTable,iCurrBuffer,iTrBuffer,iCurrDate).

    DELETE OBJECT oSysClass.
 END PROCEDURE. 


 DEF VAR mFileName      AS CHAR   NO-UNDO.
 DEF VAR mCount         AS INT64  NO-UNDO.

 DEF VAR mOperTable     AS HANDLE NO-UNDO.
 DEF VAR mQuery         AS HANDLE NO-UNDO. 
 DEF VAR mBuffer        AS HANDLE NO-UNDO.
 DEF VAR mField         AS HANDLE NO-UNDO.


 DEF VAR mTableName          AS CHAR   NO-UNDO.
 DEF VAR mFieldCount         AS INT64  NO-UNDO.
 DEF VAR mI                  AS INT64  NO-UNDO.
 DEF VAR mOpKindHandle       AS HANDLE NO-UNDO.
 DEF VAR mDntProcTempl       AS LOG    NO-UNDO.
 DEF VAR currDate            AS DATE   NO-UNDO.

 DEF VAR mBefRowRead         AS CHAR   NO-UNDO.
 DEF VAR mAftRowRead         AS CHAR   NO-UNDO.
 DEF VAR mAftTrEnd           AS CHAR   NO-UNDO.

 DEF VAR mLnCountInt         AS INT    NO-UNDO.
 DEF VAR mLnTotalInt         AS INT    NO-UNDO.


 DEF VAR main-first      AS LOG                     NO-UNDO.
 DEF VAR cur-n           LIKE currency.currency     NO-UNDO.
 DEF VAR vclass          LIKE class.class-code      NO-UNDO.
 DEF VAR vacct-cat       LIKE acct.acct-cat         NO-UNDO.
 DEF VAR tcur-db         LIKE op-templ.currency     NO-UNDO.
 DEF VAR tcur-cr         LIKE op-templ.currency     NO-UNDO.
 DEF VAR noe             LIKE op-entry.op-entry     NO-UNDO.
 DEF VAR dval            LIKE op-entry.value-date   NO-UNDO.
 DEF VAR fler            AS LOG                     NO-UNDO.


 
 currDate = in-op-date.

 DEF BUFFER bufOpKind FOR op-kind.

 {getfile.i &set1 = "������"
            &set2 = "��⠫��"
            &mode = must-exist
            &filename = mFileName
            &return   = "LEAVE"
  }
 mFileName = fname.


 CREATE TEMP-TABLE mOperTable.
 mOperTable:READ-XML("FILE",mFileName,?,?,?,?).

 CREATE BUFFER mBuffer FOR TABLE mOperTable.

 ASSIGN
  mTableName  = mBuffer:TABLE
  mFieldCount = mBuffer:NUM-FIELDS
 .
 

 
 CREATE QUERY mQuery.
 mQuery:SET-BUFFERS(mBuffer).
 mQuery:QUERY-PREPARE("FOR EACH " + mTableName).
 mQuery:QUERY-OPEN().


  FIND FIRST bufOpKind WHERE RECID(bufOpKind) EQ oprid NO-LOCK NO-ERROR.

  mOpKindHandle = BUFFER bufOpKind:HANDLE.
  mDntProcTempl = LOGICAL(getXAttrValueEx("op-kind",STRING(bufOpKind.op-kind),"dntProcessTemplates","NO")).
  mBefRowRead   = getXAttrValueEx("op-kind",STRING(bufOpKind.op-kind),"onBefRowRead",?).
  mAftRowRead   = getXAttrValueEx("op-kind",STRING(bufOpKind.op-kind),"onAftRowRead",?).
  mAftTrEnd     = getXAttrValueEx("op-kind",STRING(bufOpKind.op-kind),"onAftTrEnd",?).

  /*** ��������� ���������� ����� � ����� ***/

   mQuery:GET-FIRST(NO-LOCK).

   REPEAT WHILE NOT mQuery:QUERY-OFF-END:

     mLnTotalInt = mLnTotalInt + 1.
     mQuery:GET-NEXT(NO-LOCK).

   END.
   /*** ����� �������� ���������� ***/

    {init-bar.i "��ࠡ�⪠ 䠩��"}
    mQuery:GET-FIRST(NO-LOCK).

    REPEAT WHILE NOT mQuery:QUERY-OFF-END:


CR_LOAN:
DO TRANSACTION 
ON ENDKEY UNDO CR_LOAN, LEAVE CR_LOAN 
ON ERROR  UNDO CR_LOAN, LEAVE CR_LOAN:



   /**
    * ������塞 � SysConfig ᮤ�ন��� ��ப XML
    **/
   DO mI = 1 TO mBuffer:NUM-FIELDS:
     mField = mBuffer:BUFFER-FIELD(mI).
     RUN SetSysConf IN h_base (mField:NAME,mBuffer:BUFFER-FIELD(mField:NAME):BUFFER-VALUE).
     RUN SetSysConf IN h_base ("��" + STRING(mI),mBuffer:BUFFER-FIELD(mField:NAME):BUFFER-VALUE).
   END.


    IF mBefRowRead <> ? THEN DO:
      RUN onBefRowRead(mOperTable,mBuffer,mOpKindHandle,currDate,mBefRowRead).
    END.

    IF NOT mDntProcTempl THEN DO:

     ASSIGN
       in-op-date  = currDate
       cur-op-date = currDate
     .

     {pir-process-template.i}



    END.

    IF mAftRowRead <> ? THEN DO: 
       RUN onAftRowRead(mOperTable,mBuffer,mOpKindHandle,currDate,mAftRowRead).
    END.

    {move-bar.i mLnCountInt mLnTotalInt}

    mLnCountInt = mLnCountInt + 1.

END.

    mQuery:GET-NEXT(NO-LOCK).
  END.

 mQuery:QUERY-CLOSE().

 /**
  * "����뢠��" ᮡ�⨥ �࠭����� 
  * ������ �����襭�.
  **/

 IF mAftTrEnd <> ? THEN DO:
   RUN VALUE(TSysClass:whatShouldIRun2(mAftTrEnd)) (mOperTable,mOpKindHandle,currDate).
 END.



 DO mI = 1 TO mBuffer:NUM-FIELDS:
   mField = mBuffer:BUFFER-FIELD(mI).
   RUN DeleteOldDataProtocol IN h_base (mField:NAME).
   RUN DeleteOldDataProtocol IN h_base ("��" + STRING(mI)).
 END.

{intrface.del}

MESSAGE "�࠭����� �����襭�" VIEW-AS ALERT-BOX.