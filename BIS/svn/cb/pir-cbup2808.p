/***********************************************
 * ����⨥ �� ��ࠡ��� ��ப� � XML 䠩��     *
 * ��� ���⠭���� 業��� �㬠�.                *
 ***********************************************
 * ���� : ��᫮� �. �.                        *
 * ���  : 10.04.12                            *
 * ���: #2808                               *
 ***********************************************/

 DEF INPUT PARAM vCurrTable  AS HANDLE NO-UNDO.
 DEF INPUT PARAM vCurrBuffer AS HANDLE NO-UNDO.
 DEF INPUT PARAM vCurrTrans  AS HANDLE NO-UNDO.
 DEF INPUT PARAM currDate    AS DATE   NO-UNDO.

 {globals.i}
 {intrface.get xclass}
 {intrface.get instrum}  /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */
 {intrface.get acct}     /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */
 {intrface.get db2l}
 {intrface.get sm}       /* ��� ����祭�� �������� 業��� �㬠�� */

 {pir-aacctcb.i}

 DEF VAR mField       AS HANDLE        NO-UNDO.

 DEF VAR mI           AS INT64         NO-UNDO.

 DEF VAR mBodyBal     AS CHAR          NO-UNDO.
 DEF VAR mBodyAcct    AS CHAR          NO-UNDO.
 DEF VAR mIssueNum    AS CHAR          NO-UNDO.
 DEF VAR mPirEmit2Dig AS CHAR          NO-UNDO.
 DEF VAR mEmitId      AS CHAR          NO-UNDO.

 DEF VAR mNominal     AS DEC           NO-UNDO.
 DEF VAR mNominalRur  AS DEC           NO-UNDO.

 DEF VAR mMask        AS CHAR          NO-UNDO.
 DEF VAR oSysClass    AS TSysClass     NO-UNDO.
 DEF VAR mD           AS DEC           NO-UNDO.  /* ������ ����� �⮨������ ���㯪� � ��������� */
 DEF VAR mPok         AS DEC           NO-UNDO.

 DEF VAR currOrgTorg  AS CHAR          NO-UNDO.
 DEF VAR newOrgTorg   AS CHAR          NO-UNDO.

 oSysClass = NEW TSysClass().

 DEF BUFFER sec-code FOR sec-code.
 DEF BUFFER newAcct  FOR acct.

 /*** ����砥� ���ଠ�� �� 業��� �㬠�� ***/

 FIND FIRST sec-code WHERE sec-code.sec-code EQ vCurrBuffer::id NO-LOCK.

 IF NOT AVAILABLE(sec-code) THEN DO:
       MESSAGE "�訡��! �� ������� 業��� �㬠��!" VIEW-AS ALERT-BOX.
 END.

 mEmitId = getXAttrValue("sec-code",sec-code.sec-code,"issue_cod").

 FIND FIRST cust-role WHERE cust-role-id EQ INT64(mEmitId) NO-LOCK.

 IF NOT AVAILABLE(cust-role) THEN DO:
       MESSAGE "�訡��! �� ������ �⥭�!" VIEW-AS ALERT-BOX.
 END.
  
    
 mBodyBal      = getXAttrValue("sec-code",sec-code.sec-code,"pir-bal-acct").
 mIssueNum     = getXAttrValue("sec-code",sec-code.sec-code,"issue_num").
 mPirEmit2Dig  = getXAttrValue("cust-role",STRING(cust-role-id),"pir_emit_2dig").

 /*********************************************************
  *     ����砥� ���������� �⮨����� 業��� �㬠��!     *
  *********************************************************
  * ������ ᫥���騩:                                   *
  *  1. ��६ ���������� �⮨����� �� �ࠢ�筨��        *
  * �� => ����� �㬠�� => ���஢��;                     *
  *   1.1 �᫨ ���祭�� ����, � ������塞 ���            *
  * � SysConf;                                            *
  *  2. �᫨ ���祭�� ������� �� 㤠����, � �஢��塞   *
  * ����稥 ���祭�� � SysConfig;                         *
  *  3. �᫨ ���祭�� � SysConfig �� ��⠭������, �      *
  * ����訢��� � ���짮��⥫�;                           *
  *   3.1 ��������� ���祭�� ��࠭塞 � SysConf          *
  *********************************************************/

  mPok = DECIMAL(getSysConf("price")).

  RUN GetNominal IN h_sm (vCurrBuffer::id,OUTPUT mNominal,OUTPUT mNominalRur).
  mD = mPok - mNominal.

  RUN SetSysConf IN h_base ("mD",STRING(mD)).
  RUN SetSysConf IN h_base ("nominal",STRING(mNominal)).


    /**
     * �᫨ �� 業��� �㬠�� ��� ��,
     * � ��६ ��砫쭮� ���祭�� �� �� �����.
     * �᫨ �� 業��� �㬠�� ���� �� � �� �� "���",
     * � ���⠢�塞 ���. �᫨ �� "���", � ��祣� �� ������.
     **/
    currOrgTorg = getXAttrValueEx("sec-code",getSurrogateBuffer("sec-code",BUFFER sec-code:HANDLE),"��ঠ�࣒��",?).
    IF currOrgTorg = ? THEN DO:
      newOrgTorg = getXAttrInit(sec-code.class-code,"��ঠ�࣒��").
    END. ELSE DO:
        IF currOrgTorg <> "���" THEN DO:
                newOrgTorg = currOrgTorg.
        END. ELSE DO:
                newOrgTorg = ?.
        END.
    END.



 /**********
  * �1 ���뢠�� ⥫�.
  **********/
  mMask = mBodyBal + "����00" + mPirEmit2Dig + mIssueNum + "1" + "����".

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirPPrice",getSysConf("price"),?).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

  newAcct.details  = GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n") + ", " + GetSysConf("count") + " ��. ".
  newAcct.contract = "�����".

  mBodyAcct = newAcct.acct.
 
  RUN SetSysConf IN h_base ("��⒥��",newAcct.acct).
  RELEASE newAcct.


 /**
  * �2 ���뢠�� ��� �����
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXX����XXXXXX4XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
  newAcct.details = "������ �� �ਮ��⥭�� ������権 " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n").

  RUN SetSysConf IN h_base ("��⇠����",newAcct.acct).
  RELEASE newAcct.


 /**
  * �3 ���뢠�� �६��
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXX����XXXXXX6XXXX").

  RUN createAcct(cust-role.cust-cat,
                   cust-role.cust-id,
                   mMask,
                   currDate,
                   BUFFER newAcct
                  ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

  newAcct.details = "�६�� �� �������� " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n") + ", " + GetSysConf("count") + " ��.".
 
  RUN SetSysConf IN h_base ("���६��",newAcct.acct).
  RELEASE newAcct.


 /**
  * �4 ���뢠�� ��᪮��
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXX����XXXXXX5XXXX").

  RUN createAcct(cust-role.cust-cat,
                   cust-role.cust-id,
                   mMask,
                   currDate,
                   BUFFER newAcct
                  ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

  newAcct.details = "��᪮�� �� �������� " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n") + ", " + GetSysConf("count") + " ��.".
 
  RUN SetSysConf IN h_base ("��ℨ᪮��",newAcct.acct).
  RELEASE newAcct.


  /**
   * �5 ���뢠�� ��� 㯫�祭��
   **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXX����XXXXXX3XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

  newAcct.details = "��� 㯫�祭�� �� �������� " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n").

  RUN SetSysConf IN h_base ("��⏊����",newAcct.acct).
  RELEASE newAcct.


  /**
   * �6 ���뢠�� ��� ���᫥���
   **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXX����XXXXXX2XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

  newAcct.details = "��� ���᫥��� �� �������� " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n").

  RUN SetSysConf IN h_base ("��⏊����",newAcct.acct).
  RELEASE newAcct.


  /**
   * �7 ���뢠�� ����⥫��� ��८業��
   **/
   mMask = oSysClass:buildAcctByMask(mBodyAcct,"50220��������XXXXXXX").

   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  mMask,
                  currDate,
                  BUFFER newAcct
                  ).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

   newAcct.details  = "����⥫쭠� ��८業�� ������権 " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n").

   RUN SetSysConf IN h_base ("��⏏",newAcct.acct). 
   RELEASE newAcct.


  /**
   * �8 ���뢠�� ������⥫��� ��८業��
   **/
   mMask = oSysClass:buildAcctByMask(mBodyAcct,"50221��������XXXXXXX").
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  mMask,
                  currDate,
                  BUFFER newAcct
                  ).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"��ঠ�࣒��",newOrgTOrg,?).

   newAcct.details  = "������⥫쭠� ��८業�� ������権 " + GetSysConf("name") + " �� ᤥ��� " + GetSysConf("n").

   RUN SetSysConf IN h_base ("��⏎",newAcct.acct). 
   RELEASE newAcct.


  /**
   * �9 ���뢠�� �� ��-�����
   **/




  DO mI = 1 TO vCurrBuffer:NUM-FIELDS:
     mField = vCurrBuffer:BUFFER-FIELD(mI).
  END.

 DELETE OBJECT oSysClass.
 {intrface.del}