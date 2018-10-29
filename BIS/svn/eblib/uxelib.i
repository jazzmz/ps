/* ------------------------------------------------------
     File: $RCSfile: uxelib.i,v $ $Revision: 1.4 $ $Date: 2009-03-25 08:52:17 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: �������� �㭪樮��� ��� �ᯮ�� ������ � �ଠ� XML:Excel
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠: 
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.3  2008/04/29 09:48:23  Buryagin
     ���������: Fix the Style tag with the font type (Bold, Italic)
     ���������:
     ���������: Revision 1.2  2007/12/13 14:57:49  buryagin
     ���������: Added new function
     ���������:
------------------------------------------------------ */

/** 
		��饥:
		
			�� �㭪樨 ������ ������⥪� �������� ��ப��� ���祭��, ᮤ���騥 xml-���, �����஢���� ���
			��� ��ࠡ�⪨ �ணࠬ��� Excel.
			���㬥�� XML:Excel �᫮��� ����� ᫥������ ��������:
				<Workbook>
					...
					<Styles>
						<Style ss:ID = "..."> ... </Style>
						...
					</Styles>
					<Worksheet ss:Name = "...">
						<Column ... />
						<Column ... />
						...
						<Row>
							<Cell ... ss:StyleID="..." ...> ... </Cell>
							<Cell ... ss:StyleID="..." ...> ... </Cell>
							...
						</Row>
						<Row>
							...
						</Row>
						...
					</Worksheet>
					<Worksheet ss:Name = "...">
					</Worksheet>
				</Workbook>
				
			�.�. �ᯮ�짮����� �㭪権 �����饩 ������⥪� � 楫�� ᮧ����� ��⮢��� ���㬥�� ���ࠧ㬥���� 
			�� �����᪨ �ࠢ����� ��᫥����⥫쭮��� �맮���.

		���᮪ �㭪権:

			CreateExcelStyle(alignmentHorisontal, alignmentVertical, borderWidth, id)
			CreateExcelStyleEx(id, alignmentHorisontal, alignmentVertical, borderWidth, fontColor, fontType, bgColor) - ���� ��� ���ᠭ�� : fontType = set{B,I,U}
			CreateExcelWorkbook(styles)
			CreateExcelWorksheet(name)
			CreateExcelWorksheet(name, fixedTopRows, fixedLeftColumns) - ���� ��� ���ᠭ��
			CreateExcelRow(cells) 
			CreateExcelCell(dataType, styleId, data)
			CreateExcelCellEx(columnIndex, dataType, styleId, formula, data)
			CreateExcelCellEx2(columnIndex, mergeAcross, mergeDown, dataType, styleId, formula, data) - ���� ��� ���ᠭ��
			SetExcelColumnWidth(columnIndex, width)
			CloseExcelTag(tagName)
			
		���ᠭ��:
		
			-----------------------------------------------------------------------------------------------
			
			CreateExcelStyle(alignmentHorisontal:char, alignmentVertical:char, borderWidth:int, id:char) : char
			
				alignmentHorisontal - {"Center" | "Left" | "Right"} - ��ਧ��⠫쭮� �ᯮ������� ������ � �祩��
				alignmentVertical   - {"Center" | "Top" | "Bottom"} - ���⨪��쭮� �ᯮ������� ������ � �祩��
				borderWidth - ⮫騭� �࠭��� �祩��
				id - �����䨪��� �⨫�
			
			�����頥� XML:Excel:Style ���������, ����뢠���� �⨫�.
						
			�ਬ��: 
				...
				stylesXmlCode = CreateExcelStyle("Center", "Center", 2, "title1")
				              + CreateExcelStyle("Left", "Center", 1, "textval").
				PUT UNFORMATTED CreateExcelWorkbook(stylesXmlCode).
				...
				PUT UNFORMATTED CloseExcelTag("Workbook").
				...	
			-----------------------------------------------------------------------------------------------
			
			CreateExcelWorkbook(styles:char) : char
			
				styles - XML:Excel ���, ����뢠�騩 �⨫�
				
			�����頥� ���뢠�騩 ⥣ XML:Excel:Workbook, ����뢠�騩 ����� � ������묨 �᭮��묨 
			����ன����. �ਬ�� �. ��� �㭪樨 CreateExcelStyle()
			-----------------------------------------------------------------------------------------------
			
			CreateExcelWorksheet(name:char) : char
				
				name - ������������ ����
				
			�����頥� ���뢠�騩 ⥣ XML:Excel:Worksheet, ����뢠�騩 �⠭��� ࠡ�祩 �����.
			
			�ਬ��:
				... 
				PUT UNFORMATTED CreateExcelWorksheet("����1").
				...
				PUT UNFORMATTED CloseExcelTag("Worksheet").
				...
			-----------------------------------------------------------------------------------------------
			
			CreateExcelRow(cells:char) : char
				
				cells - XML:Excel ���, ����뢠�騩 �祩�� ��ப�
				
			�����頥� ��������� XML:Excel:Row, �।�⠢������ ᮡ�� ���ᠭ�� ��ப� � ����묨.
			
			�ਬ��:
				...
				PUT UNFORMATTED CreateExcelRow(
														CreateExcelCell("String", "style1", "���� �㯪��") +
														CreateExcelCell("Number", "style2", "12000") 
												).
				...
			-----------------------------------------------------------------------------------------------

			CreateExcelCell(dataType:char, styleID:char, data:char) : char
				
				dataType - {"String" | "Number"} - ⨯ ������
				styleID - ᨬ����� �����䨪��� �⨫�, ������� �㭪樥� CreateExcelStyle()
				data - �����, �⮡ࠦ���� � �祩��
				
			�����頥� ��������� XML:Excel:Cell, ����뢠���� �祩�� � �� ᮤ�ন���. �ਬ�� �.
			��� �㭪樨 CreateExcelRow. �ਬ�� �ᯮ�짮����� �⨫�� � ������ �㭪樨 �ਢ���� ���
			�㭪樨 CreateExcelCellEx()
			-----------------------------------------------------------------------------------------------
			
			CreateExcelCellEx(columnIndex:int, dataType:char, styleID:char, formula:char, data:char) : char
			
				columnIndex - ������ ����� �⮫�� � ��ப�
				dataType - {"String" | "Number"} - ⨯ ������
				styleID - ᨬ����� �����䨪��� �⨫�, ������� �㭪樥� CreateExcelStyle()
				formula - ��㫠, �������� ���祭�� �祩��, �������� �� �ࠢ���� Excel.
				data - �����, �⮡ࠦ���� � �祩��
			
			�����頥� ��������� XML:Excel:Cell, ����뢠���� �祩�� � �� ᮤ�ন���. �� �ࠢ����� � �㭪樥�
			CreateExcelCell() ����� ���७�� ����� �室��� ��ࠬ��஢. 
			����७��� ᨭ⠪�� ��� Excel �룫廊� ⠪:
				��뫪� �� �祩�� �������� ���� 楫��᫥��묨 ���न��⠬� R (��ப�) � � (�⮫���)
				c 㪠������ ��᮫�⭮�� ��� �⭮�⥫쭮�� ���祭��. ��᮫��� ���न���� �����뢠���� ��
				ᠬ�� ����� ���孥� �祩��, �⭮�⥫�� - �� �祩��, ��� ���ன ��।������ ��㫠.
					�ਬ�� ��᮫�⭮�:     R1�1, R4C20
					�ਬ�� �⭮�⥫쭮�:  R[0]C4, R[0]C[-1], R340C[5]
				
				�������� �祥� �������� ���� ࠧ������묨 �����稥� ���न��⠬� ��⨢��������� 㣫�� 
				��אַ㣮�쭨��, ����� ��ࠧ�� ����� ��������
				
				�� �㭪樨 Excel ⮫쪮 �� ������᪮�
					���� - SUM(<��������>)
					
			�ਬ��:
				...
				// ������ �⨫�
				styleXmlCode = CreateExcelStyle("Center", "Center", 2, "title1") +
				               CreateExcelStyle("Left", "Center", 1, "cell1").
				// ������ �����
				PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
				// ������ ����
				PUT UNFORMATTED CreateExcelWorksheet("����1").
				
				PUT UNFORMATTED 
						
						// ������ �ਭ� �⮫�殢 
						SetExcelColumnWidth(1, 100) +
						SetExcelColumnWidth(2, 200) + 
						SetExcelColumnWidth(3, 250) +

						// �뢮��� �������� ���� 
						CreateExcelRow(
							CreateExcelCell("String", "", "�������� ���� � ⮬� ��������...")
						) +
						
						// �뢮��� ��������� ����
						CreateExcelRow(
							CreateExcelCell("String", "title1", "����� �/�") +
							CreateExcelCell("String", "title1", "���") +
							CreateExcelCell("String", "title1", "�㬬�") +
							CreateExcelCell("String", "title1", "���").
				
				// �뢮��� ᠬ� ����� ��� �����ன ⠡���� ttClient
				DO i = 1 TO count :
					PUT UNFORMATTED CreateExcelRow(
						CreateExcelCell("Number", "cell1", STRING(i)) +
						CreateExcelCell("String", "cell1", ttClient.fio) +
						CreateExcelCell("Number", "cell1", STRING(ttClient.amount)) +
						CreateExcelCellEx(4, "Number", "cell1", "=R[0]C[-1]/100*18", "0")
					). 
				END.
				
				// ����뢠�� ⥣�
				PUT UNFORMATTED CloseExcelTag("Worksheet").
				PUT UNFORMATTED CloseExcelTag("Workbook").
				...
			-----------------------------------------------------------------------------------------------
			
			SetExcelColumnWidth(columnIndex:int, width:int) : char
				
				columnIndex - ����� �⮫��
				width - �ਭ� �⮫��
				
			�����頥� ��������� XML:Excel:Column, �������� �ਭ� �⮫��. �ਬ�� �. ��� �㭪樨
			CreateExcelCellEx().
			-----------------------------------------------------------------------------------------------
			
			CloseExcelTag(tagName:char) : char
			
				tagName - {"Workbook" | "Worksheet"} - ��� ����뢠����� ⥣�
				
			�����頥� ����뢠�騩 ⥣. �ਬ�� �. ��� �㭪樨 CreateExcelCellEx().
			
*/

/** =============================================================================================*/

FUNCTION CreateExcelWorkbook RETURNS CHAR (
	INPUT styles AS CHAR).
	
	DEF VAR cr AS CHAR.
	cr = CHR(13) + CHR(10).
	
	RETURN '<?xml version="1.0"?>' + cr
	        + '<?mso-application progid="Excel.Sheet"?>' + cr
	        + '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:html="http://www.w3.org/TR/REC-html40">' + cr

					+ ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>' + USERID + '</Author>
  <LastAuthor>' + USERID + '</LastAuthor>
  <Created>' + STRING(TODAY, "9999-99-99") + 'T' + STRING(TIME, 'HH:MM:SS') + 'Z</Created>
  <Company>' + CODEPAGE-CONVERT(FGetSetting('����','',''), "utf-8", SESSION:CHARSET) + '</Company>
  <Version>11.5606</Version>
 </DocumentProperties> ' + cr
 
	        + '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>11130</WindowHeight>
  <WindowWidth>15180</WindowWidth>
  <WindowTopX>480</WindowTopX>
  <WindowTopY>120</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>' + cr
 
 					+ '<Styles>' + cr + styles + cr + '</Styles>' + cr.
END FUNCTION.

/** =============================================================================================*/

FUNCTION CloseExcelTag RETURNS CHAR (INPUT tag AS CHAR).
	CASE tag:
		WHEN "Worksheet" THEN
			RETURN "</Table>" + CHR(13) + CHR(10) + "</" + tag + ">" + CHR(13) + CHR(10).
		OTHERWISE
			RETURN "</" + tag + ">" + CHR(13) + CHR(10).
	END.
END FUNCTION.

/** ============================================================================================*/

FUNCTION CreateExcelWorksheetEx RETURNS CHAR (
	INPUT name AS CHAR,
	INPUT fixedTopRows AS INTEGER,
	INPUT fixedLeftColumns AS INTEGER).
	
	DEF VAR cr AS CHAR.
	cr = CHR(13) + CHR(10).
	
	RETURN '<Worksheet ss:Name="' + CODEPAGE-CONVERT(name, "utf-8", SESSION:CHARSET) + '">' + cr
	        + '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"
     x:Right="0.78740157499999996" x:Top="0.984251969"/>
   </PageSetup>' +
   (IF fixedLeftColumns + fixedTopRows > 0 THEN '<FreezePanes/><FrozenNoSplit/>' ELSE '') +
   (IF fixedTopRows > 0 THEN '<SplitHorizontal>' + STRING(fixedTopRows) + '</SplitHorizontal><TopRowBottomPane>' + STRING(fixedTopRows) + '</TopRowBottomPane>' ELSE '') +
   (IF fixedLeftColumns > 0 THEN '<SplitVertical>' + STRING(fixedLeftColumns) + '</SplitVertical><LeftColumnRightPane>' + STRING(fixedLeftColumns) + '</LeftColumnRightPane>' ELSE '') +
   '<ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>' + cr
  				+ '<Table>' + cr.
END FUNCTION.

FUNCTION CreateExcelWorksheet RETURNS CHAR (
		INPUT name AS CHAR).
		
		RETURN CreateExcelWorksheetEx(name, 0, 0).
		
END FUNCTION.

/** =============================================================================================*/

FUNCTION SetExcelColumnWidth RETURNS CHAR (INPUT idx AS INTEGER, INPUT w AS DECIMAL).
	RETURN '<Column ss:AutoFitWidth="0" ss:Index="' + STRING(idx) + '" ss:Width="' + STRING(w) + '"/>' + CHR(13) + CHR(10).
END FUNCTION.

/** =============================================================================================*/

FUNCTION CreateExcelRow RETURN CHAR (INPUT cells AS CHAR).
	
	DEF VAR cr AS CHAR.
	cr = CHR(13) + CHR(10).
	
	RETURN '<Row>' + cr + cells + cr + '</Row>' + cr.
	
END FUNCTION.

/** =============================================================================================*/

FUNCTION CreateExcelCellEx2 RETURN CHAR (
	INPUT idx AS INTEGER,
	INPUT mAcross AS INTEGER,
	INPUT mDown AS INTEGER,
	INPUT type AS CHAR,
	INPUT styleID AS CHAR,
	INPUT formula AS CHAR,
	INPUT val AS CHAR).
	
	DEF VAR cr AS CHAR.
	cr = CHR(13) + CHR(10).
	
	IF val = ? THEN val = "".
	IF type = "number" AND val = "" THEN val = "0".	
	
	RETURN '<Cell' 
					+ (IF idx > 0 THEN ' ss:Index="' + STRING(idx) + '"' ELSE '') 
					+ (IF mAcross > 0 THEN ' ss:MergeAcross="' + STRING(mAcross) + '"' ELSE '')
					+ (IF mDown > 0 THEN ' ss:MergeDown="' + STRING(mDown) + '"' ELSE '')
					+ (IF TRIM(styleID) <> "" THEN ' ss:StyleID="' + styleID + '"' ELSE '') 
					+ (IF TRIM(formula) <> "" THEN ' ss:Formula="' + formula + '"' ELSE '') 
					+ '><Data ss:Type="' + type 
					+ '">' + REPLACE(REPLACE(REPLACE(CODEPAGE-CONVERT(val,"utf-8",SESSION:CHARSET),"<","&lt;"),">","&gt;"), "&", "&amp;") + '</Data></Cell>' + cr.

END FUNCTION.


FUNCTION CreateExcelCellEx RETURN CHAR (
	INPUT idx AS INTEGER,
	INPUT type AS CHAR,
	INPUT styleID AS CHAR,
	INPUT formula AS CHAR,
	INPUT val AS CHAR).
	
	RETURN CreateExcelCellEx2(idx, 0, 0, type, styleID, formula, val).
	
END FUNCTION.

FUNCTION CreateExcelCell RETURN CHAR (
	INPUT type AS CHAR,
	INPUT styleID AS CHAR,
	INPUT val AS CHAR).
	
	RETURN CreateExcelCellEx(0, type, styleID, "", val).
	
END FUNCTION.

/** =============================================================================================*/

FUNCTION CreateExcelStyleEx RETURNS CHAR (
	INPUT id AS CHAR,
	INPUT ah AS CHAR,
	INPUT av AS CHAR,
	INPUT borderWidth AS INTEGER,
	INPUT fColor AS CHAR,
	INPUT fType AS CHAR,
	INPUT bgColor AS CHAR
	).
	
	IF fColor = "" THEN fColor = "#000000".
	
	RETURN '  <Style ss:ID="' + id + '">
   		<Alignment ss:Horizontal="' + ah + '" ss:Vertical="' + av + '" ss:WrapText="1"/>
		  <Borders>
    		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="' + STRING(borderWidth) + '"/>
    		<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="' + STRING(borderWidth) + '"/>
    		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="' + STRING(borderWidth) + '"/>
    		<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="' + STRING(borderWidth) + '"/>
   		</Borders>
   		<Font ss:FontName="Arial Cyr" x:CharSet="204" ss:Color="' + fColor 
   			+ '" ss:Bold="' + STRING(IF INDEX(CAPS(fType), "B") > 0 THEN 1 ELSE 0) 
   			+ '" ss:Italic="' + STRING(IF INDEX(CAPS(fType), "I") > 0 THEN 1 ELSE 0)
   			+ '" ' + (IF INDEX(CAPS(fType), "U") > 0 THEN 'ss:Underline="Single" ' ELSE '') 
   			+ '/>'
   		+ (IF bgColor <> "" THEN '<Interior ss:Color="' + bgColor + '" ss:Pattern="Solid"/>' ELSE '')
   		+ '</Style>' + CHR(13) + CHR(10).

END FUNCTION.

FUNCTION CreateExcelStyle RETURNS CHAR (
	INPUT ah AS CHAR,
	INPUT av AS CHAR,
	INPUT borderWidth AS INTEGER,
	INPUT id AS CHAR).
	
	RETURN CreateExcelStyleEx(id, ah, av, borderWidth, "", "", "").
	
END FUNCTION.

/** =============================================================================================*/