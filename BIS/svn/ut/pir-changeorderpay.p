/**********************************

 Обработка предназначена 
 для изменения очередности платежа.
 Выполнена по заявке #4274
 
***********************************/
 
{tmprecid.def}
DEF VAR cNewNumber AS CHAR INITIAL ? LABEL "Новая очередность" NO-UNDO.

/* Запрашивай новый номер */
DISPLAY cNewNumber WITH FRAME fSetNumber OVERLAY CENTERED SIDE-LABELS.
SET cNewNumber WITH FRAME fSetNumber.
HIDE FRAME fSetNumber.

FOR EACH tmprecid:
 /* По всем выбранным документам */

FIND FIRST op WHERE tmprecid.id = RECID(op).
 
  DISABLE TRIGGERS FOR LOAD OF op.
  DISABLE TRIGGERS FOR LOAD OF op-entry.
  IF cNewNumber NE ? AND cNewNumber NE ""  THEN op.order-pay = cNewNumber.
 
  ACCUMULATE op.op (COUNT).

END.