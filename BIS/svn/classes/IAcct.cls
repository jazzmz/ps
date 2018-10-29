INTERFACE IAcct:
/*
   Интерфейс для работы с лицевыми счетами
*/

 METHOD PUBLIC LOGICAL updateAcct().  /* Метод производит изменение счета */
 METHOD PUBLIC LOGICAL addAcct().     /* Метод производит добавление нового счета в БД */
END INTERFACE.