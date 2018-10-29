/* Synhro d69 str.2379-2380
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: a-op.trg
      Comment: ����䥩�� �ਣ���� ��� �࠭���権 ���
   Parameters:
         Uses:
      Used by: �࠭���樨 �� ����窥:
               a-in.p af-ex.p as-ex.p af-move.p as-out.p
               ��㯯��� �࠭���樨:
               a-io(gr).p a-mv(gr).p af-amor.p af-over.p a-trans.p
      Created:
     Modified: 02.07.2004 fedm (0018856)
     Modified: 09/08/2004 Om ��ࠡ�⪠. �����祭�� �⠭���⭮�� ��㧥�.
     Modified: 26/07/2006 bams  0034386
*/

{intrface.get separate}
{intrface.get kau}
{intrface.get strng}
{intrface.get brnch}
{form.def}

&GLOBAL-DEFINE DelSysConf mDelSysConf

/* ���� ���㬥��-���筨�� */
DEFINE BUFFER bSrcOp FOR op.

RELEASE bSrcOp.

DEFINE VARIABLE mDoc-Num  AS CHARACTER NO-UNDO. /* ����� ���㬥�� */
DEFINE VARIABLE mDoc-Date AS DATE      NO-UNDO. /* ���  ���㬥�� */
DEFINE VARIABLE mDetails  AS CHARACTER NO-UNDO. /* ����ঠ��� ����樨 */

/* �६����� ⠡��� ��뫮� �� 蠡���� � ᮧ����� ���㬥���. */
DEFINE TEMP-TABLE tt-op NO-UNDO
   FIELD rid         AS RECID
   FIELD op-template AS INTEGER
   FIELD details     AS CHARACTER INITIAL ?

   INDEX templ       IS PRIMARY op-template
   INDEX rid                    rid
   .

DEFINE VARIABLE mType         AS CHARACTER NO-UNDO. /* �� ������ ���� ��� ������? */
DEFINE VARIABLE mFlag         AS LOGICAL   NO-UNDO. /* �ਧ��� ᮧ����� ���㬥�� �� �᭮�� �������ᮢ��� */
DEFINE VARIABLE mInitFields   AS CHARACTER NO-UNDO. /* ���᮪ ���樠�����㥬�� ����� */
DEFINE VARIABLE mNoViewObj    AS CHARACTER NO-UNDO. /* ���᮪ ���⮡ࠦ����� ��ꥪ⮢ */
DEFINE VARIABLE mNoSensFields AS CHARACTER NO-UNDO. /* ���᮪ ������㯭�� ��� ।���஢���� ����� */
DEFINE VARIABLE mEnd-Date     AS DATE      NO-UNDO. /* ���࠭����� ������쭠� ��� */
DEFINE VARIABLE mDelSysConf   AS CHARACTER NO-UNDO. /* ���᮪ ���⪮������ (⮫쪮 ����� �࠭���樨) ����ᥩ sysconf */
DEFINE VARIABLE mFiltOp       AS CHARACTER NO-UNDO. /* ������ ��� �롮� ��室��� ���㬥�⮢ */
DEFINE VARIABLE mLink-Code    AS CHARACTER NO-UNDO. /* ��� �裡 */
DEFINE VARIABLE mSrcClass     AS CHARACTER NO-UNDO. /* ����� ��室���� ���㬥��-�ॡ������ */
DEFINE VARIABLE mStatus       AS CHARACTER NO-UNDO. /* ����� ��� �롮� ��室���� ���㬥�� */
DEFINE VARIABLE mIgnoreMes    AS LOGICAL   NO-UNDO. /* �� �뢮��� ᮮ�饭�� �᫨ ���� �� ।����㥬�� */
DEFINE VARIABLE mF1wasPressed AS LOGICAL   NO-UNDO. /* �� �뢮��� ᮮ�饭�� �᫨ ����� F1 */
DEFINE VARIABLE mDocTypeName  AS CHARACTER NO-UNDO. /* ������������ ⨯� ���㬥�� */
   &IF DEFINED(RemAmt) &THEN
DEFINE VARIABLE mAmtUpdated   AS LOGICAL   NO-UNDO.
   &ENDIF
   &IF DEFINED(ONcalc) &THEN
DEFINE VARIABLE mQtyUpdated   AS LOGICAL   NO-UNDO.
   &ENDIF
DEFINE VARIABLE mNeedInitiate AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mAcctCat      AS CHARACTER NO-UNDO.

ASSIGN
   mType         = "���"
   mSrcClass     = "op"
   &IF DEFINED(RemAmt) &THEN
   mAmtUpdated   = NO
   &ENDIF
   &IF DEFINED(ONcalc) &THEN
   mQtyUpdated   = NO
   &ENDIF
   mNeedInitiate = YES
   .

/* ����⢨� � ��砫� �믮������ �࠭���樨 */
RUN StartTransInit NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
   RUN EndPurge NO-ERROR.
   RETURN.
END.

/* ������� ���� ����� ��室���� ���㬥�� */
FUNCTION GetNewStatus RETURNS CHARACTER
   (
     INPUT iOp-Status AS CHARACTER
   )
:
   CASE iOp-Status:
      WHEN "��" THEN
         iOp-Status = "�".
      WHEN "�"  THEN
         iOp-Status = "��".
   END CASE.

   RETURN iOp-Status.
END FUNCTION.

FUNCTION GetAcctCat RETURNS CHARACTER
   (
     INPUT iOpKind AS ROWID
   )
:
   DEFINE VARIABLE vAcctCat AS CHARACTER NO-UNDO.

   DEFINE BUFFER op-kind     FOR op-kind.
   DEFINE BUFFER op-template FOR op-template.

   vAcctCat = "".
   FOR FIRST op-kind
       WHERE ROWID(op-kind) EQ iOpKind
   NO-LOCK
   :
      vAcctCat = "b".
      FOR EACH op-template
            OF op-kind
         WHERE op-template.acct-cat EQ "n"
      NO-LOCK
      :
         vAcctCat = "n".
         LEAVE.
      END.
      IF vAcctCat EQ "n" THEN
      FOR EACH op-template
            OF op-kind
         WHERE op-template.acct-cat NE "n"
      NO-LOCK
      :
         vAcctCat = "*".
         LEAVE.
      END.
   END.

   RETURN vAcctCat.
END FUNCTION.

/* ����⢨� �� �室� �� �३� �࠭���樨 */
ON ENTRY OF FRAME opreq
DO:
   /* �᫨ � ��楤�� �࠭���樨 ��।����� ��楤�� OnFrameEntryAdd
   ** (���.����⢨� �� �室� �� �३�), � ����᪠�� �� */
   IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES, "OnFrameEntryAdd") THEN
   DO:
      RUN OnFrameEntryAdd NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
         RETURN NO-APPLY.
   END.

   /* ��砫쭠� ���樠������ ����� �३�� */
   RUN InitFields
      (
        INPUT mInitFields
      , INPUT mNoViewObj
      , INPUT mNoSensFields
      ) .
END.

ON LEAVE OF op.doc-date IN FRAME opreq
DO:
   DEFINE VARIABLE vMsg AS CHARACTER NO-UNDO.

   DEFINE BUFFER op-date FOR op-date.

   /* ���쪮 ��� �࠭���権 �� �ᯫ�����騬 � ��⮭������ ᪫���
   ** � ��砥 �� ����᪠ �१ ���⥪�⭮� ���� ����⥪� ���
   ** �஢���� ���㬥�� ⥬ ����, ����� 㪠��� � op.doc-date */
   IF CAN-DO("����,����,����", mType) AND
      GetSysConf("opreq:in-cont-code") NE ?
   THEN DO:
      FIND FIRST op-date
           WHERE op-date.op-date EQ (INPUT op.doc-date)
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE op-date THEN
      DO:
         MESSAGE "����� ����� ���㬥�� � ���������騩 ����樮��� ����!"
            VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY {&RET-ERROR}.
      END.

      /* �஢�ન ������� ���भ� */
      {chkblock.i
         &surr   = "STRING(INPUT op.doc-date)"
         &msg    = "�� �� ����� �ࠢ� ࠡ���� � �������஢����� ����樮���� ���!"
         &action = "RETURN NO-APPLY "{&RET-ERROR}"."
         }

      RUN Chk_OpKind_Cat IN h_separate
         (
            INPUT (INPUT op.doc-date)
         ,  INPUT RECID(op-kind)
         , OUTPUT vMsg
         ) .
      IF {assigned vMsg} THEN
      DO:
         MESSAGE vMsg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      /* �஢�ન ������� ���भ�  --  E n d */

      ASSIGN
         in-op-date  = op-date.op-date
         cur-op-date = in-op-date
         gend-date   = in-op-date
         .
      IF AVAILABLE op THEN
         op.op-date = in-op-date.
   END.
END.

&IF DEFINED(ONgroup) = 0 &THEN
ON "F1" OF in-cont-code IN FRAME opreq
DO:
   DEFINE BUFFER loan FOR loan.

   /* ������祭�� �⠭���⭮�� ��㧥�. */
   mF1wasPressed = YES.
   IF mFlag THEN
      RUN browseld.p
         (
           INPUT in-contract
         , INPUT "doc-date" + CHR(1) + "doc-num"
         , INPUT GetSysConf("NDFrm:vDoc-Date") + CHR(1)
               + GetSysConf("NDFrm:vDoc-Num" )
         , INPUT "doc-date" + CHR(1) + "doc-num"
         , INPUT 4
         ) .
   ELSE
      RUN browseld.p
         (
           INPUT in-contract
         , INPUT ""
         , INPUT ""
         , INPUT ""
         , INPUT 4
         ) .
   mF1wasPressed = NO.

   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN
   FOR FIRST loan
       WHERE RECID(loan) EQ INT64(pick-value)
   NO-LOCK
   :
      SELF:SCREEN-VALUE = loan.doc-ref.
      APPLY "TAB" TO SELF.
   END.

   RETURN NO-APPLY.
END.

ON LEAVE OF in-cont-code IN FRAME opreq
DO:
   DEFINE VARIABLE vTabNo    LIKE employee.tab-no  NO-UNDO.
   DEFINE VARIABLE vBranchId LIKE branch.branch-id NO-UNDO.
      &IF DEFINED(ONmove) &THEN
   DEFINE VARIABLE vQtyFl    AS   LOGICAL          NO-UNDO. /* ���� ���������� ।���஢���� ������⢠ */
   DEFINE VARIABLE vSum      AS   DECIMAL          NO-UNDO. /* �㬬� �� ����窥 */
      &ENDIF

   DEFINE BUFFER loan        FOR loan.
   DEFINE BUFFER kau         FOR kau.
   DEFINE BUFFER code        FOR code.
   DEFINE BUFFER op-template FOR op-template.

   ASSIGN FRAME opreq
      in-cont-code
      .

   mAcctCat = (IF AVAILABLE op-kind
               THEN GetAcctCat(ROWID(op-kind))
               ELSE "").

   IF mF1wasPressed THEN
      RETURN NO-APPLY.

   FIND FIRST loan
        WHERE loan.contract  EQ in-contract
          AND loan.doc-ref   EQ in-cont-code
          AND loan.filial-id EQ shFilial
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE loan THEN
   DO:
      MESSAGE "��� ⠪�� ����窨"
         VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   FOR FIRST loan
       WHERE loan.contract  EQ in-contract
         AND loan.doc-ref   EQ in-cont-code
         AND loan.filial-id EQ shFilial
   NO-LOCK
   ,   FIRST asset
          OF loan
   NO-LOCK
   :
      IF loan.close-date NE ? AND
         loan.close-date LT in-op-date
      THEN DO:
         MESSAGE
            "������ ����窠 㦥 ������"
         VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY {&RET-ERROR}.
      END.

      mCostNew = GetCostUMC(
                             loan.contract + CHR(6) + loan.cont-code
                           , in-op-date
                           , ""
                           , ""
                           ) .
      DISPLAY
         asset.name
      &IF DEFINED(ONcalc) > 0 AND
          DEFINED(ONmove) = 0
      &THEN
         mCostNew WHEN mCostNew:VISIBLE
      &ENDIF
      WITH FRAME opreq.

   &IF DEFINED(ONmove) &THEN
      &IF DEFINED(ONout) &THEN
      IF to-cont-code:SCREEN-VALUE IN FRAME opreq NE "" AND
         to-cont-code:SCREEN-VALUE IN FRAME opreq NE ?
      THEN DO:
         APPLY "LEAVE" TO to-cont-code IN FRAME opreq.
         IF RETURN-VALUE EQ {&RET-ERROR} THEN
            RETURN NO-APPLY {&RET-ERROR}.
      END.
      &ENDIF
      RELEASE kau.

      IF mAcctCat NE "n" THEN
      DO:
         FOR EACH code
            WHERE code.class EQ     "�������"
              AND code.code  BEGINS "���-" + mType
         NO-LOCK
         ,  FIRST kau
            WHERE kau.kau-id EQ     code.code
              AND kau.kau    BEGINS loan.contract + "," + loan.cont-code + ","
         NO-LOCK
         :
            LEAVE.
         END.

         IF NOT AVAILABLE kau THEN
         DO:
            MESSAGE "������ 業����� �� �� ��室�������!"
               VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY {&RET-ERROR}.
         END.

         IF GetLast-Kau(
                         loan.contract
                       , loan.cont-code
                       , mType
                       , in-op-date
                       ) EQ ?
         THEN DO:
            MESSAGE "������ 業����� �� �� ��室������� �� ���� "
                    STRING(in-op-date, "99/99/9999")
               VIEW-AS ALERT-BOX.
            RETURN NO-APPLY {&RET-ERROR}.
         END.
      END.

      IF mNeedInitiate THEN
      DO:
         IF mAcctCat EQ "n" THEN
         DO:
            ASSIGN
               vTabNo    = xtab-no1
               vBranchId = xbranch-id1
               .
         END.
         RUN GetTab-Branch
            (
               INPUT RECID(loan)
            ,  INPUT mType
            ,  INPUT in-op-date
            , OUTPUT xtab-no1
            , OUTPUT xbranch-id1
            , OUTPUT xQty
            ) .
         IF RETURN-VALUE EQ "NO" THEN
            ASSIGN
               xbranch-id1:SENSITIVE = NO
               xtab-no1   :SENSITIVE = NO
               .
         ELSE IF {assigned RETURN-VALUE} THEN
         DO:
            MESSAGE RETURN-VALUE
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            ERROR-STATUS:ERROR = YES.
            RETURN NO-APPLY {&RET-ERROR}.
         END.
         IF mAcctCat EQ "n" THEN
         DO:
            ASSIGN
               xtab-no1    = vTabNo
               xbranch-id1 = vBranchId
               .
         END.
      END.

      IF mAcctCat NE "n" THEN
      DO:
         IF mNeedInitiate THEN
         DO:
            DISPLAY
               xbranch-id1 WHEN xbranch-id1:VISIBLE
               xtab-no1    WHEN xtab-no1   :VISIBLE
            WITH FRAME opreq.

            IF xbranch-id1:VISIBLE THEN
               DISPLAY
                  GetObjName(
                              "branch"
                            , xbranch-id1
                            , YES
                            ) @ xbranch.name
               WITH FRAME opreq.

            IF xtab-no1:VISIBLE THEN
               DISPLAY
                  GetObjName(
                              "employee"
                            , shFilial + "," + STRING(xtab-no1)
                            , NO
                            ) @ sname1
               WITH FRAME opreq.
         END.
      END.

      RUN GetLoanPos IN h_umc
         (
            INPUT loan.contract
         ,  INPUT loan.cont-code
         ,  INPUT mType
         ,  INPUT in-op-date
         , OUTPUT vSum
         , OUTPUT full-qty
         ) .
      DO WITH FRAME opreq:
         ASSIGN
            vQtyFl                = (full-qty GT (IF CAN-DO("��,���", loan.contract)
                                                  THEN 1
                                                  ELSE 0))
            xQty                  = MIN(xQty, full-qty)
            xQty       :SENSITIVE = vQtyFl WHEN xQty       :SENSITIVE
            xtab-no1   :SENSITIVE = vQtyFl WHEN xtab-no1   :SENSITIVE
            xbranch-id1:SENSITIVE = vQtyFl WHEN xbranch-id1:SENSITIVE
            .
      END.

      DISPLAY
         xQty      WHEN xQty    :VISIBLE
         full-qty  WHEN full-qty:VISIBLE
      WITH FRAME opreq.
   &ELSE
         /* ���樠�����㥬 ��� � �����, �᫨ �� ����窥 㦥 ��-� ���� */
      IF mNeedInitiate THEN
      DO:
         IF mAcctCat EQ "n" THEN
         DO:
            ASSIGN
               vTabNo    = xtab-no
               vBranchId = xbranch-id
               .
         END.
         RUN GetTab-Branch
            (
               INPUT RECID(loan)
            ,  INPUT (IF mType EQ "�ॡ"
                      THEN "���"
                      ELSE mType)
            ,  INPUT in-op-date
            , OUTPUT xtab-no
            , OUTPUT xbranch-id
            , OUTPUT xQty
            ) .
         IF RETURN-VALUE EQ "NO" THEN
            ASSIGN
               xbranch-id:SENSITIVE = NO
               xtab-no   :SENSITIVE = NO
               .
         ELSE IF {assigned RETURN-VALUE} THEN
         DO:
            MESSAGE
               RETURN-VALUE
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            ERROR-STATUS:ERROR = YES.
            RETURN NO-APPLY {&RET-ERROR}.
         END.
         IF mAcctCat EQ "n" THEN
         DO:
            ASSIGN
               xtab-no    = vTabNo
               xbranch-id = vBranchId
               .
         END.

         IF mAcctCat EQ "n" THEN
         DO:
            IF xbranch-id   EQ ""   AND
               RETURN-VALUE NE "NO"
            THEN
               xbranch-id = GetXAttrValue(
                                           "op-kind"
                                         , op-kind.op-kind
                                         , "InitBranch"
                                         ) .
            IF xtab-no      EQ 0 AND
               RETURN-VALUE NE "NO"
            THEN
               xtab-no = INT64(
                                GetEntries(
                                            2
                                          , GetXAttrValue(
                                                           "op-kind"
                                                         , op-kind.op-kind
                                                         , "InitMol"
                                                         )
                                          , ","
                                          , ""
                                          )
                              ) .
         END.

         IF mFlag NE YES THEN
            xQty = 1.

         IF {assigned xbranch-id:SCREEN-VALUE} AND
            NOT ({assigned xbranch-id} AND xbranch-id EQ xbranch-id:SCREEN-VALUE)
         THEN
            xbranch-id = xbranch-id:SCREEN-VALUE.
         IF {assigned xtab-no:SCREEN-VALUE} AND
            (xtab-no         EQ 0 OR
             xtab-no         EQ ? OR
             STRING(xtab-no) NE xtab-no:SCREEN-VALUE)
         THEN
            xtab-no    = INT64(xtab-no:SCREEN-VALUE).
         IF {assigned xQty:SCREEN-VALUE}    AND
            (xQty         EQ 0 OR
             xQty         EQ ? OR
             STRING(xQty) NE xQty:SCREEN-VALUE)
         THEN
            xQty       = DECIMAL(xQty :SCREEN-VALUE).

         DISPLAY
            xbranch-id WHEN xbranch-id:VISIBLE
            xtab-no    WHEN xtab-no   :VISIBLE
            xQty       WHEN xQty      :VISIBLE
         WITH FRAME opreq.

         IF xbranch-id:VISIBLE THEN
            DISPLAY
               GetObjName(
                           "branch"
                         , xbranch-id
                         , YES
                         ) @ branch.name
            WITH FRAME opreq.

         IF xtab-no:VISIBLE THEN
            DISPLAY
               GetObjName(
                           "employee"
                         , shFilial + "," + STRING(xtab-no)
                         , NO
                         ) @ sname
            WITH FRAME opreq.
      END.
   &ENDIF

   /* �롮� ���㬥��-���筨�� �� ��㧥� ���㬥�⮢ �� ����窥 */
   IF mFiltOp NE "" THEN
   DO:
      RUN GetSrcOp-Loan NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
         MESSAGE
            RETURN-VALUE SKIP
            ERROR-STATUS:GET-MESSAGE(1)
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
         APPLY "END-ERROR" TO SELF.
      END.
      ELSE DO:
         /* ���樠������ 㪠������ ����� �३�� */
         RUN InitFields
            (
              INPUT "in-cont-code," + mDelSysConf
            , INPUT mNoViewObj
            , INPUT mNoSensFields
            ) .
      &IF DEFINED(RemAmt) &THEN
         mAmtUpdated = YES.
      &ENDIF
      END.
   END.

   /* ���᫥��� �㬬� � �ᥣ� */
   &IF DEFINED(RemAmt) &THEN
      IF NOT mAmtUpdated AND
         mCostNew GT 0
      THEN DO:
         remove-amt = mCostNew.
         IF xQty NE ? AND
            xQty NE 0 AND
            xQty NE 1
         THEN DO:
            remove-amt = mCostNew * xQty.
         END.
      END.

      &IF DEFINED(ONgroup) = 0 &THEN
      &IF DEFINED(ONcalc)  > 0 &THEN
      IF xQty:SENSITIVE IN FRAME opreq AND
         xQty:VISIBLE   IN FRAME opreq
      THEN
         APPLY "LEAVE" TO xQty IN FRAME opreq.
      &ENDIF
      &ENDIF

      DISPLAY
         remove-amt WHEN remove-amt:VISIBLE
      WITH FRAME opreq.
   &ENDIF

      /* �᫨ � ��楤�� �࠭���樨 ��।����� ��楤�� OnLeaveIn-cont-code
      ** (���.����⢨� �� ��室� �� ����), � ����᪠�� �� */
      IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES, "OnLeave" + SELF:NAME)
      THEN DO:
         RUN VALUE("OnLeave" + SELF:NAME) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
            RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
END.

/* �롮� ���㬥��-���筨�� �� ��㧥� ���㬥�⮢ �� ����窥 */
PROCEDURE GetSrcOp-Loan:
   DEFINE VARIABLE vOp  AS INT64   NO-UNDO.
   DEFINE VARIABLE vCnt AS INT64   NO-UNDO.
   DEFINE VARIABLE vQty AS DECIMAL NO-UNDO.

   pick-value = ?.

   DO TRANSACTION:
      RUN "a-br(op).p"
         (
           INPUT mSrcClass
         , INPUT "KauClass"
               + CHR(1) + REPLACE(
                                   GetCodeMisc(
                                                "�������"
                                              , "���-" + mType
                                              , 6
                                              )
                                 , ","
                                 , CHR(1)
                                 )
                        + (IF mFiltOp EQ ""
                           THEN ""
                           ELSE (CHR(1) + "UserConf"))
               + CHR(1) + "ActionLock"
         , INPUT "�������,������"
               + CHR(1) + in-contract
               + CHR(1) + AddFilToLoan(in-cont-code:SCREEN-VALUE IN FRAME opreq, shFilial)
               + CHR(1) + "*"
               + CHR(1) + "*"
                        + (IF mFiltOp EQ ""
                           THEN ""
                           ELSE (CHR(1) + mFiltOp))
               + CHR(1) + "F6"
         , INPUT "UserConf"
               + CHR(1) + "ActionLock"
         , INPUT 9
         ) NO-ERROR.
      vOp = INT64(PICK-VALUE) NO-ERROR.
   END.

   FIND FIRST bSrcOp
        WHERE bSrcOp.op EQ vOp
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE bSrcOp THEN
      RETURN ERROR "�롮� ��室���� ���㬥�� ��易⥫�� ��� �⮩ �࠭���樨!".

   /* ���࠭���� ������ �� ���㬥��-���筨��,
   ** ����室���� ��� ���樠����樨 ����� ��� �࠭���樨 */
   RUN Src2SysConf
      (
        INPUT bSrcOp.op
      ) .

   RETURN.
END PROCEDURE. /* GetSrcOp-Loan */
&ENDIF

ON GO OF FRAME opreq
DO:
   DEFINE VARIABLE vGoProc  AS CHARACTER     NO-UNDO INITIAL "OnGoOfFrame".
   DEFINE VARIABLE vWdgtHdl AS WIDGET-HANDLE NO-UNDO. /* ��� ����� ����䥩� */
   DEFINE VARIABLE vWdgtNam AS CHARACTER     NO-UNDO. /* ������ ��� ������ (� ������ ⠡����) */

&IF DEFINED(ONgroup) = 0 &THEN
   DEFINE BUFFER loan FOR loan.

   FOR FIRST loan
       WHERE loan.contract  EQ in-contract
         AND loan.doc-ref   EQ in-cont-code:SCREEN-VALUE
         AND loan.filial-id EQ shFilial
   NO-LOCK
   :
      IF loan.close-date NE ?          AND
         loan.close-date LT in-op-date
      THEN DO:
         MESSAGE
            "������ ����窠 㦥 ������!"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO in-cont-code.
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.

   &IF DEFINED(OnOut) &THEN
      ASSIGN
         chpar1 = to-cont-code:SCREEN-VALUE
         chpar2 = to-contract
         .
   &ELSE
      ASSIGN
         chpar1 = in-cont-code:SCREEN-VALUE
         chpar2 = in-contract
         .
   &ENDIF
&ENDIF

   /* �᫨ � ��楤�� �࠭���樨 ��।����� ��楤�� OnGoOpReq
   ** (���.����⢨� �� ��室� �� �३��), � ����᪠�� �� */
   IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES, vGoProc) THEN
   DO:
      RUN ResetError     NO-ERROR.
      RUN VALUE(vGoProc) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
         RETURN NO-APPLY.
   END.

   /* ���࠭塞 �������� ���祭�� ����� �३�� � sys-conf,
   ** �⮡� ��� ���樠����஢����� �� ᫥���饬 ����᪥ */

   ASSIGN
      vWdgtHdl  = SELF:HANDLE
      vWdgtHdl  = vWdgtHdl:FIRST-CHILD
      vWdgtHdl  = vWdgtHdl:FIRST-CHILD
      NO-ERROR.
   DO WHILE VALID-HANDLE(vWdgtHdl)
   :
      vWdgtNam = (IF vWdgtHdl:TABLE EQ ?
                  THEN ""
                  ELSE (vWdgtHdl:TABLE + "."))
               + vWdgtHdl:NAME.

      /* ��� ��㯯���� ����権 ���������� ᮤ�ঠ��� */
      IF vWdgtNam EQ "op.details" THEN
      FOR FIRST tt-op
          WHERE tt-op.details EQ ?
      :
         tt-op.details = vWdgtHdl:SCREEN-VALUE.
      END.

      IF NOT CAN-DO("in-cont-code," + mDelSysConf, vWdgtNam)
         AND CAN-DO(mInitFields, vWdgtNam)
         AND CAN-DO("FILL-IN,EDITOR", vWdgtHdl:TYPE)
         AND vWdgtHdl:SENSITIVE
      THEN
         RUN SetSysConf IN h_base
            (
              INPUT "opreq:" + vWdgtNam
            , INPUT vWdgtHdl:SCREEN-VALUE
            ) .
      vWdgtHdl = vWdgtHdl:NEXT-SIBLING.
   END.
END.

ON "F1" OF op.doc-type IN FRAME opreq
DO:
   RUN browseld.p
      (
        INPUT "doc-type"
      , INPUT ""
      , INPUT ""
      , INPUT ""
      , INPUT 4
      ) .
   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN DO:
      SELF:SCREEN-VALUE = pick-value.
      APPLY "TAB" TO SELF.
   END.
   RETURN NO-APPLY.
END.

ON LEAVE OF op.doc-type IN FRAME opreq
DO:
   RUN GetDocTypeName IN h_op
      (
         INPUT op.doc-type:SCREEN-VALUE
      , OUTPUT mDocTypeName
      ) .
   DISPLAY
      mDocTypeName @ doc-type.name
   WITH FRAME opreq.
END.

&IF DEFINED(OFFbranch) = 0 &THEN
ON "F1" OF xbranch-id
   &IF DEFINED(ONxbranch) > 0 AND
       DEFINED(ONgroup)   > 0
   &THEN
         , xbranch-id1
   &ENDIF
                       IN FRAME opreq
DO:
   mF1wasPressed = YES.
   RUN a-branch.p
      (
        INPUT ""
      , INPUT ""
      , INPUT 4
      ) .
   mF1wasPressed = NO.
   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN DO:
      SELF:SCREEN-VALUE = pick-value.
      APPLY "TAB" TO SELF.
   END.
   RETURN NO-APPLY.
END.

ON LEAVE OF xbranch-id IN FRAME opreq
DO:
   IF NOT (xbranch-id:SENSITIVE IN FRAME opreq AND
           xbranch-id:VISIBLE   IN FRAME opreq)
   THEN
      RETURN NO-APPLY.

   ASSIGN FRAME opreq
      xbranch-id
      .

   IF mF1wasPressed THEN
      RETURN NO-APPLY.

   mAcctCat = (IF AVAILABLE op-kind
               THEN GetAcctCat(ROWID(op-kind))
               ELSE "").
   IF mAcctCat EQ "n" THEN
      RETURN.

   RUN CheckBranch
      (
        INPUT xbranch-id
      ) .
   IF RETURN-VALUE NE "" THEN
   DO:
      IF mIgnoreMes THEN
         RUN Fill-SysMes IN h_tmess
            (
              INPUT ""
            , INPUT ""
            , INPUT "0"
            , INPUT (IF RETURN-VALUE NE ?
                     THEN RETURN-VALUE
                     ELSE "")
            ) .
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   DISPLAY
      GetObjName(
                  "branch"
                , xbranch-id
                , YES
                ) @ branch.name
   WITH FRAME opreq.
END.
&ENDIF

&IF DEFINED(ONxbranch) &THEN
&IF DEFINED(ONgroup) = 0 &THEN
ON "F1" OF xbranch-id1 IN FRAME opreq
DO:
   RUN "a-br(kp).p"
      (
        INPUT ""
      , INPUT "KauClass"
            + CHR(1) + "-����"
            + CHR(1) + REPLACE(
                                GetCodeMisc(
                                             "�������"
                                           , "���-" + mType
                                           , 6
                                           )
                              , ","
                              , CHR(1)
                              )
      , INPUT "�������,������"
            + CHR(1) + mType
            + CHR(1) + in-contract
            + CHR(1) + AddFilToLoan(in-cont-code:SCREEN-VALUE, shFilial)
            + CHR(1) + "*"
            + CHR(1) + "*"
      , INPUT "*"
      , INPUT 9
      ) NO-ERROR.

   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN DO:
      ASSIGN
         xtab-no1   :SCREEN-VALUE = ENTRY(3, pick-value)
         xbranch-id1:SCREEN-VALUE = ENTRY(4, pick-value)
         NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
      DO:
         APPLY "TAB" TO xtab-no1    IN FRAME opreq.
         APPLY "TAB" TO xbranch-id1 IN FRAME opreq.
      END.
   END.
   RETURN NO-APPLY.
END.
&ENDIF

ON LEAVE OF xbranch-id1 IN FRAME opreq
DO:
   IF NOT (xbranch-id1:SENSITIVE IN FRAME opreq AND
           xbranch-id1:VISIBLE   IN FRAME opreq)
   THEN
      RETURN NO-APPLY.

   ASSIGN FRAME opreq
      xbranch-id1
      .

   mAcctCat = (IF AVAILABLE op-kind
               THEN GetAcctCat(ROWID(op-kind))
               ELSE "").
   IF mAcctCat EQ "n" THEN
      RETURN.

   RUN CheckBranch
      (
        INPUT xbranch-id1
      ) .
   IF RETURN-VALUE NE "" THEN
   DO:
      IF mIgnoreMes THEN
         RUN Fill-SysMes IN h_tmess
            (
              INPUT ""
            , INPUT ""
            , INPUT "0"
            , INPUT (IF RETURN-VALUE NE ?
                     THEN RETURN-VALUE
                     ELSE "")
            ) .
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   DISPLAY
      GetObjName(
                  "branch"
                , xbranch-id1
                , YES
                ) @ xbranch.name
   WITH FRAME opreq.

&IF DEFINED(ONgroup) = 0 &THEN
&IF DEFINED(ONmove) &THEN
   RUN GetQty.
&ENDIF
&ENDIF
END.
&ENDIF

&IF DEFINED(OFFtab-no) = 0 &THEN
ON "F1" OF xtab-no
   &IF DEFINED(ONxtab-no) > 0 AND
       DEFINED(ONgroup)   > 0
   &THEN
         , xtab-no1
   &ENDIF
                    IN FRAME opreq
DO:
   RUN a-emptab.p
      (
        INPUT ?
      , INPUT 4
      ) .
   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN DO:
      SELF:SCREEN-VALUE = ENTRY(NUM-ENTRIES(pick-value), pick-value).

      &IF DEFINED(OFFbranch) = 0 &THEN
         IF NUM-ENTRIES(pick-value) GT 1 THEN
         CASE SELF:NAME
         :
         &IF DEFINED(ONxbranch) &THEN
            WHEN "xtab-no1" THEN
            DO:
               IF xbranch-id1:SENSITIVE IN FRAME opreq AND
                  xbranch-id1:VISIBLE   IN FRAME opreq
               THEN
                  xbranch-id1:SCREEN-VALUE = ENTRY(1, pick-value).
            END.
         &ENDIF

            WHEN "xtab-no"  THEN
            DO:
               IF xbranch-id :SENSITIVE IN FRAME opreq AND
                  xbranch-id :VISIBLE   IN FRAME opreq
               THEN
                  xbranch-id :SCREEN-VALUE = ENTRY(1, pick-value).
            END.
         END CASE. /* SELF:NAME */
      &ENDIF
      APPLY "TAB" TO SELF.
   END.
   RETURN NO-APPLY.
END.

ON LEAVE OF xtab-no IN FRAME opreq
DO:
   DEFINE BUFFER employee FOR employee.

   IF NOT (xtab-no:SENSITIVE IN FRAME opreq AND
           xtab-no:VISIBLE   IN FRAME opreq)
   THEN
      RETURN NO-APPLY.

   ASSIGN FRAME opreq
      xtab-no
      .

   mAcctCat = (IF AVAILABLE op-kind
               THEN GetAcctCat(ROWID(op-kind))
               ELSE "").
   IF mAcctCat EQ "n" THEN
      RETURN.

   RUN CheckEmployee
      (
        INPUT xtab-no
      ) .
   IF RETURN-VALUE NE "" THEN
   DO:
      IF mIgnoreMes THEN
         RUN Fill-SysMes IN h_tmess
            (
              INPUT ""
            , INPUT ""
            , INPUT "0"
            , INPUT (IF RETURN-VALUE NE ?
                     THEN RETURN-VALUE
                     ELSE "")
            ) .
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   FIND FIRST employee
        WHERE employee.filial-id EQ shFilial
          AND employee.tab-no    EQ INT64(xtab-no)
      NO-LOCK NO-ERROR.
   IF AVAILABLE employee THEN
      DISPLAY
         GetObjName(
                     "employee"
                   , shFilial + "," + STRING(xtab-no)
                   , NO
                   ) @ sname
      WITH FRAME opreq.
   ELSE
      DISPLAY
                  "" @ sname
      WITH FRAME opreq.
END.
&ENDIF

&IF DEFINED(ONxtab-no) &THEN
&IF DEFINED(ONgroup) = 0 &THEN
ON "F1" OF xtab-no1 IN FRAME opreq
DO:
   RUN "a-br(kp).p"
      (
        INPUT ""
      , INPUT "KauClass"
            + CHR(1) + "-����"
            + CHR(1) + REPLACE(
                                GetCodeMisc(
                                             "�������"
                                           , "���-" + mType
                                           , 6
                                           )
                              , ","
                              , CHR(1)
                              )
      , INPUT "�������,������"
            + CHR(1) + mType
            + CHR(1) + in-contract
            + CHR(1) + AddFilToLoan(in-cont-code:SCREEN-VALUE, shFilial)
            + CHR(1) + "*"
            + CHR(1) + "*"
      , INPUT "*"
      , 9
      ) NO-ERROR.
   IF (LASTKEY   EQ 10  OR
       LASTKEY   EQ 13) AND
      pick-value NE ?
   THEN DO:
      ASSIGN
         xtab-no1   :SCREEN-VALUE = ENTRY(3, pick-value)
         xbranch-id1:SCREEN-VALUE = ENTRY(4, pick-value)
         NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
      DO:
         APPLY "TAB" TO xtab-no1    IN FRAME opreq.
         APPLY "TAB" TO xbranch-id1 IN FRAME opreq.
      END.
   END.
   RETURN NO-APPLY.
END.
&ENDIF

ON LEAVE OF xtab-no1 IN FRAME opreq
DO:
   DEFINE BUFFER employee FOR employee.

   IF NOT (xtab-no1:SENSITIVE IN FRAME opreq AND
           xtab-no1:VISIBLE   IN FRAME opreq)
   THEN
      RETURN NO-APPLY.

   ASSIGN FRAME opreq
      xtab-no1
      .

   mAcctCat = (IF AVAILABLE op-kind
               THEN GetAcctCat(ROWID(op-kind))
               ELSE "").
   IF mAcctCat EQ "n" THEN
      RETURN.

   RUN CheckEmployee
      (
        INPUT xtab-no1
      ) .
   IF RETURN-VALUE NE "" THEN
   DO:
      IF mIgnoreMes THEN
         RUN Fill-SysMes IN h_tmess
            (
              INPUT ""
            , INPUT ""
            , INPUT "0"
            , INPUT (IF RETURN-VALUE NE ?
                     THEN RETURN-VALUE
                     ELSE "")
            ) .
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   FIND FIRST employee
        WHERE employee.filial-id EQ shFilial
          AND employee.tab-no    EQ INT64(xtab-no1)
      NO-LOCK NO-ERROR.
   IF AVAILABLE employee THEN
      DISPLAY
         GetObjName(
                     "employee"
                   , shFilial + "," + STRING(xtab-no1)
                   , NO
                   ) @ sname1
      WITH FRAME opreq.
   ELSE
      DISPLAY
                  "" @ sname1
      WITH FRAME opreq.

&IF DEFINED(ONgroup) = 0 &THEN
&IF DEFINED(ONmove) &THEN
   RUN GetQty.
&ENDIF
&ENDIF
END.
&ENDIF

&IF DEFINED(Details) &THEN

{details.def}

/* ����ୠ� ��ࠡ�⪠ � �����祭�� ���⥦� ��� �������� �࠭���権
** (��� ��㯯���� ।����㥬 �� ����୮� ��ࠡ�⪨) */
&IF DEFINED(ONgroup) = 0 &THEN
ON ENTRY OF op.details IN FRAME opreq
DO:
   DEFINE VARIABLE vDetails AS CHARACTER NO-UNDO.

   /* �⮡� �ᯮ�짮���� ���쓌� �� �᭮���� ����窥 � �����祭�� */
   IF VALID-HANDLE(ht) THEN
      RUN Change IN ht
         (
           INPUT in-contract
         , INPUT AddFilToLoan(in-cont-code:SCREEN-VALUE, shFilial)
      &IF DEFINED(OnMove)
      &THEN
         , INPUT xtab-no1
         , INPUT xbranch-id1
      &ELSE
         , INPUT xtab-no
         , INPUT xbranch-id
      &ENDIF
         ) .

   &IF DEFINED(OnOut) &THEN
      /* �⮡� �ᯮ�짮���� ���쓌� �� �������⥫쭮� ����窥 � �����祭�� */
      IF VALID-HANDLE(ph) THEN
         RUN Change IN ph
            (
              INPUT to-contract
            , INPUT AddFilToLoan(to-cont-code, shFilial)
            , INPUT xtab-no
            , INPUT xbranch-id
            ) .
      ASSIGN
         chpar1 = to-cont-code:SCREEN-VALUE
         chpar2 = to-contract
         .
   &ELSE
      ASSIGN
         chpar1 = in-cont-code:SCREEN-VALUE
         chpar2 = in-contract
         .
   &ENDIF

   /* ��-�� ⮣�, �� ��� �������� ������� �㭪権 �� ��� ������,
   ** ��� �㭪樮��� ���� �⪫�祭.
   ** RUN ProcessDetails ����᪠�� � a-tr-prc.i */
   /*
   IF LOOKUP("ProcessDetails", THIS-PROCEDURE:INTERNAL-ENTRIES) GT 0 THEN
   DO:
      vDetails = SELF:SCREEN-VALUE.
      RUN ProcessDetails
         (
           INPUT        (IF AVAILABLE wop
                         THEN RECID(wop)
                         ELSE ?)
         , INPUT-OUTPUT vDetails
         ) .
      SELF:SCREEN-VALUE = vDetails.
   END.
   */
END.
&ENDIF

ON "F3", "F4", "F5" OF op.details IN FRAME opreq
DO:
   DEFINE VARIABLE vDetails AS CHARACTER NO-UNDO.

   IF LASTKEY EQ KEYCODE("F3") OR
      LASTKEY EQ KEYCODE("F4")
   THEN DO:
      IF LASTKEY EQ KEYCODE("F3")
      THEN DO:
         IF AVAILABLE xop THEN
            FIND PREV xop
                WHERE xop.user-id EQ USERID("bisquit")
                  AND xop.op      LE op.op
               NO-LOCK USE-INDEX op NO-ERROR.
         ELSE
            FIND LAST xop
                WHERE xop.user-id EQ USERID("bisquit")
                  AND xop.op      LE op.op
               NO-LOCK USE-INDEX op NO-ERROR.
      END.
      ELSE DO:
         IF AVAILABLE xop AND
            ROWID(xop) NE ROWID(op)
         THEN
            FIND NEXT xop
                WHERE xop.user-id EQ USERID("bisquit")
                  AND xop.op      LE op.op
               NO-LOCK USE-INDEX op NO-ERROR.
         ELSE
            BELL.
      END.

      IF AVAILABLE xop THEN
         SELF:SCREEN-VALUE = xop.details.
   END.
   ELSE DO:
      vDetails = SELF:SCREEN-VALUE.
      RUN insrtop.p
         (
           INPUT-OUTPUT vDetails
         , INPUT        RECID(op)
         ) .
      SELF:SCREEN-VALUE = vDetails.
   END.
   APPLY "ENTRY" TO SELF.
   RETURN NO-APPLY.
END.
&ENDIF

&IF DEFINED(ONgroup) = 0 &THEN
&IF DEFINED(ONcalc)  > 0 &THEN
ON LEAVE OF xQty IN FRAME opreq
DO:
&IF DEFINED(ONmove) &THEN
   DEFINE VARIABLE vQty    AS DECIMAL   NO-UNDO INITIAL ?. /* ������⢮ */
   DEFINE VARIABLE vSum    AS DECIMAL   NO-UNDO INITIAL ?. /* ���⮪ */
   DEFINE VARIABLE vKau    AS CHARACTER NO-UNDO.           /* ����� */
&IF DEFINED(WithTB) &THEN
   DEFINE VARIABLE vQtyTB  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vSumTB  AS DECIMAL   NO-UNDO.
&ENDIF
&ENDIF
&IF DEFINED(ONcalc) &THEN
   DEFINE VARIABLE vOldQty AS DECIMAL   NO-UNDO.
&ENDIF

   IF NOT (xQty:SENSITIVE IN FRAME opreq  AND
           xQty:VISIBLE   IN FRAME opreq)
   THEN
      RETURN NO-APPLY.

   &IF DEFINED(ONcalc) &THEN
   vOldQty = xQty.
   &ENDIF

   ASSIGN FRAME opreq
      xQty
      .

   &IF DEFINED(ONcalc) &THEN
   IF vOldQty NE xQty AND
      vOldQty GT 0
   THEN
      mQtyUpdated = YES.
   &ENDIF
   
&IF DEFINED(ONmove) &THEN
   DEFINE BUFFER op-template FOR op-template.

   DEFINE VARIABLE vQtyNeed AS LOGICAL NO-UNDO INITIAL YES.

   IF AVAILABLE op-kind THEN
   DO:
      vQtyNeed = NO.
      FOR EACH op-template
            OF op-kind
      NO-LOCK
      :
         IF GetXAttrValueEx(
                             "op-template"
                           ,  op-template.op-kind + "," + STRING(op-template.op-template)
                           , "QtyNeed"
                           , (IF op-template.op-template EQ  1  AND
                                 op-template.acct-cat    NE "n"
                              THEN "��"
                              ELSE "���")
                           ) EQ "��"
         THEN DO:
            vQtyNeed = YES.
            LEAVE.
         END.
      END.
      IF NOT vQtyNeed THEN
         RETURN NO-APPLY.
   END.

   IF xQty LE 0 THEN
   DO:
      MESSAGE "������⢮ ������ ���� ����� 0"
         VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   vKau =       in-contract
        + "," + AddFilToLoan(in-cont-code:SCREEN-VALUE, shFilial)
        + "," + STRING(xtab-no1)
        + "," + xbranch-id1.
   RUN GetKauPos IN h_umc
      (
         INPUT vKau
      ,  INPUT mType
      ,  INPUT in-op-date
      , OUTPUT vSum
      , OUTPUT vQty
      ) .
   &IF DEFINED(WithTB) &THEN
      IF mType EQ "���" THEN
      DO:
         RUN GetKauPos IN h_umc
            (
               INPUT vKau
            ,  INPUT "�ॡ"
            ,  INPUT in-op-date
            , OUTPUT vSumTB
            , OUTPUT vQtyTB
            ) .
         ASSIGN
            vSum = vSum - vSumTB
            vQty = vQty - vQtyTB
            .
      END.
   &ENDIF
   IF xQty GT vQty THEN
   DO:
      MESSAGE
         "� �⢥��⢥����� ⠡.N" xtab-no1 SKIP(0)
         (IF vQty LE 0
          THEN ("��������� 業����� ���.N " + in-cont-code:SCREEN-VALUE)
          ELSE ("� ����稨 ⮫쪮 "           + STRING(vQty) + " ��."))
                                           SKIP(1)
         "������ ����!"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   remove-amt = xQty * (vSum / vQty).
&ELSE
   IF AVAILABLE asset THEN
      remove-amt = xQty * mCostNew.
&ENDIF

   DISPLAY
      remove-amt
   WITH FRAME opreq.
END.
&ENDIF

&IF DEFINED(ONcalcAmt) > 0 &THEN
ON LEAVE OF remove-amt IN FRAME opreq
DO:
   &IF DEFINED(RemAmt) &THEN
   DEFINE VARIABLE old-amt AS DECIMAL NO-UNDO.

   old-amt = remove-amt.
   &ENDIF

   ASSIGN FRAME opreq
      remove-amt
      .

   IF remove-amt LE 0 THEN
   DO:
      MESSAGE "�㬬� ������ ���� ����� 0"
         VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   &IF DEFINED(RemAmt) &THEN
   IF old-amt NE remove-amt AND
      old-amt GT 0
   THEN
      mAmtUpdated = YES.
   &ENDIF
END.
&ENDIF

/* ������� ��� �� ��室���� ���㬥�� */
PROCEDURE GetSrcKau:
   DEFINE  INPUT PARAMETER iLoanRID AS RECID     NO-UNDO.
   DEFINE OUTPUT PARAMETER oKau     AS CHARACTER NO-UNDO INITIAL ?. /* ���    */
   DEFINE OUTPUT PARAMETER oQty     AS DECIMAL   NO-UNDO INITIAL ?. /* ���-�� */

   DEFINE BUFFER loan      FOR loan.
   DEFINE BUFFER code      FOR code.
   DEFINE BUFFER op        FOR op.
   DEFINE BUFFER kau-entry FOR kau-entry.

   DEFINE VARIABLE vKauMatches  AS CHARACTER NO-UNDO INITIAL ?. /* ������ ��� �⡮� �� ��� ��� MATCHES */
   DEFINE VARIABLE vKauBegins   AS CHARACTER NO-UNDO INITIAL ?. /* ������ ��� �⡮� �� ��� ��� MATCHES */
   DEFINE VARIABLE vDoc-Date    AS DATE      NO-UNDO INITIAL ?. /* ��� � ����� ��室���� ���㬥�� */
   DEFINE VARIABLE vDoc-Num     AS CHARACTER NO-UNDO INITIAL ?.
   DEFINE VARIABLE vOpLst       AS CHARACTER NO-UNDO.           /* ���᮪ ���㬥�⮢ �� ����窥 */
   DEFINE VARIABLE vDebit       AS LOGICAL   NO-UNDO.           /* ���� ��/�� */
   DEFINE VARIABLE vRetVal      AS CHARACTER NO-UNDO.           /* �����頥��� ���祭�� */

   FOR FIRST loan
       WHERE RECID(loan) EQ iLoanRID
   NO-LOCK
   :
      oKau = loan.contract + "," + loan.cont-code + ",".
      IF mFlag THEN
      l_code:
      FOR EACH code
         WHERE
         (
               code.class   EQ "�������"
           AND code.code    EQ "���-���"
           AND code.misc[8] EQ "u"
         )
            OR
         (
               code.class   EQ "�������"
           AND code.code    EQ "���-�ॡ"
           AND code.misc[8] EQ "u"
         )
      NO-LOCK
      :
         ASSIGN
            /* ������ ��� MATCHES */
            vKauMatches = KauMatchPattern(
                                           code.code
                                         , "�������"     + CHR(1) + "������"
                                         , loan.contract + CHR(1) + loan.cont-code
                                         )
            /* ������ ��� BEGINS  */
            vKauBegins  = ConvMatch2Beg(vKauMatches)
            vDebit      = ("{&ONmove}" EQ "")
            vDoc-Date   = DATE(GetSysConf("NDFrm:vDoc-Date"))
            vDoc-Num    =      GetSysConf("NDFrm:vDoc-Num" )
            .
         IF vKauMatches NE ? THEN
         FOR EACH kau-entry       /* USE-INDEX kau */
            WHERE kau-entry.kau-id        EQ code.code
              AND kau-entry.kau      BEGINS  vKauBegins
              AND kau-entry.kau      MATCHES vKauMatches
              AND kau-entry.op-date       EQ vDoc-Date
              AND kau-entry.acct-cat      EQ code.misc[8]
              AND kau-entry.debit         EQ vDebit
         NO-LOCK
         ,  FIRST op
               OF kau-entry
            WHERE op.doc-date EQ vDoc-Date
              AND op.doc-num  EQ vDoc-Num
              AND (NOT AVAILABLE bSrcOp
               OR  RECID(op)  EQ RECID(bSrcOp))
         NO-LOCK
         :
            {additem.i vOpLst STRING(op.op)}
            ASSIGN
               oKau = kau-entry.kau
               oQty = kau-entry.qty
               .
         END.

         IF      NUM-ENTRIES(vOpLst) GT 1 THEN
            vRetVal = "�� ����窥 ������� ��᪮�쪮 ���㬥�⮢~n"
                    + "� 㪠����묨 ��⮩ � ����஬!".
         ELSE IF NUM-ENTRIES(vOpLst) EQ 0 THEN
            vRetVal = "�� ����窥 ��� ���㬥�⮢ � 㪠����묨 ��⮩ � ����஬,"
                    + "~n���室��� ��� ������ ����樨!".
         ELSE
            vRetVal = "NO".
      END.
   END.

   RETURN vRetVal.
END PROCEDURE. /* GetSrcKau */

PROCEDURE GetTab-Branch:
   DEFINE  INPUT PARAMETER iLoanRID AS RECID     NO-UNDO.
   DEFINE  INPUT PARAMETER iRoleSfx AS CHARACTER NO-UNDO. /* ���䨪� ஫�         */
   DEFINE  INPUT PARAMETER iDate    AS DATE      NO-UNDO. /* �� ����              */
   DEFINE OUTPUT PARAMETER oTab     AS INT64     NO-UNDO. /* ⠡���� �����      */
   DEFINE OUTPUT PARAMETER oBranch  AS CHARACTER NO-UNDO. /* ���ࠧ�������        */
   DEFINE OUTPUT PARAMETER oQty     AS DECIMAL   NO-UNDO. /* ������⢮           */

   IF NOT (iRoleSfx BEGINS "-") THEN
      iRoleSfx = "-" + iRoleSfx.

   IF iDate EQ ? THEN
      iDate  = 12/31/9999.

   DEFINE BUFFER loan      FOR loan.
   DEFINE BUFFER loan-acct FOR loan-acct.
   DEFINE BUFFER kau       FOR kau.

   DEFINE VARIABLE vKau    AS CHARACTER NO-UNDO INITIAL ?. /* ����� */
   DEFINE VARIABLE vSum    AS DECIMAL   NO-UNDO EXTENT  2. /* �ᯮ����⥫�� �㬬� */
   DEFINE VARIABLE vRetVal AS CHARACTER NO-UNDO.           /* �����饭��� GetSrcKau ���祭�� */
   DEFINE VARIABLE vStr    AS CHARACTER NO-UNDO INITIAL ?. /* �ᯮ����⥫쭠� ��ப� */
&IF DEFINED(WithTB) &THEN
   DEFINE VARIABLE vQtyTB  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vSumTB  AS DECIMAL   NO-UNDO.
&ENDIF

   FOR FIRST loan
       WHERE RECID(loan) EQ iLoanRID
   NO-LOCK
   :
      /* ��६ kau �� ��室���� ���㬥�� ��⮭������ ᪫���
      ** (�᫨ ��� ���, � contract + cont-code) */
      RUN GetSrcKau
         (
            INPUT iLoanRID
         , OUTPUT vKau
         , OUTPUT oQty
         ) .
      vRetVal = RETURN-VALUE.

      FOR LAST loan-acct
            OF loan
         WHERE loan-acct.acct-type EQ loan.contract + iRoleSfx
           AND loan-acct.since     LE iDate
      NO-LOCK
      ,   EACH kau
         WHERE kau.kau         BEGINS vKau
           AND kau.acct            EQ loan-acct.acct
           AND kau.currency        EQ loan-acct.currency
      NO-LOCK
      :
         RUN GetKauPos IN h_umc
            (
               INPUT kau.kau
            ,  INPUT iRoleSfx
            ,  INPUT iDate
            , OUTPUT vSum[1]
            , OUTPUT vSum[2]
            ) .
   &IF DEFINED(WithTB) &THEN
         IF mType EQ "���" THEN
         DO:
            RUN GetKauPos IN h_umc
               (
                  INPUT kau.kau
               ,  INPUT "�ॡ"
               ,  INPUT in-op-date
               , OUTPUT vSumTB
               , OUTPUT vQtyTB
               ) .
            ASSIGN
               vSum[1] = vSum[1] - vSumTB
               vSum[2] = vSum[2] - vQtyTB
               .
         END.
   &ENDIF
         IF vSum[2] GT 0 THEN
         DO:
            vKau = kau.kau.
            LEAVE.
         END.
      END.

      &IF DEFINED(ONMove) &THEN
      oQty = (IF oQty EQ ?
              THEN vSum[2]
              ELSE MIN(oQty, vSum[2])).
      &ENDIF

      IF   CAN-DO("��,���", in-contract)
         &IF DEFINED(ONOut) &THEN         OR
           CAN-DO("��,���", to-contract)
         &ENDIF
      THEN
         oQty = MIN(1, oQty).

      IF NUM-ENTRIES(vKau) GT 2 THEN
      DO:
         oTab = INT64(ENTRY(3, vKau)) NO-ERROR.
         IF NUM-ENTRIES(vKau) GT 3 THEN
            oBranch = ENTRY(4, vKau).
      END.
   END.

   RETURN vRetVal.
END PROCEDURE. /* GetTab-Branch */

&IF DEFINED(ONmove) &THEN
PROCEDURE GetQty:
   DEFINE VARIABLE vQty   AS DECIMAL   NO-UNDO INITIAL ?. /* ������⢮ */
   DEFINE VARIABLE vSum   AS DECIMAL   NO-UNDO INITIAL ?. /* ���⮪ */
   DEFINE VARIABLE vKau   AS CHARACTER NO-UNDO.           /* ����� */
&IF DEFINED(WithTB) &THEN
   DEFINE VARIABLE vQtyTB AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vSumTB AS DECIMAL   NO-UNDO.
&ENDIF

   vKau =       in-contract
        + "," + AddFilToLoan(in-cont-code:SCREEN-VALUE IN FRAME opreq, shFilial)
        + "," + STRING(xtab-no1)
        + "," + xbranch-id1.

   RUN GetKauPos IN h_umc
      (
         INPUT vKau
      ,  INPUT mType
      ,  INPUT in-op-date
      , OUTPUT vSum
      , OUTPUT vQty
      ) .
   &IF DEFINED(WithTB) &THEN
      IF mType EQ "���" THEN
      DO:
         RUN GetKauPos IN h_umc
            (
               INPUT vKau
            ,  INPUT "�ॡ"
            ,  INPUT in-op-date
            , OUTPUT vSumTB
            , OUTPUT vQtyTB
            ) .
         ASSIGN
            vSum = vSum - vSumTB
            vQty = vQty - vQtyTB
            .
      END.
   &ENDIF
   DO WITH FRAME opreq:
      IF xQty:SENSITIVE AND
         xQty:VISIBLE
      THEN DO:
         IF vQty GT 0    AND
            vQty NE xQty
         THEN DO:
            &IF DEFINED(ONcalc) &THEN
            IF mQtyUpdated     AND
               vQty LT xQty    OR
               NOT mQtyUpdated
            THEN
            &ENDIF
            xQty = vQty. /* MAX(1, vQty). */
         END.
      END.

      IF CAN-DO("��,���", in-contract)
      &IF DEFINED(ONOut) &THEN         OR
         CAN-DO("��,���", to-contract)
      &ENDIF
      THEN
         xQty = MIN(1, xQty).

      remove-amt = xQty * (IF vQty EQ 0
                           THEN 0
                           ELSE (vSum / vQty)).
      DISPLAY
         xQty
         remove-amt
      WITH FRAME opreq.
   END.

   RETURN.
END PROCEDURE. /* GetQty */
&ENDIF
&ENDIF

/* ����� ���� � ����� ��室��� ���㬥�⮢ ��⮭������ ᪫���
** (��� ��㯯���� �࠭���権 ��壠���) */
PROCEDURE GetDatNum:
   mFlag = YES.

   /* ��� � ����� ��室���� ���㬥�� */
   DEFINE VARIABLE vDoc-Date AS DATE      NO-UNDO LABEL "���" FORMAT "99/99/9999".
   DEFINE VARIABLE vDoc-Num  AS CHARACTER NO-UNDO LABEL "�����".
   DEFINE VARIABLE vOpRID    AS RECID     NO-UNDO. /* RECID ��࠭���� ���㬥�� */

   FORM                                                      SKIP(1)
      vDoc-Date   HELP "��� �஢������ ��室���� ���㬥��" SKIP(1)
      vDoc-Num    HELP "����� ��室���� ���㬥��"           SKIP(1)
   WITH FRAME NDFrm CENTERED ROW 12 OVERLAY SIDE-LABELS 1 COLUMN TITLE COLOR
        BRIGHT-WHITE "[ ��������� ��室��� ���㬥�⮢ ]".

   /* �롮� ���㬥�� �� F1 */
   ON "F1" OF FRAME NDFrm ANYWHERE
   DO:
      /* �������㥬 ���� ���㬥�� */
      DEFINE BUFFER op FOR op.

      RUN GetSrcOp
         (
            INPUT (INPUT vDoc-Date)
         ,  INPUT (INPUT vDoc-Num)
         ,  INPUT mFiltOp
         ,  INPUT mSrcClass
         , OUTPUT vOpRID
         ) .

      IF vOpRID NE ? THEN
      FOR FIRST op
          WHERE op.op EQ INT64(pick-value)
      NO-LOCK
      :
         DISPLAY
            op.doc-date  @ vDoc-Date
            op.doc-num   @ vDoc-Num
         WITH FRAME NDFrm.
      END.
      RETURN NO-APPLY.
   END.

   ON GO OF FRAME NDFrm
   DO:
      DEFINE VARIABLE vF1 AS LOGICAL NO-UNDO.

      RUN CheckDatNum
         (
           INPUT (INPUT vDoc-Date)
         , INPUT (INPUT vDoc-Num)
         ) .
      IF RETURN-VALUE NE "" THEN
      DO:
         vF1 = (INDEX(RETURN-VALUE, "���室���") GT 0).

         MESSAGE
            RETURN-VALUE +
            (IF vF1
             THEN "~n���஡�� ����� �� ᯨ᪠."
             ELSE "")
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.

         IF vF1 THEN
            APPLY "F1" TO SELF.
         RETURN NO-APPLY.
      END.
   END.

   READKEY PAUSE 0.

   ASSIGN
      vDoc-Date   = DATE(GetSysConf("NDFrm:vDoc-Date"))
      vDoc-Num    =      GetSysConf("NDFrm:vDoc-Num" )
      .

   IF vDoc-Date EQ ? THEN
      vDoc-Date =  TODAY.

   IF vDoc-Num  EQ ? THEN
      vDoc-Num  =  "".

   DO ON ERROR  UNDO, RETRY
      ON ENDKEY UNDO, RETRY
   :
      IF RETRY THEN
      DO:
         HIDE FRAME NDFrm NO-PAUSE.
         RETURN ERROR.
      END.

      &IF DEFINED(ONgroup) &THEN
         UPDATE
            vDoc-Date
            vDoc-Num
         WITH FRAME NDFrm.
      &ELSE /* FD!!! ����� �㦥� �롮� ���㬥�⮢ �� ����窥! */
         RUN GetSrcOp
            (
               INPUT ?
            ,  INPUT ""
            ,  INPUT mFiltOp
            ,  INPUT mSrcClass
            , OUTPUT vOpRID
            ) .

      IF vOpRID NE ? THEN
         FOR FIRST bSrcOp
             WHERE bSrcOp.op EQ INT64(pick-value)
         NO-LOCK
         :
            ASSIGN
               vDoc-Date = bSrcOp.doc-date
               vDoc-Num  = bSrcOp.doc-num
               .
         END.
      &ENDIF
      RUN SetSysConf IN h_base
         (
           INPUT "NDFrm:vDoc-Date"
         , INPUT STRING(vDoc-Date, "99/99/9999")
         ) .
      RUN SetSysConf IN h_base
         (
           INPUT "NDFrm:vDoc-Num"
         , INPUT vDoc-Num
         ) .
   END.
   HIDE FRAME NDFrm NO-PAUSE.

   RETURN.
END PROCEDURE. /* GetDatNum */

/* �஢�ઠ ���४⭮�� ���� � ����� ��楯�㥬�� ���㬥�⮢
** FD: �� ᠬ�� ���� ��� �஢��� ���� �������� �� �஢�મ�
**     ������ ��� ���㬥�⮢ � 㪠����묨 ��⮩ � ����஬
**     � �롮થ � 㪠����� 䨫��஬! */
PROCEDURE CheckDatNum:
   DEFINE INPUT PARAMETER iDoc-Date AS DATE      NO-UNDO. /* ��� � ����� ���㬥�⮢ */
   DEFINE INPUT PARAMETER iDoc-Num  AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vRetVal   AS CHARACTER NO-UNDO. /* �����頥��� ᮮ�饭�� �� �訡�� */
   DEFINE VARIABLE vDebit    AS LOGICAL   NO-UNDO. /* ���� ��/�� */
   DEFINE VARIABLE vDoc-Type AS CHARACTER NO-UNDO. /* ��� ���㬥�� */

   /* �����쭮 ���塞 ���� */
   DEFINE BUFFER op         FOR op.
   DEFINE BUFFER kau-entry  FOR kau-entry.

   ASSIGN
      vDebit    = (
                    &IF DEFINED(ONgroup) &THEN
                       GetXattrValueEx(
                                        "op-kind"
                                      , op-kind.op-kind
                                      , "tomodule"
                                      , ""
                                      )
                    &ELSE
                       "{&ONmove}"
                    &ENDIF EQ ""
                  )
      vDoc-Type = (IF vDebit
                   THEN "1011"
                   ELSE "1016")
      .
   &IF DEFINED(ONgroup) &THEN
      &IF DEFINED(ONmove) &THEN
         vDoc-Type = "1019".
      &ENDIF
   &ENDIF

   FOR EACH op
      WHERE op.doc-num  EQ iDoc-Num
        AND op.op-date  EQ iDoc-Date
        AND op.doc-date LE iDoc-Date
   NO-LOCK
         BY op.doc-date DESCENDING
   :
      vRetVal = ",~n���室��� ��� ������ ����樨".

      IF op.doc-type  NE vDoc-Type OR
         op.acct-cat  NE "u"       OR
         op.op-status NE mStatus
      THEN
         NEXT.

      FOR EACH kau-entry
            OF op
         WHERE CAN-DO("���-���,���-�ॡ", kau-entry.kau-id)
           AND kau-entry.debit            EQ vDebit
           AND NUM-ENTRIES(kau-entry.kau) GT 3
      NO-LOCK
      :
         /* ��� ��㣨� �㡯஢����, �஬� ���室��� */
         /*
         IF NOT CAN-FIND (FIRST kau-entry
                             OF op
                          WHERE kau-entry.kau-id NE "���-���"
                             OR kau-entry.debit  NE vDebit)
         THEN
            RETURN.
         */
         RETURN.
      END.
   END.

   RETURN "��� ���㬥�⮢ � 㪠����묨 ��⮩ � ����஬" + vRetVal + "!".
END PROCEDURE. /* CheckDatNum */

/* �롮� ���㬥��-���筨�� �� �⠭���⭮�� ��㧥� ���㬥�⮢ */
PROCEDURE GetSrcOp:
   DEFINE  INPUT PARAMETER iDoc-Date AS DATE      NO-UNDO. /* ��� ���-�          */
   DEFINE  INPUT PARAMETER iDoc-Num  AS CHARACTER NO-UNDO. /* � ���-�             */
   DEFINE  INPUT PARAMETER iFiltOp   AS CHARACTER NO-UNDO. /* ��-� 䨫���         */
   DEFINE  INPUT PARAMETER iClass    AS CHARACTER NO-UNDO. /* ����� ���㬥�⮢     */
   DEFINE OUTPUT PARAMETER oOp       AS INT64     NO-UNDO. /* ID ��࠭���� ���-� */

   /* ���᪨ ��� 䨫��� */
   DEFINE VARIABLE vFields AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vVars   AS CHARACTER NO-UNDO.

   DEFINE BUFFER op FOR op.

   IF iDoc-Num NE "" THEN
      ASSIGN
         vFields    = vFields + CHR(1) + "doc-num"
         vVars      = vVars   + CHR(1) + iDoc-Num
         .

   IF iDoc-Date NE ? THEN
      ASSIGN
         vFields    = vFields
                    + CHR(1) + "doc-date"
                    + CHR(1) + "op-date1"
                    + CHR(1) + "op-date2"
         vVars      = vVars
                    + CHR(1) + STRING(iDoc-Date)
                    + CHR(1) + STRING(iDoc-Date)
                    + CHR(1) + STRING(iDoc-Date)
         .

   IF iFiltOp NE ? THEN
      ASSIGN
         vFields    = vFields + CHR(1) + "UserConf"
         vVars      = vVars   + CHR(1) + iFiltOp
         .

   IF vFields BEGINS CHR(1) THEN
      ASSIGN
         vFields    = SUBSTRING(vFields, 2)
         vVars      = SUBSTRING(vVars,   2)
         .

   pick-value = ?.

   DO TRANSACTION:
      RUN browseld.p
         (
           INPUT (IF iClass EQ ""
                  THEN "op"
                  ELSE iClass)
         , INPUT vFields + CHR(1) + "ActionLock"
         , INPUT vVars   + CHR(1) + "F6"
         , INPUT vFields
         , INPUT 4
         ) NO-ERROR.
   END.

   oOp = INT64(pick-value) NO-ERROR.

   /* ���࠭���� ������ �� ���㬥��-���筨��,
   ** ����室���� ��� ���樠����樨 ����� ��� �࠭���樨 */
   RUN Src2SysConf
      (
        INPUT oOp
      ) .

   RETURN.
END PROCEDURE. /* GetSrcOp */

/* ����⢨� � ��砫� �믮������ �࠭���樨 */
PROCEDURE StartTransInit:
   DEFINE VARIABLE vCnt         AS INT64     NO-UNDO. /* ���稪 */
   DEFINE VARIABLE vProcBefore  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vParam       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vParent      AS CHARACTER NO-UNDO. /* �� ��•�࠭� */
   DEFINE VARIABLE vOpTemplSurr AS CHARACTER NO-UNDO.

   DEFINE BUFFER op-template FOR op-template.

   &SCOPED-DEFINE SfxLst "����,����,����,������"

   /* ��⠭�������� ��������� ���� = ��� ����樨 */
   ASSIGN
      mEnd-Date = gend-date
      gend-date = in-op-date
      .

   /* ���樠������ mType */
   DO vCnt = 1 TO NUM-ENTRIES({&SfxLst}):
      IF op-kind.parent BEGINS ENTRY(vCnt, {&SfxLst}) THEN
      DO:
         mType = ENTRY(vCnt, {&SfxLst}).
         LEAVE.
      END.
   END.

   &UNDEFINE SfxLst

   ASSIGN
      vParent       = fGetSetting("��•�࠭�", ?, "�����")
      mStatus       = (IF CAN-DO(vParent, op-kind.parent)
                       THEN "��"
                       ELSE "�")
      mInitFields   = "in-cont-code,"
                    + GetXattrValueEx(
                                       "op-kind"
                                     , op-kind.op-kind
                                     , "InitFields"
                                     , ""
                                     )
      mNoViewObj    = GetXattrValueEx(
                                       "op-kind"
                                     , op-kind.op-kind
                                     , "NoViewObj"
                                     , ""
                                     )
      mNoSensFields = GetXattrValueEx(
                                       "op-kind"
                                     , op-kind.op-kind
                                     , "NoSensFields"
                                     , ""
                                     )
      .

   FOR EACH op-template
         OF op-kind
   /* WHERE */
   NO-LOCK
   :
      vOpTemplSurr = op-template.op-kind + ","
                   + STRING(op-template.op-template).
      /* ��।��塞 �����䨪��� 䨫��� ��� �롮� ��室���� ���㬥�� */
      mFiltOp = GetXAttrValueEx(
                                 "op-template"
                               , vOpTemplSurr
                               , "���������"
                               , ""
                               ) .
      IF mFiltOp NE "" THEN
      DO:
         /* ��।��塞 ��� �裡 � ��室�� ���㬥�⮬ */
         mLink-Code = GetXAttrValueEx(
                                       "op-template"
                                     , vOpTemplSurr
                                     , "link-op"
                                     , ""
                                     ) .
         /* ��।��塞 ����� ��室���� ���㬥�� */
         IF mLink-Code NE "" THEN
            mSrcClass  = GetLinkedClass(
                                         op-template.cr-class-code
                                       , mLink-Code
                                       ) .
         /* ����� ���� � ����� ��室��� ���㬥�⮢ ��� ��㯯���� ����権 ��壠��� */
         &IF DEFINED(ONgroup) &THEN
            RUN GetDatNum NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
               RETURN ERROR.
         &ENDIF

         LEAVE.
      END.
   END.

   /* �믮������ ��楤���, ����᪠���� �� �믮������ �࠭���樨 */
   vProcBefore = op-kind.before.
   IF {assigned vProcBefore} THEN
   DO:
      vParam = TRIM(ENTRY(2,vProcBefore,"("),")") NO-ERROR.
      RUN VALUE(ENTRY(1, vProcBefore, "("))
         (
           INPUT vParam
         , INPUT in-op-date
         ) NO-ERROR.
   END.

   RETURN.
END PROCEDURE. /* StartTransInit */

/* ���樠������ 㪠������ ����� �३�� */
PROCEDURE InitFields:
   DEFINE INPUT PARAMETER iInitList   AS CHARACTER NO-UNDO. /* ���᮪ ���樠�����㥬�� �����⮢ */
   DEFINE INPUT PARAMETER iHidList    AS CHARACTER NO-UNDO. /* ���᮪ ������ �����⮢ */
   DEFINE INPUT PARAMETER iNoSensList AS CHARACTER NO-UNDO. /* ���᮪ ������㯭�� ��� ।���஢���� �����⮢ */

   DEFINE VARIABLE vWdgtHdl AS WIDGET-HANDLE NO-UNDO. /* ��� ����� ����䥩�  */
   DEFINE VARIABLE vWdgtVal AS CHARACTER     NO-UNDO. /* ��砫쭮� ���祭�� ������ */
   DEFINE VARIABLE vWdgtNam AS CHARACTER     NO-UNDO. /* ������ ��� ������ (� ������ ⠡����) */

   ASSIGN
      vWdgtHdl = FRAME opreq:HANDLE
      vWdgtHdl = vWdgtHdl:FIRST-CHILD
      vWdgtHdl = vWdgtHdl:FIRST-CHILD
      NO-ERROR.

   DO WHILE VALID-HANDLE(vWdgtHdl)
   :
      vWdgtNam = (IF vWdgtHdl:TABLE EQ ?
                  THEN ""
                  ELSE (vWdgtHdl:TABLE + "."))
               + vWdgtHdl:NAME.

      IF CAN-DO("FILL-IN,EDITOR", vWdgtHdl:TYPE) THEN
      DO:
         /* ��⠭�������� �ࠢ���� ������ */
         IF mType EQ "����" THEN
         CASE vWdgtHdl:NAME
         :
            WHEN "xtab-no"     OR
            WHEN "xtab-no1"    THEN
               vWdgtHdl:LABEL = "�����.����".

            WHEN "xbranch-id"  OR
            WHEN "xbranch-id1" THEN
               vWdgtHdl:LABEL = "����� �����".
         END CASE.

         /* ��⠭���� ��砫��� ���祭�� ����� �३��. */
         ASSIGN
            vWdgtVal   = GetSysConf("opreq:" + vWdgtNam)
            mIgnoreMes = YES
            .

         IF NOT FStrEmpty(vWdgtVal) AND
            vWdgtHdl:SENSITIVE      AND
            vWdgtHdl:VISIBLE        AND
            CAN-DO(iInitList, vWdgtNam)
         THEN DO:
            vWdgtHdl:SCREEN-VALUE = (IF "in-cont-code" EQ vWdgtNam
                                     THEN DelFilFromLoan(vWdgtVal)
                                     ELSE vWdgtVal) NO-ERROR.

            IF NOT ERROR-STATUS:ERROR THEN
            DO:
               IF CAN-DO("in-cont-code," + iNoSensList, vWdgtNam) THEN
                  mIgnoreMes = NO.

               /* �⮡� ��ࠡ�⠫ �ਣ���, �᫨ �� ����� */
               IF vWdgtHdl:SENSITIVE AND
                  vWdgtHdl:VISIBLE
               THEN DO:
                  APPLY "LEAVE" TO vWdgtHdl.
                  IF ERROR-STATUS:ERROR THEN
                     RETURN NO-APPLY {&RET-ERROR}.
               END.

               /* �᫨ ����, � ������ ���� ������㯭� ��� ।���஢���� */
               IF CAN-DO("in-cont-code," + iNoSensList, vWdgtNam) THEN
                  vWdgtHdl:SENSITIVE = NO.

               IF vWdgtHdl:SENSITIVE AND
                  NOT vWdgtHdl:VISIBLE
               THEN DO:
                  vWdgtHdl:SCREEN-VALUE = "".
                  vWdgtHdl:SENSITIVE = NO.
               END.
            END.
         END.
/* ������ ����, 㪠����� ������ � �� NoSensFields,
** ������㯭묨 ��� ।���஢����
** �� ����᪥ �࠭���樨 �� ���भ� �������� �訡��: ���� 㪠���� �
** iNoSensList � �� ������ ��� ���� ���������� �� ��ࢮ� ����᪥
** ��楤��� � �� ����୮� ����᪥ ��楤��� �� ���樠���������.
** �⮡� �⮣� �������� �஢��塞, �� ���� �� ᮤ�ন��� � ᯨ᪥ �����
** ���樠����樨
** !!! ���� ��� �஢�ન ⮫쪮 �� ������ */
         ELSE
         IF vWdgtHdl:SENSITIVE                AND
                CAN-DO(iNoSensList, vWdgtNam) AND
            NOT CAN-DO(iInitList,   vWdgtNam) AND
            work-module EQ "�����"
         THEN
            vWdgtHdl:SENSITIVE = NO.
      END.

      /* ���祬 ����� ���� */
      IF CAN-DO(iHidList, vWdgtNam) THEN
         vWdgtHdl:VISIBLE = NO.

      IF vWdgtHdl:SENSITIVE AND
         NOT vWdgtHdl:VISIBLE
      THEN DO:
         vWdgtHdl:SCREEN-VALUE = "".
         vWdgtHdl:SENSITIVE    = NO.
      END.

      vWdgtHdl = vWdgtHdl:NEXT-SIBLING.
   END.

   RETURN.
END PROCEDURE. /* InitFields */

/* ���࠭���� ������ �� 㪠������� ���㬥��-���筨��,
** ����室���� ��� ���樠����樨 ����� ��� �࠭���樨 */
PROCEDURE Src2SysConf:
   DEFINE INPUT PARAMETER vOp AS INT64 NO-UNDO.

   DEFINE VARIABLE vQty AS DECIMAL   NO-UNDO. /* ������⢮ */
&IF DEFINED(ONmove) &THEN
   DEFINE VARIABLE vNum AS CHARACTER NO-UNDO INITIAL "xtab-no".
   DEFINE VARIABLE vBrn AS CHARACTER NO-UNDO INITIAL "xbranch-id".
&ENDIF

   DEFINE BUFFER op        FOR op.
   DEFINE BUFFER kau-entry FOR kau-entry.

   FOR FIRST op
       WHERE op.op EQ vOp
   NO-LOCK
   :
      /* ���࠭塞 ���ண�� ��室���� ���㬥��, �⮡�
      ** ��ࠡ�⠫ ����� "���筨�" � �����祭�� ���⥦� */
      RUN SetSysConf IN h_base
         (
           INPUT "opreq:SrcOp"
         , INPUT STRING(vOp)
         ) .
      {additem.i mDelSysConf 'SrcOp'}

      mStatus = op.op-status.

      /* ���樠�����㥬 ������⢮ = ����楯⮢������ ����� ��室����
      ** ���㬥�� (���뤠����� ����� �� �ॡ������) */
      RUN GetTrebRest IN h_umc
         (
            INPUT op.op
         ,  INPUT mLink-Code
         , OUTPUT vQty
         ) .
      IF vQty NE ? THEN
         RUN SetSysConf IN h_base
            (
              INPUT "opreq:xqty"
            , INPUT STRING(vQty)
            ) .
      {additem.i mDelSysConf 'xqty'}

      /* ��� ���樠����樨 ��� � ���ࠧ������� �� ��室���� ���㬥�� */
      &IF DEFINED(ONmove) &THEN
         FOR EACH kau-entry
               OF op
            WHERE NUM-ENTRIES(kau-entry.kau) GE 4
         NO-LOCK
         :
            IF kau-entry.debit THEN
               ASSIGN
                  vNum = ENTRY(1, vNum, "1")
                  vBrn = ENTRY(1, vBrn, "1")
                  .
            ELSE
               ASSIGN
                  vNum = vNum + "1"
                  vBrn = vBrn + "1"
                  .
            RUN SetSysConf IN h_base
               (
                 INPUT "opreq:" + vNum
               , INPUT ENTRY(3, kau-entry.kau)
               ) .
            {additem.i mDelSysConf vNum}
            RUN SetSysConf IN h_base
               (
                 INPUT "opreq:" + vBrn
               , INPUT ENTRY(4, kau-entry.kau)
               ) .
            {additem.i mDelSysConf vBrn}
         END.
      &ELSE
      FOR EACH kau-entry
            OF op
         WHERE NUM-ENTRIES(kau-entry.kau) GE 4
      NO-LOCK
      :
         RUN SetSysConf IN h_base
            (
              INPUT "opreq:xtab-no"
            , INPUT ENTRY(3, kau-entry.kau)
            ) .
         {additem.i mDelSysConf 'xtab-no'}
         RUN SetSysConf IN h_base
            (
              INPUT "opreq:xbranch-id"
            , INPUT ENTRY(4, kau-entry.kau)
            ) .
         {additem.i mDelSysConf 'xbranch-id'}
         LEAVE.
      END.
      &ENDIF
   END.

   RETURN.
END PROCEDURE. /* Src2SysConf */

PROCEDURE CheckBranch PRIVATE:
   DEFINE INPUT PARAMETER iBranch AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vStrBranch AS CHARACTER NO-UNDO. /* ᯨ᮪ ���ࠧ������� */

   /* IF shMode THEN */
   DO:
      RUN GetBranchChild
         (
           INPUT        shFilial
         , INPUT-OUTPUT vStrBranch
         ) .
/* PIR      IF NOT CAN-DO(vStrBranch, iBranch) THEN
         RETURN "�� �ࠢ��쭮 㪠���� ���ࠧ�������.". */
   END.

   RETURN.
END PROCEDURE. /* CheckBranch */

PROCEDURE CheckEmployee PRIVATE:
   DEFINE INPUT PARAMETER iEmpl AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vAnsw AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vEmpl AS INT64   NO-UNDO.

   DEFINE BUFFER employee FOR employee.

   vEmpl = INT64(iEmpl) NO-ERROR.
   IF ERROR-STATUS:ERROR OR
      vEmpl EQ ?
   THEN
      RETURN "��� ���㤭��� � ⠪�� ⠡���� ����஬.".

   IF CAN-FIND(FIRST employee NO-LOCK
               WHERE employee.filial-id EQ shFilial
                 AND employee.tab-no    EQ vEmpl)
   THEN DO:
      IF vEmpl EQ 0 THEN
      DO:
         vAnsw = NO.
         MESSAGE '��࠭ ��� � ⠡���� ����஬ "0".' SKIP
                 '�� 㢥७� � �ࠢ��쭮�� �롮� ���ਠ�쭮 �⢥��⢥����� ���?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE vAnsw.
         IF NOT vAnsw THEN
            RETURN "�訡��� �롮� ���㤭���.".
      END.
   END.
   ELSE DO:
      IF shMode THEN
         RETURN "� ������ 䨫���� ��� ⠪��� ���㤭���.".
      ELSE
         RETURN "��� ⠪��� ���㤭���.".
   END.

   RETURN.
END PROCEDURE. /* CheckEmployee */

PROCEDURE ResetError:
   DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.

   vStr = "" NO-ERROR.

   RETURN ?.
END PROCEDURE. /* ResetError */

/*   Filename: a-op.trg  --  E n d */
