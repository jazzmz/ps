/****************************************
 *
 * Отчет по транзакциям пластиковых карт.
 *
 *****************************************
 *
 * Автор : Маслов Д. А. Maslov D. A.
 * Создан: 15.08.12
 * Заявка: #1233
 *
 *****************************************/

{globals.i}

DEF VAR oAArray  AS TAArray NO-UNDO.
DEF VAR dResult  AS DEC     NO-UNDO.
DEF VAR i        AS INT     NO-UNDO.

DEF VAR dBegDate AS DATE    NO-UNDO.
DEF VAR dEndDate AS DATE    NO-UNDO.

{getdates.i}

dBegDate = beg-date.
dEndDate = end-date.

DEF TEMP-TABLE tblResult
              FIELD cOperation AS CHAR
              FIELD dKom       AS DEC
             .

FOR EACH pc-trans WHERE CAN-DO("TransCard,TransCommis,TransDispute,TransSummary,TransAcquiring,MBCard,OST24Card,PSBCard,UCSCard,KOMPASPlus,OST24Commis,KPCommis,OST24Dispute,OST24Summary,ExpoAcq,UCSAcq,pc-trans",pc-trans.class-code) 
                     AND pc-trans.card_aff EQ 'Наша' 
                     AND pc-trans.cont-date >= dBegDate AND pc-trans.cont-date <= dEndDate 
                     AND pc-trans.eq_aff EQ 'Наше' 
                     AND pc-trans.pctr-code BEGINS 'СнятиеНал' 
                    NO-LOCK:

oAArray = NEW TAArray().

  FOR EACH pc-trans-amt OF pc-trans NO-LOCK:
      oAArray:setH(pc-trans-amt.amt-code,pc-trans-amt.amt-cur).
  END.
dResult = ROUND(DEC(oAArray:get("КМССЧ")) / DEC(oAArray:get("СУМСЧ")),2).
CREATE tblResult.
 ASSIGN
        tblResult.cOperation = num-card
        tblResult.dKom       = dResult
  .
DELETE OBJECT oAArray.
END.

{setdest.i}
FOR EACH tblResult BY tblResult.dKom:
 i = i + 1.
 PUT UNFORMATTED i "|" tblResult.cOperation "|" tblResult.dKom SKIP.

END.
{preview.i}