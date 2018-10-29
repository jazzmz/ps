/*инклюд для вывода в XLS отчета по связанным клиентам (для вкладчиков) s*.XLS
автор: Красков А.С.*/

FUNCTION XLHead0 RETURNS CHAR: 
DEF VAR ret_str as CHAR.


ret_str = "<?xml version=""1.0""?>" + CHR(10) +
"<?mso-application progid=""Excel.Sheet""?>" + CHR(10) +
"<?fr-application created=""FastReport""?>" + CHR(10) +
"<?fr-application homesite=""http://www.fast-report.com""?>" + CHR(10) +
"<Workbook xmlns=""urn:schemas-microsoft-com:office:spreadsheet""" + CHR(10) +
" xmlns:o=""urn:schemas-microsoft-com:office:office""" + CHR(10) +
" xmlns:x=""urn:schemas-microsoft-com:office:excel""" + CHR(10) +
" xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet""" + CHR(10) +
" xmlns:html=""http://www.w3.org/TR/REC-html40"">" + CHR(10) +
"<DocumentProperties xmlns=""urn:schemas-microsoft-com:office:office"">" + CHR(10) +
"<Title></Title>" + CHR(10) +
"<Author></Author>" + CHR(10) +
"<Created>01.11.2013T16:11:52Z</Created>" + CHR(10) +
"<Version>...</Version>" + CHR(10) +
"</DocumentProperties>" + CHR(10) +
"<ExcelWorkbook xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10) +
"<ProtectStructure>False</ProtectStructure>" + CHR(10) +
"<ProtectWindows>False</ProtectWindows>" + CHR(10) +
"</ExcelWorkbook>" + CHR(10) +
"<Styles>" + CHR(10) +
"<Style ss:ID=""s0"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s1"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""14"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s2"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#FF0000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#000080"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s3"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#A6CAF0"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s4"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#A0A0A4"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s5"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#A0A0A4"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s6"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#A0A0A4"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>".

return ret_str.

END FUNCTION.



FUNCTION XLHead RETURNS CHAR (Input iAllRows as Int): 
DEF VAR ret_str as CHAR.


ret_str = "<Style ss:ID=""s7"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#A0A0A4"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s8"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s9"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s10"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"<NumberFormat ss:Format=""0.00""/>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s11"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +                                                                                      
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s12"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""8"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#00FFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Bottom"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s13"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""8"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#00FFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"<NumberFormat ss:Format=""0.00""/>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s14"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) + 
"<Style ss:ID=""s15"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s16"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s17"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""8"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#FFFF00"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"<NumberFormat ss:Format=""0.00""/>" + CHR(10) +
"</Style>" + CHR(10) +
"<Style ss:ID=""s18"">" + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""9"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#FFFF00"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" />" + CHR(10) +
"<Borders>" + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />" + CHR(10) +
"</Borders>" + CHR(10) +
"</Style>" + CHR(10) +
"</Styles>" + CHR(10) +
"<Worksheet ss:Name=""Page 1"">" + CHR(10) +
"<Table ss:ExpandedColumnCount=""11"" ss:ExpandedRowCount=""|AllRows|"" x:FullColumns=""1"" x:FullRows=""1"">" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""16.48""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""112.62""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""24.72""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""21.97""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""82.40""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""19.23""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""68.67""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""63.18""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""24.72""/>" + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""88.11""/>".   

ret_str = REPLACE(ret_str,"|AllRows|",STRING(iAllRows * 2)).

RETURN ret_str.

END FUNCTION.

FUNCTION XLTitle RETURNS CHAR (INPUT iDate as Date):
DEF VAR ret_str as CHAR.

ret_str = "<Row ss:Height=""19.23"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""9"" ss:StyleID=""s1"" >" + CHR(10) +
          "<Data ss:Type=""String"">Отчет по взаимосвязанным вкладчикам за |iDate|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>".


    ret_str = REPLACE(ret_str,"|iDate|",STRING(iDate)).

RETURN ret_str.

END FUNCTION.

FUNCTION XLSubTitle RETURNS CHAR (INPUT GroupId as CHAR):
DEF VAR ret_str as CHAR.


ret_str = "<Row ss:Height=""9.37"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""2"" ss:MergeDown=""2"" ss:StyleID=""s2"" >" + CHR(10) +
          "<Data ss:Type=""String"">Группа |GroupID|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""4"" ss:MergeAcross=""2"" ss:StyleID=""s4"" >" + CHR(10) +
          "<Data ss:Type=""String"">ФИО Руководителя</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""7"" ss:MergeAcross=""3"" ss:StyleID=""s5"" >" + CHR(10) +
          "<Data ss:Type=""String"">Учредители</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>" + CHR(10) +
          "<Row ss:Height=""0.89"">" + CHR(10) +
          "<Cell ss:Index=""4"" ss:MergeAcross=""6"" ss:StyleID=""s0"" >" + CHR(10) +
          "<Data ss:Type=""String""></Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>" + CHR(10) +
          "<Row ss:Height=""8.72"">" + CHR(10) +
          "<Cell ss:Index=""4"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s3"" >" + CHR(10) +
          "<Data ss:Type=""String"">Счет</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""6"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s3"" >" + CHR(10) +
          "<Data ss:Type=""String"">Рубли</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""8"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s3"" >" + CHR(10) +
          "<Data ss:Type=""String"">Валюта</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""10"" ss:MergeDown=""1"" ss:StyleID=""s3"" >" + CHR(10) +
          "<Data ss:Type=""String"">Всего в рублях</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>" + CHR(10) +
          "<Row ss:Height=""0.65"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""2"" ss:StyleID=""s0"" >" + CHR(10) +
          "<Data ss:Type=""String""></Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>".


ret_str = REPLACE(ret_str,"|GroupID|",GroupId).


RETURN ret_str.

END FUNCTION.

FUNCTION XLAddClientRow RETURNS CHAR (INPUT Count AS INT, INPUT Name as CHAR, INPUT GVK as CHAR, INPUT RukName as CHAR, INPUT Uchred as CHAR):
DEF VAR ret_str as CHAR no-undo.

def var RowHeight as dec no-undo.

ret_str = "<Row ss:Height=""|RowHeight|""> " + CHR(10) +
          "<Cell ss:Index=""1"" ss:StyleID=""s7"" > " + CHR(10) +
          "<Data ss:Type=""String"">|Count|</Data> " + CHR(10) +
          "</Cell> " + CHR(10) +
          "<Cell ss:Index=""2"" ss:StyleID=""s6"" > " + CHR(10) +
          "<Data ss:Type=""String"">|Name|</Data> " + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""3"" ss:StyleID=""s6"" >" + CHR(10) +
          "<Data ss:Type=""String"">|GVK|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""4"" ss:MergeAcross=""2"" ss:StyleID=""s6"" >" + CHR(10) +
          "<Data ss:Type=""String"">|RukName|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""7"" ss:MergeAcross=""3"" ss:StyleID=""s6"" >" + CHR(10) +
          "<Data ss:Type=""String"">|Uchred|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>".

ret_str = REPLACE(ret_str,"|Count|",STRING(Count)).
ret_str = REPLACE(ret_str,"|Name|",Name).
ret_str = REPLACE(ret_str,"|GVK|",GVK).
ret_str = REPLACE(ret_str,"|RukName|",RukName).
ret_str = REPLACE(ret_str,"|Uchred|",Uchred).

RowHeight = MAX(LENGTH(Name) / 27,LENGTH(RukName) / 30,LENGTH(Uchred) / 60).
if RowHeight > 1 then  RowHeight = ROUND(RowHeight,0) * 10.17. else RowHeight = 10.17.
ret_str = REPLACE(ret_str,"|RowHeight|",STRING(RowHeight)).

RETURN ret_str.

END FUNCTION.

FUNCTION XLAddAcctRow RETURNS CHAR (INPUT cAcct as CHAR, INPUT dAmt-rub as DEC, INPUT dAmt-cur as dec, INPUT dAmt-all as dec):

DEF VAR ret_str as CHAR no-undo.

ret_str = "<Row ss:Height=""8.24"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""2"" ss:StyleID=""s11"" >" + CHR(10) +
          "<Data ss:Type=""String""></Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""4"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s8"" >" + CHR(10) +
          "<Data ss:Type=""String""> |acct|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""6"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s9"" >" + CHR(10) +
          "<Data ss:Type=""Number"">|Amt-rub|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""8"" ss:MergeAcross=""1"" ss:MergeDown=""1"" ss:StyleID=""s9"" >" + CHR(10) +
          "<Data ss:Type=""Number"">|Amt-cur|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""10"" ss:MergeDown=""1"" ss:StyleID=""s10"" >" + CHR(10) +
          "<Data ss:Type=""Number"">|Amt-all|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>" + CHR(10) +
          "<Row ss:Height=""1.93"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""2"" ss:StyleID=""s0"" >" + CHR(10) +
          "<Data ss:Type=""String""></Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""11"" />" + CHR(10) +
          "</Row>".

ret_str = REPLACE(ret_str,"|acct|",cAcct).
ret_str = REPLACE(ret_str,"|Amt-rub|",TRIM(STRING(dAmt-rub,"->>>>>>>>>>>>>>9.99"))).
ret_str = REPLACE(ret_str,"|Amt-cur|",TRIM(STRING(dAmt-cur,"->>>>>>>>>>>>>>9.99"))).
ret_str = REPLACE(ret_str,"|Amt-all|",TRIM(STRING(dAmt-all,"->>>>>>>>>>>>>>9.99"))).


RETURN ret_str.

END FUNCTION.

FUNCTION XLAddTotalByClient RETURNS CHAR (INPUT TotalAmt as DEC):
DEF VAR ret_str as CHAR no-undo.

ret_str = 
"<Row ss:Height=""9.34"">" + CHR(10) +
"<Cell ss:Index=""1"" ss:MergeAcross=""2"" ss:StyleID=""s14"" >" + CHR(10) +
"<Data ss:Type=""String""></Data>" + CHR(10) +
"</Cell>" + CHR(10) +
"<Cell ss:Index=""4"" ss:MergeAcross=""5"" ss:StyleID=""s12"" >" + CHR(10) +
"<Data ss:Type=""String"">Всего по клиенту : </Data>" + CHR(10) +
"</Cell>" + CHR(10) +
"<Cell ss:Index=""10"" ss:StyleID=""s13"" >" + CHR(10) +
"<Data ss:Type=""Number"">|TotalAmt|</Data>" + CHR(10) +
"</Cell>" + CHR(10) +
"<Cell ss:Index=""11"" />" + CHR(10) +
"</Row>".


ret_str = REPLACE(ret_str,"|TotalAmt|",TRIM(STRING(TotalAmt,"->>>>>>>>>>>>>>9.99"))).


RETURN ret_str.

END FUNCTION.

FUNCTION XLAddTotalByGroup RETURNS CHAR (INPUT TotalAmt as DEC):
DEF VAR ret_str as CHAR no-undo.

ret_str = "<Row ss:Height=""10.99""> " + CHR(10) +
"<Cell ss:Index=""1"" ss:MergeAcross=""8"" ss:StyleID=""s18"" > " + CHR(10) +
"<Data ss:Type=""String"">Всего по группе : </Data> " + CHR(10) +
"</Cell> " + CHR(10) +
"<Cell ss:Index=""10"" ss:StyleID=""s17"" > " + CHR(10) +
"<Data ss:Type=""Number"">|TotalAmt|</Data> " + CHR(10) +
"</Cell> " + CHR(10) +
"<Cell ss:Index=""11"" /> " + CHR(10) +
"</Row>".


ret_str = REPLACE(ret_str,"|TotalAmt|",TRIM(STRING(TotalAmt,"->>>>>>>>>>>>>>9.99"))).

RETURN ret_str.

END FUNCTION.


FUNCTION XLFoot RETURNS CHAR:
DEF VAR ret_str as CHAR.
ret_str = "</Table>" + CHR(10) +
          "<WorksheetOptions xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10) +
          "<PageSetup>" + CHR(10) +
          "<PageMargins x:Bottom=""0.38"" x:Left=""0.38"" x:Right=""0.38"" x:Top=""0.38""/>" + CHR(10) +
          "</PageSetup>" + CHR(10) +
          "</WorksheetOptions>" + CHR(10) +
          "</Worksheet>" + CHR(10) +
          "</Workbook>".

RETURN ret_str.

END FUNCTION.


