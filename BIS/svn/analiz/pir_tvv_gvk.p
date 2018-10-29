/********************************************/
/***   pir_tvv_gvk.p                      ***/
/********************************************/
/*** Отчет выводит в файл список          ***/
/*** клиентов по группам ГВК              ***/
/***                                      ***/
/********************************************/

{globals.i}
{sh-defs.i}
{tmprecid.def}
{ulib.i}
{pir_exf_exl.i}
/*** {getdates.i}   ***/
{getdate.i}


DEF VAR p_File	            AS CHAR NO-UNDO.
DEF VAR p_DAY               AS CHAR NO-UNDO.
DEF VAR p_MONTH             AS CHAR NO-UNDO.
DEF VAR p_YEAR              AS CHAR NO-UNDO.
DEF VAR dt_cur              AS DATE NO-UNDO.
DEF VAR cXL                 AS CHAR NO-UNDO.
DEF VAR i                   AS INT NO-UNDO INIT 1.
DEF VAR p_code              AS CHAR NO-UNDO.
DEF VAR p_code-value        AS CHAR NO-UNDO.
DEF VAR p_surrogate         AS CHAR NO-UNDO.
DEF VAR p_file-name         AS CHAR NO-UNDO.
DEF VAR p_since             AS DATE FORMAT "99/99/99".
DEF VAR p_cust-stat         AS CHAR NO-UNDO.
DEF VAR p_name-corp         AS CHAR NO-UNDO.
DEF VAR p_1                 AS CHAR NO-UNDO.
DEF VAR p_2                 AS CHAR NO-UNDO.
DEF VAR p_GR_1              AS INT NO-UNDO INIT 0.
DEF VAR p_GR_2              AS INT NO-UNDO INIT 0.
DEF VAR symb                AS CHAR NO-UNDO.


/***  Временная таблица                     ***/
DEF TEMP-TABLE t_gvk_names NO-UNDO
      FIELD code AS INT
      FIELD code-value AS CHAR
      FIELD surrogate AS CHAR 
      FIELD file-name AS CHAR
      FIELD since AS DATE FORMAT "99/99/9999"
      FIELD name_client AS CHAR
      INDEX i_gvk_names IS PRIMARY code  name_client  ASCENDING
    .

IF LENGTH(STRING(DAY(end-date))) = 1 THEN
   DO:
     p_DAY = "0" + STRING(DAY(end-date)).
   END.
ELSE
   DO:
     p_DAY = STRING(DAY(end-date)).
   END.


IF LENGTH(STRING(MONTH(end-date))) = 1 THEN
   DO:
     p_MONTH = "0" + STRING(MONTH(end-date)).
   END.
ELSE
   DO:
     p_MONTH = STRING(MONTH(end-date)).
   END.

p_File =  "REP_ANALIZ" + "/" + "GROUP_".
p_File = p_File + p_DAY + p_MONTH + STRING(YEAR(end-date)) + ".xls".

/***p_File = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + p_File .   ***/
{exp-path.i &exp-filename = "p_File"}

dt_cur = end-date.

PUT UNFORMATTED XLHead("Состав Групп по ГВК", "CCCCC", "60, 70, 320, 60, 80").

cXL = 
    XLCell("                            ")
  + XLCell(" СОСТАВ ГРУПП ВЗАИМОСВЯЗАННЫХ КЛИЕНТОВ за  " + STRING(end-date, "99/99/99")
             ).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .


cXL = 
    XLEmptyCells(2).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell("ГРУППА")
  + XLCell("ПорядНом")
  + XLCell("Наименование/ФИО")
  + XLCell("ГВК")
  + XLCell("Вкл.в группу")
.

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

DECLARE curs_signs CURSOR FOR


SELECT SUBSTRING(tsgn.code-value, 4), tsgn.code-value, tsgn.surrogate, tsgn.file-name,
       tsgn.since, crp.cust-stat, crp.name-corp

FROM tmpsigns tsgn
INNER JOIN cust-corp crp
ON STRING(crp.cust-id) = tsgn.surrogate

WHERE tsgn.file-name = "cust-corp" AND
      tsgn.code = "ГВК" AND
      tsgn.since <= dt_cur AND
      tsgn.surrogate = (SELECT DISTINCT STRING(act.cust-id)
                         FROM acct act
                         WHERE act.cust-cat = "Ю" AND 
                               (act.close-date IS NULL OR act.close-date >= dt_cur) AND 
                               act.open-date <= dt_cur AND
                               STRING(act.cust-id) = tsgn.surrogate
                         )

UNION

SELECT SUBSTRING(tsgn.code-value, 4), tsgn.code-value, tsgn.surrogate, tsgn.file-name,
       tsgn.since, psn.name-last, psn.first-names

FROM tmpsigns tsgn
INNER JOIN person psn
ON STRING(psn.person-id) = tsgn.surrogate

WHERE tsgn.file-name = "person" AND
      tsgn.code = "ГВК" AND
      tsgn.since <= dt_cur AND
      tsgn.surrogate = (SELECT DISTINCT STRING(act.cust-id)
                         FROM acct act
                         WHERE act.cust-cat = "Ч" AND 
                               (act.close-date IS NULL OR act.close-date >= dt_cur) AND 
                               act.open-date <= dt_cur AND
                               STRING(act.cust-id) = tsgn.surrogate
                         )


UNION

SELECT SUBSTRING(tsgn.code-value, 4), tsgn.code-value, tsgn.surrogate, tsgn.file-name,
       tsgn.since, bnk.name, ""

FROM tmpsigns tsgn
INNER JOIN banks bnk
ON STRING(bnk.bank-id) = tsgn.surrogate

WHERE tsgn.file-name = "banks" AND
      tsgn.code = "ГВК" AND
      tsgn.since <= dt_cur
ORDER BY 3, 4, 5 DESC
.

p_1 = "".

/*********************************************************************/
symb = "-".
PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ ... " + STRING(" ","X(48)").

    put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
/*********************************************************************/

OPEN curs_signs.
REPEAT:
  FETCH curs_signs INTO p_code, p_code-value, p_surrogate, p_file-name,
                        p_since, p_cust-stat, p_name-corp
  .

  ASSIGN
   p_2 = p_surrogate + p_file-name
  .

  IF p_1 <> p_2 THEN    /***   если клиент переведен в другое ГВК, ***/
                         /***   то брать только первое. На самом деле последнее, ***/
                         /***   т.к. отсортировано по tsgn.since DESC  ***/
    DO:
       CREATE t_gvk_names.
       ASSIGN
        t_gvk_names.code = INTEGER(p_code)
        t_gvk_names.code-value = p_code-value
        t_gvk_names.surrogate = p_surrogate
        t_gvk_names.file-name = p_file-name
        t_gvk_names.since = p_since
        t_gvk_names.name_client = p_cust-stat + " " + p_name-corp
        .

    END.   /***  DO - IF  ***/

    p_1 = p_surrogate + p_file-name.

/*********************************************************************/
    put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
/*********************************************************************/

END.  /*** repeat   ***/
CLOSE curs_signs.

p_GR_1 = 0.

FOR EACH t_gvk_names :

  p_GR_2 = t_gvk_names.code.

  IF t_gvk_names.code <> 0 THEN DO:   /***   не брать с пустой (0) группой  ***/
     IF p_GR_1 <> p_GR_2 THEN DO:   /***   для печати название группы  ***/
         cXL = XLCell("")
             + XLEmptyCell()
             + XLCell("               " + 
                      "ГРУППА" + "  " + STRING(t_gvk_names.code))
         .

         PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
         i = 1.
 
     END.      /***  END-DO   ***/

     cXL = XLNUMCell(t_gvk_names.code)
         + XLCell(STRING(i, ">>>>9"))
         + XLCell(t_gvk_names.name_client)
         + XLCell(t_gvk_names.code-value)
         + XLCell(STRING(t_gvk_names.since, "99/99/9999"))

/***
         + XLCell(t_gvk_names.surrogate)
         + XLCell(t_gvk_names.file-name)
         + XLCell(t_gvk_names.name_client)
***/
     .

     PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
     i = i + 1.
     p_GR_1 = t_gvk_names.code.

/*********************************************************************/
    put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
/*********************************************************************/

  END.   /***  DO - IF  ***/
END.        /***  END-FOR  ***/

PUT UNFORMATTED XLEnd().

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ - ЗАВЕРШЕНА." + STRING(" ","X(48)").


MESSAGE " УСПЕШНО СФОРМИРОВАН !!! " VIEW-AS ALERT-BOX  TITLE " Отчет по ГВК ".

