/*
PIR: V.N.Ermilov 24/09/2010
Переделана из бисовской person.p для возвращения в программу не id записи из таблицы с частными лицам, а записи вида #ФИО_КЛИЕНТА#,#ID_КЛИЕНТА#
*/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: person.p
      Comment: 
         Uses:
      Used by:
      Created: ???
     Modified: 03/06/99 Om  Изменен порядок 1. Лицевые счета 2. Договоры
     Modified: 06/09/04 ilvi переведен на стандартный справочник
*/

{globals.i}

DEFINE INPUT PARAMETER iLevel AS INTEGER    NO-UNDO.

RUN browseld.p("person",
               "SetFirstFrm",
               "1",
               ?,
               iLevel).

/*
MESSAGE iLevel  VIEW-AS ALERT-BOX.
MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX.
MESSAGE pick-value VIEW-AS ALERT-BOX.
*/

IF pick-value NE "" AND pick-value <> ?
THEN
DO:
    FIND FIRST person WHERE person.person-id EQ INT(pick-value).
    IF AVAIL person THEN 
    pick-value = person.name-last + " " + person.first-names + "," + pick-value
    .


END.




