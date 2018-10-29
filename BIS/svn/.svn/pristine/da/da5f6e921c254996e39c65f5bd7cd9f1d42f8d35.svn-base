/***** ================================================================= *****/
/*** 	Процедура копирования журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash) из текущего дня в новый,
	если заявки утверждены, но не выданы                  
	Входной параметр - дата оп.дня журнала (ГГГГММДД - тип CHAR)
	Запуск - из процедуры pir-statcash.p (с параметром 0,1,2,4)        ***/
/***** ================================================================= *****/

{pir-statcash.i}

/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iParam  AS CHAR.

DEF VAR iOpDate		AS CHAR NO-UNDO.
DEF VAR inewOpDate	AS CHAR NO-UNDO.
iOpDate	   = ENTRY(1,iParam,",") .
inewOpDate = ENTRY(2,iParam,",") .
/*MESSAGE "pir-statcash-copy.p  INPUT PARAM iOpDate = " iOpDate "  inewOpDate = " inewOpDate VIEW-AS ALERT-BOX. */

DEF BUFFER ncode FOR code.

DEF VAR KlName    AS CHAR NO-UNDO.
DEF VAR CodeDescr AS CHAR NO-UNDO.
DEF VAR CodeMisc  AS CHAR NO-UNDO.

DEF VAR ResStCash 	AS CHAR INIT "0"  NO-UNDO.
DEF VAR FlgUtv	 	AS LOGICAL INIT NO  NO-UNDO.


   /*** РИСОВАЛКИ  ****/ 

DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTable /*TTableCSV*/ NO-UNDO.

oTpl = new TTpl("pir-statcash-copy.tpl").
oTableDoc = new TTable(11).  /* д.б. 11 */





/***** ================================================================= *****/
/*** 	                       РЕАЛИЗАЦИЯ                                  ***/
/***** ================================================================= *****/

FOR EACH code 
	WHERE code.class = "PirStatCash" 
	AND code.parent  = iOpDate
	AND ENTRY(1,code.val ,";") = "УТВЕРЖДЕНА"
NO-LOCK:

   IF AVAIL code THEN
   DO:

	FlgUtv = YES .

	   /* заведение скопированной заявки в новом дне */ 
	ResStCash = Copy2ReqstStCash(iOpDate, inewOpDate, code.code ) . 
/*message "ResStCash = " ResStCash  view-as alert-box.*/

	IF ResStCash = "0" THEN
	DO:	
		MESSAGE "Завка по счету:" + ENTRY(1,code.name ,";") + " на сумму:" + ENTRY(2,code.name ,";") + " не была скопирована!" VIEW-AS ALERT-BOX.
	END.	
	ELSE
	DO:

	  /* отчет */ 
	FIND FIRST ncode WHERE ncode.code = ResStCash NO-LOCK NO-ERROR.

	KlName = GetKlntNameStCash(ncode.code) .

	CodeDescr = "" . 
	IF NUM-ENTRIES(ncode.description[1],";") >= 3 THEN 
	  CodeDescr = ENTRY(3,ncode.description[1],";") .

	CodeMisc  = ncode.misc[1] + ncode.misc[2] + ncode.misc[3] + ncode.misc[4] 
		    + ncode.misc[5] + ncode.misc[6] + ncode.misc[7] + ncode.misc[8]	.		

	oTableDoc:addRow().
	oTableDoc:addCell(KlName).
	oTableDoc:addCell(SUBSTRING(ENTRY(1,ncode.name,";"),6,3)).
	oTableDoc:addCell(ENTRY(1,ncode.name,";")).
	oTableDoc:addCell(DECIMAL(ENTRY(2,ncode.name,";"))).
	oTableDoc:addCell(ENTRY(3,ncode.name,";")).
	oTableDoc:addCell(ENTRY(1,ncode.val ,";")).
	oTableDoc:addCell(ENTRY(2,ncode.val ,";")).
	oTableDoc:addCell( (IF NUM-ENTRIES(code.name,";") >= 5 THEN ENTRY(5,code.name,";") ELSE "" ) ).  /* Разрешил завести онлайн завку OnlnInitr*/
	oTableDoc:addCell(CodeDescr).
	oTableDoc:addCell(ENTRY(4,ncode.name,";")).
	oTableDoc:addCell( IF ResStCash <> "0" THEN "Заявка скопирована" ELSE "Заявка не была скопирована!!!" ).

	ResStCash =  "0" .
	END.
     END.

END.   /* end_FOR EACH code */


IF FlgUtv = NO THEN
DO:	
	MESSAGE "Нет утвержденных заявок!" VIEW-AS ALERT-BOX.
END.	



oTpl:addAnchorValue("oldOpDate", STRING( SUBSTRING(iOpDate,7,2) + "/" + SUBSTRING(iOpDate,5,2) + "/" + SUBSTRING(iOpDate,1,4) )   ).
oTpl:addAnchorValue("newOpDate", STRING( SUBSTRING(inewOpDate,7,2) + "/" + SUBSTRING(inewOpDate,5,2) + "/" + SUBSTRING(inewOpDate,1,4) )   ).
oTpl:addAnchorValue("TABLEDOC",oTableDoc).

/*
IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
*/

                                          	
{setdest.i}
oTpl:show().
{preview.i}


DELETE OBJECT oTableDoc.
DELETE OBJECT oTpl.

