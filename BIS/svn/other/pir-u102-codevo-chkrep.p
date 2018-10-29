/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-u102-codevo-chkrep.p
      Comment: Отчет по кодам ВО для У10-2 
		Критерии заданы в настроечных параметрах PirU102codeVO
   Parameters: 
       Launch: БМ - Печать - Выходные формы - РАЗНОЕ - Отчет по кодам ВО для У10-2 
      Created: Sitov S.A., 2013-10-23
	Basis: #3951
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}
{getdates.i}


DEF VAR  toVOCode	AS  CHAR INIT "" NO-UNDO. 

DEF VAR oTpl1		AS TTpl       NO-UNDO.
DEF VAR oTableDoc1	AS TTableCSV  NO-UNDO.

oTpl1 = new TTpl("pir-u102-codevo-chkrep.tpl").
oTableDoc1 = new TTableCSV(4).




FOR EACH op-entry 
  WHERE  op-entry.op-date >= beg-date
  AND    op-entry.op-date <= end-date
  AND    op-entry.acct-db BEGINS "4"
  AND    op-entry.acct-cr BEGINS "4"
NO-LOCK:

   RUN pir-u102-codevo.p( op-entry.acct-db , op-entry.acct-cr , op-entry.currency , "" , OUTPUT toVOCode ) .  

   IF toVOCode <> "" THEN 
   DO:

	FIND FIRST op OF op-entry  WHERE  op.op-date <> ?  AND  op.op-status <> 'А'  NO-LOCK NO-ERROR.
	IF AVAIL(op) THEN
	DO:

	  IF NOT (op.details  MATCHES   STRING("*" + toVOCode + "*"))  THEN
	  DO:
		oTableDoc1:addRow().
		oTableDoc1:addCell(STRING(op.op-date,"99/99/99")).
		oTableDoc1:addCell(op.doc-num).
		oTableDoc1:addCell(op.details).
		oTableDoc1:addCell(toVOCode).
	  END.

	END.

   END.

END.




oTpl1:addAnchorValue("BegDate",beg-date).
oTpl1:addAnchorValue("EndDate",end-date).
IF oTableDoc1:HEIGHT <> 0 THEN  oTpl1:addAnchorValue("TABLEDOC",oTableDoc1). ELSE oTpl1:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").


{setdest.i}
oTpl1:show().
{preview.i}


DELETE OBJECT oTableDoc1.
DELETE OBJECT oTpl1.

