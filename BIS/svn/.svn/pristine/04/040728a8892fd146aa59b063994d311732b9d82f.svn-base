/* ------------------------------------------------------
File          : pir_exf_exl.i
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Библиотека п/п для выгрузки из Бисквита в файлы XL
Автор         : rusinov 06.05.08 
Изменения     : Борисов - добавлено форматирование столбцов 16.09.2008

---------------------------------------------------------
                Список функций:
                ===============
- начало XL-файла
   XLHead (cFN, cColl, lColl) => char
      cFN   - Имя листа XL-файла,
      cColl - Формат столбцов: D - дата, I - целое, N - числа, C - символьн,
      lColl - ширина столбцов.
- следующий лист XL-файла
   XLNextList (cFN, cColl, lColl) => char
      cFN   - Имя листа XL-файла,
      cColl - Формат столбцов: D - дата, I - целое, N - числа, C - символьн,
      lColl - ширина столбцов.
- окончание XL-файла
   XLEnd () => char
- начало строки таблицы
   XLRow (iBord) => char
      iBord - Тип верхней границы: 1 - одинарная черта, 2 - двойная.
- окончание строки таблицы
   XLRowEnd () => char
- ячейка символьного формата
   XLCell (cVal) => char
      cVal  - содержимое ячейки
- ячейка формата даты
   XLDateCell (dVal) => char
      daVal - содержимое ячейки. Если неопр.значение, то ячейка пустая.
              Если год < 1800 (бредовый), выдается STRING(dVal).
              Формат в XL "ДД.ММ.ГГГГ"
- ячейка числового формата
   XLCell (dVal) => char
      dVal  - содержимое ячейки. Если неопр.значение, то ячейка пустая.
              Формат в XL "# ##0.00"
- пустая ячейка
   XLEmptyCell () => char

                Использование:
                ==============
/* Вставляем инклюдник */
   {pir_exf_exl.i}
/* Открываем поток для вывода в файл, или используем             */
/* {exp-path.i &stream="STREAM xl"} - кладет в .../imp-exp/doc/  */
   OUTPUT STREAM xl THROUGH unix-dos > VALUE(FullFileName).
/* Формируем файл: */
   PUT STREAM xl UNFORMATTED
      XLHead("имя листа", "CDIN", "50,20.25,10,40.5")
         XLRow(2) XLCell("Имя") XLCell("Дата")    XLCell("Сумма") XLRowEnd() /* заголовки */
         XLRow(0) XLCell(cName) XLDateCell(TODAY) XLNumCell(summ) XLRowEnd() /* данные    */
      XLEnd().
/* Закрываем поток */
     OUTPUT STREAM xl CLOSE.

------------------------------------------------------ */

/*********** Вывод заголовока файла xls  **********/
FUNCTION XLHead RETURNS CHAR 
   (INPUT cFN   AS CHARACTER,  /* Имя листа XL-файла */
    INPUT cColl AS CHARACTER,  /* Формат столбцов: D - дата, N - числа, C - символьн. */
    INPUT lColl AS CHARACTER   /* Ширина столбцов */
   ):

   DEFINE VARIABLE cRetStr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

   cRetStr = "<?xml version=""1.0""?>" + CHR(10) +
             "<?mso-application progid=""Excel.Sheet""?>" + CHR(10) +
             "<Workbook xmlns=""urn:schemas-microsoft-com:office:spreadsheet""" + CHR(10) + 
             " xmlns:o=""urn:schemas-microsoft-com:office:office""" + CHR(10) + 
             " xmlns:x=""urn:schemas-microsoft-com:office:excel""" + CHR(10) + 
             " xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet""" + CHR(10) + 
             " xmlns:html=""http://www.w3.org/TR/REC-html40"">" + CHR(10) + 
             " <DocumentProperties xmlns=""urn:schemas-microsoft-com:office:office"">" + CHR(10) +
             "  <Version>11.9999</Version>" + CHR(10) +
             " </DocumentProperties>" + CHR(10) +
             " <ExcelWorkbook xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10) +
             " </ExcelWorkbook>" + CHR(10) +
             " <Styles>" + CHR(10) +
             "  <Style ss:ID=""Default"" ss:Name=""Normal"">" + CHR(10) +
             "   <Alignment ss:Vertical=""Bottom""/>" + CHR(10) +
             "   <Borders/>" + CHR(10) +
             "   <Font ss:FontName=""Arial Cyr"" x:CharSet=""204""/>" + CHR(10) +
             "   <Interior/>" + CHR(10) +
             "   <NumberFormat/>" + CHR(10) +
             "   <Protection/>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s21"">" + CHR(10) +
             "   <NumberFormat ss:Format=""@""/>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s22"">" + CHR(10) +
             "   <NumberFormat ss:Format=""Standard""/>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s23"">" + CHR(10) +
             "   <NumberFormat ss:Format=""Short Date""/>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s24"">" + CHR(10) +
             "   <NumberFormat ss:Format=""#,##0""/>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s31"">" + CHR(10) +
             "   <Borders>" + CHR(10) +
             "    <Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   </Borders>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s32"">" + CHR(10) +
             "   <Borders>" + CHR(10) +
             "    <Border ss:Position=""Top"" ss:LineStyle=""Double"" ss:Weight=""3""/>" + CHR(10) +
             "   </Borders>" + CHR(10) +
             "  </Style>" + CHR(10) +
             "  <Style ss:ID=""s29"">" + CHR(10) +
             "   <Borders>" + CHR(10) +
	     "   <Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   <Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   <Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   <Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   </Borders>" + CHR(10) +
             "   <NumberFormat ss:Format=""Short Date""/>" + CHR(10) +
             "   </Style>" + CHR(10) +
             "   <Style ss:ID=""s30"">" + CHR(10) +
             "   <Borders>" + CHR(10) +
             "    <Border ss:Position=""Bottom"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "    <Border ss:Position=""Left"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "    <Border ss:Position=""Right"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "    <Border ss:Position=""Top"" ss:LineStyle=""Continuous"" ss:Weight=""1""/>" + CHR(10) +
             "   </Borders>" + CHR(10) +
             "  </Style>" + CHR(10) +
             " </Styles>" + CHR(10) +
             " <Worksheet ss:Name=""" + cFN + """>" + CHR(10) +
             "  <Table>" + CHR(10).

   i = LENGTH(cColl) - NUM-ENTRIES(lColl).
   IF i > 0 THEN lColl = lColl + FILL(",", i).

   DO i = 1 TO LENGTH(cColl) :
      CASE SUBSTR(cColl, i, 1):
         WHEN "D" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s23""".
         WHEN "N" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s22""".
         WHEN "I" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s24""".
         WHEN "C" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s21""".
         OTHERWISE
            cRetStr = cRetStr + "   <Column".
      END CASE.

      IF ENTRY(i, lColl) = ""
         THEN cRetStr = cRetStr + " ss:AutoFitWidth=""0""".
         ELSE cRetStr = cRetStr + " ss:Width=""" + TRIM(STRING(INTEGER(ENTRY(i, lColl)) * 3 / 4, ">>>9.99")) + """".

      cRetStr = cRetStr + "/>" + CHR(10).
   END.
   
   RETURN CODEPAGE-CONVERT(cRetStr,"UTF-8",SESSION:CHARSET).
          /* */
END FUNCTION.

/*********** Вывод заголовока след.листа xls  **********/
FUNCTION XLNextList RETURNS CHAR 
   (INPUT cFN   AS CHARACTER,  /* Имя листа XL-файла */
    INPUT cColl AS CHARACTER,  /* Формат столбцов: D - дата, N - числа, C - символьн. */
    INPUT lColl AS CHARACTER   /* Ширина столбцов */
   ):

   DEFINE VARIABLE cRetStr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

   cRetStr = "  </Table>" + CHR(10)
           + "  <WorksheetOptions xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10)
           + "  </WorksheetOptions>" + CHR(10)
           + " </Worksheet>" + CHR(10)
           + " <Worksheet ss:Name=""" + cFN + """>" + CHR(10)
           + "  <Table>" + CHR(10)
           .

   i = LENGTH(cColl) - NUM-ENTRIES(lColl).
   IF i > 0 THEN lColl = lColl + FILL(",", i).

   DO i = 1 TO LENGTH(cColl) :
      CASE SUBSTR(cColl, i, 1):
         WHEN "D" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s23""".
         WHEN "N" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s22""".
         WHEN "I" THEN
            cRetStr = cRetStr + "   <Column ss:StyleID=""s24""".
         OTHERWISE
            cRetStr = cRetStr + "   <Column".
      END CASE.

      IF ENTRY(i, lColl) = ""
         THEN cRetStr = cRetStr + " ss:AutoFitWidth=""0""".
         ELSE cRetStr = cRetStr + " ss:Width=""" + TRIM(STRING(INTEGER(ENTRY(i, lColl)) * 3 / 4, ">>>9.99")) + """".

      cRetStr = cRetStr + "/>" + CHR(10).
   END.
   
   RETURN CODEPAGE-CONVERT(cRetStr,"UTF-8",SESSION:CHARSET).
          /* */
END FUNCTION.

/********* Вывод окончания файла xls  **********/
FUNCTION XLEnd RETURNS CHAR: 
   RETURN "  </Table>" + CHR(10) +
          "  <WorksheetOptions xmlns=""urn:schemas-microsoft-com:office:excel"">" + CHR(10) +
          "  </WorksheetOptions>" + CHR(10) +
          " </Worksheet>" + CHR(10) +
          "</Workbook>".
END FUNCTION.

/****** Добавление строки ***********/
FUNCTION XLRow RETURNS CHAR 
   (INPUT iBord AS INTEGER  /* Тип верхней границы: 1 - одинарная черта, 2 - двойная */
   ) :

   CASE iBord:
      WHEN 2 THEN
         RETURN "   <Row ss:StyleID=""s32"">" + CHR(10).
      WHEN 1 THEN
         RETURN "   <Row ss:StyleID=""s31"">" + CHR(10).
      OTHERWISE
         RETURN "   <Row>" + CHR(10).
   END CASE.
  
END FUNCTION.

/****** Добавление строки ***********/
/* Убрала iBord, т.к. подразумевается присутствие стиля s31 или s32 , но этих стилей может и не быть.*/
FUNCTION XLRowInFormat RETURNS CHAR 
   (INPUT iHeight AS INTEGER,
    INPUT iStyle AS CHAR
   ) :

   RETURN "   <Row ss:Height=" + CHR(34) + string(iHeight) + CHR(34) 
			+ " ss:StyleID=" + CHR(34) + iStyle + CHR(34) + ">" + CHR(10).
  
END FUNCTION.

/****** Конец строки ***********/
FUNCTION XLRowEnd RETURNS CHAR :
    RETURN "   </Row>" + CHR(10).
END FUNCTION.

/****** Добавление новой символьной ячейки ***********/
FUNCTION XLCell RETURNS CHAR 
   (INPUT cVal AS CHAR   /* содержимое ячейки */
   ) :

   DEFINE VARIABLE cBCell  AS CHARACTER INITIAL "    <Cell><Data ss:Type=""String"">" NO-UNDO.
   DEFINE VARIABLE cECell  AS CHARACTER INITIAL "</Data></Cell>" NO-UNDO.
   DEFINE VARIABLE cRetStr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE nF      AS INTEGER   NO-UNDO.

   IF cVAL = ? THEN
      cRetStr = cBCell + "/НЕ определено/" + cECell + CHR(10).
   ELSE DO:
/*
      nF = INDEX(cVal, "<").
      DO WHILE nF <> 0:
         SUBSTRING(cVal, nF, 1) = "&lt;".
         nF = INDEX(cVal, "<", nF).
      END.

      nF = INDEX(cVal, ">").
      DO WHILE nF <> 0:
         SUBSTRING(cVal, nF, 1) = "&gt;".
         nF = INDEX(cVal, ">", nF).
      END.
*/
      cVal = REPLACE(cVal, "<", "&lt;").
      cVal = REPLACE(cVal, ">", "&gt;").
      cVal = REPLACE(cVal, '"', "&quot;").
      cVal = REPLACE(cVal, CHR(10), "&#10;").

      cRetStr = cBCell + cVal + cECell + CHR(10).
   END.

   RETURN CODEPAGE-CONVERT(cRetStr,"UTF-8",SESSION:CHARSET).
          /* */
END FUNCTION.

/****** Добавление новой символьной ячейки ***********/
FUNCTION XLCellInFormat RETURNS CHAR 
   (INPUT cVal AS CHAR,   /* содержимое ячейки */
    INPUT iStyle AS CHAR
   ) :

   DEFINE VARIABLE cBCell  AS CHARACTER INITIAL "    <Cell><Data ss:Type=""String"">" NO-UNDO.
   DEFINE VARIABLE cECell  AS CHARACTER INITIAL "</Data></Cell>" NO-UNDO.
   DEFINE VARIABLE cRetStr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE nF      AS INTEGER   NO-UNDO.

   cBCell = "    <Cell ss:StyleID=" + CHR(34) + iStyle + CHR(34) + "><Data ss:Type=""String"">".

   IF cVAL = ? THEN
      cRetStr = cBCell + "/НЕ определено/" + cECell + CHR(10).
   ELSE DO:
      cVal = REPLACE(cVal, "<", "&lt;").
      cVal = REPLACE(cVal, ">", "&gt;").
      cVal = REPLACE(cVal, '"', "&quot;").
      cVal = REPLACE(cVal, CHR(10), "&#10;").

      cRetStr = cBCell + cVal + cECell + CHR(10).
   END.

   RETURN CODEPAGE-CONVERT(cRetStr,"UTF-8",SESSION:CHARSET).
END FUNCTION.

/****** Добавление новой ячейки с датой ***********/
FUNCTION XLDateCell RETURNS CHAR 
   (INPUT daVal AS DATE   /* содержимое ячейки */
   ) :

   DEF VAR cBCell AS CHAR INITIAL "    <Cell><Data ss:Type=""DateTime"">" NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL "T00:00:00.000</Data></Cell>" NO-UNDO.

   IF daVAL = ? THEN
      RETURN "    <Cell/>" + CHR(10).
   ELSE IF YEAR(daVal) < 1800 THEN
      RETURN "    <Cell><Data ss:Type=""String"">" + 
                      STRING(daVal) + cECell + CHR(10).
   ELSE
      RETURN cBCell + STRING(YEAR(daVal), "9999") + "-" +
                      STRING(MONTH(daVal),  "99") + "-" +
                      STRING(DAY(daVal),    "99") + cECell + CHR(10).
END FUNCTION.

FUNCTION XLDateCellInFormat RETURNS CHAR 
   (INPUT daVal AS DATE,   /* содержимое ячейки */
    INPUT iStyle AS CHAR
   ) :

   DEF VAR cBCell AS CHAR NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL "T00:00:00.000</Data></Cell>" NO-UNDO.
   cBCell = "    <Cell ss:StyleID=" + CHR(34) + iStyle + CHR(34) + "><Data ss:Type=""DateTime"">".
   IF daVAL = ? THEN
      RETURN "    <Cell/>" + CHR(10).
   ELSE IF YEAR(daVal) < 1800 THEN
      RETURN "    <Cell ss:StyleID=" + CHR(34) + iStyle + CHR(34) + "><Data ss:Type=""String"">" + 
                      STRING(daVal) + cECell + CHR(10).
   ELSE
      RETURN cBCell + STRING(YEAR(daVal), "9999") + "-" +
                      STRING(MONTH(daVal),  "99") + "-" +
                      STRING(DAY(daVal),    "99") + cECell + CHR(10).
END FUNCTION.

/****** Добавление новой числовой ячейки ***********/
FUNCTION XLNumCell RETURNS CHAR 
   (INPUT dVal AS DECIMAL /* содержимое ячейки */
   ) :

   DEF VAR cBCell AS CHAR INITIAL "    <Cell><Data ss:Type=""Number"">" NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL "</Data></Cell>" NO-UNDO.

   IF dVAL = ? THEN
      RETURN "    <Cell/>" + CHR(10).
   ELSE
      RETURN cBCell + STRING(dVal) + cECell + CHR(10).
END FUNCTION.

/****** Добавление новой числовой ячейки. Вместо 0 - пусто **/
FUNCTION XLNumECell RETURNS CHAR 
   (INPUT dVal AS DECIMAL /* содержимое ячейки */
   ) :

   DEF VAR cBCell AS CHAR INITIAL "    <Cell><Data ss:Type=""Number"">" NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL "</Data></Cell>" NO-UNDO.

   IF (dVAL = ?) OR (dVAL = 0) THEN
      RETURN "    <Cell/>" + CHR(10).
   ELSE
      RETURN cBCell + STRING(dVal) + cECell + CHR(10).
END FUNCTION.


/****** Добавление новой числовой ячейки. Вместо 0 - пусто, форматирование "рамка вокруг ячейки"**/
FUNCTION XLNumECellInFormat RETURNS CHAR 
   (INPUT dVal AS DECIMAL, /* содержимое ячейки */
   INPUT iStyle as Char) : /*стиль. из списка в заголовке эксель файла*/

   DEF VAR cBCell AS CHAR  NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL "</Data></Cell>" NO-UNDO.
   cBCell = "    <Cell ss:StyleID=" + CHR(34) + iStyle + CHR(34) + "><Data ss:Type=""Number"">".
   IF (dVAL = ?) THEN
      RETURN "    <Cell/>" + CHR(10).
   ELSE
      RETURN cBCell + STRING(dVal) + cECell + CHR(10).
END FUNCTION.



/****** Добавление новой ячейки с формулой ***********/
FUNCTION XLFormulaCell RETURNS CHAR 
   (INPUT cVal AS CHAR   /* формула */
   ) :

   DEF VAR cBCell AS CHAR INITIAL "    <Cell ss:Formula=""" NO-UNDO.
   DEF VAR cECell AS CHAR INITIAL """></Cell>" NO-UNDO.

   RETURN cBCell + cVal + cECell + CHR(10).
END FUNCTION.

/****** Добавление пустой ячейки ***********/
FUNCTION XLEmptyCell RETURNS CHAR :
    RETURN "    <Cell/>" + CHR(10).
END FUNCTION.

FUNCTION XLEmptyCells RETURNS CHAR
   (INPUT iNum AS INTEGER /* количество ячеек */
   ) :
   IF (iNum GT 1)
   THEN RETURN XLEmptyCell() + XLEmptyCells(iNum - 1).
   ELSE RETURN XLEmptyCell().
END FUNCTION.
