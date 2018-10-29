/*������������ � ������ ������ �� �������� ��
��������: ���������� �.�.
�����: ������� �.�.*/

using Progress.Lang.*.

{globals.i}
{getdate.i}
{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */
{ulib.i}

DEF VAR oTpl AS TTpl.
def buffer transh for loan.
def var oTable AS TTable.
def var ctrans as CHAR NO-UNDO.
def var oAcct as TAcct.
def var oFunc as tfunc.
def var grriska as char.
def var rate as dec.
def var temple as char.
DEF INPUT PARAMETER TypeOtch AS INT.
DEF VAR cur as Char.
ctrans = "over_flk".
def var DataZakl as date.
oFunc = new tfunc().

if TypeOtch = 1 then cur = "".
else cur = "840,978".
if TypeOtch = 1 then temple = "pirgetover.tpl".
else temple = "pirgetvalover.tpl".

oTpl = new TTpl(temple).
oTable = new TTable(12).


    oTable:AddRow().
    oTable:AddCell("�� ����").
    oTable:AddCell("�����").
    oTable:AddCell("������").
    oTable:AddCell("����").
    oTable:AddCell("������� ����").
    oTable:AddCell("�������").
    oTable:AddCell("��������� �������").
    oTable:AddCell("����� ������").
    oTable:AddCell("���� ����� ������ �").
    oTable:AddCell("���������� ������").
    oTable:AddCell("���� ������ ���������").
    oTable:AddCell("��������� ��������").


for each loan where loan.contract = "�।��" and loan.class-code begins "loan_tran" and loan.open-date = end-date and can-do(cur,loan.currency) NO-LOCK,
    first loan-int where loan-int.contract = loan.contract 
		     and loan-int.cont-code = loan.cont-code 
		     and loan-int.id-k = 3 and loan-int.id-d = 0
		     and loan-int.op-date = end-date NO-LOCK by loan-int.amt-rub.
/*    message loan-int.op loan-int.op-entry VIEW-As ALERT-BOX.*/
    find first op-entry where op-entry.op = loan-int.op and can-do(cur,op-entry.currency) NO-LOCK NO-ERROR.
    if NOT AVAILABLE (op-entry) then MESSAGE "�� ������� ������ �뤠� ������� �� �࠭�� " loan.cont-code VIEW-AS ALERT-BOX. 

    find first op where op-entry.op = op.op and op.op-date = end-date NO-LOCK NO-ERROR.

    find last loan-acct where loan-acct.contract = loan.contract and loan-acct.cont-code = ENTRY(1,loan.cont-code," ") and loan-acct.acct-type = "�।�" NO-LOCK NO-ERROR.

    if not available loan-acct then message "�� ���� ���� ��� ����� ���: " op.doc-num VIEW-AS ALERT-BOX.

    find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.

    dataZakl = DATE(getMainLoanAttr("�।��",ENTRY(1,loan.cont-code," "),"%��⠑���")).
    grriska = oFunc:getKRez(entry(1,loan.cont-code," "),end-date).

    oAcct = new TAcct(loan-acct.acct).
    rate = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%�।", end-date, false).


    oTable:AddRow().
    oTable:AddCell(op-entry.acct-cr).

    if TypeOtch = 1 then oTable:AddCell((STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).

    else
    oTable:AddCell((STRING(round(op-entry.amt-cur,2),">>>,>>>,>>>,>>9.99"))).

    if TypeOtch = 1 then 
    oTable:AddCell("810").
    else
    oTable:AddCell(op-entry.currency).

    oTable:AddCell("� " + STRING(loan.open-date) + " �� " + STRING(loan.end-date)).
    oTable:AddCell(op-entry.acct-db).
    oTable:AddCell(Person.name-last + " " + Person.first-names).
    oTable:AddCell(loan.cont-code + " �� " + STRING(dataZakl)).
    oTable:AddCell(TRIM(STRING(round(oAcct:GetLastPos2Date(end-date),2),">>>,>>>,>>>,>>9.99"))).
    oTable:AddCell(loan-acct.acct).
    oTable:AddCell(STRING(RATE * 100) + "% �������").
    oTable:AddCell(loan.end-date).


    oTable:AddCell(ENTRY(2,grriska) + " (" + ENTRY(1,grriska)  + "%)").


    DELETE OBJECT oAcct.


end.

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oFunc.