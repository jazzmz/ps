/*************************
 *
 * Доп. фильтрация для процедуры начисления процентов по договорам 
 * Ожидается что не будет начисленно процентов по договорам 
 * с плановой датой в том же месяце что и начисление
 * Вешается доп. реком на all_flt
 *
 *************************
 *
 * Автор: Красков А.С.
 * Заявка: #4036
 * Дата создания: 23.10.2013
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

DEF INPUT PARAM oprid AS RECID NO-UNDO.

DEF VAR mTotalRecs  AS INT64 NO-UNDO. 
def var bDel as logical NO-UNDO.

def var DateFromCond as DATE NO-UNDO.

FIND LAST all_recids NO-ERROR.
IF NOT AVAIL all_recids THEN
DO:
   RETURN.
END.
ELSE
   mTotalRecs = all_recids.count.

find first flt-template NO-LOCK.

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:

  bDel = false.

  find first term-obl WHERE term-obl.cont-code = loan.cont-code 
                        and term-obl.contract  = loan.contract
                        and term-obl.idnt      = 1
                        and term-obl.end-date >= svPlanDate
                        NO-LOCK NO-ERROR.
  if available term-obl then do:
  if month(svPlanDate) = month(term-obl.end-date)
      then DELETE all_recids.
  end.
  else 
  find last loan-cond where loan-cond.cont-code = loan.cont-code
                        and loan-cond.contract  = loan.contract
                        and loan-cond.since <= svPlanDate 
                        NO-LOCK NO-ERROR.
  if available loan-cond then
     if loan-cond.int-date = 31 then DELETE all_recids.     /*так договор на просрочке*/

END.

