/* Бурягин: настоящий скрипт необходим для успешного отката транзакции
   открытия договора ИБС (модуль КД, а не АХД). Как выяснилось и договоров МБК
   тоже.
   Запускать перед удалением (откатом) самой операции.
   Перед запуском необходимо задать значения глобальных констант.
   Суть: заменяет символ CHR(5), находящийся между "Депоз" и номером
   договора, на символ ",", потому что так он сохраняется в history.
   
   Раскомментируйте ниже модификатор SQL!
*/

/** Тип договора - МБК: Кредит ; ИБС: Депоз */ 
&GLOBAL-DEFINE CONT_TYPE Депоз
/** Номер договора */
&GLOBAL-DEFINE CONT_CODE 3-0880/0001/Ф
/** Код комиссии МБК: %Кред и %Рез; ИБС: SafeRent */
&GLOBAL-DEFINE COMM_CODE SafeRent
/** Дата начала условия (дата открытия договора) в формате ДД/ММ/ГГ */
&GLOBAL-DEFINE SINCE 25/09/07
/** Валюта договора. Пустое значение, если валюта - рубли */
&GLOBAL-DEFINE CURR 

select surrogate format "x(50)" from signs where 
file-name = "comm-rate" and code = "class-code" and surrogate like 
"{&COMM_CODE}%{&CONT_TYPE}%{&CONT_CODE}%{&SINCE}".

/** Раскомментируйте здесь для работы */


do:
disable triggers for load of signs.
update signs set surrogate = "{&COMM_CODE},0,{&CURR},{&CONT_TYPE},{&CONT_CODE},0,0,{&SINCE}" where
file-name = "comm-rate" and code = "class-code" and surrogate like
"{&COMM_CODE}%{&CONT_TYPE}%{&CONT_CODE}%{&SINCE}".                                           
end.


