/********************************************/
/***   pir_tvv_svg0.p                     ***/
/********************************************/
/*** Отчет выводит в файл список          ***/
/*** не закрытые счета клиентов           ***/
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
DEF VAR p_cust-stat         AS CHAR NO-UNDO.
DEF VAR p_name-corp         AS CHAR NO-UNDO.
DEF VAR p_open-date         AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_acct              AS CHAR NO-UNDO.
DEF VAR p_close-date        AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_currency          AS CHAR NO-UNDO.
DEF VAR p_cust-id           AS INT NO-UNDO.
DEF VAR p1_cust-id          AS INT NO-UNDO.
DEF VAR p2_cust-id          AS INT NO-UNDO.


DEF VAR p_since             AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_balance           AS DECIMAL NO-UNDO.
DEF VAR p_sh-bal            AS DECIMAL NO-UNDO INIT 0.
DEF VAR p_sh-val            AS DECIMAL NO-UNDO INIT 0.
DEF VAR total-bal-val       AS DECIMAL NO-UNDO INIT 0.
DEF VAR viv1-bal-val        AS DECIMAL NO-UNDO INIT 0.
DEF VAR viv2-bal-val        AS DECIMAL NO-UNDO INIT 0.
DEF VAR viv3-bal-val        AS DECIMAL NO-UNDO INIT 0.
DEF VAR viv4-bal-val        AS DECIMAL NO-UNDO INIT 0.
DEF VAR viv5-bal-val        AS DECIMAL NO-UNDO INIT 0.


DEF VAR p_FIORukov          AS CHAR NO-UNDO.
DEF VAR p_UchrOrg           AS CHAR NO-UNDO.
DEF VAR p_cust-cat          AS CHAR NO-UNDO.
DEF VAR p1_cust-cat         AS CHAR NO-UNDO.
DEF VAR p2_cust-cat         AS CHAR NO-UNDO.

DEF VAR person_person-id    AS INT NO-UNDO.
DEF VAR person_name-last    AS CHAR NO-UNDO.
DEF VAR person_first-names  AS CHAR NO-UNDO.

/***  DEF VAR t_total_FIORukov    AS CHAR NO-UNDO.   ***/

DEF VAR p_gr_gvk            AS INT NO-UNDO.
DEF VAR p_Rodstvenniki      AS CHAR NO-UNDO.
DEF VAR p_fio_ruk_organ     AS CHAR NO-UNDO.
DEF VAR p1_Rodstvenniki     AS CHAR NO-UNDO.
DEF VAR p_GVK_RODSTV        AS INT NO-UNDO.
DEF VAR p_GVK_UCHRED        AS INT NO-UNDO.
DEF VAR p_BIS_gr_gvk        AS INT NO-UNDO.


/***  Временная таблица                     ***/
DEF TEMP-TABLE acc_acc-pos NO-UNDO
      FIELD cust-id LIKE acct.cust-id
      FIELD cust-stat AS CHAR
      FIELD name-corp AS CHAR 
      FIELD open-date LIKE acct.open-date
      FIELD acct LIKE acct.acct
      FIELD close-date LIKE acct.close-date
      FIELD currency LIKE acct.currency
      FIELD sh-bal AS DECIMAL
      FIELD sh-val AS DECIMAL
      FIELD total-bal-val AS DECIMAL
      FIELD FIORukov AS CHAR
      FIELD UchrOrg AS CHAR
      FIELD cust-cat LIKE acct.cust-cat
      INDEX i_acc_acc-pos IS PRIMARY cust-id cust-cat acct
    .

/***  Временная таблица                     ***/
DEF TEMP-TABLE t_total NO-UNDO
      FIELD cust-id LIKE acct.cust-id
      FIELD total-bal-val AS DECIMAL
      FIELD cust-cat LIKE acct.cust-cat
      FIELD ruk_cust-id LIKE person.person-id
      FIELD fio_ruk_organ AS CHAR
      FIELD gr_gvk AS INT INIT 0
      FIELD Rodstvenniki AS CHAR
      FIELD Uchrediteli AS CHAR
      FIELD BIS_gr_gvk AS INT INIT 0
      INDEX i_t_total IS PRIMARY total-bal-val DESCENDING cust-id cust-cat
    .


DEF BUFFER buf_t_total FOR t_total.
DEF BUFFER buf_person FOR person.
DEF BUFFER Rodstv_t_total FOR t_total.
DEF BUFFER uchred_person FOR person.
DEF BUFFER Uchred_t_total FOR t_total.


DEF VAR p_Ucredit            AS CHAR NO-UNDO.
DEF VAR p_spisok_Ucredit     AS CHAR NO-UNDO.
DEF VAR p_fio_Ucredit        AS CHAR NO-UNDO.
DEF VAR p_find_Uchred        AS CHAR NO-UNDO.
DEF VAR p_kod_sim            AS CHAR NO-UNDO.



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

/***  p_File =  "REP_ANALIZ" + "/" + "ACCOUNT_".    ***/
p_File =  "REP_ANALIZ" + "/" + "SVG0_".
p_File = p_File + p_DAY + p_MONTH + STRING(YEAR(end-date)) + ".xls".

/***p_File = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + p_File .   ***/
{exp-path.i &exp-filename = "p_File"}

dt_cur = end-date.

PUT UNFORMATTED XLHead("Не закрытые счета клиентов", "CCCCCCCC", "35, 250, 180, 120, 120, 120, 120, 120").

cXL = 
    XLCell("                            ")
  + XLCell(" НЕ ЗАКРЫТЫЕ СЧЕТА КЛИЕНТОВ за  " + STRING(end-date, "99/99/99")).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLEmptyCells(2).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell(" ГРУППА 0 ").
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell("")
/***    XLCell("cust-id")   ***/
  + XLCell("Наименование клиента")
  + XLCell("Номер счета")
  + XLCell("Рубли")
  + XLCell("Валюта")
  + XLCell("Всего в рублях")
/***  + XLCell("Группа ГВК")    ***/
/***  + XLCell("Родственники")  ***/
.

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

/*********************************************************************/
PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ ... " + STRING(" ","X(48)").
/*********************************************************************/



DECLARE acct_acct-pos CURSOR FOR

SELECT acc.cust-id, crp.cust-stat, crp.name-corp,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN cust-corp crp
ON crp.cust-id = acc.cust-id

WHERE acc.cust-cat = "Ю" AND
      acc.open-date <= dt_cur AND
      (acc.close-date >= dt_cur OR acc.close-date IS NULL) AND
      SUBSTRING(acc.acct, 1, 3) IN ("407", "408", "409", "421", "423", "438") AND
      STRING(acc.cust-id) NOT IN (SELECT DISTINCT tsgn.surrogate
                                  FROM tmpsigns tsgn
                                  WHERE tsgn.file-name = "cust-corp" AND
                                        tsgn.surrogate = STRING(acc.cust-id) AND
                                        tsgn.code = "ГВК" AND tsgn.since <= dt_cur
                                  )
UNION

SELECT acc.cust-id, psn.name-last, psn.first-names,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN person psn
ON psn.person-id = acc.cust-id

WHERE acc.cust-cat = "Ч" AND
      acc.open-date <= dt_cur AND
      (acc.close-date >= dt_cur OR acc.close-date IS NULL) AND
      SUBSTRING(acc.acct, 1, 3) IN ("407", "408", "409", "421", "423", "438") AND
      STRING(acc.cust-id) NOT IN (SELECT DISTINCT tsgn.surrogate
                                    FROM tmpsigns tsgn
                                    WHERE tsgn.file-name = "person" AND
                                          tsgn.surrogate = STRING(acc.cust-id) AND
                                          tsgn.code = "ГВК" AND tsgn.since <= dt_cur
                                  )

/*********************************************************************************************/       
/*** найти у которых tsgn.code = "ГВК" AND INTEGER(SUBSTRING(tsgn.code-value, 4)) = 0)     ***/
UNION

SELECT acc.cust-id, psn.name-last, psn.first-names,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN person psn
ON psn.person-id = acc.cust-id

WHERE acc.cust-cat = "Ч" AND
      acc.open-date <= dt_cur AND
      (acc.close-date >= dt_cur OR acc.close-date IS NULL) AND
      SUBSTRING(acc.acct, 1, 3) IN ("407", "408", "409", "421", "423", "438") AND
      STRING(acc.cust-id) IN (SELECT DISTINCT tsgn.surrogate
                                     FROM tmpsigns tsgn
                                     WHERE tsgn.file-name = "person" AND
                                           tsgn.surrogate = STRING(acc.cust-id) AND
                                           tsgn.code = "ГВК" AND tsgn.since <= dt_cur AND
                                           INTEGER(SUBSTRING(tsgn.code-value, 4)) = 0
                              )

UNION

SELECT acc.cust-id, crp.cust-stat, crp.name-corp,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN cust-corp crp
ON crp.cust-id = acc.cust-id

WHERE acc.cust-cat = "Ю" AND
      acc.open-date <= dt_cur AND
      (acc.close-date >= dt_cur OR acc.close-date IS NULL) AND
      SUBSTRING(acc.acct, 1, 3) IN ("407", "408", "409", "421", "423", "438") AND
      STRING(acc.cust-id) IN (SELECT DISTINCT tsgn.surrogate
                                  FROM tmpsigns tsgn
                                  WHERE tsgn.file-name = "cust-corp" AND
                                        tsgn.surrogate = STRING(acc.cust-id) AND
                                        tsgn.code = "ГВК" AND tsgn.since <= dt_cur AND
                                        INTEGER(SUBSTRING(tsgn.code-value, 4)) = 0
                              )
/*********************************************************************************************/
/*** ORDER BY 3, 4, 5 DESC  ***/
ORDER BY 1, 8 ,5
.

p1_cust-id = 0.
p1_cust-cat = "".

OPEN acct_acct-pos.

REPEAT:
  FETCH acct_acct-pos INTO p_cust-id, p_cust-stat, p_name-corp,
                           p_open-date, p_acct, p_close-date, p_currency, p_cust-cat
  .

  RUN acct-pos IN h_base (p_acct, p_currency, dt_cur, dt_cur, CHR(251)).
  assign
    p_sh-bal = ABS(sh-bal)
    p_sh-val = ABS(sh-val)
  .

  IF (p_cust-cat = "Ю")  THEN
    DO:
       p_FIORukov = TRIM(GetXAttrValue("cust-corp", STRING(p_cust-id), "ФИОрук")).
       p_UchrOrg = TRIM(GetTempXAttrValueEx("cust-corp", STRING(p_cust-id), "УчредОрг", dt_cur,"")).

    END.
  ELSE
    DO:
       p_FIORukov = "".
       p_UchrOrg = "".
    END.


  IF (p_sh-bal <> 0)  THEN
    DO:

       p2_cust-id = p_cust-id.
       p2_cust-cat = p_cust-cat.


       IF (p1_cust-id = p2_cust-id) AND (p1_cust-cat = p2_cust-cat) THEN
         DO:
           total-bal-val = total-bal-val + p_sh-bal.
         END.
       ELSE
         DO:

             /*** запись во 2 таблицу total-bal-val и p1_cust-id   ***/
          CREATE t_total.
           ASSIGN
            t_total.cust-id = p1_cust-id
            t_total.cust-cat = p1_cust-cat
            t_total.total-bal-val = total-bal-val
           .

           viv5-bal-val = viv5-bal-val + total-bal-val.   /*** итого  по всем клиентам ***/

           total-bal-val = p_sh-bal.
           p1_cust-id = p_cust-id.
           p1_cust-cat = p_cust-cat.
         END.

       CREATE acc_acc-pos.
       ASSIGN
        acc_acc-pos.cust-id = p_cust-id
        acc_acc-pos.cust-stat = p_cust-stat
        acc_acc-pos.name-corp = p_name-corp
        acc_acc-pos.open-date = p_open-date
        acc_acc-pos.acct = p_acct
        acc_acc-pos.close-date = p_close-date
        acc_acc-pos.currency = p_currency
        acc_acc-pos.sh-bal = p_sh-bal
        acc_acc-pos.sh-val = p_sh-val
        acc_acc-pos.total-bal-val = total-bal-val
        acc_acc-pos.FIORukov = p_FIORukov
        acc_acc-pos.UchrOrg = p_UchrOrg
        acc_acc-pos.cust-cat = p_cust-cat
        .

       assign
         p_sh-bal = 0
         p_sh-val = 0
         p_FIORukov = ""
         p_UchrOrg = ""
       .

    END.

END.  /*** repeat   ***/
CLOSE acct_acct-pos.

/***************************************************************************/
/***   на всякий случай надо проверить правильно ли ГВК                  ***/
/***    BIS_gr_gvk                                                       ***/
FOR EACH t_total  :

 CASE t_total.cust-cat :
  WHEN "Ю" THEN p_BIS_gr_gvk = INT(SUBSTR(TRIM(GetTempXAttrValueEx("cust-corp", STRING(t_total.cust-id), "ГВК", dt_cur,"")), 4)). 
  WHEN "Ч" THEN p_BIS_gr_gvk = INT(SUBSTR(TRIM(GetTempXAttrValueEx("person", STRING(t_total.cust-id), "ГВК", dt_cur,"")), 4)). 
  OTHERWISE p_BIS_gr_gvk = 0.
 END.  /***   CASE  ***/
 
 IF t_total.gr_gvk <> p_BIS_gr_gvk THEN
 DO :
   t_total.BIS_gr_gvk =  p_BIS_gr_gvk.
   t_total.gr_gvk = p_BIS_gr_gvk.

/********************************************************************************
    MESSAGE " Клиент: " t_total.cust-id  "\n"
            "t_total.BIS_gr_gvk"   t_total.BIS_gr_gvk  "\n"
            "t_total.gr_gvk"   t_total.gr_gvk  "\n"

    VIEW-AS ALERT-BOX BUTTONS OK.
********************************************************************************/

 END.

END.   /***  FOR   ***/



/***************************************************************************/

/*****************************************************/
/*** присутствует ли у организации <Руководитель>  ***/
/***  в таблице   <t_total> как ФизЛицо            ***/
/*** если <ДА>, то объединить в некую группу       ***/

ASSIGN
 p_gr_gvk = 1000000
.

FOR EACH t_total WHERE t_total.cust-cat = "Ю" :

 t_total.fio_ruk_organ = TRIM(GetXAttrValue("cust-corp", STRING(t_total.cust-id), "ФИОрук")).

 FIND FIRST person
      WHERE (person.name-last + " " + person.first-names) = t_total.fio_ruk_organ
      NO-LOCK NO-ERROR.
 IF AVAIL person THEN
  DO:
/***    t_total.ruk_cust-id = INT(TRIM(GetXAttrValue("person", STRING(person.person-id), "УНК"))).  ***/
    FIND FIRST buf_t_total
         WHERE buf_t_total.cust-id = person.person-id AND
               buf_t_total.cust-cat = "Ч"
         NO-LOCK NO-ERROR.
    IF AVAIL buf_t_total THEN
      DO:
        t_total.gr_gvk = p_gr_gvk.
        t_total.ruk_cust-id = buf_t_total.cust-id.
        buf_t_total.gr_gvk = p_gr_gvk.

        p_gr_gvk = p_gr_gvk + 1.
      END.
  END.
 ELSE
  DO:
    t_total.ruk_cust-id = 0.
  END.

END.
/**************************************************************************************/



/*************************************************/
/***  найти родственников  <Руководителя>      ***/

FOR EACH t_total WHERE t_total.cust-cat = "Ю" :

 p_Rodstvenniki = "".
 p_fio_ruk_organ = TRIM(GetXAttrValue("cust-corp", STRING(t_total.cust-id), "ФИОрук")).

 FIND FIRST person
      WHERE (person.name-last + " " + person.first-names) = p_fio_ruk_organ
      NO-LOCK NO-ERROR.

 IF AVAIL person THEN
  DO:
    p_Rodstvenniki = TRIM(GetTempXAttrValueEx("person", STRING(person.person-id), "Родственники", dt_cur,"")).
    t_total.Rodstvenniki = p_Rodstvenniki.

       /*************************************************************************************/
       /*** выделить из p_Rodstvenniki - фамилия всех родственников *************************/
    IF LENGTH(TRIM(p_Rodstvenniki)) > 0 THEN
    DO:

/********************************************************************************
    MESSAGE " Начало  Родственники:" "\n"
            t_total.cust-id  LENGTH(TRIM(t_total.Rodstvenniki)) "\n"
    VIEW-AS ALERT-BOX BUTTONS OK.
********************************************************************************/


     DO WHILE LENGTH(TRIM(p_Rodstvenniki)) > 0 :    
       DO:                                         

         p1_Rodstvenniki = SUBSTRING(TRIM(p_Rodstvenniki), 1, INDEX(TRIM(p_Rodstvenniki), ";") - 1).

/*** на случай, если у "Родственника" не проставили символ < ; >    ***/
         IF INDEX(TRIM(p_Rodstvenniki), ";") = 0 THEN
           DO:
            p_Rodstvenniki = "".
	   END.
	 ELSE
           DO:
            p_Rodstvenniki =  SUBSTRING(TRIM(p_Rodstvenniki), INDEX(TRIM(p_Rodstvenniki), ";") + 1).
	   END.
 
/***
         IF t_total.cust-id = 5398 THEN
           DO:
             MESSAGE " Родственники:1" p1_Rodstvenniki LENGTH(TRIM(p1_Rodstvenniki)) "\n"
                     " Родственники:" p_Rodstvenniki LENGTH(TRIM(p_Rodstvenniki)) "\n"
	     VIEW-AS ALERT-BOX BUTTONS OK.
	   END.
***/

         FIND FIRST buf_person
              WHERE (buf_person.name-last + " " + buf_person.first-names) = p1_Rodstvenniki
              NO-LOCK NO-ERROR.

         IF AVAIL buf_person THEN
           DO:
              FIND FIRST buf_t_total
                   WHERE buf_t_total.cust-id = buf_person.person-id AND
                         buf_t_total.cust-cat = "Ч"
                   NO-LOCK NO-ERROR.
         /***  если имеется "Родственник" у "Руководителя"  в нашем списке   ***/
              IF AVAIL buf_t_total THEN
                DO:
                  IF t_total.gr_gvk <> 0 THEN
                    DO:
                      p_GVK_RODSTV = buf_t_total.gr_gvk.

                      buf_t_total.gr_gvk = t_total.gr_gvk.    /*** присвоить "Родственнику" <номер ГВК> "Руководителя" ***/
                      /*** теперь необходимо найти у "Родственника" все его организации ***/
                      /*** и присвоить им <номер ГВК> "Руководителя"                    ***/
                      IF p_GVK_RODSTV <> 0 THEN
                      DO:
                        FOR EACH Rodstv_t_total WHERE Rodstv_t_total.gr_gvk = p_GVK_RODSTV :
/***********************************
                           MESSAGE " Родственник1" p1_Rodstvenniki "\n"
                                   " СВОЙ ГВК Родственника:" Rodstv_t_total.gr_gvk "\n"
                                   " cust-id Родственника:" Rodstv_t_total.cust-id "\n"

                                   " ГВК Руководителя:" t_total.gr_gvk "\n"
                  	   VIEW-AS ALERT-BOX BUTTONS OK.
******************************************************************************/
                           Rodstv_t_total.gr_gvk = t_total.gr_gvk.

                        END.  /***   FOR EACH   ***/
                      END. 
  


                    END.
                ELSE
                    DO:
                      t_total.gr_gvk = p_gr_gvk.
                      t_total.ruk_cust-id = buf_t_total.cust-id.
                      buf_t_total.gr_gvk = p_gr_gvk.
                      p_gr_gvk = p_gr_gvk + 1.

                    END.
                END.
           END.

       END.     
     END.                 /***  WHILE    ***/

/********************************************************************************

    MESSAGE " Завершен Родственники:" "\n"
            t_total.Rodstvenniki LENGTH(TRIM(t_total.Rodstvenniki)) "\n"
    VIEW-AS ALERT-BOX BUTTONS OK.
********************************************************************************/



    END.


  END.
END.   /*** FOR    ***/

/***********************************************************************/
/*************************************/
/*** обработка Учредителей         ***/
/*************************************/
/********************************************************************************/
FOR EACH t_total WHERE t_total.cust-cat = "Ю" :

 t_total.Uchrediteli = TRIM(GetXAttrValue("cust-corp", STRING(t_total.cust-id), "УчредОрг")).

END.
/********************************************************************************/

FOR EACH t_total WHERE t_total.cust-cat = "Ю" :

 p_Ucredit = "".
 p_spisok_Ucredit = t_total.Uchrediteli.
/**** p_spisok_Ucredit = TRIM(GetXAttrValue("cust-corp", STRING(t_total.cust-id), "УчредОрг")).   ***/


 DO WHILE LENGTH(TRIM(p_spisok_Ucredit)) > 0 :    
  DO:                                         
     p_Ucredit = SUBSTRING(TRIM(p_spisok_Ucredit), 1, INDEX(TRIM(p_spisok_Ucredit), ";") - 1).

      /*** на случай, если "Учредитель" - организация, у которой несколько человек с долями   ***/
     DO WHILE LENGTH(TRIM(p_Ucredit)) > 0 :
      DO:                                         
        p_fio_Ucredit = "".
        p_fio_Ucredit = SUBSTRING(TRIM(p_Ucredit), 1, INDEX(TRIM(p_Ucredit), ":") - 1).

        /***   поиск учредителя в person ***/
        FIND FIRST uchred_person
             WHERE (uchred_person.name-last + " " + uchred_person.first-names) = p_fio_Ucredit
             NO-LOCK NO-ERROR.

         IF AVAIL uchred_person THEN
           DO:

       /***   поиск учредителя в нашем списке ***/
              FIND FIRST buf_t_total
                   WHERE buf_t_total.cust-id = uchred_person.person-id AND
                         buf_t_total.cust-cat = "Ч"
                   NO-LOCK NO-ERROR.
/***********
              IF AVAIL buf_t_total THEN
              DO:
************/
         /***  если "Учредитель" организации присутствует в нашем списке   ***/

                IF AVAIL buf_t_total THEN
                DO:
                  IF t_total.gr_gvk <> 0 THEN
                  DO:
                      p_GVK_UCHRED = buf_t_total.gr_gvk.

                      buf_t_total.gr_gvk = t_total.gr_gvk.    /*** присвоить "Учредителю" <номер ГВК> "Организации", в которой он "Учредитель" ***/
                      /*** теперь необходимо найти у "Учредителя" все его организации ***/
                      /*** и присвоить им <номер ГВК> "Организации", в которой он "Учредитель"  ***/
                        IF p_GVK_UCHRED <> 0 THEN
                        DO:
                          FOR EACH Uchred_t_total WHERE Uchred_t_total.gr_gvk = p_GVK_UCHRED :

/*****************************************************************************************
                             MESSAGE " cust-id Организации:" t_total.cust-id "\n"
                                     " Список Учред:" p_spisok_Ucredit "\n"
                                     " Обрезанный Учред:" p_Ucredit "\n"
                                     " Учредитель" p_fio_Ucredit  p_GVK_UCHRED  "\n"
                                     " СВОЙ ГВК Учредителя:" Uchred_t_total.gr_gvk "\n"
                                     " cust-id Учредителя:"  Uchred_t_total.cust-id "\n"
                  	     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/
                             Uchred_t_total.gr_gvk = t_total.gr_gvk.

                          END.  /***   FOR EACH   ***/
                        END. 
                  END.
                  ELSE
                    DO:
                      t_total.gr_gvk = p_gr_gvk.
                      t_total.ruk_cust-id = buf_t_total.cust-id.
                      buf_t_total.gr_gvk = p_gr_gvk.
                      p_gr_gvk = p_gr_gvk + 1.

                  END.
                END.
/**************
              END.
***************/
           END.
/*****************************************************************************************
     MESSAGE " cust-id Организации:" t_total.cust-id "\n"
             " ФИО Учред1:" p_Ucredit "\n"
     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/


          /*** на случай, если внутри "Учредителя" не проставили символ < : >    ***/
        IF INDEX(TRIM(p_Ucredit), ":") = 0 THEN
         DO:
           p_Ucredit = "".
         END.
        ELSE
         DO:
           p_Ucredit =  SUBSTRING(TRIM(p_Ucredit), INDEX(TRIM(p_Ucredit), ":") + 1).
         END.

/*****************************************************************************************
     MESSAGE " cust-id Организации:" t_total.cust-id "\n"
             " ФИО Учред2:" p_Ucredit "\n"
     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/

      END.
     END.  /***  WHILE   p_Ucredit  ***/

/****************************************************************************************
     MESSAGE " cust-id Организации:" t_total.cust-id "\n"
             " Список Учред1:" p_spisok_Ucredit "\n"
     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/
        /*** на случай, если у "Учредителей" не проставили символ < ; >    ***/
    IF INDEX(TRIM(p_spisok_Ucredit), ";") = 0 THEN
    DO:
     p_spisok_Ucredit = "".
    END.
    ELSE
    DO:
     p_spisok_Ucredit =  SUBSTRING(TRIM(p_spisok_Ucredit), INDEX(TRIM(p_spisok_Ucredit), ";") + 1).
    END.
/*****************************************************************************************
     MESSAGE " cust-id Организации:" t_total.cust-id "\n"
             " Список Учред2:" p_spisok_Ucredit "\n"
     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/


  END.
 END.    /***  WHILE   p_spisok_Ucredit  ***/


END.   /*** FOR     завершена обработка Учредителей  ***/

/*********************************************************************************/
/*** продолжение обработки Учредителей  ***/

FOR EACH t_total WHERE t_total.cust-cat = "Ю" :

 p_spisok_Ucredit = "".
 p_spisok_Ucredit = t_total.Uchrediteli.


 DO WHILE LENGTH(TRIM(p_spisok_Ucredit)) > 0 :    
  DO:                                         
     p_Ucredit = SUBSTRING(TRIM(p_spisok_Ucredit), 1, INDEX(TRIM(p_spisok_Ucredit), ";") - 1).

      /*** на случай, если "Учредитель" - организация, у которой несколько человек с долями   ***/
     DO WHILE LENGTH(TRIM(p_Ucredit)) > 0 :
      DO:                                         
        p_fio_Ucredit = "".
        p_fio_Ucredit = SUBSTRING(TRIM(p_Ucredit), 1, INDEX(TRIM(p_Ucredit), ":") - 1).
        p_find_Uchred = "*" + p_fio_Ucredit + "*".

/****************************************************************************************
       /***   поиск учредителя в нашем списке ***/
        FIND FIRST buf_t_total
             WHERE buf_t_total.Uchrediteli MATCHES p_find_Uchred AND
                   buf_t_total.cust-id <> t_total.cust-id
             NO-LOCK NO-ERROR.
****************************************************************************************/
        FOR EACH buf_t_total WHERE buf_t_total.Uchrediteli MATCHES p_find_Uchred AND
                                   buf_t_total.cust-id <> t_total.cust-id :


         /***  если "Учредитель" организации присутствует в нашем списке   ***/
          IF AVAIL buf_t_total THEN
/*****************************************************************************************
     MESSAGE " Учредитель: " p_fio_Ucredit  t_total.cust-id   "\n"
             " Маска: " p_find_Uchred  "\n"
             " Найден: " buf_t_total.Uchrediteli "\n"
             " cust-id: " buf_t_total.cust-id "\n"
     VIEW-AS ALERT-BOX BUTTONS OK.
*****************************************************************************************/
                DO:
                  IF t_total.gr_gvk <> 0 THEN
                  DO:
                      p_GVK_UCHRED = buf_t_total.gr_gvk.

                      buf_t_total.gr_gvk = t_total.gr_gvk.    /*** присвоить найденному "Учредителю" <номер ГВК> "Учредитедя", в друг.Организации ***/
                      /*** теперь необходимо найти у "Учредителя" все его организации ***/
                      /*** и присвоить им <номер ГВК> "Организации", в которой он "Учредитель"  ***/
                        IF p_GVK_UCHRED <> 0 THEN
                        DO:
                          FOR EACH Uchred_t_total WHERE Uchred_t_total.gr_gvk = p_GVK_UCHRED :
                             Uchred_t_total.gr_gvk = t_total.gr_gvk.
                          END.  /***   FOR EACH   ***/
                        END. 
                  END.
                  ELSE
                    DO:
                      t_total.gr_gvk = p_gr_gvk.
                      t_total.ruk_cust-id = buf_t_total.cust-id.
                      buf_t_total.gr_gvk = p_gr_gvk.
                      p_gr_gvk = p_gr_gvk + 1.

                  END.
                END.

/****************************************************************************/

        END.   /*** FOR    ***/


          /*** на случай, если внутри "Учредителя" не проставили символ < : >    ***/
        IF INDEX(TRIM(p_Ucredit), ":") = 0 THEN
         DO:
           p_Ucredit = "".
         END.
        ELSE
         DO:
           p_Ucredit =  SUBSTRING(TRIM(p_Ucredit), INDEX(TRIM(p_Ucredit), ":") + 1).
           p_kod_sim = SUBSTRING(TRIM(p_Ucredit), 1, 1).
           CASE p_kod_sim :
             WHEN "0" OR  WHEN "1" 
                      OR  WHEN "2"
                      OR  WHEN "3"
                      OR  WHEN "4"
                      OR  WHEN "5"
                      OR  WHEN "6"
                      OR  WHEN "7"
                      OR  WHEN "8"
                      OR  WHEN "9"
                      OR  WHEN ":" THEN p_Ucredit = "". 

           END.  /***   CASE  ***/

         END.

      END.
     END.   /*** WHILE  p_Ucredit ***/


        /*** на случай, если у "Учредителей" не проставили символ < ; >    ***/
     IF INDEX(TRIM(p_spisok_Ucredit), ";") = 0 THEN
     DO:
      p_spisok_Ucredit = "".
     END.
     ELSE
     DO:
      p_spisok_Ucredit =  SUBSTRING(TRIM(p_spisok_Ucredit), INDEX(TRIM(p_spisok_Ucredit), ";") + 1).
     END.

  END.
 END.       /*** WHILE  p_spisok_Ucredit  ***/

END.     /*** FOR  **/

/********************************************************************************/

/***********************************************************************/

p1_cust-id = 0.

FOR EACH t_total  WHERE t_total.gr_gvk = 0
  ,  EACH acc_acc-pos
      WHERE t_total.cust-id = acc_acc-pos.cust-id AND
            t_total.cust-cat = acc_acc-pos.cust-cat
 :

  p2_cust-id = acc_acc-pos.cust-id.
  IF (p1_cust-id <> p2_cust-id) THEN
    DO:
      IF viv4-bal-val > 0 THEN
       DO:
         cXL = XLCell("")
             + XLCell("")
             + XLCell("")
             + XLCell("")
             + XLCell("Всего по клиенту:")
             + XLCell(STRING(viv4-bal-val))
         .

         PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
       END.

      viv4-bal-val = 0.
      viv4-bal-val = viv4-bal-val + acc_acc-pos.sh-bal.

/***      cXL = XLCell(STRING(acc_acc-pos.cust-id))          ***/
      cXL = XLCell(STRING(""))
          + XLCell(acc_acc-pos.cust-stat + " " + acc_acc-pos.name-corp)
          + XLCell("Руководитель: " + acc_acc-pos.FIORukov)
          + XLCell("Учредитель: " + acc_acc-pos.UchrOrg)
          + XLCell("")
          + XLCell("")
      .

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
    END.
  ELSE
    DO:
      viv4-bal-val = viv4-bal-val + acc_acc-pos.sh-bal.
    END.


    assign
      viv1-bal-val = 0
      viv2-bal-val = 0
      viv3-bal-val = 0
    .

    IF (acc_acc-pos.sh-bal > 0 AND acc_acc-pos.sh-val = 0 ) THEN  /*** рубли  ***/
      DO:
        viv1-bal-val = acc_acc-pos.sh-bal.
        viv2-bal-val = 0.
        viv3-bal-val = acc_acc-pos.sh-bal.
      END.
    ELSE IF (acc_acc-pos.sh-bal > 0 AND acc_acc-pos.sh-val > 0 ) THEN   /*** валюта  ***/
      DO:
        viv1-bal-val = 0.
        viv2-bal-val = acc_acc-pos.sh-val.
        viv3-bal-val = acc_acc-pos.sh-bal.
      END.

    cXL = XLCell("")
        + XLCell("")
        + XLCell(acc_acc-pos.acct)
/***
        + XLCell(STRING(acc_acc-pos.sh-bal))
        + XLCell(STRING(acc_acc-pos.sh-val))
        + XLCell(STRING(acc_acc-pos.total-bal-val))
***/
        + XLCell(STRING(viv1-bal-val))
        + XLCell(STRING(viv2-bal-val))
        + XLCell(STRING(viv3-bal-val))
    .

    PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
    p1_cust-id = acc_acc-pos.cust-id.

END.  /***  FOR  ***/
/***********************************************************************/

cXL = XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("Всего по группе:")
    + XLCell(STRING(viv5-bal-val))
.

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

cXL =  XLEmptyCells(2).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .


/*******************************************************************************
FOR EACH t_total :

   cXL = XLCell(STRING(t_total.cust-id))
       + XLCell(t_total.cust-cat)
       + XLCell(STRING(t_total.total-bal-val))
       + XLCell(t_total.fio_ruk_organ)
       + XLCell(t_total.Rodstvenniki)
       + XLCell(STRING(t_total.gr_gvk))
       + XLCell(t_total.Uchrediteli)          
       + XLCell(STRING(t_total.BIS_gr_gvk))   

   .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

    

END.  /***  FOR  ***/
**********************************************************/


PUT UNFORMATTED XLEnd().

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "ОБРАБОТКА ДАННЫХ - ЗАВЕРШЕНА." + STRING(" ","X(48)").


MESSAGE " УСПЕШНО СФОРМИРОВАН. " VIEW-AS ALERT-BOX TITLE " ОТЧЕТ ".

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "                                    " + STRING(" ","X(48)").





