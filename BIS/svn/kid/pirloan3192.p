{globals.i}
{tmprecid.def}
{ulib.i}   

DEF VAR oTable  AS TTable    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR client_name AS CHAR INIT ""  NO-UNDO.
DEF VAR loaninf AS CHAR 	NO-UNDO.
DEF VAR tmpStr 	AS CHAR EXTENT 5 NO-UNDO.
DEF VAR summapr	AS CHAR 	NO-UNDO.
Def Var Month_Name As Char Initial
   "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������" NO-UNDO.
   
oTable = new TTable(2).
oTpl = new TTpl("pirloan3192.tpl").

FOR EACH tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK:
	if can-do("61301*",op-entry.acct-db) then do:
		FIND LAST loan-acct WHERE loan-acct.acct = op-entry.acct-db AND loan-acct.contract EQ "�।��" NO-LOCK NO-ERROR.
		if avail(loan-acct) then do:
			FIND LAST loan WHERE loan.contract  = loan-acct.contract 
	        			AND loan.cont-code = loan-acct.cont-code
					NO-LOCK NO-ERROR.   
			IF AVAIL loan THEN DO:
                                oTable:addRow().
				oTable:addCell("�㬬�").
				RUN x-amtstr.p(op-entry.amt-rub, "", true, true, output tmpStr[1], output tmpStr[2]).
                                summapr = tmpStr[1] + ' ' + tmpStr[2].
				oTable:addCell(string(op-entry.amt-rub,">>>,>>>,>>>,>>9.99") + " (" + summapr + ")").
                                oTable:addRow().
				oTable:addCell("�� ���").
				oTable:addCell(op-entry.acct-cr).
				client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
                                oTable:addRow().
				oTable:addCell("����騪").
				oTable:addCell(client_name).
                                oTable:addRow().
				oTable:addCell("����ᯮ�����᪨� ��� �").
				oTable:addCell(op-entry.acct-db).
				loaninf = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
                                oTable:addRow().
				oTable:addCell("�।��� �������").
				oTable:addCell(loaninf).
                                oTable:addRow().
				oTable:addCell("�����").
				oTable:addCell(if op-entry.currency eq "" then "810" else op-entry.currency).
                                oTable:addRow().
				oTable:addCell("��� ����樨").
				oTable:addCell("���᫥��� �������� �।�� �� ��室� � ��� ������ 
��業⮢ �� " + entry(MONTH(op-entry.op-date), Month_Name) + " " + string(YEAR(op-entry.op-date)) + " ���� ��⥭��� ࠭�� 
�� ��� ��室�� ����� ��ਮ���").
			end.
			else do:
				message "�� ��襫 ��� " + op-entry.acct-db + " � ������� loan" view-as alert-box.
				return.
			end.
		end.
		else do:
			message "�� ��襫 ��� " + op-entry.acct-db + " � ������� loan-acct" view-as alert-box.
			return.
		end.
	end.
	else do:
		message "��࠭ �� �� ���㬥��. ���㬥�� �� ������� �ᯮ�殮��� ������ � ����� ����� 61301*" view-as alert-box.
		return.
	end.

END.

oTpl:addAnchorValue("Date",op-entry.op-date).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
