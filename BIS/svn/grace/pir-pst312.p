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
def var btOk as logical NO-UNDO.


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


def buffer bloan for loan.

/*message "Старт" flt-template.op-kind VIEW-AS ALERT-BOX.*/

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:

  bDel = true.

  if not bDel THEN DO:
     for each bloan where bloan.cont-code begins loan.cont-code + " "
                      and bloan.contract  = loan.contract
                      and bloan.close-date = ?
                      NO-LOCK,
     first loan-int where loan-int.contract   = bloan.contract
                         and loan-int.cont-code = bloan.cont-code
                         and loan-int.mdate     = svPlanDate 
                         and loan-int.id-d = 7                   /*вынос на просрочку ссуды*/
                         and loan-int.id-k = 0 
                         NO-LOCK.
            bDel = false.
      end.
  END.

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

 

  if bDel = false THEN  MESSAGE "Закрыть лимит по договору " + loan.contract + "?"  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 
  if btOk = ? or NOT btOk then DELETE all_recids.

  if bDel then DELETE all_recids.

END.

/*Здесь второй проход для грейс-траншей*/

