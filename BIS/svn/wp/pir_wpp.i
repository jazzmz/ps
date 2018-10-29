/* ------------------------------------------------------
File          : $RCSfile: pir_wpp.i,v $ $Revision: 1.2 $ $Date: 2007-08-08 12:12:46 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Форма выбора категорий учета для процедуры Рабочего плана счетов.
Место запуска : Используется в pir_wpcls.p, pir_wp.p, pir_wpcl.p
Автор         : ???
Изменения     : $Log: not supported by cvs2svn $
------------------------------------------------------ */
FORM
   bal-cat[1]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " БАЛАНСОВЫЕ СЧЕТА"  
   bal-cat[2]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " ВНЕБАЛАНСОВЫЕ СЧЕТА"  
   bal-cat[3]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " СЧЕТА ДЕПО"  
   bal-cat[4]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " СЧЕТА ПО СРОЧНЫМ СДЕЛКАМ"  
   bal-cat[5]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " СЧЕТА ДОВЕРИТЕЛЬНОГО УПРАВЛЕНИЯ"  
   bal-cat[6]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " СЧЕТА ВНЕСИСТЕМНОГО УЧЕТА ЦЕННОСТЕЙ"     
   bal-cat[7]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " БЮДЖЕТНЫЕ СЧЕТА"       
   bal-cat[8]
      AT 2
      VIEW-AS TOGGLE-BOX
      LABEL  " СЧЕТА НАЛОГОВОГО УЧЕТА"  
      
WITH FRAME frParam CENTERED ROW 10 column 2 overlay TITLE "[ ПЛАН СЧЕТОВ: ВЫБЕРИТЕ КАТЕГОРИИ УЧЕТА]".

PAUSE 0.
UPDATE
  bal-cat[1]
  bal-cat[2]
  bal-cat[3]
  bal-cat[4]
  bal-cat[5]
  bal-cat[6]
  bal-cat[7]
  bal-cat[8]
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE.

incat = "".
DO i = 1 TO 8:
 IF bal-cat[i] THEN
   DO:
      {additem.i incat entry(i,cat-all)}
   END.
END.

{pir-log.i &module="$RCSfile: pir_wpp.i,v $" &comment="Форма выбора категорий учета"}