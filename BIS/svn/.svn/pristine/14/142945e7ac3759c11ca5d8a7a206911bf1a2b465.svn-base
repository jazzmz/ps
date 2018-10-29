/* ------------------------------------------------------
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: -
     Причина: Измнение доп. реквизитов документа 
     Что делает: Показывает форму с существующими реквизитами для их изменения
     Как работает: Показывает форму с существующими реквизитами для их изменения
     Параметры: <каталог_экспорта>
     Место запуска: броузер документов           
*******************************************************
     Автор: Нечаев П.В.
     Дата создания: 14.05.2010
     Заявка: #290
------------------------------------------------------
     Автор: Красков А.С.
     Дата модификации: 13.12.2010
     Заявка: #573
     Причина модификации: добавление отправки сообщения об изменениях документа в систему "Говорун"
******************************************************* */

/** используем информацию из броузера */
{tmprecid.def}

DEF VAR oTEventLog AS TEventLog NO-UNDO.

DEF VAR cDocNum  AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR cDocType AS CHAR FORMAT "x(5)" NO-UNDO.
DEF VAR cNameBen AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4    NO-UNDO.
DEF VAR cDocDetails AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4 NO-UNDO.
DEF VAR cEvent AS CHAR NO-UNDO.
DEF VAR iEventNum AS INTEGER INITIAL 60 NO-UNDO. /* номер события в системе регистрации событий */

DEF FRAME fSet 
   "Номер документа:" cDocNum SKIP(1) 
   "Тип документа:" cDocType SKIP(1)
   "Реквизиты клиента:" SKIP cNameBen SKIP(1)
   "Содержание документа:" SKIP cDocDetails 
   WITH CENTERED NO-LABELS TITLE "Введите данные".

/** тело программы */

/*DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.  */

FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
   
   /** выводим на форму данные для изменения */
   cDocNum = op.doc-num.
   cDocType = op.doc-type.
   cNameBen = op.name-ben.
   cDocDetails = op.details.

   DISPLAY cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.

   SET cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.
   cEvent = "В документе номер: " + op.doc-num + " от " + STRING(op.op-date) + " изменено:".

   IF cDocNum NE ? AND cDocNum NE "" THEN 
        DO:
           if op.doc-num <> cDocNum THEN cEvent = cEvent + " Номер документа: старое значение:" + op.doc-num + " новое значение: " + cDocNum.
           op.doc-num = cDocNum.
        END.

   IF cDocType NE ? AND cDocType NE "" THEN 
        DO:
           if op.doc-type <> cDocType THEN cEvent = cEvent + " Тип документа: старое значение:" + op.doc-type + " новое значение: " + cDocType.
             op.doc-type = cDocType.
        END.

   if op.name-ben <> cNameBen THEN cEvent = cEvent + " реквизиты клинета: старое значение:" + op.name-ben + " новое значение: " + cNameBen.
   op.name-ben = cNameBen.

   IF cDocDetails NE ? AND cDocDetails NE "" THEN 
        DO:
           if op.details <> cDocDetails THEN cEvent = cEvent + " Содержание документа: старое значение:" + op.details + " новое значение: " + cDocDetails.
           op.details = cDocDetails.
        END.

   DISPLAY cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.

   HIDE FRAME fSet.

   IF cEvent <> "В документе номер: " + op.doc-num + " от " + STRING(op.op-date) + " изменено:" THEN 
        DO:
           cevent = REPLACE(cevent,CHR(34),"").
/*           Message cevent VIEW-AS ALERT-BOX.*/
           
           oTEventLog = new TEventLog("curl","http://govorun/event").
           oTEventLog:fillInfo(iEventNum,cEvent).
           oTEventLog:Send().
           DELETE OBJECT oTEventLog.
        END.
END.

