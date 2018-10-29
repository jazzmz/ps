{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: dblinput.p
      Comment: ������� ���� - ������ ४����⮢ ���㬥��
   Parameters: -
         Uses:
      Used by:
      Created:
     Modified: xx/xx/xxxx
     Modified: 02/06/2003 ����
     Modified: 27/02/2006 Anisimov �������� ����஫� ��� �����⥫� � �������� ��ࠬ���� ����᪠ ��楤��� nalpl_ed.p
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
      "������:" op.name-ben VIEW-AS FILL-IN SIZE 51 BY 1 "���:" vINN
      "����ঠ��� ����樨:" op.details VIEW-AS EDITOR INNER-CHARS 54
                           INNER-LINES 4 MAX-CHARS 255
   WITH FRAME q OVERLAY CENTERED NO-LABEL
      TITLE '[ ������ �������� #' + op.doc-num + ' ]'.
   {dblinput.upd}
END.

IF ( TRIM(vINN) NE TRIM(op.inn)) THEN DO:
   MESSAGE "����୮ 㪠��� ���! ������� ����?" VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO SET choice AS LOGICAL.
   IF choice EQ YES THEN UNDO , RETRY.
END.

HIDE FRAME q.

/* ��뢠�� ��� ।���஢���� ��������� ४����⮢ */
/*RUN nalpl_ed.p (RECID(op),99, 1).*/

   RUN dblinp_nalpl_ed.p (RECID(op),99, 3).

IF LASTKEY = KEYCODE("F9") AND RETURN-VALUE = "OK" THEN
   do:
/*	MESSAGE "sgsg" VIEW-AS ALERT-BOX.*/
   RUN dblinp_nalpl_ed.p (RECID(op),2, 3).
   end.
RELEASE op.
