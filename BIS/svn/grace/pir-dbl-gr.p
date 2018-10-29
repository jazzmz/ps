/*************************
 *
 * Доп. фильтрация для процедуры погашения
 * по овердрафтам. исключает повторную работу
 * транзакции 
 * Вешается доп. реком на all_flt
 *
 *************************
 *
 * Автор: Красков А.С.
 * Заявка: #2700
 * Дата создания: 15.04.2013
 *
 **************************/
{globals.i}
{svarloan.def}
{loan-def.i}
{pick-val.i}
{flt-file.i} /* Объявление фильтра по договорам */
{l-table.def new}
{sh-defs.i}
{all_note.def} /* Таблица с recid, выбранных по фильтру записей Shared */
{flt_var.def}
{over-def.def} /* описание таблицы over-error */
{loan.pro}     /* DS - Работа с полями таблицы loan. */
{mf-loan.i}

{intrface.get xclass}
{tloan.pro}
{intrface.get loan}
{intrface.get ovl}
{intrface.get op}
{intrface.get bag}
{intrface.get blkob}

DEF INPUT PARAM oprid AS RECID NO-UNDO.

DEF BUFFER bloan-cond for loan-cond.

DEF VAR mTotalRecs  AS INT64     NO-UNDO.
def var bDel as logical NO-UNDO.
/*message "Старт" VIEW-AS ALERT-BOX.*/

FIND LAST all_recids NO-ERROR.
IF NOT AVAIL all_recids THEN
DO:
   {intrface.del tloan}
   {intrface.del loan}
   {intrface.del ovl}
   {intrface.del op}
   RETURN.
END.
ELSE
   mTotalRecs = all_recids.count.

find first flt-template NO-LOCK.

/*message "Старт" flt-template.op-kind VIEW-AS ALERT-BOX.*/

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:

  bDel = false.

  for each loan-int where loan-int.contract   = loan.contract
                       and loan-int.cont-code = loan.cont-code
                       and loan-int.mdate     = svPlanDate 
                       NO-LOCK,
      first op where op.op = loan-int.op
                 and op.op-kind = flt-template.op-kind
     NO-LOCK:
        bDel = true.
/*        message "Повторный запуск по договору " loan.cont-code VIEW-AS ALERT-BOX.*/

  end.

    find last loan-cond where loan-cond.contract   = loan.contract
                          and loan-cond.cont-code  = loan.cont-code
                          and loan-cond.since     <= svPlanDate  
                          NO-LOCK NO-ERROR.


   IF GetXattrValueEx("loan-cond", loan-cond.contract + "," 
                                 + loan-cond.cont-code + "," 
                                 + STRING(loan-cond.since,"99/99/99"), "Грейс","Нет") = "Да" then bDel = true.


  if bDel then DELETE all_recids.

END.

/*Здесь второй проход для грейс-траншей*/

