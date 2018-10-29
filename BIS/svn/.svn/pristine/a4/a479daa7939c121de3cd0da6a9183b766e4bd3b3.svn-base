{globals.i}           /** Глобальные определения */
{intrface.get tmess}  /** Служба системных сообщений */
{ulib.i}

DEFINE VARIABLE cDoc   AS CHARACTER
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cDNazn AS CHARACTER
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cLine1 AS CHARACTER
   INIT  "─────────────────────────────────────────────────────────────────"
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPlat  AS CHARACTER LABEL "Плательщик"
   FORMAT "x(53)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPrPl  AS CHARACTER
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPList AS CHARACTER LABEL "Подписал"
   FORMAT "x(50)" NO-UNDO VIEW-AS COMBO-BOX
   LIST-ITEM-PAIRS "","" INNER-LINES 3.
DEFINE VARIABLE cLine2 AS CHARACTER
   INIT  "─────────────────────────────────────────────────────────────────"
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPolu  AS CHARACTER LABEL "Получатель"
   FORMAT "x(53)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPrPo  AS CHARACTER LABEL "Представитель получателя"
   FORMAT "x(39)" NO-UNDO VIEW-AS TEXT.
DEFINE VARIABLE cPList2 AS CHARACTER LABEL "Подписал"
   FORMAT "x(50)" NO-UNDO VIEW-AS COMBO-BOX
   LIST-ITEM-PAIRS "","" INNER-LINES 3.
DEFINE VARIABLE cLine3 AS CHARACTER
   INIT  "─────────────────────────────────────────────────────────────────"
   FORMAT "x(65)" NO-UNDO VIEW-AS TEXT.
/*DEFINE VARIABLE cPrPoN AS CHARACTER LABEL "        "
   FORMAT "x(50)" NO-UNDO VIEW-AS COMBO-BOX
   LIST-ITEM-PAIRS "","" INNER-LINES 3.
*/
DEFINE VARIABLE iJ      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPrPlN  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrPl   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPrPoN  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrPo   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cClMask AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDRAcct AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMaskFl AS CHARACTER INIT "Право_дов_подписи"                               NO-UNDO.
DEFINE VARIABLE cMaskUl AS CHARACTER INIT "Директор,Право_первой_подписи,Право_дов_подписи,Управляющая_комп" NO-UNDO.
DEFINE VARIABLE cMaskPo AS CHARACTER INIT "Директор,Управляющая_комп,Право_первой_подписи"                                     NO-UNDO.
cMaskUl = FGetSetting('PirClMask','',?).
DEFINE FRAME fPredst
   cDoc     NO-LABEL SKIP
   cDNazn   NO-LABEL SKIP
   cLine1   NO-LABEL SKIP
   cPlat    SKIP
   cPrPl    NO-LABEL SKIP
   cPList   SKIP
   cLine2   NO-LABEL SKIP
   cPolu    SKIP
   cPrPo    NO-LABEL SKIP
   cPList2  SKIP
   cLine3   NO-LABEL SKIP
/*   cPrPoN   SKIP*/
   WITH SIDE-LABELS CENTERED OVERLAY
        AT COL 5 ROW 5
        TITLE " Выбор представителей плательщика/получателя "
        SIZE 67 BY 12.

cDoc   = " Документ N " + op.doc-num + " от " + STRING(op.op-date, "99.99.9999")
       + " на сумму " + TRIM(STRING(dAmt, ">>>,>>>,>>>,>>9.99")) + cCur.
cDNazn = " " + op.details.
cDNazn = IF (LENGTH(cDNazn) LE 65) THEN cDNazn ELSE (STRING(cDNazn, "x(62)") + "...").

iJ = cPList:NUM-ITEMS.
DO iI = 1 TO iJ:
   cPList:DELETE(1).
/*   cPList:DELETE(cPList:SCREEN-VALUE) IN FRAME fPredst. */
END.

iJ = cPList2:NUM-ITEMS.
DO iI = 1 TO iJ:
   cPList2:DELETE(1).
/*   cPList:DELETE(cPList:SCREEN-VALUE) IN FRAME fPredst. */
END.

IF lPr[1]
THEN DO:

   FIND acct
      WHERE (acct.acct EQ cPrAcct[1])
/* AND raschetnyj ? */
      NO-LOCK NO-ERROR.

   IF AVAIL acct
   THEN DO:
      cPlat  = GetAcctClientName_UAL(cPrAcct[1], NO).

      IF (acct.cust-cat EQ "Ч")
      THEN DO:
         cFile   = "person".
         cClMask = cMaskFl.
      END.
      ELSE DO:
         cFile   = "cust-corp".

         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ acct.cust-id)
            NO-LOCK NO-ERROR.

         IF    (cust-corp.cust-stat EQ "ИП")
            OR (cust-corp.cust-stat EQ "Адвокат")
            OR (cust-corp.cust-stat EQ "Нотариус")
         THEN cClMask = cMaskFl.
         ELSE cClMask = cMaskUl.
      END.

      IF (cClMask EQ cMaskFl)
      THEN DO:
         cPrPl  = "Правом доверенной подписи обладают: ".
         cPList:ADD-LAST("Владелец счета", "0").
/*
         cPList:SCREEN-VALUE = "0".
         APPLY "value-changed" TO cPList IN FRAME fPredst.
*/
      END.
      ELSE DO:
         cPrPl  = "Правом первой подписи обладают: ".
      END.

      iI = 0.
      FOR EACH cust-role
         WHERE (cust-role.file-name   EQ cFile)
           AND (cust-role.surrogate   EQ STRING(acct.cust-id))
/*           AND (cust-role.cust-cat    EQ "Ч")*/
           AND CAN-DO(cClMask, cust-role.class-code)
           AND (cust-role.open-date   LE op.op-date)
           AND ((cust-role.close-date GE op.op-date)
             OR (cust-role.close-date EQ ?))
         NO-LOCK:
         cDRAcct = GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "acct-list").

         IF    ((cDRAcct EQ "")
            OR (INDEX(cDRAcct, acct.acct) NE 0)) AND (cust-role.cust-name <> "")
         THEN DO:
            cPList:ADD-LAST(cust-role.cust-name, cust-role.cust-cat + "_" + cust-role.cust-id).


/*
            cPList:SCREEN-VALUE = cust-role.cust-cat + "_" + cust-role.cust-id.
            APPLY "value-changed" TO cPList IN FRAME fPredst.
*/

            iI = iI + 1.

 	    iPrPl  = iI.
            cPrPl  = cPrPl + STRING(iI).
         END.
      END.                  

/*      iPrPl  = iI.
      cPrPl  = cPrPl + STRING(iI).*/
/*
      lPr[1] = (iI NE 0).
*/
   END.
   ELSE lPr[1] = NO.
END.

IF lPr[2]
THEN DO:

   FIND acct
      WHERE (acct.acct EQ cPrAcct[2])
      NO-LOCK NO-ERROR.

   IF AVAIL acct
   THEN DO:
      cPolu  = GetAcctClientName_UAL(cPrAcct[2], NO).
      IF (acct.cust-cat EQ "Ч")
      THEN DO:
         cFile   = "person".
         cClMask = cMaskFl.
      END.
      ELSE DO:
         cFile   = "cust-corp".

         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ acct.cust-id)
            NO-LOCK NO-ERROR.

         IF    (cust-corp.cust-stat EQ "ИП")
            OR (cust-corp.cust-stat EQ "Адвокат")
            OR (cust-corp.cust-stat EQ "Нотариус")
         THEN cClMask = cMaskFl.
         ELSE cClMask = cMaskUl.
      END.

      IF (cClMask EQ cMaskFl)
      THEN DO:
         cPrPo  = "Правом доверенной подписи обладают: ".
         cPList2:ADD-LAST("Владелец счета", "0").
      END.
      ELSE DO:
         cPrPo  = "Правом первой подписи обладают: ".
      END.

      iI = 0.
      FOR EACH cust-role
         WHERE (cust-role.file-name   EQ cFile)
           AND (cust-role.surrogate   EQ STRING(acct.cust-id))
           AND CAN-DO(cClMask, cust-role.class-code)
           AND (cust-role.open-date   LE op.op-date)
           AND ((cust-role.close-date GE op.op-date)
             OR (cust-role.close-date EQ ?))
         NO-LOCK:
         cDRAcct = GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "acct-list").

         IF    ((cDRAcct EQ "")
            OR (INDEX(cDRAcct, acct.acct) NE 0)) AND (cust-role.cust-name <> "")
         THEN DO:
            cPList2:ADD-LAST(cust-role.cust-name, cust-role.cust-cat + "_" + cust-role.cust-id).

            iI = iI + 1.

 	    iPrPo  = iI.
            cPrPo  = cPrPo + STRING(iI).
         END.
      END.                  

   END.
   ELSE lPr[2] = NO.
END.

IF (lPr[1] OR lPr[2])
THEN DO:
   IF lPr[1]
   THEN
      ASSIGN
         cPlat:HIDDEN   = NO
         cPrPl:HIDDEN   = NO
         cPList:HIDDEN  = NO
         NO-ERROR.
   ELSE
      ASSIGN
         cPlat:HIDDEN   = YES
         cPrPl:HIDDEN   = YES
         cPList:HIDDEN  = YES
         NO-ERROR.

   IF lPr[2]
   THEN
      ASSIGN
         cPolu:HIDDEN   = NO
         cPrPo:HIDDEN   = NO
         cPList2:HIDDEN  = NO
         NO-ERROR.
   ELSE
      ASSIGN
         cPolu:HIDDEN   = YES
         cPrPo:HIDDEN   = YES
         cPList2:HIDDEN  = YES
         NO-ERROR.

   UPDATE UNLESS-HIDDEN
      cDoc  cDNazn       cLine1
      cPlat cPrPl cPList cLine2
      cPolu cPrPo cPList2 cLine3 cPrPoN
      WITH FRAME fPredst.

   cPrPlN = IF (iPrPl GT 0) THEN cPList:SCREEN-VALUE ELSE "0".
   cPrPoN = IF (iPrPo GT 0) THEN cPList2:SCREEN-VALUE ELSE "0".
   HIDE FRAME fPredst.


   IF     lPr[1]
/*      AND (iPrPl  GT 0) */
/*      AND (cPrPoN NE "0")*/
   THEN cPr-id[1] = REPLACE(cPrPlN, "_", ",").
   ELSE lPr[1]    = NO.

   IF     lPr[2]
   THEN cPr-id[2] = REPLACE(cPrPoN, "_", ",").
   ELSE lPr[2]    = NO.

END.
