/*®≠™´Ó§ §´Ô ¢Î¢Æ§† ¢ XLS Æ‚Á•‚† ØÆ ·¢Ôß†≠≠Î¨ ™´®•≠‚†¨ GROUP.XLS
†¢‚Æ‡: ä‡†·™Æ¢ Ä.ë.*/

FUNCTION XLHead RETURNS CHAR (Input iAllRows as Int):
DEF VAR ret_str as CHAR.

ret_str = "<?xml version=""1.0""?> " + CHR(10) +
"<?mso-application progid=""Excel.Sheet""?> " + CHR(10) +
"<?fr-application created=""FastReport""?> " + CHR(10) +
"<?fr-application homesite=""http://www.fast-report.com""?> " + CHR(10) +
"<Workbook xmlns=""urn:schemas-microsoft-com:office:spreadsheet"" " + CHR(10) +
" xmlns:o=""urn:schemas-microsoft-com:office:office"" " + CHR(10) +
" xmlns:x=""urn:schemas-microsoft-com:office:excel"" " + CHR(10) +
" xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet"" " + CHR(10) +
" xmlns:html=""http://www.w3.org/TR/REC-html40""> " + CHR(10) +
"<DocumentProperties xmlns=""urn:schemas-microsoft-com:office:office""> " + CHR(10) +
"<Title></Title> " + CHR(10) +
"<Author></Author> " + CHR(10) +
"<Created>01.11.2013T16:21:17Z</Created> " + CHR(10) +
"<Version>...</Version> " + CHR(10) +
"</DocumentProperties> " + CHR(10) +
"<ExcelWorkbook xmlns=""urn:schemas-microsoft-com:office:excel""> " + CHR(10) +
"<ProtectStructure>False</ProtectStructure> " + CHR(10) +
"<ProtectWindows>False</ProtectWindows> " + CHR(10) +
"</ExcelWorkbook> " + CHR(10) +
"<Styles>" + CHR(10) +
"<Style ss:ID=""s0""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000""/> " + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s1""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""14"" ss:Color=""#000000"" ss:Bold=""1""/>" + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"</Borders> " + CHR(10) + 
"</Style> " + CHR(10) +
"<Style ss:ID=""s2""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#0000FF"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#00FF00"" ss:Pattern=""Solid""/>" + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />  " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s3""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#C0DCC0"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s4""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#FFFF00"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s5""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000080"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#00FFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s6""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#FFFFFF"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#008080"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s7""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""9"" ss:Color=""#000000""/> " + CHR(10) +
"<Interior ss:Color=""#FFFBF0"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" />  " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s8""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""9"" ss:Color=""#000000""/> " + CHR(10) +
"<Interior ss:Color=""#C0C0C0"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"2<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s9""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""9"" ss:Color=""#000000"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#A6CAF0"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s10""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""9"" ss:Color=""#000000"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#FFFBF0"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Center"" ss:Vertical=""Center"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"<Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"<Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1"" ss:Color=""#000000"" /> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s11""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/> " + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s12""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""7"" ss:Color=""#000000""/> " + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Right"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"<Style ss:ID=""s13""> " + CHR(10) +
"<Font ss:FontName=""Arial"" ss:Size=""10"" ss:Color=""#000000"" ss:Bold=""1""/> " + CHR(10) +
"<Interior ss:Color=""#FFFFFF"" ss:Pattern=""Solid""/> " + CHR(10) +
"<Alignment ss:Horizontal=""Left"" ss:Vertical=""Top"" ss:WrapText=""1"" /> " + CHR(10) +
"<Borders> " + CHR(10) +
"</Borders> " + CHR(10) +
"</Style> " + CHR(10) +
"</Styles> " + CHR(10) +
"<Worksheet ss:Name=""Page 1""> " + CHR(10) +
"<Table ss:ExpandedColumnCount=""12"" ss:ExpandedRowCount=""|RowCounts|"" x:FullColumns=""1"" x:FullRows=""1""> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""46.69""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""35.71""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""30.21""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""109.87""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""24.72""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""123.60""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""2.75""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""65.92""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""27.47""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""24.72""/> " + CHR(10) +
"<Column ss:AutoFitWidth=""0"" ss:Width=""2.96""/> ".
ret_str = REPLACE(ret_str,"|RowCounts|",STRING(iAllRows * 2)).
RETURN ret_str.

END FUNCTION.

FUNCTION XLTitle RETURNS CHAR (INPUT iDate as Date):
DEF VAR ret_str as CHAR.

ret_str = "<Row ss:Height=""19.23"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""7"" ss:StyleID=""s1"" >" + CHR(10) +
          "<Data ss:Type=""String"">ëéëíÄÇ Éêìèè ÇáÄàåéëÇüáÄççõï äãàÖçíéÇ ß† |iDate|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""9"" ss:MergeAcross=""2"" ss:MergeDown=""60"" ss:StyleID=""s0"" >" + CHR(10) +
          "<Data ss:Type=""String""></Data>" + CHR(10) +
          "</Cell>" + CHR(10) +   
          "Cell ss:Index=""12"" />" + CHR(10) +
          "</Row>".

ret_str = REPLACE(ret_str,"|iDate|",STRING(iDate)).

RETURN ret_str.

END FUNCTION.

FUNCTION XLSubTitle RETURNS CHAR (INPUT GroupId as CHAR):
DEF VAR ret_str as CHAR.

ret_str = "<Row ss:Height=""13.73"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:StyleID=""s2"" >" + CHR(10) +
          "<Data ss:Type=""String"">ÉêìèèÄ</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""2"" ss:StyleID=""s4"" >" + CHR(10) +
          "<Data ss:Type=""String"">¸¸</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""3"" ss:MergeAcross=""3"" ss:StyleID=""s3"" >" + CHR(10) +
          "<Data ss:Type=""String"">ç†®¨•≠Æ¢†≠®•/îàé</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""7"" ss:MergeAcross=""1"" ss:StyleID=""s5"" >" + CHR(10) +
          "<Data ss:Type=""String"">ÉÇä</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""12"" />" + CHR(10) +
          "</Row>" + CHR(10) +
          "<Row ss:Height=""13.73"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:MergeAcross=""7"" ss:StyleID=""s6"" >" + CHR(10) +
          "<Data ss:Type=""String"">ÉêìèèÄ  |GroupID|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""12"" />" + CHR(10) +
          "</Row>".

ret_str = REPLACE(ret_str,"|GroupID|",GroupId).


RETURN ret_str.

END FUNCTION.

FUNCTION XLAddRow RETURNS CHAR (INPUT GroupId as CHAR, INPUT Count AS INT, INPUT Name as CHAR, INPUT GVK as CHAR):
DEF VAR ret_str as CHAR.

ret_str = "<Row ss:Height=""11.63"">" + CHR(10) +
          "<Cell ss:Index=""1"" ss:StyleID=""s10"" >" + CHR(10) +
          "<Data ss:Type=""String"">|GroupId|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""2"" ss:StyleID=""s8"" >" + CHR(10) +
          "<Data ss:Type=""String"">|Count|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""3"" ss:MergeAcross=""3"" ss:StyleID=""s7"" >" + CHR(10) +
          "<Data ss:Type=""String"">|Name|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""7"" ss:MergeAcross=""1"" ss:StyleID=""s9"" >" + CHR(10) +
          "<Data ss:Type=""String"">|GVK|</Data>" + CHR(10) +
          "</Cell>" + CHR(10) +
          "<Cell ss:Index=""12"" />" + CHR(10) +
          "</Row>".


ret_str = REPLACE(ret_str,"|GroupID|",GroupId).
ret_str = REPLACE(ret_str,"|Count|",STRING(Count)).
ret_str = REPLACE(ret_str,"|Name|",Name).
ret_str = REPLACE(ret_str,"|GVK|",GVK).


RETURN ret_str.

END FUNCTION.


FUNCTION XLFoot RETURNS CHAR:
DEF VAR ret_str as CHAR.

ret_str = "</Table>" + CHR(10) +
          "<WorksheetOptions xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10) +
          "<PageSetup>" + CHR(10) +
          "<PageMargins x:Bottom=""0.38"" x:Left=""0.75"" x:Right=""0.38"" x:Top=""0.38""/>" + CHR(10) +
          "</PageSetup>" + CHR(10) +
          "</WorksheetOptions>" + CHR(10) +
          "</Worksheet>" + CHR(10) +
          "</Workbook>" + CHR(10).

RETURN ret_str.

END FUNCTION.



