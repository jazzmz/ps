/*****************************
 * Процедура отслеживания    *
 * красного сальдо.          *
 *****************************
 * Дата создания: 09.06.11
 * Автор: Маслов Д. А. Maslov D. A.
 * Заявка:
 ******************************/
 
 DEF VAR oSysClass AS TSysClass NO-UNDO.
 DEF VAR dLastCloseDate AS DATE NO-UNDO.
 DEF VAR dLastOpenDate  AS DATE NO-UNDO.

 oSysClass = new TSysClass().
   dLastCloseDate = oSysClass:getLastCloseDate().
   
 DELETE OBJECT oSysClass.

