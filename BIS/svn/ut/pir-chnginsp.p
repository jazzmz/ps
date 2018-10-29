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
/*изменил из pir-chngdoc.p, теперь только изменение контролера*/



/** используем информацию из броузера */
{tmprecid.def}

DEF VAR oTEventLog AS TEventLog.

DEF VAR cOrderPay AS CHAR FORMAT "x(8)".

DEF FRAME fSet 

   "Контролер:" cOrderPay SKIP(1) 

   WITH CENTERED NO-LABELS TITLE "Введите данные".

/** тело программы */

DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.

FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
   
   /** выводим на форму данные для изменения */
   cOrderPay = /*op.order-pay.*/ user-inspector.

   DISPLAY  cOrderPay  WITH FRAME fSet.
   PAUSE (0).
   SET  cOrderPay     WITH FRAME fSet.
   PAUSE (0).
   IF corderpay NE ? THEN if op.user-inspector <> corderpay then op.user-inspector = corderpay.


   HIDE FRAME fSet.


END.

