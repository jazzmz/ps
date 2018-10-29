/* ------------------------------------------------------
     File: $RCSfile: pirgetfname.p,v $ $Revision: 1.1 $ $Date: 2008-05-29 08:45:25 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: позволяет в диалоговом режиме выбрать файл
     Как работает: 
     Параметры: 
     Место запуска: Функция PROMPT в универсальных транзакциях  
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

{globals.i}

DEF INPUT PARAM iParam AS CHAR NO-UNDO. 
DEF VAR fname AS CHAR NO-UNDO.

fname = iParam.

RUN ch-file.p (INPUT-OUTPUT fname).

pick-value = fname.