/*************************************
 *
 * Процедура для работы в op_flt,
 * для простановки ссылки на ребенка.
 *
 *************************************
 *
 * Автор         : Маслов Д. А.
 * Дата создания : 07.08.12
 * Заявка        : #1195
 *
 *************************************/

DEF INPUT PARAM r AS RECID NO-UNDO.


{globals.i}
{intrface.get xclass}
{rid_tabl.def}
{def-wf.i}

DEF BUFFER op FOR op.

DEF VAR childPk  LIKE op.op NO-UNDO.
DEF VAR currDate      AS DATE NO-UNDO.
DEF VAR linkSurr      AS CHAR NO-UNDO.

currDate = gend-date.

FIND FIRST op WHERE RECID(op) = r NO-LOCK.

IF AVAILABLE(op) THEN DO:
childPk = op.op.

DO TRANSACTION ON ERROR UNDO, LEAVE:

 RUN CreateLinksRetSurr("opb","PirLnkCom",STRING(chpar2),STRING(childPk),currDate,?,"",OUTPUT linkSurr).
 
 /*******************************
  *
  * Если не создалась связь, то
  * проставляем допник.
  *
  *******************************
  *
  * Автор        : Маслов Д. А. Maslov D. A.
  * Дата создания: 24.10.12
  * Заявка       : #1617
  ********************************/


 IF linkSurr <> ? THEN DO:
    UpdateSigns("opb",STRING(chpar2),"PirChildPk",STRING(childPk),?).
 END.

END.

END.
{intrface.del}




