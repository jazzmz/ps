/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует проверочную ведомость по счету с      *     
 * ролью ПАРАМ2 и параметром ПАРАМ1                          *
 *                                                           *
 * Входные параметры: ПАРАМ1: параметр кредитного договора   *
 *                    ПАРАМ2: Роль счета кредитного договора *
 *                                                           *
 *                                                           *
 *************************************************************
 *                                                           *
 * Автор: Красков А.С.                                       *
 * Дата создания: 16.12.2010                                 *
 * заявка №562                                               *
 *                                                           *
 *************************************************************/

using Progress.Lang.*.

{globals.i}
{tmprecid.def}
{getdate.i}
{lshpr.pro}

DEF VAR oTAcct AS TAcct NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.

DEF VAR str AS CHAR NO-UNDO.

DEF VAR dSummPar AS DECIMAL INIT 0 NO-UNDO.
DEF VAR dSummAcct AS DECIMAL INIT 0 NO-UNDO.
DEF VAR dItog AS DECIMAL INIT 0 NO-UNDO.
DEF VAR TEMP AS DECIMAL INIT 0 NO-UNDO.
DEF VAR dDate AS Date NO-UNDO.

DEF BUFFER bLoan for loan.

DEFINE INPUT PARAM iParam AS CHAR.

DEF VAR iParam_1 AS CHAR NO-UNDO.
DEF VAR iParam_2 AS CHAR NO-UNDO.


DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

oTpl = new TTpl("pir-provved.tpl").

ASSIGN
   iParam_1 = ENTRY(1, iParam)
   iParam_2 = ENTRY(2, iParam).

oTable = new TTable(4).

dDate = end-date.

if not can-find (first tmprecid)
then do:
    message "Нет ни одного выбранного договора!"
    view-as alert-box.
    return.
end.

{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id and loan.class-code = "loan-transh" NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.

FOR EACH tmprecid,
    first loan where RECID(loan) EQ tmprecid.id and loan.class-code = "loan-transh" NO-LOCK.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


          str = TRIM(loan.cont-code) + " ".
          for each loan-acct where loan-acct.cont-code = loan.cont-code and loan-acct.acct-type = iParam_2 NO-LOCK.

          oTAcct = new TAcct(loan-acct.acct).
          dSummAcct = dSummAcct + oTacct:getlastpos2date(dDate).

          DELETE OBJECT oTAcct.
          end.
          for each bloan where bloan.cont-code begins str NO-LOCK:
              RUN PARAM_0_NEW(bloan.contract,bloan.cont-code,0,dDate,OUTPUT temp).
	      dSummPar = dSummPar + temp.
	      temp = 0.
          end.
          if dSummPar <> dSummAcct THEN
                DO:
                   dItog = dSummPar - dSummAcct.

                   oTable:AddRow().
                   oTable:AddCell(loan.cont-code).
                   oTable:AddCell(dSummPar).
                   oTable:AddCell(dSummAcct).
                   oTable:AddCell(dItog). 

        
                END.

           dSummPar = 0.
           dSummAcct = 0.        

           vLnCountInt = vLnCountInt + 1.
end.

oTpl:addAnchorValue("DATE",dDate).
oTpl:addAnchorValue("Table1",oTable).

{setdest.i}
oTpl:show().
{preview.i}                              

DELETE OBJECT oTable.
{tpl.delete}
