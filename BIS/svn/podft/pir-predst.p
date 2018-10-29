{pirsavelog.p}

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) �� "�p������������"
     Filename: pir-pfkntrl.p
      Comment: ����� ॥��� ���㬥�⮢ �� ����஫� �����
      Created: 09/11/2010 Borisov
     Modified: 18/11/2012 Goncharov
*/
/******************************************************************************/
{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{wordwrap.def}

/*============================================================================*/
DEFINE VARIABLE lPr     AS LOGICAL   EXTENT 2 NO-UNDO.
DEFINE VARIABLE cPr-id  AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE cPrAcct AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE cKlAcct AS CHARACTER INIT "405*,406*,407*,40802*,40807*,40817*,40820*,40821*,423*,426*" NO-UNDO.
DEFINE VARIABLE cPrDR   AS CHARACTER INIT "�।���⥫�騪�,�।�����⥫�" NO-UNDO.
DEFINE VARIABLE iI      AS INTEGER            NO-UNDO.
DEFINE VARIABLE cCur    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE dAmt    AS DECIMAL            NO-UNDO.

/* ----------------------------------------------------- */
cKlAcct = FGetSetting("pir-predst","","!*"). /* ��뭥 �࠭�� ��� � ����஥筨�� pir-predst */

FOR EACH tmprecid 
   NO-LOCK,
   FIRST op
      WHERE RECID(op) EQ tmprecid.id
   NO-LOCK:

   lPr[1] = NO.
   lPr[2] = NO.

   FOR EACH op-entry OF op
      NO-LOCK:

      IF CAN-DO(cKlAcct, op-entry.acct-db)
         AND NOT lPr[1]
      THEN DO:
         lPr[1] = YES.
         cPrAcct[1] = op-entry.acct-db.
      END.

      IF CAN-DO(cKlAcct, op-entry.acct-cr)
         AND NOT lPr[2]
      THEN DO:
         lPr[2] = YES.
         cPrAcct[2] = op-entry.acct-cr.
      END.
   END.

   FOR FIRST op-entry OF op
      NO-LOCK:

      cCur = op-entry.currency.
      dAmt = IF (cCur EQ "") THEN op-entry.amt-rub ELSE op-entry.amt-cur.
      cCur = IF (cCur EQ "") THEN " RUR" ELSE (IF (cCur EQ "840") THEN " USD" ELSE " EUR").
   END.

   {pir-predst.frm}

   DO iI = 1 TO 2:
      IF lPr[iI]
      THEN do:
      if cPr-id[ii] <> "0" then 
         UpdateSigns("op", STRING(op.op), ENTRY(iI, cPrDR), cPr-id[iI], NO).
        end.     
   END.
END.
