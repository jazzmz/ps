/***** ================================================================= *****/
/*** 	Процедура печати  журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash)                  
	Входной параметр - дата оп.дня журнала (ГГГГММДД - тип CHAR)
	Запуск - из процедуры pir-statcash.p (с параметром 0,1,2,4)        ***/
/***** ================================================================= *****/


/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iOpDate AS CHAR.
/* MESSAGE "pir-statcash-prnt.p  INPUT PARAM iOpDate = " iOpDate VIEW-AS ALERT-BOX. */

DEF VAR KlName    AS CHAR NO-UNDO.
DEF VAR CodeDescr AS CHAR NO-UNDO.
DEF VAR CodeMisc  AS CHAR NO-UNDO.

DEF VAR Sum810  AS DEC INIT 0 NO-UNDO.
DEF VAR Sum840  AS DEC INIT 0 NO-UNDO.
DEF VAR Sum978  AS DEC INIT 0 NO-UNDO.

   /*** РИСОВАЛКИ  ****/ 
DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTable /*TTableCSV*/ NO-UNDO.

oTpl = new TTpl("pir-statcash-prnt.tpl").
oTableDoc = new TTable(10).  /* а вроде 10 должно быть */




/***** ================================================================= *****/
/*** 	                       РЕАЛИЗАЦИЯ                                  ***/
/***** ================================================================= *****/

FOR EACH code 
	WHERE code.class = "PirStatCash" 
	AND code.parent  = iOpDate
NO-LOCK:

   IF AVAIL code THEN
     DO:

	CASE SUBSTRING(ENTRY(1,code.name,";"),6,3) :
	  WHEN "810" THEN DO:
		Sum810 = Sum810 + DECIMAL(ENTRY(2,code.name,";")) .
	  END.
	  WHEN "840" THEN DO:
		Sum840 = Sum840 + DECIMAL(ENTRY(2,code.name,";")) .
	  END.
	  WHEN "978" THEN DO:
		Sum978 = Sum978 + DECIMAL(ENTRY(2,code.name,";")) .
	  END.
	END CASE.

	IF ENTRY(3,code.code,"_") = "Ч" THEN
	  DO:
		FIND FIRST person WHERE STRING(person.person-id) = ENTRY(1,code.code,"_") NO-LOCK NO-ERROR.

		IF AVAIL person THEN
		  KlName = STRING(person.name-last + " " + person.first-name) .
		ELSE 
	  	  KlName = "Клиент не найден!".
	  END.
	ELSE
	  DO:
		FIND FIRST cust-corp WHERE STRING(cust-corp.cust-id) = ENTRY(1,code.code,"_") NO-LOCK NO-ERROR.

		IF AVAIL cust-corp THEN
		  KlName = cust-corp.name-short  . 
		ELSE 
	  	  KlName = "Клиент не найден!".
	  END.
	
	IF NUM-ENTRIES(code.description[1],";") >= 3 THEN 
	DO:
	  CodeDescr = ENTRY(3,code.description[1],";") .
	END.
	ELSE 
	  CodeDescr = "" . 

	CodeMisc  = code.misc[1] + code.misc[2] + code.misc[3] + code.misc[4] 
		    + code.misc[5] + code.misc[6] + code.misc[7] + code.misc[8]	.		


	oTableDoc:addRow().
	oTableDoc:addCell(KlName).
	oTableDoc:addCell(SUBSTRING(ENTRY(1,code.name,";"),6,3)).
	oTableDoc:addCell(ENTRY(1,code.name,";")).
	oTableDoc:addCell(DECIMAL(ENTRY(2,code.name,";"))).
	oTableDoc:addCell(ENTRY(3,code.name,";")).
	oTableDoc:addCell(ENTRY(1,code.val ,";")).
	oTableDoc:addCell(ENTRY(2,code.val ,";")).
	oTableDoc:addCell( (IF NUM-ENTRIES(code.name,";") >= 5 THEN ENTRY(5,code.name,";") ELSE "" ) ).  /* Разрешил завести онлайн завку OnlnInitr*/
	oTableDoc:addCell(CodeDescr).
	oTableDoc:addCell( (IF NUM-ENTRIES(code.name,";") >= 4 THEN ENTRY(4,code.name,";") ELSE "" ) ).

     END.

END.   /* end_FOR EACH code */

oTpl:addAnchorValue("OpDate", STRING( SUBSTRING(iOpDate,7,2) + "/" + SUBSTRING(iOpDate,5,2) + "/" + SUBSTRING(iOpDate,1,4) )   ).
oTpl:addAnchorValue("Sum810", STRING(Sum810,">>>,>>>,>>>,>99.99") ).
oTpl:addAnchorValue("Sum840", STRING(Sum840,">>>,>>>,>>>,>99.99") ) .
oTpl:addAnchorValue("Sum978", STRING(Sum978,">>>,>>>,>>>,>99.99") ) .
oTpl:addAnchorValue("TABLEDOC",oTableDoc).
/*
IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
*/

{setdest.i}
oTpl:show().
{preview.i}


DELETE OBJECT oTableDoc.
DELETE OBJECT oTpl.

