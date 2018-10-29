{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ЗАО "Банковские информационные системы"
     Filename: dblinput.p
      Comment: Двойной ввод - доввод реквизитов документа
   Parameters: -
         Uses:
      Used by:
      Created:
     Modified: xx/xx/xxxx
     Modified: 02/06/2003 Илюха
     Modified: 27/02/2006 Anisimov Добавлен контроль ИНН получателя и изменены параметры запуска процедуры nalpl_ed.p
*/

DEF INPUT PARAM rid AS RECID NO-UNDO.

{globals.i}

FIND FIRST op WHERE
     RECID(op) = rid EXCLUSIVE-LOCK NO-WAIT.

FIND FIRST op-kind  OF op NO-LOCK.
FIND FIRST op-templ OF op NO-LOCK.
FIND FIRST op-bank  OF op.
FIND FIRST op-entry OF op.

DEFINE VARIABLE vINN      LIKE  op.inn NO-UNDO.

DO ON ENDKEY UNDO, LEAVE:
   PAUSE 0.
   UPDATE
      "Клиент:" op.name-ben VIEW-AS FILL-IN SIZE 51 BY 1 "ИНН:" vINN
      "Содержание операции:" op.details VIEW-AS EDITOR INNER-CHARS 54
                           INNER-LINES 4 MAX-CHARS 255
   WITH FRAME q OVERLAY CENTERED NO-LABEL
      TITLE '[ ДОВВОД ОПЕРАЦИИ #' + op.doc-num + ' ]'.
   {dblinput.upd}
END.

IF ( TRIM(vINN) NE TRIM(op.inn)) THEN DO:
   MESSAGE "Неверно указан ИНН! Повторить ввод?" VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO SET choice AS LOGICAL.
   IF choice EQ YES THEN UNDO , RETRY.
END.

HIDE FRAME q.

/* вызываем форму редактирования налоговых реквизитов */
/*RUN nalpl_ed.p (RECID(op),99, 1).*/

   RUN dblinp_nalpl_ed.p (RECID(op),99, 3).

IF LASTKEY = KEYCODE("F9") AND RETURN-VALUE = "OK" THEN
   do:
/*	MESSAGE "sgsg" VIEW-AS ALERT-BOX.*/
   RUN dblinp_nalpl_ed.p (RECID(op),2, 3).
   end.
RELEASE op.
