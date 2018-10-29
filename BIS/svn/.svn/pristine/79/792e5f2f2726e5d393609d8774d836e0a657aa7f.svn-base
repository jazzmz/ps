/***************************************
 *				       *
 * Процедура заполнения имени          *
 * имени отправителя.                  *
 * Подставляет в наименование          *
 * отправителя его адрес .	       *
 *                                     *
 ***************************************
 *                                     *
 * Автор: Маслов Д. А. Maslov D. A.    *
 * Заявка: #638                        *
 * Дата создания: 18.02.11             *
 *				       *
 *                                     *
 ***************************************/
{pick-val.i}

DEF INPUT PARAMETER iLevel AS INTEGER NO-UNDO.                                      
DEF SHARED VARIABLE XATTR_Params AS CHAR NO-UNDO.

DEF VAR oDocument AS TPaymentOrder.
DEF VAR oClient AS TClient.

 oDocument = new TPaymentOrder(INTEGER(ENTRY(2,XATTR_Params))).

 /***************************
  * Если документ внешний. *
  ***************************/

 IF oDocument:direct = "out" THEN
   DO:

     oClient = new TClient(oDocument:acct-db).
	/*******************************
	 * Если установлен реквизит,
	 * то к нему "приклеиваем"
	 * адресс.
	 * Если реквизит не установлен, то
	 * берем его с клиента.
	 *******************************/
	IF pick-value <> "" THEN  pick-value = pick-value + " //" + oClient:address + "//".
	ELSE pick-value = oClient:name-short + " //" + oClient:address + "//".

     DELETE OBJECT oClient.
    
     SELF:SCREEN-VALUE = pick-value.
     APPLY "ANY-PRINTABLE" TO SELF. /* как бы ручками ввели */
   END.

 DELETE OBJECT oDocument.	



