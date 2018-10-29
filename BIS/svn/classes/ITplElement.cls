INTERFACE ITplElement:
 /*
   Интерфейс для любого сложного элемента
   шаблонизатора TTpl
 */
METHOD PUBLIC VOID show().			                                                /* Выводит элемент на экран */
METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHAR,INPUT cPropertyValue AS CHAR).	/* Устанавливает значение свойства */
METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR).		                        /* Устанавливает значение свойства */
METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL).	                                        /* Устанавливает поле, используется ли в шаблоне */

END INTERFACE.