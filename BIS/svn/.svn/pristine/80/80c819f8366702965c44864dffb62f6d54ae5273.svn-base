/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы"
     Filename: e2k_407_2539.p
      Comment: ф.407. Новый формат экспорта в KLIKO по 1803-У от 01.07.07. 
   Parameters:
         Uses:
      Used by:
      Created: 11.07.2007 15:26 ler     
     Modified: 11.07.07 ler 79323 - ф.407. Новый формат экспорта в KLIKO по 1803-У от 01.07.07.   
     Modified: 12.07.07 ler 79323  
     Modified: 15.10.13 ler 0208614 - ф.407. Экспорт в KLIKO от 01.08.13 (3006-У) F407_14.PAK.
*/
/******************************************************************************/
&GLOBAL-DEFINE mode "клиент"    /* переделки: RUN ExportPutLine, */
{e2k.def " "  }                 /* &mode=""клиент" "сервер"" */

DEFINE VARIABLE mColumn1 AS CHARACTER NO-UNDO.
/******************************************************************************/
PROCEDURE InitVar.
   mClassRepTeml  = "f407,--f407p3006.p".                      /* класс, шаблон (или процедура с .p) для генерарации входного файла отчета */
   mLstNamePart   = "F407_1,F407_1_2,F407_2_1,F407_2_2,F407_3N,,f407".        /* список заголовков разделов */
   mLstNamePart   = mLstNamePart + STRING(MONTH(in-beg-date), "99") + ".klk"  /* + in-branch-id*/ .
   mLstBreakPart  = "Подраздел 1.2.,Подраздел 2.1.,Подраздел 2.2.,Раздел 3.". /* список значений - условий нач нов разд (в формате CAN-DO) */
   mNumberColumns = 7.                                         /* всего колонок */ 
END PROCEDURE.
/******************************************************************************/
PROCEDURE RunColumns.      /* формирование кода строки - 1я кол эксп файла */
DEF INPUT-OUTPUT PARAM pFlagItog AS LOGICAL NO-UNDO.
DEF INPUT-OUTPUT PARAM pSaveVal  AS CHAR    NO-UNDO.

DEF VAR counter AS INT64 NO-UNDO. /* для delitem.i */

   CASE tExpFile.Column1:
      WHEN ""               THEN tExpFile.Column1 = mColumn1.
      WHEN "Из Российской"  THEN 
      ASSIGN
         tExpFile.Column1 = "переводы из РФ"
         mColumn1         = tExpFile.Column1.
      WHEN "В Российскую"   THEN 
      ASSIGN
         tExpFile.Column1 = "переводы в РФ"
         mColumn1         = tExpFile.Column1.
      WHEN "Поступления в"  THEN 
      ASSIGN
         tExpFile.Column1 = "поступления в пользу ФЛ-резидентов от нерезидентов"
         mColumn1         = tExpFile.Column1.
      WHEN "Платежи физиче" THEN 
      ASSIGN
         tExpFile.Column1 = "платежи ФЛ-резидентов в пользу нерезидентов"
         mColumn1 = tExpFile.Column1.
   END CASE.
   IF ENTRY(3, tExpFile.List-Values) = "" THEN 
      ENTRY(3, tExpFile.List-Values) = "X".
/** 
   IF ENTRY(2, tExpFile.List-Values) = "X" THEN 
      {delitem.i tExpFile.List-Values ENTRY(2,tExpFile.List-Values) }
**/      
   IF ENTRY(3, tExpFile.List-Values) = "X" THEN 
      {delitem.i tExpFile.List-Values ENTRY(3,tExpFile.List-Values) }

   RETURN "".
END PROCEDURE.
/******************************************************************************/
PROCEDURE Rep2TempFile.                  /* генерация отчета => _spool.tmp */
&IF DEFINED(U-3006) &THEN
   RUN f407p3006.p (in-data-id, "").
&ELSE
   RUN f407p2539.p (in-data-id, "").
&ENDIF
END PROCEDURE.
/******************************************************************************/
