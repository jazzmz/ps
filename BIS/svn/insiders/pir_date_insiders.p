/**************************************************/
/***   pir_date_insiders.p                      ***/
/**************************************************/

/*** Глобальные определения ***/
{globals.i}
{sh-defs.i}
{tmprecid.def}

/*******************************************************************/
DEF VAR p_person-id         AS INT NO-UNDO.
DEF VAR p_name-last         AS CHAR NO-UNDO.
DEF VAR p_first-names       AS CHAR NO-UNDO.
DEF VAR p_cust-role-id      AS INT NO-UNDO.
DEF VAR p_file-name         AS CHAR NO-UNDO.
DEF VAR p_surrogate         AS CHAR NO-UNDO.
DEF VAR p_Class-Code        AS CHAR NO-UNDO.
DEF VAR p_cust-name         AS CHAR NO-UNDO.
DEF VAR p_code              AS CHAR NO-UNDO.
DEF VAR p_ves_sviazi        AS INT NO-UNDO.
DEF VAR p_chet              AS INT NO-UNDO.
DEF VAR i_ch                AS INT NO-UNDO INIT 0.
DEF VAR p_open-date         AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_close-date        AS DATE NO-UNDO FORMAT "99/99/9999".

DEF VAR sum_Class-Code      AS CHAR NO-UNDO.
DEF VAR ins_Class-Code      AS CHAR NO-UNDO.
DEF VAR ch1_ves_sviazi      AS CHAR NO-UNDO INIT "Член Совета директоров".
DEF VAR ch2_ves_sviazi      AS CHAR NO-UNDO INIT "Член Правления".
DEF VAR ch3_ves_sviazi      AS CHAR NO-UNDO INIT "Председатель Правления".
DEF VAR ch4_ves_sviazi      AS CHAR NO-UNDO INIT "Заместитель Председателя Правления".
DEF VAR ch5_ves_sviazi      AS CHAR NO-UNDO INIT "Главный бухгалтер".
DEF VAR ch6_ves_sviazi      AS CHAR NO-UNDO INIT "Заместитель Главного бухгалтера".
DEF VAR ch7_ves_sviazi      AS CHAR NO-UNDO INIT "Член Кредитного комитета".
DEF VAR ch8_ves_sviazi      AS CHAR NO-UNDO INIT " ".  /*** "БИнсайдерСНеиспОбяз" ***/         
DEF VAR ch9_ves_sviazi      AS CHAR NO-UNDO INIT " ".    /*** "СотрБанкаВозмВозд"   ***/
DEF VAR ch10_ves_sviazi     AS CHAR NO-UNDO INIT "Родственник".
DEF VAR ch11_ves_sviazi     AS CHAR NO-UNDO INIT "Сотрудник Банка".
DEF VAR ch12_ves_sviazi     AS CHAR NO-UNDO INIT "УчастникРазмерДоли".
DEF VAR ch13_ves_sviazi     AS CHAR NO-UNDO INIT "ЗависимаяОрганизация".
DEF VAR ch14_ves_sviazi     AS CHAR NO-UNDO INIT "ДочерняяОрганизация".
DEF VAR ch15_ves_sviazi     AS CHAR NO-UNDO INIT "МатеринскаяОрган".
DEF VAR ch16_ves_sviazi     AS CHAR NO-UNDO INIT "ОбязательныеУказания".
DEF VAR ch17_ves_sviazi     AS CHAR NO-UNDO INIT "ПоПредложИзбранЕИО".
DEF VAR ch18_ves_sviazi     AS CHAR NO-UNDO INIT "ПоПредлИзбБол50КИО".

DEF VAR p_Razdel            AS CHAR NO-UNDO.
DEF VAR log_Razdel1         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel2         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel3         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel4         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel5         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel6         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel7         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel8         AS INT NO-UNDO INIT 0.
DEF VAR log_Razdel9         AS INT NO-UNDO INIT 0.

DEF VAR p_Razdel1           AS CHAR NO-UNDO INIT "Члены Совета директоров:".
DEF VAR p_Razdel2           AS CHAR NO-UNDO INIT "Члены Правления:".
DEF VAR p_Razdel3           AS CHAR NO-UNDO INIT "Председатель Правлениям:".
DEF VAR p_Razdel4           AS CHAR NO-UNDO INIT "Заместителя Председателя Правления:".
DEF VAR p_Razdel5           AS CHAR NO-UNDO INIT "Главный бухгалтер:".
DEF VAR p_Razdel6           AS CHAR NO-UNDO INIT "Заместители Главного бухгалтера:".
DEF VAR p_Razdel7           AS CHAR NO-UNDO INIT "Члены Кредитного комитета:".
DEF VAR p_Razdel8           AS CHAR NO-UNDO INIT "Лица, которые в момент получения кредита относились к инсайдерам и не исполнили обязательства по кредитным требованиям на день, когда они перестали к ним относиться:".
DEF VAR p_Razdel9           AS CHAR NO-UNDO INIT "Сотрудники Банка, которые обладают возможностьями воздействия на характер принимаемых решений о выдаче кредита Банком, и их близкие родственники:".
DEF VAR p_RazdelRodst       AS CHAR NO-UNDO INIT "Близкие родственники лиц, указанных выше:".

DEF VAR p_Rodst_Class-Code  AS CHAR NO-UNDO.
DEF VAR cr AS CHAR NO-UNDO.
DEF VAR Ruk_D7B  AS CHAR NO-UNDO INIT "Начальник Д7Б".
DEF VAR dt_cur              AS DATE NO-UNDO.


cr = CHR(10).

/*******************************************************************
                    Вес связи

 "ЧленСДНС"              - p_ves_sviazi = 1.
 "ЧленКИО"               - p_ves_sviazi = 2.
 "ЕИО"                   - p_ves_sviazi = 3.
 "ЗамЕИО"                - p_ves_sviazi = 4.
 "ГлБухгалтер"           - p_ves_sviazi = 5.
 "ЗамГлБухгалтер"        - p_ves_sviazi = 6.
 "ЧленКК"                - p_ves_sviazi = 7.
 "БИнсайдерСНеиспОбяз"   - p_ves_sviazi = 8.
 "СотрБанкаВозмВозд"     - p_ves_sviazi = 9.
  Родственник           -  99            10
  СотрудникБанка        -  99            11
  УчастникРазмерДоли    -  99            12
  ЗависимаяОрганизация  -  99            13
  ДочерняяОрганизация   -  99            14
  МатеринскаяОрган      -  99            15
  ОбязательныеУказания  -  99            16
  ПоПредложИзбранЕИО    -  99            17
  ПоПредлИзбБол50КИО    -  99            18
******************************************************************/

/***  Временная таблица                     ***/
DEF TEMP-TABLE t_cust-role NO-UNDO

      FIELD person-id LIKE person.person-id
      FIELD name-last LIKE person.name-last
      FIELD first-names LIKE person.first-names
      FIELD cust-role-id LIKE cust-role.cust-role-id
      FIELD file-name LIKE cust-role.file-name
      FIELD surrogate LIKE cust-role.surrogate
      FIELD Class-Code LIKE cust-role.Class-Code
      FIELD cust-name LIKE cust-role.cust-name
      FIELD open-date LIKE cust-role.open-date
      FIELD close-date LIKE cust-role.close-date
      FIELD ves_sviazi AS INT
      FIELD code  LIKE signs.code
      FIELD xattr-value LIKE signs.xattr-value
      INDEX i_t_cust-role IS PRIMARY person-id ves_sviazi
      .

/***  Временная таблица                     ***/
DEF TEMP-TABLE t_ves_sv NO-UNDO
      FIELD person-id LIKE person.person-id
      FIELD name-last LIKE person.name-last
      FIELD first-names LIKE person.first-names
      FIELD Class-Code LIKE cust-role.Class-Code
      FIELD open-date LIKE cust-role.open-date
      FIELD close-date LIKE cust-role.close-date
      FIELD ves_sviazi AS INT
      INDEX i_t_ves_sv IS PRIMARY ves_sviazi person-id
      .


/***  Временная таблица                     ***/
DEF TEMP-TABLE t_find_cl NO-UNDO
      FIELD person-id LIKE person.person-id
      FIELD name-last LIKE person.name-last
      FIELD first-names LIKE person.first-names
      INDEX i_find_cl IS PRIMARY person-id
      .



{getdate.i}
dt_cur = end-date.

/*********************************************************************/
PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ ... " + STRING(" ","X(48)").
/*********************************************************************/

DECLARE curs_cust-role CURSOR FOR

SELECT psn.person-id, psn.name-last, psn.first-names, crole.cust-role-id,
       crole.file-name, crole.surrogate, crole.Class-Code, crole.cust-name,
       "Примечание", crole.open-date, crole.close-date

FROM cust-role crole, person psn

WHERE crole.surrogate = STRING(psn.person-id) AND
      crole.file-name = "person" AND
      crole.open-date = dt_cur AND
      crole.Class-Code IN ("ЧленСДНС", "ЧленКИО", "ЕИО", "ЗамЕИО", "ГлБухгалтер", "ЗамГлБухгалтер",
                           "ЧленКК", "БИнсайдерСНеиспОбяз", "СотрБанкаВозмВозд", "Родственник", 
                           "СотрудникБанка", "УчастникРазмерДоли", "ЗависимаяОрганизация", 
                           "ДочерняяОрганизация", "МатеринскаяОрган", "ОбязательныеУказания", 
                           "ПоПредложИзбранЕИО", "ПоПредлИзбБол50КИО") 

ORDER BY 1
.


OPEN curs_cust-role.

REPEAT:
  FETCH curs_cust-role INTO p_person-id, p_name-last, p_first-names, p_cust-role-id,
        p_file-name, p_surrogate, p_Class-Code, p_cust-name,
        p_code, p_open-date, p_close-date
  .

  CASE p_Class-Code :
   WHEN "ЧленСДНС" THEN p_ves_sviazi = 1.
   WHEN "ЧленКИО" THEN p_ves_sviazi = 2.
   WHEN "ЕИО" THEN p_ves_sviazi = 3.
   WHEN "ЗамЕИО" THEN p_ves_sviazi = 4.
   WHEN "ГлБухгалтер" THEN p_ves_sviazi = 5.
   WHEN "ЗамГлБухгалтер" THEN p_ves_sviazi = 6.
   WHEN "ЧленКК" THEN p_ves_sviazi = 7.
   WHEN "БИнсайдерСНеиспОбяз" THEN p_ves_sviazi = 8.
   WHEN "СотрБанкаВозмВозд" THEN p_ves_sviazi = 9.

   OTHERWISE p_ves_sviazi = 99.
  END.  /***   CASE  ***/


  CREATE t_cust-role.
  ASSIGN t_cust-role.person-id = p_person-id
         t_cust-role.name-last = p_name-last
         t_cust-role.first-names = p_first-names
         t_cust-role.cust-role-id = p_cust-role-id
         t_cust-role.file-name = p_file-name
         t_cust-role.surrogate = p_surrogate
         t_cust-role.Class-Code = p_Class-Code
         t_cust-role.cust-name = p_cust-name
         t_cust-role.ves_sviazi = p_ves_sviazi
         t_cust-role.code = p_code
         t_cust-role.xattr-value = TRIM(GetXAttrValueEx("cust-role", STRING(p_cust-role-id), "Примечание", ""))
         t_cust-role.open-date = p_open-date
         t_cust-role.close-date = p_close-date.


  CREATE t_ves_sv.
  ASSIGN t_ves_sv.person-id = p_person-id
         t_ves_sv.name-last = p_name-last
         t_ves_sv.first-names = p_first-names
         t_ves_sv.Class-Code = p_Class-Code
         t_ves_sv.ves_sviazi = p_ves_sviazi
         t_ves_sv.open-date = p_open-date
         t_ves_sv.close-date = p_close-date.


END.  /*** repeat   ***/
CLOSE curs_cust-role.

/****************************************************************************/
/***        Обработка                                                     ***/
/***                                                                      ***/
/****************************************************************************/

DEF VAR oTable AS TTable2 NO-UNDO.
oTable = NEW TTable2().
oTable:colsHeaderList="№ п/п,Инсайдер,Вид Связи,С кем связь,Примечание".
oTable:setcolWidth(1, 5).
oTable:setcolWidth(2, 20).
oTable:setcolWidth(3, 20).
oTable:setcolWidth(4, 20).
oTable:setcolWidth(5, 40).

p_Razdel = "".

FOR EACH t_ves_sv  WHERE t_ves_sv.ves_sviazi <= 9   :

  FIND FIRST t_find_cl
      WHERE t_ves_sv.person-id = t_find_cl.person-id
      NO-LOCK NO-ERROR.
  IF NOT AVAIL t_find_cl THEN
   DO:
    CREATE t_find_cl.
    ASSIGN t_find_cl.person-id = t_ves_sv.person-id
           t_find_cl.name-last = t_ves_sv.name-last
           t_find_cl.first-names = t_ves_sv.first-names.

    i_ch = i_ch + 1.
    p_chet = 1.

    CASE t_ves_sv.ves_sviazi :
       WHEN 1 THEN DO:
                     log_Razdel1 = log_Razdel1 + 1.
                   END.
       WHEN 2 THEN DO:
                     log_Razdel2 = log_Razdel2 + 1.
                   END.
       WHEN 3 THEN  DO:
                      log_Razdel3 = log_Razdel3 + 1.
                    END.
       WHEN 4 THEN  DO:
                      log_Razdel4 = log_Razdel4 + 1.
                    END.
       WHEN 5 THEN  DO:
                      log_Razdel5 = log_Razdel5 + 1.
                    END.
       WHEN 6 THEN  DO:
                      log_Razdel6 = log_Razdel6 + 1.
                    END.
       WHEN 7 THEN  DO:
                      log_Razdel7 = log_Razdel7 + 1.
                    END.
       WHEN 8 THEN  DO:
                      log_Razdel8 = log_Razdel8 + 1.
                    END.
       WHEN 9 THEN  DO:
                      log_Razdel9 = log_Razdel9 + 1.
                    END.
    END.  /***   CASE  ***/

    IF log_Razdel1 = 1 THEN
      DO:
        p_Razdel = "Раздел ЧленСДНС".
        p_Razdel = p_Razdel1.
        log_Razdel1 = log_Razdel1 + 1.
      END.
    ELSE IF log_Razdel2 = 1 THEN
          DO:
           p_Razdel = "Раздел ЧленКИО".
           p_Razdel = p_Razdel2.
           log_Razdel2 = log_Razdel2 + 1.
          END.
    ELSE IF log_Razdel3 = 1 THEN
          DO:
           p_Razdel = "Раздел КИО".
           p_Razdel = p_Razdel3.
           log_Razdel3 = log_Razdel3 + 1.
          END.
    ELSE IF log_Razdel4 = 1 THEN
          DO:
           p_Razdel = "Раздел ЗамЕИО".
           p_Razdel = p_Razdel4.
           log_Razdel4 = log_Razdel4 + 1.
          END.
    ELSE IF log_Razdel5 = 1 THEN
          DO:
           p_Razdel = "Раздел ГлБухгалтер".
           p_Razdel = p_Razdel5.
           log_Razdel5 = log_Razdel5 + 1.
          END.
    ELSE IF log_Razdel6 = 1 THEN
          DO:
           p_Razdel = "Раздел ЗамГлБухгалтер".
           p_Razdel = p_Razdel6.
           log_Razdel6 = log_Razdel6 + 1.
          END.
    ELSE IF log_Razdel7 = 1 THEN
          DO:
           p_Razdel = "Раздел ЧленКК".
           p_Razdel = p_Razdel7.
           log_Razdel7 = log_Razdel7 + 1.
          END.
    ELSE IF log_Razdel8 = 1 THEN
          DO:
           p_Razdel = "Раздел БИнсайдерСНеиспОбяз".
           p_Razdel = p_Razdel8.
           log_Razdel8 = log_Razdel8 + 1.
          END.
    ELSE IF log_Razdel9 = 1 THEN
          DO:
           p_Razdel = "Раздел СотрБанкаВозмВозд".
           p_Razdel = p_Razdel9.
           log_Razdel9 = log_Razdel9 + 1.
          END.

    IF LENGTH(p_Razdel) > 0 THEN DO:
       oTable:addRow().
       oTable:addCell("").
       oTable:addCell(p_Razdel).
       oTable:addCell("").
       oTable:addCell("").
       oTable:addCell("").
       p_Razdel = "".
    END.


    oTable:addRow().
    oTable:addCell(i_ch).
    oTable:addCell(t_ves_sv.name-last + " " + t_ves_sv.first-names).
  
    FOR EACH t_cust-role  WHERE t_ves_sv.person-id = t_cust-role.person-id    :

     CASE t_cust-role.Class-Code :
         WHEN "ЧленСДНС" THEN ins_Class-Code = ch1_ves_sviazi.
         WHEN "ЧленКИО" THEN ins_Class-Code = ch2_ves_sviazi.
         WHEN "ЕИО" THEN ins_Class-Code = ch3_ves_sviazi.
         WHEN "ЗамЕИО" THEN ins_Class-Code = ch4_ves_sviazi.
         WHEN "ГлБухгалтер" THEN ins_Class-Code = ch5_ves_sviazi.
         WHEN "ЗамГлБухгалтер" THEN ins_Class-Code = ch6_ves_sviazi.
         WHEN "ЧленКК" THEN ins_Class-Code = ch7_ves_sviazi.
         WHEN "БИнсайдерСНеиспОбяз" THEN ins_Class-Code = ch8_ves_sviazi.
         WHEN "СотрБанкаВозмВозд" THEN ins_Class-Code = ch9_ves_sviazi.

/***********************************
         WHEN "Родственник" THEN ins_Class-Code = ch10_ves_sviazi.
         WHEN "СотрудникБанка" THEN ins_Class-Code = ch11_ves_sviazi.
         WHEN "УчастникРазмерДоли" THEN ins_Class-Code = ch12_ves_sviazi.
         WHEN "ЗависимаяОрганизация" THEN ins_Class-Code = ch13_ves_sviazi.
         WHEN "ДочерняяОрганизация" THEN ins_Class-Code = ch14_ves_sviazi.
         WHEN "МатеринскаяОрган" THEN ins_Class-Code = ch15_ves_sviazi.
         WHEN "ОбязательныеУказания" THEN ins_Class-Code = ch16_ves_sviazi.
         WHEN "ПоПредложИзбранЕИО" THEN ins_Class-Code = ch17_ves_sviazi.
         WHEN "ПоПредлИзбБол50КИО" THEN ins_Class-Code = ch18_ves_sviazi.
***********************************/

         OTHERWISE ins_Class-Code = "".
     END.  /***   CASE  ***/

     IF LENGTH(ins_Class-Code) > 0 THEN DO:

       IF p_chet = 1 THEN
        DO:
         oTable:addCell(ins_Class-Code).          /*** t_cust-role.Class-Code  ***/
         oTable:addCell(t_cust-role.cust-name).
         oTable:addCell(t_cust-role.xattr-value).

        END.
       ELSE
        DO:
         oTable:addRow().
         oTable:addCell("").
         oTable:addCell("").
         oTable:addCell(ins_Class-Code).         /*** t_cust-role.Class-Code  ***/
         oTable:addCell(t_cust-role.cust-name).
         oTable:addCell(t_cust-role.xattr-value).

        END.
       p_chet = p_chet + 1.
     END.

   END.    /***   FIND FIRST t_find_cl    ***/

  END.  /*** FOR  t_cust-role  ***/
END.  /*** FOR   t_ves_sv  ***/

/***************************************************************************************/
/***    вывести родственников   ***/
/***************************************************************************************/
    oTable:addRow().
    oTable:addCell("").
    oTable:addCell(p_RazdelRodst).
    oTable:addCell("").
    oTable:addCell("").
    oTable:addCell("").

    ins_Class-Code = "".

    FOR EACH t_cust-role  WHERE t_cust-role.Class-Code = "Родственник" :
     sum_Class-Code = "".
     FOR EACH  t_ves_sv  WHERE t_ves_sv.person-id = t_cust-role.person-id AND
                               t_ves_sv.ves_sviazi <= 9 :

      p_Rodst_Class-Code = t_ves_sv.Class-Code.

      CASE p_Rodst_Class-Code :
          WHEN "ЧленСДНС" THEN ins_Class-Code = ch1_ves_sviazi.
          WHEN "ЧленКИО" THEN ins_Class-Code = ch2_ves_sviazi.
          WHEN "ЕИО" THEN ins_Class-Code = ch3_ves_sviazi.
          WHEN "ЗамЕИО" THEN ins_Class-Code = ch4_ves_sviazi.
          WHEN "ГлБухгалтер" THEN ins_Class-Code = ch5_ves_sviazi.
          WHEN "ЗамГлБухгалтер" THEN ins_Class-Code = ch6_ves_sviazi.
          WHEN "ЧленКК" THEN ins_Class-Code = ch7_ves_sviazi.
          WHEN "БИнсайдерСНеиспОбяз" THEN ins_Class-Code = ch8_ves_sviazi.
          WHEN "СотрБанкаВозмВозд" THEN ins_Class-Code = ch9_ves_sviazi.

          OTHERWISE ins_Class-Code = "".
      END.  /***   CASE  ***/
      sum_Class-Code = sum_Class-Code + ins_Class-Code + "   ".

     END.  /***  FOR t_ves_sv  ***/

     i_ch = i_ch + 1.
     oTable:addRow().
     oTable:addCell(i_ch).
     oTable:addCell(t_cust-role.cust-name).
     oTable:addCell(t_cust-role.xattr-value).
     oTable:addCell(t_cust-role.name-last + " " + t_cust-role.first-names).
     oTable:addCell(sum_Class-Code).

    END.  /*** FOR  t_cust-role  ***/
/*****************************************************************************/

DEF VAR currDate     AS DATE NO-UNDO FORMAT "99/99/9999".
currDate = dt_cur.

{tpl.create}

oTpl:addAnChorValue("DATE", currDate).
oTpl:addAnChorValue("cr1", cr).
oTpl:addAnChorValue("cr1", cr).
oTpl:addAnChorValue("cr1", cr).
oTpl:addAnChorValue("Table", oTable).
oTpl:addAnChorValue("M_Ruk_D7B", Ruk_D7B).

{tpl.show}
DELETE OBJECT oTable.
{tpl.delete}


/**************************
{setdest.i}
/***  
PUT UNFORM "Привет" SKIP.
***/
oTable:show().
{preview.i}
DELETE OBJECT oTable.
**************************/

/**********************************************************************************
TEMP-TABLE t_cust-role:WRITE-XML("file","./out_cust-role.xml",YES,?,?,NO,NO).
TEMP-TABLE t_ves_sv:WRITE-XML("file","./out_ves_sv.xml",YES,?,?,NO,NO).
TEMP-TABLE t_find_cl:WRITE-XML("file","./out_find_cl.xml",YES,?,?,NO,NO).
**********************************************************************************/


/**********************************************************************************/
PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ - ЗАВЕРШЕНА." + STRING(" ","X(48)").
/**********************************************************************************/

MESSAGE " УСПЕШНО СФОРМИРОВАН. " VIEW-AS ALERT-BOX TITLE " ОТЧЕТ ".
PUT SCREEN col 1 row 24 color bright-blink-normal 
       "                                    " + STRING(" ","X(48)").
