/***********************************
 *
 * Отчет выданных счет фактур.
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания: 29.02.2012
 * Заявка: #853
 *
 *************************************/

{globals.i}
{intrface.get axd}

{tmprecid.def}

DEF VAR mAmtSf    AS DECIMAL NO-UNDO.
DEF VAR mAmtNds   AS DECIMAL NO-UNDO.
DEF VAR mAmtNoNds AS DECIMAL NO-UNDO.

DEF VAR mCustName AS CHARACTER NO-UNDO.
DEF VAR mAddr     AS CHARACTER NO-UNDO.
DEF VAR mInn      AS CHARACTER NO-UNDO.
DEF VAR mKpp      AS CHARACTER NO-UNDO.

DEF VAR i AS INT INIT 1 NO-UNDO.

DEF VAR oTable AS TTable NO-UNDO.

{tpl.create}
oTable = new TTable(5).

FOR EACH tmprecid NO-LOCK,
 FIRST loan WHERE RECID(loan) = tmprecid.id 
   NO-LOCK
    by loan.doc-num:
 
 /*определяем сумму и НДС счет-фактуры*/
   RUN SFAmtServs IN h_axd (loan.contract,
                            loan.cont-code,
                            OUTPUT mAmtSf,
                            OUTPUT mAmtNds,
                            OUTPUT mAmtNoNds).

 /*определяем ФИО контрагента*/
   RUN SFAttribs_Seller IN h_axd (loan.contract,
                                  loan.cont-code,
                                  loan.cust-cat,
                                  loan.cust-id,
                                  OUTPUT mCustName,
                                  OUTPUT mAddr,
                                  OUTPUT mInn,
                                  OUTPUT mKpp).

  oTable:addRow().
  oTable:addCell(i).
  oTable:addCell(mCustName).
  oTable:addCell(loan.doc-num).
  oTable:addCell((IF loan.open-date <> ? THEN STRING(loan.open-date,"99/99/9999") ELSE "")).
  oTable:addCell(mAmtSf).

  oTable:setAlign(1,i,"left").
  oTable:setAlign(2,i,"left").

  i = i + 1.
END.
oTpl:addAnchorValue("TABLE",oTable).

{tpl.show}
{tpl.delete}
