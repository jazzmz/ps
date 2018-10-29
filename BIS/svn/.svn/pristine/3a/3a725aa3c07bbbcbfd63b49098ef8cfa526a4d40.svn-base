/**********************************

 Обработка предназначена 
 для изменения номеров документов
 в закрытом дне.
 Выполнена по заявке #98
 
***********************************/
 
{tmprecid.def}
DEF VAR cNewNumber AS CHARACTER INITIAL ? LABEL "Новый номер документа" NO-UNDO.

/* Запрашивай новый номер */
DISPLAY cNewNumber WITH FRAME fSetNumber OVERLAY CENTERED SIDE-LABELS.
SET cNewNumber WITH FRAME fSetNumber.
HIDE FRAME fSetNumber.

FOR EACH tmprecid:
 /* По всем выбранным документам */

FIND FIRST op WHERE tmprecid.id = RECID(op).
 
  DISABLE TRIGGERS FOR LOAD OF op.
  DISABLE TRIGGERS FOR LOAD OF op-entry.
  IF cNewNumber NE ? AND cNewNumber NE ""  THEN op.doc-num = cNewNumber.
 
  ACCUMULATE op.op (COUNT).

END.