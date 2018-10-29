/* ООО ПИР Банк, Управление автоматизации 2013г.   
   pir-intellipp.p
   Интеллектуальное платёжное поручение.
   
   Летопись версий:                                  
   v0.9 - проверяем, каким пользователем вызвана  
  	  процедура печати. В зависимости от       
          печатаем платёжку _bs (без штампа) или
	  _e (со штампом). В настоящее время,
	  актуально только для док-ов с кодом 01.
          Заявка #2254 
*/

def var input-proc as char no-undo.
def input parameter rid as recid.


/* Операционисты имеют uidы, начинающиеся на 04101 (Д4, у10-1). */

If can-do("04101*",userid('bisquit')) then input-proc = "pirpp-uni_e".
	else input-proc = "pirpp-uni_bs".

If SEARCH(input-proc + ".r") <> ? then run VALUE (input-proc + ".r")(rid).
	else run VALUE(input-proc + ".p")(rid).
