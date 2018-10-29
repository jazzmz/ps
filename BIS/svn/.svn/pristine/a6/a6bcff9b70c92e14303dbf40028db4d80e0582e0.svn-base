{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-brcode.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Процедура выбора значений д/р из крассификатора с возвращением требуемого поля таблицы code
Причина		    : б/н, 20.06.07, Управление открытия счетов, Беззубова М.Ю.
Место запуска : Метод browse на реквизите классов (person, cust-corp)
Параметры     : В параметре метода надо указать код классификатора, значения из которого выбираются и 
              : наименование поля таблицы code, значение из которого будет возвращено 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.1  2007/06/22 08:06:50  lavrinenko
Изменения     : метод просмотра классификатора, с возвратом произвольного поля
Изменения     :
*************************
* Используется в качестве метода
* на реквизите ОценкаРиска в cust-corp
*************************
*
* Актуальность: 19.12.11
* 19.12.2011
*
----------------------------------------------------- */

{globals.i}

DEF INPUT PARAM in-class AS CHAR NO-UNDO.
DEF INPUT PARAM in-level AS INT  NO-UNDO.

FIND FIRST code WHERE code.class EQ "" AND code.code EQ ENTRY(1,in-class,'.') NO-LOCK NO-ERROR.

IF AVAIL code THEN DO:
    RUN pclass.p (code.code, code.code, code.name, in-level).
    IF (LASTKEY EQ 13 OR LASTKEY EQ 10) AND pick-value NE ? THEN DO:
    		FIND FIRST code WHERE code.class EQ ENTRY(1,in-class,'.') AND code.code EQ pick-value NO-LOCK NO-ERROR.
    		
    		pick-value = IF NOT AVAIL code THEN ?
    								 ELSE IF ENTRY(2,in-class,'.') EQ 'name' THEN code.name 
    								 ELSE IF ENTRY(2,in-class,'.') EQ 'code' THEN code.code 
    								 ELSE IF ENTRY(2,in-class,'.') EQ 'val'  THEN code.val 
/*    								 ELSE IF ENTRY(2,in-class,'.') EQ 'description' THEN code.description */
    								 ELSE ?.
    END.
END. /*  IF AVAIL code THEN*/
