/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2012 ЗАО "Банковские информационные системы"
     Filename: e2k_155_2835.p
      Comment: экспорт данных ф.155 из ИБС "БИСквит" в ПК KLIKO 
               для версии F155_11.PAK от 01.08.12
               Сведения о резервах на возможные потери. (Месячная/Квартальная тыс. руб.)
               
               Класс данных: f155it_2_3      
               f155p6.p => f155p.p
               f155_2_3_dml6.p => f155_2_3_dml.p
               
                f155_1_dml.p    =>                 f155_1_print4.p                        /* Раздел 1    */    
                f155_2_3_dml5.p => f155_2_3_dml.p  f155_2_3_print5.p => f155_2_3_print.p  /* Разделы 2,3 */ 
   Parameters:
         Uses:
      Used by:
      Created: 07.08.2012 16:17 ler
     Modified: 27.08.12 ler 0177895 - ф.155. Экспорт в программу KLIKO 2835-У на 01.08.12 (F155_11.PAK)
     Modified: 23.08.13 ler 0204764 - Ф.155. Экспорт в программу KLIKO 3006-У 01.08.13 F155_16.pak (версия от 30.07.2013)
*/
/******************************************************************************/
&GLOBAL-DEFINE mode "клиент"
{e2k.def " "  }                             /* &mode=""клиент" "сервер"" */
{e2k_tst-typ-form.i} /* Определение типа отчетн. формы (месячная/квартальная) */

DEFINE VARIABLE mCount155 AS INT64   NO-UNDO.
&IF DEFINED(U-3006)
&THEN 
   DEFINE VARIABLE mNumbClmnsPart AS INT64 NO-UNDO EXTENT 8 INIT [15, 15, 7, 8, 1, 8, 2, 1].
&ELSE
   DEFINE VARIABLE mNumbClmnsPart AS INT64 NO-UNDO EXTENT 7 INIT [15, 15, 7, 8, 1, 8, 1].
&ENDIF 
DEF TEMP-TABLE tt-NameInstr NO-UNDO 
    FIELD f-NumbPart  AS CHAR
    FIELD f-Code      AS CHAR
    FIELD f-NameInstr AS CHAR
    INDEX i f-NumbPart f-Code
.
DEF BUFFER bformula FOR  Formula.
/******************************************************************************/
PROCEDURE InitNameInstr.
DEFINE INPUT PARAMETER iFormula AS CHARACTER NO-UNDO. /* разд.1 - KlikoNF1551, разд.3,4 - KlikoNF1552 */

DEFINE VARIABLE vF        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vI        AS INT64     NO-UNDO.
DEFINE VARIABLE vNumbPart AS CHARACTER   NO-UNDO.

/* формулы для формирования наименований инструментов 
   (графа 1 разделов 1,2,3 ф.155) для выгрузки в Клико */
   RUN find_formula 
      IN h_olap ("f155it_2_3", iFormula, DataBlock.End-Date, YES, BUFFER bformula).
   
   /* Формат формулы: |КодСтроки|НаименовИнструм...|КодСтроки|НаименовИнструм... */
   ASSIGN 
      vF        = bformula.formula
      vF        = REPLACE(vF, "~~", "@")
      vNumbPart = (IF iFormula = "KlikoNF1551" THEN "1" ELSE (IF iFormula = "KlikoNF1552" THEN "2" ELSE "3"))
   .
   /* д.б. четным (NUM-ENTRIES(vF) / 2) */
   DO vI = 1 TO NUM-ENTRIES(vF, "@") :
      IF NUM-ENTRIES(ENTRY(vI, vF, "@"), "|") NE 2 THEN
         NEXT.
      CREATE tt-NameInstr.
      ASSIGN
         tt-NameInstr.f-NumbPart  = vNumbPart
         tt-NameInstr.f-Code      = TRIM(ENTRY(1, ENTRY(vI, vF, "@"), "|"))
         tt-NameInstr.f-NameInstr = TRIM(ENTRY(2, ENTRY(vI, vF, "@"), "|"))
     .
   END.

   RELEASE tt-NameInstr.
END PROCEDURE.
/******************************************************************************/
/* формирование наименований инструментов (графа 1 разделов 1,2,3 ф.155) для выгрузки в Клико */
FUNCTION Get-NameInstr RETURN CHAR (INPUT iNPart AS CHAR, INPUT iName AS CHAR, INPUT iLine AS CHAR).

DEFINE VARIABLE vCode AS CHARACTER   NO-UNDO.

   vCode = ENTRY(NUM-ENTRIES(iLine), iLine).
   FIND FIRST tt-NameInstr WHERE tt-NameInstr.f-NumbPart EQ iNPart AND 
                                 tt-NameInstr.f-Code     EQ vCode  
   NO-LOCK NO-ERROR.

   IF AVAIL tt-NameInstr THEN 
      RETURN TRIM(tt-NameInstr.f-NameInstr).

   RETURN iName.
END FUNCTION.
/******************************************************************************/
FUNCTION Get-Res RETURN CHAR (INPUT iTxt AS CHAR).
   DEFINE BUFFER sp2-DataBlock FOR DataBlock.
   DEFINE BUFFER sp2-Dataline  FOR Dataline.
   DEFINE VARIABLE vTmp    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vTmpInt AS INT64     NO-UNDO.

   FIND sp2-DataBlock WHERE 
      sp2-DataBlock.DataClass-Id EQ "f155_sp2"   AND /* атрибут Txt2 */
      sp2-DataBlock.Beg-Date     EQ in-Beg-Date  AND   
      sp2-DataBlock.End-Date     EQ in-End-Date  AND   
      sp2-DataBlock.branch-id    EQ in-branch-id 
   NO-LOCK NO-ERROR.

   iTxt = REPLACE(iTxt, "'", '"').
   FIND FIRST sp2-Dataline OF sp2-DataBlock WHERE /* "Наименование организации" */
         ENTRY(1, sp2-Dataline.Txt, "~n") EQ iTxt /* ENTRY(1, tExpFile.List-Values) */
   NO-LOCK NO-ERROR.
/* если в поле Txt2 (ИНН организации, депозитария) класса данных "f155_sp2" указано 10 или 12значное число, то это резидент.
    Иначе это неразидент (для нерезидентов в Txt2 проставляется 3-хзначный код страны).
*/
   vTmp = IF LENGTH(ENTRY(2, sp2-Dataline.Txt, "~n")) EQ 10 OR
             LENGTH(ENTRY(2, sp2-Dataline.Txt, "~n")) EQ 12 
          THEN ENTRY(2, sp2-Dataline.Txt, "~n")
          ELSE "error".
   ASSIGN vTmpInt = INT64(vTmp) NO-ERROR.

   RETURN IF ERROR-STATUS:ERROR 
          THEN "1" /* для нерезидента */
          ELSE "0" /* для резидента   */ .
END FUNCTION.
/******************************************************************************/
/******************************************************************************/
PROCEDURE InitVar.
   mClassRepTeml  = "f155it_2_3,f155p5.p".    /* класс, шаблон          */
   mNumberColumns = mNumbClmnsPart[1].        /* кол-во колонок - всего */
   mLstNullVal    = "X,Х".                    /* список для замены пустым значеним "" */
&IF DEFINED(U-3006) /* список значений - условий нач нов разд (в формате CAN-DO) */ 
&THEN               /* список заголовков разделов; если в списке есть пустой элемент, то следующий - нестандартное имя вых файла */
   mLstBreakPart  = "Раздел NF15511,Раздел 2.,Раздел 3.,Справочно:,2. Информация о ценных бумагах,NF1554_SP345" .   
   mLstNamePart   = "NF1551,NF15511,NF1552,NF1553,NF1554,NF15541,NF1554_SP345,NF1555,,f155_" 
&ELSE
   mLstBreakPart  = "Раздел NF15511,Раздел 2.,Раздел 3.,Справочно:,2. Информация о ценных бумагах". 
   mLstNamePart   = "NF1551,NF15511,NF1552,NF1553,NF1554,NF15541,NF1555,,f155_" 
&ENDIF
                  + STRING(MONTH(in-end-date), "99") + STRING(YEAR (in-end-date), "9999") + ".txt".
/* mDelitLine     = "│       1       │,│       4       │". */
   RUN InitNameInstr("KlikoNF1551") . /* разд.1 */
   RUN InitNameInstr("KlikoNF1552") . /* разд.3 */
   RUN InitNameInstr("KlikoNF1553") . /* разд.4 */
END PROCEDURE.
/******************************************************************************/
PROCEDURE RunColumns.         /* формирование кода строки - 1я кол эксп файла */
DEF INPUT-OUTPUT PARAM pFlagItog AS LOGICAL NO-UNDO.
DEF INPUT-OUTPUT PARAM pSaveVal  AS CHAR    NO-UNDO.

   CASE mCountPart:
      WHEN 1 THEN DO: 
         IF /*tExpFile.Column1 = "Иные портфели" AND*/ tExpFile.List-Values = "7.4" THEN
            ASSIGN
         /* tExpFile.Column1     = "ИИные портфели (указывается наименование портфеля))" */
            tExpFile.List-Values = ",,,,,,,,,,,,,7.4"
         .
         tExpFile.Column1 = Get-NameInstr("1",  tExpFile.Column1, tExpFile.List-Values).
      END.
      WHEN 2 THEN
         ASSIGN
            tExpFile.List-Values = tExpFile.Column1 + "," + tExpFile.List-Values
            tExpFile.Column1     = ENTRY(NUM-ENTRIES(tExpFile.List-Values), tExpFile.List-Values)
            tExpFile.List-Values = REPLACE(tExpFile.List-Values, tExpFile.Column1, "")
            tExpFile.List-Values = tExpFile.List-Values + "1,1,"
         .
      WHEN 3 /*OR WHEN 4*/ THEN DO: 
         tExpFile.Column1 = Get-NameInstr("2", tExpFile.Column1, tExpFile.List-Values).
      END.
      WHEN 4 THEN DO: 
         tExpFile.Column1 = Get-NameInstr("3", tExpFile.Column1, tExpFile.List-Values).
      END.

      WHEN 6 THEN DO:                                            /* <NF15541> */
         DO WHILE NUM-ENTRIES(tExpFile.List-Values) LT 7:
            tExpFile.List-Values = "," + tExpFile.List-Values.
         END.                                /* Get-Res = разидент/нерезидент */
         tExpFile.List-Values = Get-Res(ENTRY(1, tExpFile.List-Values))
                              + "," + tExpFile.List-Values.
      END.

   END CASE.

   RETURN "".
END PROCEDURE.
/******************************************************************************/
/* спец. обработка нового раздела при импорте (необязательная - пр-ра может отсутствовать) 126 135m */
PROCEDURE SpecRunPart. 
DEFINE INPUT PARAM pCountPart AS INT64 NO-UNDO.

   IF pCountPart EQ 0 THEN DO:            /* обработка при импорте            */
      mCount155    = mCount155 + 1.

      ASSIGN
         mNumberColumns = mNumbClmnsPart[mCount155 + 1] 

         mNumberActCol  = mNumberColumns
         mNumberColumns = mNumberColumns + IF mFlagFirstCol THEN 2 ELSE 1. 
      RETURN "".
   END.

   RETURN "".
END PROCEDURE.
/******************************************************************************/
PROCEDURE Rep2TempFile.                     /* генерация отчета => _spool.tmp */
&IF DEFINED(U-3006)
&THEN RUN f155p6.p (in-data-id, ""). 
&ELSE RUN f155p5.p (in-data-id, ""). /* IF iParam GT "" THEN mF155r1 = iParam. ("f155it") */
&ENDIF
END PROCEDURE.
/******************************************************************************/
