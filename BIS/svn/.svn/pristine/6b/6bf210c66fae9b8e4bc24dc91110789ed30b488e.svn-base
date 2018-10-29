{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Ведомость операций по договору ТСП.
   Борисов А.В., 30.12.2009
*/

{globals.i}           /* Глобальные определения */
{tmprecid.def}        /* Используем информацию из броузера */

/******************************************* Определение переменных и др. */

DEFINE VARIABLE dSumOp AS DECIMAL  NO-UNDO.
DEFINE VARIABLE dSumU  AS DECIMAL  NO-UNDO.
DEFINE VARIABLE dSum   AS DECIMAL  NO-UNDO.
DEFINE BUFFER   ustr   FOR loan.

/******************************************* Реализация */
{getdates.i}
{setdest.i}
/*
FIND FIRST tmprecid
   NO-ERROR.
FIND FIRST ustr
   WHERE (RECID(ustr) EQ tmprecid.id)
   NO-ERROR.
FIND FIRST loan
   WHERE (loan.contract   EQ "card-acq")
     AND (loan.class-code EQ "card-loan-acqcust")
     AND (ustr.parent-cont-code EQ loan.cont-code)
   NO-ERROR.
FIND FIRST cust-corp
   WHERE (cust-corp.cust-id EQ loan.cust-id)
   NO-ERROR.
*/
FIND FIRST tmprecid
   NO-ERROR.
FIND FIRST loan
   WHERE (RECID(loan) EQ tmprecid.id)
   NO-ERROR.
FIND FIRST cust-corp
   WHERE (cust-corp.cust-id EQ loan.cust-id)
   NO-ERROR.

PUT UNFORMATTED "Ведомость операций по договору  " loan.cont-code SKIP
"(" cust-corp.cust-stat " " + cust-corp.name-corp ")" SKIP
" за период с " STRING(beg-date, "99.99.9999") " по " STRING(end-date, "99.99.9999") SKIP(1)
"|   Дата   | Устройство |     Сумма     |Тип транзакции|" SKIP
"|----------|------------|---------------|--------------|" SKIP.
/*
FOR EACH tmprecid
   NO-LOCK,
   FIRST ustr
      WHERE (RECID(ustr) EQ tmprecid.id)
*/
FOR EACH ustr
   WHERE (ustr.contract   EQ "card-equip")
     AND (ustr.class-code EQ "card-equip")
     AND (ustr.parent-cont-code EQ loan.cont-code)
   NO-LOCK,
EACH pc-trans
   WHERE CAN-DO("TransAcquiring,UCSAcq,UCSCard", pc-trans.class-code)
     AND (pc-trans.sur-equip   EQ "card-equip," + ustr.cont-code)
     AND (pc-trans.pctr-status EQ "ОБР")
     AND (pc-trans.cont-date   GE beg-date)
     AND (pc-trans.cont-date   LE end-date)
   NO-LOCK,
FIRST pc-trans-amt
   WHERE (pc-trans-amt.pctr-id  EQ pc-trans.pctr-id)
     AND (pc-trans-amt.amt-code EQ "СУМТ")
   NO-LOCK
   BY ustr.cont-code BY pc-trans.cont-date:

   dSumOp = IF pc-trans.dir THEN pc-trans-amt.amt-cur ELSE (- pc-trans-amt.amt-cur).
   dSumU  = dSumU + dSumOp.
   dSum   = dSum  + dSumOp.

   PUT UNFORMATTED
      "|" STRING(pc-trans.cont-date, "99.99.9999")
      "| " ustr.doc-num FORMAT "x(11)"
      "|" STRING(dSumOp, "->>>,>>>,>>9.99")
      "|" IF pc-trans.dir THEN " Оплата       " ELSE " ВозвратОпл   "
      "|" SKIP.

END.

PUT UNFORMATTED
   "|======================================================|" SKIP
   "| ИТОГО:                 "
      STRING(dSum, "->>>,>>>,>>9.99")
   "               |" SKIP(1).

{preview.i}
{intrface.del}
