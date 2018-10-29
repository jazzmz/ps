/* ------------------------------------------------------
     Автор: Красков А.С.
     Дата модификации: 28.10.2011
     Заявка: #764

******************************************************* */

/** используем информацию из броузера */
{tmprecid.def}

DEF VAR cDocNum AS CHAR FORMAT "x(6)".
DEF VAR cDocDetails AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4.

DEF FRAME fSet 
   "Номер документа:" cDocNum SKIP(1) 
   "Содержание документа:" SKIP cDocDetails 
   WITH CENTERED NO-LABELS TITLE "Введите данные" .

/** тело программы */

/*DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.*/

DEF VAR oSysClass AS TSysClass.

oSysClass = new TSysClass().


FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
    find first op-entry where op-entry.op-date = op.op-date and op-entry.op = op.op NO-LOCK NO-ERROR.
    if MAXIMUM(op.op-status, op-entry.op-status) GE '√' then 
       do:
/*          find first acct-pos where since = op.op-date NO-LOCK NO-ERROR.*/
          if oSysClass:getLastCloseDate() >= op.op-date then
             do:
                MESSAGE COLOR WHITE/RED "Опер. день уже закрыт! Редактирование документов в закрытом дне запрещено" VIEW-AS ALERT-BOX. 

             end.
          else
             do:

                if ((can-do("СКЛАД*",op-entry.kau-cr)) OR (CAN-DO("СКЛАД*",op-entry.kau-db))) AND (op.user-id EQ USERID('bisquit')) then 
                   do:   
                     /** выводим на форму данные для изменения */
                      cDocNum = op.doc-num.
                      cDocDetails = op.details.
 
                      DISPLAY cDocNum cDocDetails WITH FRAME fSet.
 
                      SET cDocNum  cDocDetails WITH FRAME fSet.

                      IF cDocNum NE ? AND cDocNum NE "" THEN 
                         DO:
                            if op.doc-num <> cDocNum THEN op.doc-num = cDocNum.
                         END.


                      IF cDocDetails NE ? AND cDocDetails NE "" THEN 
                         DO:
                            if op.details <> cDocDetails THEN op.details = cDocDetails.
                         END.

                     DISPLAY cDocNum cDocDetails WITH FRAME fSet.
                     HIDE FRAME fSet.
                   END.
                ELSE
                   DO:
                      MESSAGE COLOR WHITE/RED "Вы не имеете права править документ созданный другим пользователем" VIEW-AS ALERT-BOX. 
                   END.
             END.
       END.
    else
       DO:
          MESSAGE COLOR WHITE/RED "Данная процедура предназначена только для правки проконтролированых документов!"
                             SKIP "Воспользуйтесь стандартным функционалом" VIEW-AS ALERT-BOX. 
       END.
END.
DELETE OBJECT oSysClass.