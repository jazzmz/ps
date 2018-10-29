/**
 * Процедура простановки рынка 
 * для договоров по которым уже рассчитан рынок
 * с запуском из Ctrl + G.
 **
 * Автор : Маслов Д. А.
 * Заявка: #2907
 **/
DEF INPUT PARAM in-Data-Id1 LIKE DataBlock.Data-Id NO-UNDO.
DEF INPUT PARAM cParam                    AS CHAR NO-UNDO.

FIND FIRST DataBlock WHERE DataBlock.Data-Id = in-Data-Id1 NO-LOCK.

 {intrface.get xclass}

   {pir-f227-mrk.i}

 {intrface.del}
