/* PIR: VNE переделано из 47ого патча для печати всей карточки на 1 странице сразу а не на двух как предполагает BIS */

/*{pirsavelog.p}*/


/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: ap-os6.p
      Comment: Инвентарная карточка учета объекта основных средств (форма  N ОС-6)
   Parameters:
         Uses:
      Used by:
      Created: kraw 03.09.2003 (0014563)
     Modified: kraw 10/02/2004 (0014563) В "операциях перемещения и пр." брать дебетовые kau-entry
     Modified: BMS 01/04/2007
     Modified:
*/

{ap-os6.i}

DEF VAR mDatePos   AS DATE    NO-UNDO. /*Дата расчета остатка*/
DEF VAR mDateInA   AS DATE    NO-UNDO. /*Дата первой амортизации*/
DEF VAR mDateInU   AS DATE    NO-UNDO. /*Дата приходования*/
DEF VAR mSumInA    AS DEC     NO-UNDO. /*заглушка*/
DEF VAR mSumInU    AS DEC     NO-UNDO. /*заглушка*/
DEF VAR sLibHandle AS HANDLE  NO-UNDO. /*хендл на библиотеку*/


/*   Внутренние функции   */
FUNCTION KoefPer RETURNS DECIMAL
(iDate AS DATE, iOp AS CHARACTER):

   IF AVAILABLE asset THEN
      DO:
      FIND FIRST instr-rate WHERE
                 instr-rate.instr-cat  = "overcode"
             AND ENTRY(1, instr-rate.instr-code, "/") = asset.commission
             AND instr-rate.since     <= iDate
      NO-LOCK NO-ERROR.

      IF AVAILABLE instr-rate AND NUM-ENTRIES(instr-rate.instr-code, "/") > 1 THEN
         IF NOT CAN-DO(ENTRY(2, instr-rate.instr-code, "/"), iOp) THEN
            RELEASE instr-rate.

      IF NOT AVAILABLE instr-rate THEN
      FOR EACH instr-rate WHERE
               instr-rate.instr-cat = "overcode"
           AND instr-rate.since    >= iDate
         NO-LOCK:

         IF NUM-ENTRIES(instr-rate.instr-code, "/") > 1 THEN

            IF CAN-DO(ENTRY(1, instr-rate.instr-code, "/"),
                      asset.commission
                     ) 
               AND 
               CAN-DO(ENTRY(2, instr-rate.instr-code, "/"), iOp)
            THEN
               RETURN instr-rate.rate-instr.
      END.

      IF AVAILABLE instr-rate THEN
         RETURN instr-rate.rate-instr.
   END.

   RETURN 0.0.
END FUNCTION.

RUN GetLoanDate IN h_umc (loan.contract,
                          loan.cont-code,
                          "-учет",
                          "In",
                          OUTPUT sDatInExpl,
                          OUTPUT vTmpSum
                         ).
RUN GetLoanDate IN h_umc (loan.contract,
                          loan.cont-code,
                          "-учет",
                          "Out",
                          OUTPUT sDatOutBuhg,
                          OUTPUT vTmpSum
                         ).


IF sDatOutBuhg > 05/31/1223 THEN
DO:
   RUN GetAmtUMC IN h_umc (sContract, 
                           sContCode, 
                           sDatOutBuhg, 
                    OUTPUT mAmt, 
                    OUTPUT mQty).

   IF mAmt <> 0 THEN
      sDatOutBuhg = ?.
END.

/* Ищем не передана ли ценность со склада */

/*FIND FIRST kau-entry WHERE kau-entry.kau     = sUMC-Kau 
                       AND kau-entry.op-date = sDatInBuhg
   USE-INDEX op NO-LOCK NO-ERROR.

IF AVAILABLE kau-entry THEN
DO:
   FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
   FOR FIRST op-entry OF op WHERE op-entry.acct-db = acct.acct,
      FIRST bacct WHERE bacct.acct = op-entry.acct-cr
                    AND bacct.contract = "СКЛАД" NO-LOCK:
/* Была передача со склада */
      FIND FIRST kau-entry OF op WHERE kau-entry.kau BEGINS "СКЛАД" 
         NO-LOCK NO-ERROR.
      IF AVAILABLE kau-entry THEN
         sDatInBuhg  = GetLoanDate("СКЛАД", ENTRY(2,kau-entry.kau), "-учет", "In").
   END.
END.
*/

ASSIGN
   sDatInBuhg  = IF (sDatInBuhg  = 01/01/9999) THEN ? ELSE sDatInBuhg
   sDatInExpl  = IF (sDatInExpl  = 01/01/9999) THEN ? ELSE sDatInExpl
   sDatOutBuhg = IF (sDatOutBuhg = 01/01/0001) THEN ? ELSE sDatOutBuhg
.

/* Делаем таблицу операций переоценки */
mI = 0.
FOR EACH kau-entry WHERE
         kau-entry.kau BEGINS loan.contract + "," + loan.cont-code + ","
     AND kau-entry.kau-id   = "УМЦ-пере"
     AND kau-entry.op      <> -1
   NO-LOCK BREAK BY kau-entry.op-date:

   IF FIRST-OF(kau-entry.op-date) THEN
   DO:
      FIND FIRST vPOp WHERE vPOp.op = kau-entry.op NO-ERROR.

      FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
      FIND FIRST op-entry OF op WHERE
         (
             CAN-FIND(FIRST loan-acct OF loan 
                      WHERE loan-acct.acct-type = loan.contract + "-учет" 
                        AND loan-acct.acct      = op-entry.acct-db)
         AND CAN-FIND(FIRST loan-acct OF loan
                      WHERE loan-acct.acct-type = loan.contract + "-пере" 
                        AND loan-acct.acct      = op-entry.acct-cr)
         )
      OR (   CAN-FIND(FIRST loan-acct OF loan
                      WHERE loan-acct.acct-type = loan.contract + "-учет" 
                        AND loan-acct.acct      = op-entry.acct-cr)
         AND CAN-FIND(FIRST loan-acct OF loan
                      WHERE loan-acct.acct-type = loan.contract + "-пере" 
                        AND loan-acct.acct      = op-entry.acct-db)
         )
      NO-LOCK NO-ERROR.

      IF NOT AVAILABLE vPOp AND AVAILABLE op-entry THEN
      DO:
         CREATE sAOsPere.
         CREATE vPOp.
         ASSIGN
            sAOsPere.Numb     = mI / 3
            sAOsPere.ind      = mI MODULO 3
            sAOsPere.doc-date = kau-entry.op-date
            sAOsPere.koef     = KoefPer(sDatInExpl, STRING(kau-entry.op))
            sAOsPere.amt      = GetLoan-pos(sContract, 
                                               sContCode, 
                                               "-учет", 
                                               kau-entry.op-date) 
            vPOp.op           = kau-entry.op
         .
         mI = mI + 1.
      END.
   END.
END.

/* Допишем в хвост пустые, чтобы дополнить до целой строки */

DO mJ = 0 TO mI MODULO 3:
   CREATE sAOsPere.
   ASSIGN
      sAOsPere.Numb     = mI / 3
      sAOsPere.ind      = mI MODULO 3
   .
   mI = mI + 1.
END.
/* -------------------------------- */

/* Делаем таблицу операций приходования, внутр. перемещения, выбытия, списания */
/*      и таблицу операций изменения стоимости */
mI = 0.
FOR EACH kau-entry WHERE
         kau-entry.kau BEGINS loan.contract + "," + loan.cont-code
     AND kau-entry.kau-id   = "УМЦ-учет"
   NO-LOCK BREAK BY kau-entry.op:

   mOpTmp = kau-entry.op.

   IF    kau-entry.debit 
      OR NOT CAN-FIND(FIRST kau-entry WHERE
                            kau-entry.kau BEGINS loan.contract + "," + loan.cont-code
                        AND kau-entry.kau-id   = "УМЦ-учет"
                        AND kau-entry.debit    = YES
                        AND kau-entry.op       = mOpTmp
                        USE-INDEX op
                     ) THEN
   DO:
      FIND FIRST vPOp WHERE vPOp.op = kau-entry.op NO-ERROR.

      IF NOT AVAILABLE vPOp THEN
      DO:
         CREATE sAOsUch.
         CREATE vPOp.
         RUN GetAmtUMC IN h_umc (sContract, 
                                 sContCode, 
                                 IF sDatOutBuhg <> ? AND LAST(kau-entry.op) THEN
                                    sDatOutBuhg - 1
                                 ELSE
                                    kau-entry.op-date, 
                          OUTPUT mAmt, 
                          OUTPUT mQty).

         mDatePos = IF     sDatOutBuhg NE ?
                       AND LAST(kau-entry.op)
                    THEN sDatOutBuhg - 1
                    ELSE kau-entry.op-date.

         RUN GetLoanPos (sContract,
                         sContCode,
                         "-учет",
                         mDatePos,
                         OUTPUT mAmt,
                         OUTPUT mQty
                        ).

         RUN GetLoanDate ( sContract,
                           sContCode,
                           "-учет",
                           "InDate",
                           OUTPUT mDateInU,
                           OUTPUT mSumInU
                         ).
         RUN GetLoanDate ( sContract,
                           sContCode,
                           "-амор",
                           "InDate",
                           OUTPUT mDateInA,
                           OUTPUT mSumInA
                         ).

/* Для начального решения амортизацию не учитываем,
** если первое движение по счету учета и первое движение по счету амортизации
** проведено одной датой. */
         IF     CAN-DO("ОС,НМА", sContract)
            AND mDateInU NE ?
            AND NOT (    NOT CAN-FIND(FIRST op-entry OF kau-entry)
                     AND mDateInU EQ mDateInA
                    ) THEN
            mAmt = mAmt - GetLoan-Pos (sContract,
                                       sContCode,
                                       "-амор",
                                       mDatePos).
         
         FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
         IF AVAILABLE op THEN
            FIND FIRST op-kind  OF op NO-LOCK NO-ERROR.
         FIND FIRST branch WHERE
                    branch.branch-id = ENTRY(4,kau-entry.kau)
            NO-LOCK NO-ERROR.
         sAOsUch.Numb     = mI.
         ASSIGN
            sAOsUch.docNum   = (IF AVAILABLE op THEN op.doc-num ELSE "НР")
            sAOsUch.dateN    = STRING(kau-entry.op-date,"99/99/9999")
                             + ", " + sAOsUch.docNum
            sAOsUch.branch   = branch.name WHEN AVAILABLE branch
            sAOsUch.nTab     = EmplShrtName(INT(ENTRY(3,kau-entry.kau)))
            sAOsUch.tran     = op-kind.name-opkind WHEN AVAILABLE op-kind
            vPOp.op          = kau-entry.op
            sAu              = asset.precious-1
            sAg              = asset.precious-2
            sPt              = asset.precious-3
            sOt              = asset.precious-4
            sAOsUch.isPP     =    mI = 0
                               OR NOT CAN-FIND(FIRST op-entry OF op)
                               OR sDatOutBuhg <> ? AND LAST(kau-entry.op)
            sAOsUch.amt      = IF sAOsUch.isPP THEN mAmt ELSE kau-entry.amt-rub
         .
         mI = mI + 1.
      END.
   END.
END.

/* -------------------------------- */

FIND FIRST kau-entry WHERE
           kau-entry.op-date  = sDatInExpl
       AND kau-entry.kau BEGINS loan.contract + "," + loan.cont-code
       AND kau-entry.debit    = YES
       AND kau-entry.kau-id   = "УМЦ-учет"
   NO-LOCK NO-ERROR.

sDocNumIn = "".

IF AVAILABLE kau-entry THEN
DO:
   IF NOT VALID-HANDLE(sLibHandle) THEN
      RUN a-prn.p PERSISTENT SET sLibHandle .

   RUN SetInRecId IN sLibHandle (RECID(kau-entry)).

   FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.

   IF AVAILABLE op THEN
      sDocNumIn = op.doc-num.
END.

{norm-beg.i &title = "'ГЕНЕРАЦИЯ КАРТОЧКИ УЧЕТА (ЛИЦЕВАЯ СТОРОНА)'" &nodate=yes}

RUN norm-clc.p (in-dataclass-id,    
                "a-os6p",
                in-branch-id,
                TODAY,
                TODAY).

{norm-end.i}

/*RUN ap-os6-1.p.*/

IF VALID-HANDLE(sLibHandle) THEN
   DELETE PROCEDURE (sLibHandle).

{intrface.del}