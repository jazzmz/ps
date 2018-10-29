/********************************************/
/***   pir_tvv_1400.p                     ***/
/*******************************************************************/
/*** ‘¯¨á®ª áç¥â®¢ ª«¨¥­â®¢, ®âªàëâëå §  ¯¥à¨®¤                  ***/
/*** „®¯®«­.à¥ª¢¨§¨â: "‘¢¥¤¥­¨ï ®¡ ãçà¥¤¨â¥«ïå"                  ***/
/*** „®¯®«­.à¥ª¢¨§¨â: "€­ª¥â : ‘¢¥¤.®¡ ®à£ ­ å ž‹-®¡é¥¥ á®¡à ­." ***/
/*******************************************************************/

{globals.i}
{sh-defs.i}
{tmprecid.def}
{ulib.i}
{pir_exf_exl.i}
{getdates.i}
/*** {getdate.i}    ***/


DEF VAR p_File	            AS CHAR NO-UNDO.
DEF VAR p_DAY               AS CHAR NO-UNDO.
DEF VAR p_MONTH             AS CHAR NO-UNDO.
DEF VAR p_beg-date          AS DATE NO-UNDO.
DEF VAR p_end-date          AS DATE NO-UNDO.
DEF VAR cXL                 AS CHAR NO-UNDO.
DEF VAR p_cust-id           AS INT NO-UNDO.
DEF VAR p_cust-stat         AS CHAR NO-UNDO.
DEF VAR p_name-corp         AS CHAR NO-UNDO.
DEF VAR p_open-date         AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_acct              AS CHAR NO-UNDO.
DEF VAR p_close-date        AS DATE NO-UNDO FORMAT "99/99/9999".
DEF VAR p_currency          AS CHAR NO-UNDO.
DEF VAR p_cust-cat          AS CHAR NO-UNDO.
DEF VAR p_Ob_Sobranie       AS CHAR NO-UNDO.
DEF VAR p_UchrOrg           AS CHAR NO-UNDO.
DEF VAR p_benef             AS CHAR NO-UNDO.

/***  ‚à¥¬¥­­ ï â ¡«¨æ                      ***/
DEF TEMP-TABLE client_acc NO-UNDO
      FIELD cust-id LIKE acct.cust-id
      FIELD cust-stat AS CHAR
      FIELD name-corp AS CHAR 
      FIELD open-date LIKE acct.open-date
      FIELD acct LIKE acct.acct
      FIELD close-date LIKE acct.close-date
      FIELD currency LIKE acct.currency
      FIELD cust-cat LIKE acct.cust-cat
      FIELD Uchredit AS CHAR
      FIELD benef AS CHAR
      FIELD Anketa_UL AS CHAR
      INDEX i_client_acc IS PRIMARY cust-id cust-cat acct.


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

p_File =  "OPEN_SCHET" + "/" + "CL_ACCOUNT_".
p_File = p_File + p_DAY + p_MONTH + STRING(YEAR(end-date)) + ".xls".

/*** p_File = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + p_File .  ***/
{exp-path.i &exp-filename = "p_File"}
/*p_File = "/home/PIRBANK/agoncharov/4359/otchet.xls".*/

p_beg-date = beg-date.
p_end-date = end-date.

PUT UNFORMATTED XLHead("‘ç¥â  ª«¨¥­â®¢", "CCCCCCCCC", "35, 250, 160, 100, 250, 250, 120, 120, 120").
cXL = 
    XLCell("                            ")
  + XLCell(" ‘—…’€ Š‹ˆ…’Ž‚, ŠŽ’Ž›… Ž’Š›’› ‡€ …ˆŽ„   á  " + STRING(beg-date, "99/99/9999") + 
           "    ¯®  " + STRING(end-date, "99/99/9999")).

PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLEmptyCells(2).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell("")
  + XLCell(" ¨¬¥­®¢ ­¨¥ ª«¨¥­â ")
  + XLCell("®¬¥à áç¥â ")
  + XLCell("„ â  ®âªàëâ¨ï áç¥â ")
  + XLCell("‘¢¥¤¥­¨ï ®¡ ãçà¥¤¨â¥«ïå")
  + XLCell("‘¢¥¤¥­¨ï ® ¡¥­¥ä. ¢« ¤¥«ìæ å")
  + XLCell("€­ª¥â ")
.

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "Ž€Ž’Š€ „€›• ... " + STRING(" ","X(48)").

DECLARE cl_acct CURSOR FOR

SELECT acc.cust-id, crp.cust-stat, crp.name-corp,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN cust-corp crp
ON crp.cust-id = acc.cust-id

WHERE acc.cust-cat = "ž" AND
      (SUBSTRING(acc.acct, 1, 3) IN ("405", "406", "407") OR
       SUBSTRING(acc.acct, 1, 5) IN ("40807")) AND
      ((acc.open-date >= p_beg-date) AND (acc.open-date <= p_end-date))

UNION

SELECT acc.cust-id, psn.name-last, psn.first-names,
       acc.open-date, acc.acct, acc.close-date, acc.currency, acc.cust-cat

FROM acct acc 

INNER JOIN person psn
ON psn.person-id = acc.cust-id

WHERE acc.cust-cat = "—" AND
      (SUBSTRING(acc.acct, 1, 3) IN ("405", "406", "407") OR
       SUBSTRING(acc.acct, 1, 5) IN ("40807")) AND
      ((acc.open-date >= p_beg-date) AND (acc.open-date <= p_end-date))


ORDER BY 1, 8 ,5
.    /***   END  CURSOR        ***/

OPEN cl_acct.
REPEAT:
  FETCH cl_acct INTO p_cust-id, p_cust-stat, p_name-corp,
                     p_open-date, p_acct, p_close-date, p_currency, p_cust-cat.

  IF (p_cust-cat = "ž")  THEN
    DO:
       p_Ob_Sobranie = TRIM(GetXAttrValue("cust-corp", STRING(p_cust-id), "Ž¡é‘®¡à ­¨¥")).
       p_UchrOrg = TRIM(GetTempXAttrValueEx("cust-corp", STRING(p_cust-id), "“çà¥¤Žà£", p_end-date,"")).
       p_benef = TRIM(GetTempXAttrValueEx("cust-corp", STRING(p_cust-id), "pir-bendata", p_end-date,"")).
    END.
  ELSE
    DO:
       p_Ob_Sobranie = "".
       p_UchrOrg = "".
       p_benef = "".
    END.

 /*** § ¯¨áì ¢ â ¡«¨æã client_acc  ***/
  CREATE client_acc.
   ASSIGN  client_acc.cust-id = p_cust-id
           client_acc.cust-stat = p_cust-stat
           client_acc.name-corp = p_name-corp
           client_acc.open-date = p_open-date
           client_acc.acct = p_acct
           client_acc.close-date = p_close-date
           client_acc.currency = p_currency
           client_acc.cust-cat = p_cust-cat
           client_acc.Uchredit = p_UchrOrg
           client_acc.benef = p_benef
           client_acc.Anketa_UL = p_Ob_Sobranie.
END.  /*** repeat   ***/
CLOSE cl_acct.

FOR EACH client_acc:
  cXL = XLCell("")
      + XLCell(client_acc.cust-stat + " " + client_acc.name-corp)
      + XLCell(client_acc.acct)
      + XLCell(STRING(client_acc.open-date, "99/99/9999"))
      + XLCell(client_acc.Uchredit)
      + XLCell(client_acc.benef)
      + XLCell(client_acc.Anketa_UL)
     .

     PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

END.        /***  END-FOR  ***/

PUT UNFORMATTED XLEnd().

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "Ž€Ž’Š€ „€›• - ‡€‚…˜…€." + STRING(" ","X(48)").


MESSAGE " “‘…˜Ž ‘”ŽŒˆŽ‚€. " VIEW-AS ALERT-BOX TITLE " Ž’—…’ ".

PUT SCREEN col 1 row 24 color bright-blink-normal 
       "                                    " + STRING(" ","X(48)").







