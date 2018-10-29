/************************************************
 * ����⨥ �� ��७�� ���㬥�� � ��㣮� ����.
 * ��।����� � ����� ���� ��७����� ���㬥��
 * ����� �ࠢ��� ���� newDate � oldDate.
 ************************************************
 * ���� : ��᫮� �. �. Maslov D. A.
 * ���: #1974
 * ���  : 21.05.13
 **/
DEF VAR docCounter AS CHAR NO-UNDO.
DEF VAR newNum     AS CHAR NO-UNDO.

 docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"Counters",?).

 IF docCounter = ? THEN DO:
    docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"DocCounter",?).
 END.   

 IF docCounter = ? THEN DO:
   docCounter = getXAttrValueEx("op-template",op.op-kind + "," + STRING(op.op-template),"��������",?).
 END.   

IF newDate > oldDate THEN DO:  
  IF docCounter <> ? AND CAN-DO(FGetSetting("PirChkOp","PirCounterLst","!*"),docCounter) THEN DO:
     newNum = STRING(GetCounterNextValue(docCounter,newDate)).
     op.doc-num = newNum.
  END.
END.