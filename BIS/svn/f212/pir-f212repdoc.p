{tmprecid.def}
DEF VAR oTpl      AS TTpl      NO-UNDO.
DEF VAR oDTInput1 AS TDTInput  NO-UNDO. /* Запрашиваем период отчета */
DEF VAR oDTInput2 AS TDTInput  NO-UNDO. /* Запрашиваем дату, когда отчет формируется */

DEF VAR oSysClass AS TSysClass NO-UNDO.

DEF VAR cAcctList  AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR cDateBeg   AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR cDateEnd   AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR iCopyCount AS INTEGER INITIAL 1 LABEL "Кол-во копий" 		    NO-UNDO.
DEF VAR cOrderNum  AS CHARACTER INITIAL "" LABEL "Номер документа" 	    NO-UNDO.
DEF VAR cRepDate   AS CHARACTER INITIAL "" LABEL "Дата формирования отчета" NO-UNDO.

DEFINE VARIABLE i AS INTEGER NO-UNDO.

oSysClass=new TSysClass().

oDTInput1 = new TDTInput("4").
oDTInput1:X = 200.
oDTInput1:Y = 50.
oDTInput1:head = "Отчетный период?".
oDTInput1:show().
cDateBeg = oSysClass:DATETIME2STR(oDTInput1:beg-datetime,"%d.%m.%y").
cDateEnd = oSysClass:DATETIME2STR(oDTInput1:end-datetime,"%d.%m.%y").
DELETE OBJECT oDTInput1.

oDTInput2 = new TDTInput("3").
oDTInput2:head = "Дата запроса?".
oDTInput2:label1 = "Дата:".
oDTInput2:X = 195.
oDTInput2:Y = 55.
oDTInput2:show().
cRepDate=oSysClass:DATETIME2STR(oDTInput2:beg-datetime,"%d.%m.%y").
DELETE OBJECT oDTInput2.

MESSAGE "Номер документа?" UPDATE cOrderNum.
MESSAGE "Кол-во копий?" UPDATE iCopyCount.

DELETE OBJECT oSysClass.

{setdest.i}
FOR EACH tmprecid, FIRST cust-corp WHERE tmprecid.id = RECID(cust-corp) BY cust-corp.name-short:

  FOR EACH acct WHERE acct.cust-cat="Ю" AND acct.cust-id=cust-corp.cust-id AND CAN-DO('405..810*,406..810*,407..810*,40802810*,40807810*',acct.acct) NO-LOCK:
  cAcctList = cAcctList + acct.acct + "\n".
  END. /* Все счета */

FIND FIRST cust-ident WHERE cust-ident.Class-Code="p-cust-adr" AND cust-ident.cust-cat="Ю" AND cust-code-type="АдрЮр" AND cust-ident.cust-id=cust-corp.cust-id NO-LOCK NO-ERROR.

   oTpl = new TTpl("pir-f212repdoc.tpl").
   oTpl:addAnchorValue("Название_Организации",cust-corp.name-short).
   oTpl:addAnchorValue("НОМЕР_ДОКУМЕНТА",cOrderNum).
   
   oTpl:addAnchorValue("СПИСОК_СЧЕТОВ",cAcctList).
   

 IF AVAILABLE(cust-ident) THEN oTpl:addAnchorValue("АДРЕС",cust-ident.issue).

   oTpl:addAnchorValue("ДАТА",cRepDate).     
   oTpl:addAnchorValue("ДАТАНАЧ",cDateBeg).
   oTpl:addAnchorValue("ДАТАКОН",cDateEnd).
   
     DO i = 1 TO iCopyCount:
        oTpl:show().
        PAGE.
     END.
DELETE OBJECT oTpl.
cAcctList = "". /* Очищаем переменную со счетами для след. орг-ции */
END. /* ПО всем клиентам */
{preview.i}
 