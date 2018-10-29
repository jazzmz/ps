/* ------------------------------------------------------
     File: $RCSfile: piramexel1.p,v $ $Revision: 1.3 $ $Date: 2008-08-18 12:00:05 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: ��ᯮ�� ������ � �ଠ�e XML:Excel
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠: 
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.2  2008/04/28 14:32:25  Buryagin
     ���������: Added the bottom signs
     ���������:
     ���������: Revision 1.1  2008/04/28 13:38:53  Buryagin
     ���������: *** empty log message ***
     ���������:
------------------------------------------------------ */

{globals.i}
{get-bankname.i}

/** �㭪樨 ��� ᮧ����� XML:Excel 䠩��� */
{uxelib.i}

DEFINE TEMP-TABLE ttReport
	FIELD isin AS CHAR
	FIELD emit AS CHAR
	FIELD type AS CHAR
	FIELD deal AS CHAR
	FIELD ddate AS DATE
	FIELD currency AS CHAR
	FIELD price AS DECIMAL
	FIELD count AS INTEGER
	FIELD amount AS DECIMAL
	FIELD comBankWithNDS AS DECIMAL
	FIELD comBankWithoutNDS AS DECIMAL
	FIELD comTSWithNDS AS DECIMAL
	FIELD comTSWithoutNDS AS DECIMAL
	FIELD comAllWithoutNDS AS DECIMAL
	FIELD org AS CHAR
	FIELD orgDate AS DATE
	FIELD min AS DECIMAL
	FIELD max AS DECIMAL
	FIELD avg AS DECIMAL
	
	INDEX mainIndex isin type ddate 
	.

DEF VAR periodBegin AS DATE NO-UNDO.
DEF VAR periodEnd AS DATE NO-UNDO.	
DEF VAR fileName AS CHAR NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR xmlCode AS CHAR NO-UNDO.
DEF VAR subTotal AS DECIMAL EXTENT 17 NO-UNDO.
DEF VAR total AS DECIMAL EXTENT 17 NO-UNDO.

fileName = "/home/bis/quit41d/imp-exp/users/" + lc(userid) + "/piramexel.xml".

{getdates.i}

periodBegin = beg-date.
periodEnd = end-date.

/** ���� ������ */
FOR EACH DataBlock WHERE
    DataBlock.DataClass-Id = "piranalmm1"
    AND
    DataBlock.beg-date >= periodBegin
    AND
    DataBlock.end-date <= periodEnd
    AND
    DataBlock.beg-date = DataBlock.end-date
    NO-LOCK,
    EACH DataLine OF DataBlock NO-LOCK
  :

	CREATE ttReport.
	ttReport.isin = DataLine.Sym4.
	ttReport.emit = ENTRY(1, DataLine.Txt, "~n"). 
	ttReport.type = DataLine.Sym2.
	ttReport.deal = DataLine.Sym1.
	ttReport.ddate = DATE(DataLine.Sym3).
	ttReport.currency = "��".
	ttReport.price = DEC(DataLine.Val[1]).
	ttReport.count = DEC(DataLine.Val[2]).
	ttReport.amount = DEC(DataLine.Val[3]).
	ttReport.comBankWithNDS = DEC(DataLine.Val[4]).
	ttReport.comBankWithoutNDS = DEC(DataLine.Val[5]).
	ttReport.comTSWithNDS = DEC(DataLine.Val[6]).
	ttReport.comTSWithoutNDS = DEC(DataLine.Val[7]).
	ttReport.comAllWithoutNDS = ttReport.comBankWithoutNDS + ttReport.comTSWithoutNDS.
	if NUM-ENTRIES(DataLine.Txt, "~n") > 1 then 
		ttReport.org = ENTRY(2, DataLine.Txt, "~n").
	if NUM-ENTRIES(DataLine.Txt, "~n") > 2 then
		ttReport.orgDate = DATE(ENTRY(3, DataLine.Txt, "~n")).
	ttReport.min = DEC(DataLine.Val[8]).
	ttReport.max = DEC(DataLine.Val[9]).
	ttReport.avg = DEC(DataLine.Val[10]).

END.

/** ��ᯮ�� � 䠩� */

OUTPUT TO VALUE(fileName).

PUT UNFORMATTED CreateExcelWorkbook(
									CreateExcelStyle("Center", "Center", 2, "t1") +
				          CreateExcelStyle("Right", "Center", 1, "c1") +
				          CreateExcelStyle("Left", "Center", 1, "c2") +
				          CreateExcelStyleEx("st1", "Right", "Center", 1, "", "B", "") +
				          CreateExcelStyleEx("isin", "Left", "Center", 1, "", "BI", "") +
				          CreateExcelStyleEx("h1", "Left", "Center", 0, "", "B", "") +
				          CreateExcelStyleEx("h2", "Center", "Center", 0, "", "B", "")
								).

PUT UNFORMATTED CreateExcelWorksheet("�������").

PUT UNFORMATTED SetExcelColumnWidth(1,50) +	SetExcelColumnWidth(2,70)	+	SetExcelColumnWidth(3,70) +
								SetExcelColumnWidth(4,50)	+	SetExcelColumnWidth(5,80)	+ SetExcelColumnWidth(6,80) +
								SetExcelColumnWidth(7,80)	+ SetExcelColumnWidth(8,80) +	SetExcelColumnWidth(9,80) +
								SetExcelColumnWidth(10,80) + SetExcelColumnWidth(11,80) +	SetExcelColumnWidth(12,80) +
								SetExcelColumnWidth(13,80) + SetExcelColumnWidth(14,80) +	SetExcelColumnWidth(15,80) +
								SetExcelColumnWidth(16,70) + SetExcelColumnWidth(17,80) +	SetExcelColumnWidth(18,80) +
								SetExcelColumnWidth(19,80) +
								
								CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "h1", '', cBankName) ) +
								CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "h1", '', '�. ��᪢�') ) +
								CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "h2", "", 
									"�������᪨� ॣ���� ���������� ��� �� " + STRING(TRUNCATE((MONTH(periodEnd) - 1) / 3, 0) + 1) + 
									' (����� ����⠫) ' + STRING(YEAR(periodEnd)) + '�.') ) +
								CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "h2", '', 
									'��� १���⮢ ॠ����樨 業��� �㬠� � ᮮ⢥��⢨� � ��.280 �� ��, ���������� �� ��饩 �⠢�� ������ �� �ਡ��') ) +
								CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "h1", "", "I. ����� �㬠��, �����騥�� �� �࣠���������� �뭪�") ) +
								CreateExcelRow(
									CreateExcelCellEx2(1, 6, 0, "String", "t1", '', "������") +
									CreateExcelCellEx2(8, 4, 0, "String", "t1", '', "�������") +
									CreateExcelCellEx2(13, 4, 0, "String", "t1", "", "���ଠ�� �� ���ࢠ�� 業 �� ���� ᮢ��蠭�� ᤥ��� �� �த���") 
								) + 	
								CreateExcelRow(
									CreateExcelCell("String", "t1", "���") +
									CreateExcelCell("String", "t1", "N ᤥ���") +
									CreateExcelCell("String", "t1", "��� ᤥ���") +
									CreateExcelCell("String", "t1", "���. ���./���. ���⥦") +
									CreateExcelCell("String", "t1", "����, ��.") +
									CreateExcelCell("String", "t1", "���-��, ��.") +
									CreateExcelCell("String", "t1", "�㬬�, ��.") +
									CreateExcelCell("String", "t1", "������� ����� � ���") +
									CreateExcelCell("String", "t1", "������� ����� ��� ���") +
									CreateExcelCell("String", "t1", "������� �� � ���") +
									CreateExcelCell("String", "t1", "������� �� ��� ���") +
									CreateExcelCell("String", "t1", "�����") +
									CreateExcelCell("String", "t1", "�࣠������ �࣮���") +
									CreateExcelCell("String", "t1", "���") +
									CreateExcelCell("String", "t1", "Min") +
									CreateExcelCell("String", "t1", "Max") +
									CreateExcelCell("String", "t1", "�뭮筠� 業�")
								).	


xmlCode = "".
DO i = 1 TO 17 :
  xmlCode = xmlCode + CreateExcelCell("String", "t1", STRING(i)).
END.
PUT UNFORMATTED CreateExcelRow(xmlCode).


FOR EACH ttReport USE-INDEX mainIndex NO-LOCK BREAK BY ttReport.isin BY ttReport.type :
	
	IF FIRST-OF(ttReport.isin) THEN 
		PUT UNFORMATTED
				CreateExcelRow( CreateExcelCellEx2(1, 16, 0, "String", "isin", "", ttReport.emit + "/" + ttReport.isin) ).
	
	xmlCode = CreateExcelCell("String", "c2", ttReport.type) +
	          CreateExcelCell("String", "c2", ttReport.deal) +
	          CreateExcelCell("String", "c1", STRING(ttReport.ddate, "99.99.9999") ) +
	          CreateExcelCell("String", "c1", ttReport.currency) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.price)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.count)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.amount)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.comBankWithNDS)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.comBankWithoutNDS)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.comTSWithNDS)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.comTSWithoutNDS)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.comAllWithoutNDS)) +
	          CreateExcelCell("String", "c2", ttReport.org) +
	          CreateExcelCell("String", "c1", STRING(ttReport.orgDate, "99.99.9999") ) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.min)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.max)) +
	          CreateExcelCell("Number", "c1", STRING(ttReport.avg)).
	
	          
	PUT UNFORMATTED	CreateExcelRow( xmlCode ).
	
	subTotal[7] = subTotal[7] + ttReport.amount.
	subTotal[12] = subTotal[12] + ttReport.comAllWithoutNDS.
	
	IF LAST-OF (ttReport.type) THEN DO:
	xmlCode = CreateExcelCell("String", "st1", "�����:") +
	          CreateExcelCell("String", "c2", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("Number", "st1", STRING(subTotal[7])) +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("Number", "st1", STRING(subTotal[12])) +
	          CreateExcelCell("String", "c2", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "") +
	          CreateExcelCell("String", "c1", "").
         
	PUT UNFORMATTED	CreateExcelRow( xmlCode ).
	subTotal[7] = 0.
	subTotal[12] = 0.
	
	END.
		
END.

PUT UNFORMATTED CreateExcelRow(CreateExcelCell("String", "c1", "")).
PUT UNFORMATTED CreateExcelRow(CreateExcelCell("String", "c1", "")).
PUT UNFORMATTED CreateExcelRow(CreateExcelCellEx2(1, 16, 0, "String", "h1", "", "������� �⢥��⢥����� �ᯮ���⥫�")).
PUT UNFORMATTED CloseExcelTag("Worksheet").
PUT UNFORMATTED CloseExcelTag("Workbook").    

OUTPUT CLOSE.

MESSAGE "����� �ᯮ��஢���� � 䠩� " + fileName VIEW-AS ALERT-BOX.