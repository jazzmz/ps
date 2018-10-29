/******************************
 * 
 * Обработка по заявке #1481.
 * Если ИНН пользователя одни нули,
 * то будет его заменять на ?
 *
 *******************************
 * Автор         : Маслов Д. А. Maslov D. A.
 * Дата создания : 29.10.12
 * Заявка        : #1481
 *******************************/

{globals.i}
{intrface.get xclass}
DEF TEMP-TABLE tbl4Modify
        FIELD pk           AS INT
        FIELD nlast        AS CHAR
        FIELD inn          AS CHAR
        FIELD okato_nalog  AS CHAR
        FIELD okato_302    AS CHAR
        FIELD kpp          AS CHAR
.

FOR EACH person WHERE INT64(person.inn) = 0:
  CREATE tbl4Modify.
     ASSIGN
        tbl4Modify.pk          = person.person-id
        tbl4Modify.nlast       = person.name-last + " " + person.first-names
        tbl4Modify.inn         = person.inn
        tbl4Modify.okato_nalog = getXAttrValue("person",STRING(person-id),"ОКАТО-НАЛОГ")
        tbl4Modify.okato_302   = getXAttrValue("person",STRING(person-id),"ОКАТОР_302")
        tbl4Modify.kpp         = getXAttrValue("person",STRING(person-id),"КПП")
     .

   /**
    * Устаналвиваем значения в ноль.
    **/
   person.inn = "".
   UpdateSigns("person",STRING(person.person-id),"КПП",?,?).
END.

TEMP-TABLE tbl4Modify:WRITE-XML("file","./tbl-1481-" + STRING(ETIME) + ".xml",YES,?,?,NO,NO).
{intrface.del}