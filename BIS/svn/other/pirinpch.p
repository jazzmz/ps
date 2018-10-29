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
*/

DEF INPUT PARAM rid AS RECID NO-UNDO.

{globals.i}

def var name-cl as char format "x(51)" NO-UNDO.
def var inn-cl as char format "x(12)" NO-UNDO.


FIND FIRST op WHERE
     RECID(op) = rid EXCLUSIVE-LOCK NO-WAIT.

FIND FIRST op-kind  OF op NO-LOCK.
FIND FIRST op-templ OF op NO-LOCK.
/* FIND FIRST op-bank  OF op.*/
FIND FIRST op-entry OF op.
FIND acct where acct.acct EQ op-entry.acct-cr.

    IF acct.cust-cat EQ "�" THEN
    DO:
    FIND FIRST cust-corp WHERE 
    cust-corp.cust-id EQ acct.cust-id no-lock no-error.
    If AVAILABLE cust-corp THEN 
    name-cl = cust-corp.cust-stat + " " + cust-corp.name-corp.
    inn-cl = cust-corp.inn.
    end.

    IF acct.cust-cat EQ "�" THEN
    DO:
    FIND FIRST person WHERE 
    person.person-id EQ acct.cust-id no-lock no-error.
    If AVAILABLE person THEN 
    name-cl = person.name-last + " " + person.first-names.
    inn-cl = person.inn.
    end.

    IF acct.cust-cat EQ "�" THEN
    DO:
    FIND FIRST branch WHERE
    branch.branch-id EQ acct.branch-id  no-lock no-error.
    IF AVAILABLE branch THEN
    name-cl = branch.name.
    inn-cl = GetXattrValueEx("branch",string(branch.branch-id),"���","").
    end.

 
DO ON ENDKEY UNDO, LEAVE:
   PAUSE 0.
/*   UPDATE */
disp  "������:" name-cl VIEW-AS FILL-IN SIZE 51 BY 1 "���:" inn-cl
      "����ঠ��� ����樨:" op.details VIEW-AS EDITOR INNER-CHARS 54
                           INNER-LINES 4 MAX-CHARS 255
			   
   WITH FRAME q OVERLAY CENTERED NO-LABEL
      TITLE '[ ������ �������� #' + op.doc-num + ' ]'.
      update op.details with frame q.
/*   {pirinput.upd}*/
END.

HIDE FRAME q.

/* ��뢠�� ��� ।���஢���� ��������� ४����⮢ */
RUN nalpl_ed.p (RECID(op),0, 3).
IF LASTKEY = KEYCODE("F9") AND RETURN-VALUE = "OK" THEN
   RUN nalpl_ed.p (RECID(op),2, 3).

RELEASE op.
