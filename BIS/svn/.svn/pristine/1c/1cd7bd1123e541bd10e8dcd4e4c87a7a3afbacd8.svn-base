/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2012 ЗАО "Банковские информационные системы"
     Filename: PP-SMEV.P
      Comment: Обмен со СМЭВ
   Parameters:
      Created: 17.01.2013 12:43 Vasov   
     Modified: 17.01.2013 12:43 Vasov   
*/

{globals.i}             /* Глобальные переменные сессии. */
{intrface.get tmess}
{intrface.get exch}
{intrface.get pack}
{intrface.get strng}
{intrface.get rfrnc}

{exchange.equ}

&GLOBAL-DEFINE NO-BASE-PROC    YES
&GLOBAL-DEFINE VERSION_NUM    "1.15.0"
&GLOBAL-DEFINE PURPOSE_VALUES "ТП,ЗД,ТР,PC,ОТ,АП,АР,КВ,0"
&GLOBAL-DEFINE STATUS_VALUES  "01,02,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20"
&GLOBAL-DEFINE KPP_LEN         9
&GLOBAL-DEFINE OKATO_LEN       10

{smev-payt-req.i}

PROCEDURE SMEVPaymentExportSet.
   DEFINE INPUT  PARAMETER iClass AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER hIns   AS HANDLE      NO-UNDO.

   DEFINE VARIABLE hExch     AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hFilter   AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hQry      AS HANDLE      NO-UNDO.
   DEFINE VARIABLE vSeanceID AS INT64       NO-UNDO.
   DEFINE VARIABLE vPacketID AS INT64       NO-UNDO.
   DEFINE VARIABLE vUpdOK    AS LOGICAL     NO-UNDO.

   DEFINE VARIABLE vFlagSet AS LOGICAL     NO-UNDO    INIT ?.

   DEFINE BUFFER Seance    FOR Seance.
   DEFINE BUFFER mail-user FOR mail-user.

MAIN:
DO ON ERROR UNDO MAIN, RETRY MAIN:
   {do-retry.i MAIN}

   ASSIGN
      hExch       = hIns:DEFAULT-BUFFER-HANDLE
      vSeanceID   = hExch::SeanceID
      hFilter     = WIDGET-HANDLE(hExch::FilterTable)
      hFilter     = hFilter:DEFAULT-BUFFER-HANDLE.

   IF hExch::FilterResults EQ 0 THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "-1", "Не выбрано ни одного документа для экспорта.").
      UNDO MAIN, RETRY MAIN.
   END.
   
   FIND FIRST Seance WHERE Seance.SeanceID EQ vSeanceID NO-LOCK NO-ERROR.
   FIND FIRST mail-user WHERE mail-user.op-kind-exp EQ Seance.op-kind
                          AND ((NOT shMode) OR
                               (shMode AND mail-user.filial-id EQ shFilial))
      NO-LOCK NO-ERROR. {&ON-ERROR}
   hExch::mail-user-num = mail-user.mail-user-num.

   &IF DEFINED (IS-DEBUG) &THEN
      RUN dbgprint.p ("SMEVPaymentExportSet","mail-user-num:" + GetNullInt(hExch::mail-user-num)).    
   &ENDIF

   CREATE QUERY hQry.
   hQry:ADD-BUFFER(hFilter).
   hQry:QUERY-PREPARE("FOR EACH FilterTable NO-LOCK").
   hQry:QUERY-OPEN().
   hQry:GET-FIRST().
   DO WHILE NOT hQry:QUERY-OFF-END :
      RUN InstanceCreate IN h_exch (?, hExch).
      hExch::op = hFilter:BUFFER-FIELD("op"):BUFFER-VALUE.
      RUN SMEVPaymentUpdate(hExch, OUTPUT vUpdOK).
      IF vUpdOK THEN DO:
         RUN PacketCreate IN h_pack (hExch::SeanceID,
                                     -1,
                                     hExch::mail-user-num,
                                     hExch:NAME,
                                     OUTPUT vPacketID).
         hExch::PacketID = vPacketID.
         RUN SMEVPacketCreate (hExch).
      END.
      ELSE
         RUN Fill-SysMes IN h_tmess ("", "", "", "Документ пропущен").
      hQry:GET-NEXT().
   END.
   hQry:QUERY-CLOSE().
   IF VALID-HANDLE(hQry) THEN
      DELETE OBJECT hQry.

   vFlagSet = YES.
END.

{doreturn.i vFlagSet}
END PROCEDURE.

PROCEDURE SMEVPaymentUpdate.
   DEFINE INPUT  PARAMETER hExch   AS HANDLE      NO-UNDO.
   DEFINE OUTPUT PARAMETER oOK     AS LOGICAL     NO-UNDO      INIT YES.

   DEFINE VARIABLE vFlagSet   AS LOGICAL     NO-UNDO    INIT ?.

   DEFINE BUFFER op         FOR op.
   DEFINE BUFFER PackObject FOR PackObject.

MAIN:
DO ON ERROR UNDO MAIN, RETRY MAIN:
   {do-retry.i MAIN}

   RUN EmptyReqDS.

   FIND FIRST op WHERE op.op EQ hExch::op NO-LOCK NO-ERROR.
   FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
   FIND FIRST op-bank  OF op NO-LOCK NO-ERROR.

   CREATE ttImportData.
   ASSIGN
      ttImportData.fRef = "1".

   CREATE ttImportRequest.
   ASSIGN
      ttImportRequest.fRef    = "1".

   CREATE ttPostBlock.
   ASSIGN
      ttPostBlock.fRef        = "1"
      ttPostBlock.fID         = GUID(GENERATE-UUID)
      ttPostBlock.fTimeStamp  = NOW
      ttPostBlock.fSenderId   = hExch::SendID
      .

   CREATE ttFinalPayment.
   ASSIGN
      ttFinalPayment.fRef           = "1"
      ttFinalPayment.fNarrative     = replace(op.details, CHR(10) , " " )
      ttFinalPayment.fAmount        = INT64 (op-entry.amt-rub * 100)
      ttFinalPayment.fPaymentDate   = op.op-date
      ttFinalPayment.fVersion       = {&VERSION_NUM}
      ttFinalPayment.fChangeStatus  = hExch::ChangeStatus
      ttFinalPayment.fPayeeINN      = op.inn
      .
      ttFinalPayment.fSupplBillID   = GetXattrValueEx("op", STRING(op.op), "УИН", "").
      ttFinalPayment.fApplicationID = GetXattrValueEx("op", STRING(op.op), "УИЗ", "").
      ttFinalPayment.fPayerID       = GetXattrValueEx("op", STRING(op.op), "ЕИП", "").
      IF NOT {assigned ttFinalPayment.fPayerID} THEN
         ttFinalPayment.fPayerID    = GetXattrValueEx("op", STRING(op.op), "АИП", "0").
      ttFinalPayment.fPayeeKPP      = GetXattrValueEx("op", STRING(op.op), "KPP-rec", "").
      ttFinalPayment.fKBK           = GetXattrValueEx("op", STRING(op.op), "КБК", "").
      ttFinalPayment.fOKATO         = GetXattrvalueEx("op", STRING(op.op), "ОКАТО-НАЛОГ", "").

   IF NOT {assigned ttFinalPayment.fSupplBillID} THEN
      ttFinalPayment.fSupplBillID = "0".

   {find-act.i
      &acct = op-entry.acct-db }
   IF acct.cust-cat NE "В" AND 
      NOT CAN-DO(fGetSetting("НазнСчМБР", "", ""), acct.contract) THEN
      ttFinalPayment.fPayerPA = DelFilFromAcct(acct.acct).

   CREATE ttBudgetIndex.
   ASSIGN
      ttBudgetIndex.fRef          = "1".
      ttBudgetIndex.fStatus       = GetXAttrValueEx("op", STRING(op.op), "ПокСт", "").
      ttBudgetIndex.fPaymentType  = GetXAttrValueEx("op", STRING(op.op), "ПокТП", "").
      ttBudgetIndex.fPurpose      = GetXAttrValueEx("op", STRING(op.op), "ПокОП", "").
      ttBudgetIndex.fTaxPeriod    = GetXAttrValueEx("op", STRING(op.op), "ПокНП", "").
      ttBudgetIndex.fTaxDocNumber = GetXAttrValueEx("op", STRING(op.op), "ПокНД", "").
      ttBudgetIndex.fTaxDocDate   = GetXAttrValueEx("op", STRING(op.op), "ПокДД", "").

   CREATE ttPaymentIdentData.
   ASSIGN
      ttPaymentIdentData.fRef       = "1".
      ttPaymentIdentData.fSystemId  = GetXattrValueEx("op", STRING(op.op), "УИП", "").

   CREATE ttBank.
   ASSIGN
      ttBank.fRef    = "1".
      ttBank.fBIK    = fGetSetting("БанкМФО", "", "").

   CREATE ttPayeeBankAcc.
   ASSIGN
      ttPayeeBankAcc.fRef     = "1"
      ttPayeeBankAcc.fAccount = op.ben-acct.

   CREATE ttPayeeBank.
   ASSIGN
      ttPayeeBank.fRef     = "1"
      ttPayeeBank.fBIK     = op-bank.bank-code.

   /* Проверки */
   FIND FIRST PackObject WHERE PackObject.file-name EQ "op"
                           AND PackObject.surrogate EQ STRING(op.op)
                           AND PackObject.Kind      EQ "SMEV-PTI"
      NO-LOCK NO-ERROR.

   IF hExch::ChangeStatus EQ "1" AND AVAIL PackObject THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Документ " + op.doc-num + ": " +
                                               "Для документа уже экспортировано первичное сообщение для СМЭВ. " +
                                               "Повторный экспорт первичного сообщения невозможен.").
      oOK = NO.
   END.

   IF hExch::ChangeStatus EQ "2" AND NOT AVAIL PackObject THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Документ " + op.doc-num + ": " +
                                               "Для документа не было экспортировано первичное сообщение. " + 
                                               "Экспорт корректирующего сообщения невозможен.").
      oOK = NO.
   END.

   IF LENGTH(ttFinalPayment.fPayeeKPP) NE {&KPP_LEN} THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Документ " + op.doc-num + ": " +
                                               "Длина элемента payeeKPP не равна " + STRING({&KPP_LEN})).
      oOK = NO.
   END.
   IF LENGTH(ttFinalPayment.fOKATO) < {&OKATO_LEN} THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Документ " + op.doc-num + ": " +
                                               "Длина элемента OKATO больше " + STRING({&OKATO_LEN})).
      oOK = NO.
   END.

   IF NOT {assigned ttFinalPayment.fNarrative} THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Документ " + op.doc-num + ": " +
                                               "Не заполнен обязательный элемент Narrative (назначение платежа)").
      oOK = NO.
   END.

   vFlagSet = YES.
END.

&IF DEFINED (IS-DEBUG) &THEN
   DATASET dsReq:WRITE-XML("FILE", "smev-req.xml", NO, "utf-8").
&ENDIF

{doreturn.i vFlagSet}
END PROCEDURE.
 

PROCEDURE EmptyReqDs.

   {empty ttImportData}
   {empty ttImportRequest}
   {empty ttPostBlock}
   {empty ttFinalPayment}
   {empty ttBudgetIndex}
   {empty ttPaymentIdentData}
   {empty ttBank}

END PROCEDURE.

PROCEDURE SMEVPacketCreate.
   DEFINE INPUT  PARAMETER hExch AS HANDLE      NO-UNDO.

   DEFINE VARIABLE vFlagSet  AS LOGICAL     NO-UNDO    INIT ?.
   DEFINE VARIABLE vPacketID AS INT64       NO-UNDO.
   DEFINE VARIABLE vReqTxt   AS LONGCHAR    NO-UNDO.
   DEFINE VARIABLE vReqStr   AS CHARACTER   NO-UNDO.

   DEFINE VARIABLE vI        AS INT64       NO-UNDO.
   DEFINE VARIABLE hBuff     AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hFld      AS HANDLE      NO-UNDO.

MAIN:
DO ON ERROR UNDO MAIN, RETRY MAIN:
   {do-retry.i MAIN}

   vPacketID = hExch::PacketID.
   hExch::SendREF = "UNIFO" + STRING(vPacketID,"999999999999").

   DO vI = 1 TO DATASET dsReq:NUM-BUFFERS :
      hBuff = DATASET dsReq:GET-BUFFER-HANDLE(vI).
      hFld  = hBuff:BUFFER-FIELD("fRef") NO-ERROR.
      IF VALID-HANDLE(hFld) THEN
         hFld:BUFFER-VALUE = hExch::SendREF.
   END.

   DATASET dsReq:WRITE-XML("LONGCHAR", vReqTxt, YES, "ibm866").

   RUN SMEVForceOrder   (INPUT-OUTPUT vReqTxt).
   RUN SMEVDelEmptyTags (INPUT-OUTPUT vReqTxt).

   vReqTxt = REPLACE(vReqTxt, "ibm866", "utf-8").
   vReqStr = STRING(vReqTxt).
   RUN PacketTextSave (vPacketID, vReqStr).

   RUN PacketCreateLink(vPacketID, "op", STRING(hExch::op), 
                        IF hExch::ChangeStatus EQ "1"
                        THEN "SMEV-PTI"
                        ELSE "SMEV-PTC").

   RUN PacketCreateRef(hExch::SeanceDate,
                       vPacketID,
                       "RSMEVPayment",
                       hExch::SendREF).

   vFlagSet = YES.
END.

{doreturn.i vFlagSet}
END PROCEDURE.

PROCEDURE SMEVPacketExportTxt.
   DEFINE INPUT  PARAMETER iPacketID AS INT64       NO-UNDO.
   DEFINE INPUT  PARAMETER iFilePath AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCodePage AS CHARACTER   NO-UNDO.

   DEFINE VARIABLE vFlagSet  AS LOGICAL     NO-UNDO    INIT ?.
   DEFINE VARIABLE vReqStr   AS LONGCHAR    NO-UNDO.
   DEFINE VARIABLE vKeepMode AS CHARACTER   NO-UNDO.

MAIN:
DO ON ERROR UNDO MAIN, RETRY MAIN:
   {do-retry.i MAIN}

   vKeepMode = TRNSettingValue ("", "XMLKeepMode", "FILE").

   FOR FIRST PacketText WHERE PacketText.PacketID EQ iPacketID NO-LOCK:
      vReqStr = PacketText.Contents.
      IF vKeepMode EQ "FILE" THEN
         COPY-LOB FROM vReqStr TO FILE iFilePath CONVERT TARGET CODEPAGE "utf-8".
   END.

   vFlagSet = YES.
END.

{doreturn.i vFlagSet}
END PROCEDURE.


PROCEDURE SMEVForceOrder.
   DEFINE INPUT-OUTPUT PARAMETER ioTxt AS LONGCHAR   NO-UNDO.

   DEFINE VARIABLE hDoc   AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hRoot  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIData AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIReq  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hFPay  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hBIdx  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hPyId  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIns1  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hPIDt  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hSyId  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hBank  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIns2  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIns3  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hPyIdB AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hPBAc  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hChSt  AS HANDLE      NO-UNDO.
   DEFINE VARIABLE hIns4  AS HANDLE      NO-UNDO.

   CREATE WIDGET-POOL "XDOC".
   CREATE X-DOCUMENT hDoc IN WIDGET-POOL "XDOC" .
   hDoc:LOAD("LONGCHAR", ioTxt, NO).
   CREATE X-NODEREF hRoot IN WIDGET-POOL "XDOC".
   hDoc:GET-DOCUMENT-ELEMENT(hRoot).

   CREATE X-NODEREF hIData IN WIDGET-POOL "XDOC".
   RUN GetChildByName(hRoot, "ImportData", INPUT-OUTPUT hIData).
   CREATE X-NODEREF hIReq IN WIDGET-POOL "XDOC".
   RUN GetChildByName(hIData, "ImportRequest", INPUT-OUTPUT hIReq).
   CREATE X-NODEREF hFPay IN WIDGET-POOL "XDOC".
   RUN GetChildByName(hIReq, "FinalPayment", INPUT-OUTPUT hFPay).
   CREATE X-NODEREF hBIdx IN WIDGET-POOL "XDOC".
   RUN GetChildByName(hFPay, "BudgetIndex", INPUT-OUTPUT hBIdx).
   CREATE X-NODEREF hIns1 IN WIDGET-POOL "XDOC".
   hFPay:GET-CHILD(hIns1, hBIdx:CHILD-NUM + 1).
   CREATE X-NODEREF hPyId IN WIDGET-POOL "XDOC".
   RUN GetChildByName(hFPay, "PayerIdentifier", INPUT-OUTPUT hPyId).

   hFPay:REMOVE-CHILD(hBIdx).
   hFPay:REMOVE-CHILD(hIns1).
   hFPay:INSERT-BEFORE(hBIdx, hPyId).
   hFPay:INSERT-BEFORE(hIns1, hPyId).

   CREATE X-NODEREF hPyIdB IN WIDGET-POOL "XDOC".
   hFPay:GET-CHILD(hPyIdB, hPyId:CHILD-NUM - 1).

   CREATE X-NODEREF hPIDt IN WIDGET-POOL "XDOC".
   RUN GetChildByName (hFPay, "PaymentIdentificationData", INPUT-OUTPUT hPIDt).
   CREATE X-NODEREF hIns2 IN WIDGET-POOL "XDOC".
   hFPay:GET-CHILD(hIns2, hPIDt:CHILD-NUM - 1).

   hFPay:REMOVE-CHILD(hIns2).
   hFPay:REMOVE-CHILD(hPIDt).
   hFPay:INSERT-BEFORE(hIns2, hPyIdB). 
   hFPay:INSERT-BEFORE(hPIDt, hPyIdB).

   CREATE X-NODEREF hSyId IN WIDGET-POOL "XDOC".
   hPIDt:GET-CHILD(hSyId, 1).
   CREATE X-NODEREF hBank IN WIDGET-POOL "XDOC".
   RUN GetChildByName (hPIDt, "Bank", INPUT-OUTPUT hBank).
   CREATE X-NODEREF hIns3 IN WIDGET-POOL "XDOC".
   hPIDt:GET-CHILD(hIns3, hBank:CHILD-NUM - 1).

   hPIDt:REMOVE-CHILD(hIns3).
   hPIDt:REMOVE-CHILD(hBank).
   hPIDt:INSERT-BEFORE(hIns3, hSyId).
   hPIDt:INSERT-BEFORE(hBank, hSyId).
   
   CREATE X-NODEREF hPBAc IN WIDGET-POOL "XDOC".
   RUN GetChildByName (hFPay, "PayeeBankAcc", INPUT-OUTPUT hPBAc).
   CREATE X-NODEREF hChSt IN WIDGET-POOL "XDOC".
   RUN GetChildByName (hFPay, "ChangeStatus", INPUT-OUTPUT hChSt).
   hFPay:GET-CHILD(hIns1, hChSt:CHILD-NUM - 1).
   CREATE X-NODEREF hIns4 IN WIDGET-POOL "XDOC".
   hFPay:GET-CHILD(hIns4, hPBAc:CHILD-NUM - 1).

   hFPay:REMOVE-CHILD(hPBAc).
   hFPay:REMOVE-CHILD(hIns4).
   hFPay:INSERT-BEFORE(hIns4, hIns1).
   hFPay:INSERT-BEFORE(hPBAc, hIns1).

   hDoc:SAVE("LONGCHAR", ioTxt).

   DELETE WIDGET-POOL "XDOC".

END PROCEDURE.

PROCEDURE GetChildByName.
   DEFINE INPUT         PARAMETER hNode  AS HANDLE      NO-UNDO.
   DEFINE INPUT         PARAMETER iName  AS CHARACTER   NO-UNDO.
   DEFINE INPUT-OUTPUT  PARAMETER hChild AS HANDLE      NO-UNDO.

   DEFINE VARIABLE vI AS INT64       NO-UNDO.

   DO vI = 1 TO hNode:NUM-CHILDREN:
      hNode:GET-CHILD(hChild, vI).
      IF hChild:SUBTYPE EQ "ELEMENT" AND hChild:NAME EQ iName THEN
         LEAVE.
   END.

END PROCEDURE.

PROCEDURE SMEVDelEmptyTags.
   DEFINE INPUT-OUTPUT PARAMETER ioTxt AS LONGCHAR NO-UNDO.

   DEFINE VARIABLE vPos       AS INT64       NO-UNDO.
   DEFINE VARIABLE vTagStart  AS INT64       NO-UNDO.
   DEFINE VARIABLE vTagEnd    AS INT64       NO-UNDO.
   DEFINE VARIABLE vTag       AS CHARACTER   NO-UNDO.

   vPos = 1.
   DO WHILE vPos LE LENGTH(ioTxt):
      IF SUBSTR(ioTxt,vPos,1) EQ "<" THEN
         vTagStart = vPos.
      IF SUBSTR(ioTxt,vPos,1) EQ ">" THEN DO:
         vTagEnd = vPos.
         IF SUBSTR(ioTxt,vPos - 1, 2) EQ "/>" THEN DO:
            vTagStart = R-INDEX(ioTxt, "~n", vTagStart).
            vTagStart = IF vTagStart EQ 0 
                        THEN 1
                        ELSE vTagStart + 1.
            vTag  = SUBSTR(ioTxt, vTagStart, vTagEnd - vTagStart + 1) + "~n".
            ioTxt = REPLACE (ioTxt, vTag, "").
            vPos  = vTagStart - 1.
         END.
      END.
      vPos = vPos + 1.
   END.

END PROCEDURE.
