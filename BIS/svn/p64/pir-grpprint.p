/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: GRPPRINT.P
      Comment: ���室��� ��� ��㯯���� ���� ���㬥��
   Parameters: �������� ��楤��� (� ��楤��� ��।����� 1 ��ࠬ��� 
                                   "yes"  - ��㯯���� �����, ���� �����筠�
                                   recid ����� � ⠡��� tmprecid
                                                                     
         Uses:
      Used by:
      Created: 07.06.2004 ilvi (27309)   
     Modified: ��᪮�, ��� #639.  
*/
{globals.i}
DEFINE INPUT PARAMETER iParams AS CHARACTER NO-UNDO.

DEFINE VARIABLE vProc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vDate AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDate AS DATE NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

vProc = ENTRY(1,iParams).
vDate = ENTRY(2,iParams).

idate = TODAY - INTEGER(vDate).

{tmprecid.def}

if vProc = "anksec" then do:

FOR each sec-code WHERE TRUE AND (sec-code.close-date EQ ? OR
sec-code.close-date >= iDate) AND sec-code.class-code BEGINS '' NO-LOCK,
last instr-rate WHERE  instr-rate.instr-code EQ sec-code.sec-code
AND instr-rate.instr-cat EQ 'sec-code' AND instr-rate.rate-instr >= 0 AND
instr-rate.rate-type EQ '�������' AND instr-rate.since <= iDate NO-LOCK
   BY sec-code.sec-code. 

create tmprecid.
       tmprecid.id = recid(sec-code).

end.
end.

{getdaydir.i}

cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(vDate)) + '/grpprint.txt'.


{setdest.i &cols=150 &filename=cFileName}

FOR EACH tmprecid NO-LOCK:
   IF SearchPfile(vProc) THEN
      RUN VALUE(vProc + '.p') ("yes",tmprecid.id).


put unformatted skip(2) "���.�।ᥤ�⥫� �ࠢ�����              ������� ����� ���ਨ�����"
skip(1).

put unformatted "������ ��壠���                       ����ᮢ� ��죠 ���᫠�����" SKIP(2).

put unformatted Skip STRING (idate,"99/99/9999") skip(2).
   PAGE. 
END.