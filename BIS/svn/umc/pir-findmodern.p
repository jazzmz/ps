/*��楤�� ��� ���᪠ ����୨��樨 �� ��
��� 957 */
{globals.i}

{tmprecid.def}

def var oTable as TTable.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* ���稪 ������஢ */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* ��饥 ������⢮ ������஢ */
DEF VAR count AS INTEGER INIT 0 NO-UNDO.



oTable = new TTable(6).

oTable:colsWidthList="4,14,12,12,13,13".

oTable:addRow().
oTable:addCell("").
oTable:addCell("����� ����窨 ��").
oTable:addCell("��� ����୨��樨").
oTable:addCell("�㬬� ����୨��樨").
oTable:addCell("���祭�� ���.४����� �㬬�����").
oTable:addCell("���祭�� ���.४����� �㬬�������").
oTable:SetAlign(1,1,"Center").
oTable:SetAlign(2,1,"Center").
oTable:SetAlign(3,1,"Center").
oTable:SetAlign(4,1,"Center").
oTable:SetAlign(5,1,"Center").
oTable:SetAlign(6,1,"Center").



{getdate.i}

{init-bar.i "��ࠡ�⪠ ������஢"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.


for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK:

         /* ������ ��ப� - �������� ࠡ��� ����� */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    for each loan-acct where loan-acct.acct-type = "��-���-���" 
			   and loan-acct.contract = loan.contract 
			   and loan-acct.cont-code = loan.cont-code NO-LOCK:
	 for each op-entry where (op-entry.acct-db = loan-acct.acct)
			      and op-entry.op-date <= end-date NO-LOCK,
	       FIRST op where op.op = op-entry.op
                          and CAN-DO("7012b2*",op.op-kind) NO-LOCK:	

                        count = count + 1.

			oTable:addRow().
			oTable:addCell(count).
			oTable:addCell(loan.cont-code).
			oTable:addCell(op.op-date).
			oTable:addCell(op-entry.amt-rub).
			oTable:addCell(GetXattrValue("Loan",loan.contract + "," + loan.cont-code,"�㬬�����")).
			oTable:addCell(GetXattrValue("Loan",loan.contract + "," + loan.cont-code,"�㬬�������")).


	end.
    END.

 vLnCountInt = vLnCountInt + 1.


END.


{setdest.i}
oTable:show().
{preview.i}

DELETE OBJECT oTable.
