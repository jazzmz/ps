/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: DEPPR.P
      Comment: ���室���, ��������騩 tmprecid ��� �맮�� deppr(a
   Parameters:
         Uses:
      Used by:
      Created: 25.11.2003 ilvi (22099) 
     Modified: 18.07.2006 OZMI (0054745) � ���������� for each ��⥭ 䨫���.
*/
{globals.i}
{tmprecid.def}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.

FOR EACH bal-acct WHERE
         bal-acct.acct-cat EQ "d" NO-LOCK,
   EACH acct OF bal-acct WHERE acct.filial-id EQ shFilial NO-LOCK:
   CREATE tmprecid.
   tmprecid.id = RECID(acct).
END.

IF SearchPfile("pir-deppr(a") THEN
   RUN VALUE("pir-deppr(a" + ".p") (iParmStr).

{empty tmprecid}
