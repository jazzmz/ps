/*����-ᯨ᮪ ������஢ ��.
�����稪: ��ᨫ쪮�� �.�.
����: ��᪮� �.�."               */

def var oTable AS TTable.
def var oAcct as TAcct.
def var count as Int INIT 0 NO-UNDO.

oTable = new TTable(4).
  oTable:AddROW().
  oTable:addCell("").
  oTable:addCell("����� �������").
  oTable:addCell("��� ����騪�").
  oTable:addCell("���⮪ ������������").
for each loan where loan.contract = "�।��" and loan.cont-code begins "��" and loan.class-code = "l_agr_with_per" and loan.close-date = ? No-Lock.
find first loan-acct where loan-acct.contract = loan.contract and loan-acct.cont-code = loan.cont-code and loan-acct.acct-type = "�।��" NO-LOCK NO-ERROR.
if available (loan-acct) then
do:
  oAcct = new TAcct(loan-acct.acct).
  count = count + 1.
  find first person where person.person-id = loan.cust-id NO-LOCk NO-ERROR.
  oTable:AddROW().
  oTable:addCell(count).
  oTable:addCell(loan.cont-code).
  oTable:addCell(person.name-last + " " + person.first-names).
  oTable:addCell(oAcct:getLastPos2Date(TODAY)).
  DELETE OBJECT oAcct.
end.
else
do:
message loan.cont-code " ���ਢ易� ��㤭� ���" VIEW-AS ALERT-BOX.

end.
end.


{setdest.i}
PUT UNFORMATTED "                        ������ ��������� �� �� ��������� �� " TODAY SKIP.
oTable:show().
{preview.i}

DELETE OBJECT oTable.