/** Заглушка, которая может быть использована в работе транзакций, 
    основанных на процедуре pirustrt.p 
*/

/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.



/**  Запуск 2-го РАБОЧЕГО ДНЯ возможен только в оп.дне, следующем 
за выходным/праздничным днем
*/

{gdate.i}
IF NOT( IsHoliday(in-op-date - 1) ) THEN
  DO:
     MESSAGE COLOR WHITE/RED 
        "Запуск 2-го РАБОЧЕГО ДНЯ возможен только в оп.дне, следующем за выходным/праздничным днем! Выходим из транзакции!"
        VIEW-AS ALERT-BOX TITLE "ОШИБКА" .
     RETURN ERROR. 
  END.
