/*************************
 *
 * Доп. фильтрация для процедуры выноса
 * на просрочку по овердрафтам.
 * Вешается доп. реком на all_flt
 *
 *************************
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Заявка:
 * Дата создания:
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

DEF VAR mTotalRecs  AS INT64     NO-UNDO.


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

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:
    IF loan.end-date <> svPlanDate THEN DELETE all_recids.
END.
