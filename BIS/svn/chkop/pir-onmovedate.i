/************************************************
 * Событие на перенос документа в другой день.
 * Определить в какой день переносится документ
 * можно сравнив даты newDate и oldDate.
 ************************************************
 * Автор : Маслов Д. А. Maslov D. A.
 * Заявка: #1974
 * Дата  : 21.05.13
 **/
DEF VAR docCounter AS CHAR NO-UNDO.
DEF VAR newNum     AS CHAR NO-UNDO.

 docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"Counters",?).

 IF docCounter = ? THEN DO:
    docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"DocCounter",?).
 END.   

 IF docCounter = ? THEN DO:
   docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"ДокНомер",?).
 END.   

IF newDate > oldDate THEN DO:  
  IF docCounter <> ? AND CAN-DO(FGetSetting("PirChkOp","PirCounterLst","!*"),docCounter) THEN DO:
     newNum = STRING(GetCounterNextValue(docCounter,newDate)).
     op.doc-num = newNum.
  END.
END.