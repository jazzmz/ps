{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir_f207_ved.p,v $ $Revision: 1.5 $ $Date: 2010-12-08 07:40:22 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Ведомость документов отобранных для 207П
Автор         : 13.10.2005      ANISIMOV
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.4  2010/10/22 09:08:30  borisov
Изменения     : Vybiraetsja provodka s MAX summo'
Изменения     :
Изменения     : Revision 1.3  2007/10/18 07:42:21  anisimov
Изменения     : no message
Изменения     :
Изменения     : Revision 1.2  2007/06/15 07:20:10  lavrinenko
Изменения     : изменено определение даты регистрации - берется из д/р RegData, как и при расчета  класса данныз 207-П
Изменения     :
----------------------------------------------------- */

DEF VAR mNam1     AS CHAR NO-UNDO.
DEF VAR mNam2     AS CHAR NO-UNDO.
DEF VAR mDebName  AS CHAR extent  1 NO-UNDO.
DEF VAR mCreName  AS CHAR extent  1 NO-UNDO.
DEF VAR dbMov     AS DATE NO-UNDO.
DEF VAR crMov     AS DATE NO-UNDO.
DEF VAR dbReg     AS DATE NO-UNDO.
DEF VAR crReg     AS DATE NO-UNDO.
DEF VAR dbcur     AS CHAR NO-UNDO.
DEF VAR crcur     AS CHAR NO-UNDO.
DEF VAR dbacc     AS CHAR NO-UNDO.
DEF VAR cracc     AS CHAR NO-UNDO.
DEF VAR dbamt     AS DECIMAL NO-UNDO.
DEF VAR cramt     AS DECIMAL NO-UNDO.
Def Var NameCli   as char  extent 2 no-undo.

DEF VAR num	  AS INT  NO-UNDO.
DEFINE QUERY q-oe FOR op-entry.

{tmprecid.def}        /** Используем информацию из броузера */
{globals.i}
{sh-defs.i}
{get-bankname.i}
{setdest.i &cols=238}

num = 1.

FOR EACH tmprecid
      NO-LOCK,
   FIRST op
      WHERE (RECID(op) EQ tmprecid.id)
      NO-LOCK
   BREAK BY op.op-date
         BY op.doc-num:

   OPEN QUERY q-oe
      FOR EACH op-entry OF op
      NO-LOCK
      BY op-entry.amt-rub DESCENDING.

   GET FIRST q-oe.

/*
   FIND FIRST op-entry OF op NO-LOCK.
*/
   IF FIRST-OF(op.op-date) THEN DO:
      PUT UNFORMATTED "                            Реестр сведений об операциях, контролируемых в соответствии с Положением Банка РФ от 29.08.2008г. N 321-П" SKIP.
      PUT UNFORMATTED "                                                    Данные по " cBankName "по операциям за " op.op-date SKIP.
      PUT UNFORMATTED  "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+" SKIP.
      PUT UNFORMATTED  "|Номер|Номер |       Дебет        |          Наименование счета по дебету            |   Дата   |Дата посл.|Вал|  Сумма по дебету  |Назначение платежа                                                                                       |" SKIP.
      PUT UNFORMATTED  "| п/п |докум.|       Кредит       |          Наименование счета по кредиту           | регистр. | проводки |   |  Сумма по кредиту |                                                                                                         |" SKIP.
      PUT UNFORMATTED  "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+" SKIP.
   END.

   ASSIGN
      dbacc = IF op-entry.acct-db NE ? THEN TRIM(op-entry.acct-db) ELSE ""
      cracc = IF op-entry.acct-cr NE ? THEN TRIM(op-entry.acct-cr) ELSE ""
   .
   IF cracc EQ "" THEN DO:
/*
      FIND NEXT op-entry OF op.
*/
      GET NEXT q-oe.
      cracc = IF op-entry.acct-cr NE ? THEN TRIM(op-entry.acct-cr) ELSE "".
   END.
   IF dbacc EQ "" THEN DO:
/*
      FIND NEXT op-entry OF op.
*/
      GET NEXT q-oe.
      dbacc = IF op-entry.acct-db NE ? THEN TRIM(op-entry.acct-db) ELSE "".
   END.

   ASSIGN
      dbcur = SUBSTR(dbacc,6,3)
      crcur = SUBSTR(cracc,6,3)
      mNam1 = SUBSTR(TRIM(REPLACE(op.details,'\n',' ')),1,105)
      mNam2 = SUBSTR(TRIM(REPLACE(op.details,'\n',' ')),106,105)
   .

   FIND FIRST acct WHERE acct.acct EQ dbacc NO-LOCK NO-ERROR.
   mDebName[1] = TRIM(acct.Details).
     if mDebName[1] eq ? then DO:
     {getcust.i &name=NameCli &OFFinn = "/*" &OFFsigns = "/*"}
     mDebName[1] = NameCli[1] + " " + NameCli[2].
     end.
   RUN acct-pos IN h_base (acct.acct,
                           acct.currency,
                           op.op-date,
                           op.op-date,
                           CHR(251)).
   dbMov = lastmove.
   dbReg = DATE (GetXAttrValue ("cust-corp",STRING (acct.cust-id), "RegDate")).

   FIND FIRST acct WHERE acct.acct EQ cracc NO-LOCK NO-ERROR.
    mCreName[1] = TRIM(acct.Details).
    if mCreName[1] eq ? then DO:
    {getcust.i &name=NameCli &OFFinn = "/*" &OFFsigns = "/*"}
    mCreName[1] = NameCli[1] + " " + NameCli[2].
    end.
   RUN acct-pos IN h_base (acct.acct,
                           acct.currency,
                           op.op-date,
                           op.op-date,
                           CHR(251)).
   crMov = lastmove.
   crReg = DATE (GetXAttrValue ("cust-corp",STRING (acct.cust-id), "RegDate")).

   IF dbcur="810" THEN
      ASSIGN
         dbamt = IF op-entry.amt-rub  NE ? THEN op-entry.amt-rub ELSE 0
         cramt = IF op-entry.amt-cur  NE ? THEN op-entry.amt-cur ELSE 0
      .
   ELSE
      ASSIGN
         dbamt = IF op-entry.amt-cur  NE ? THEN op-entry.amt-cur ELSE 0
         cramt = IF op-entry.amt-rub  NE ? THEN op-entry.amt-rub ELSE 0
      .

   PUT UNFORMATTED  "|" num FORMAT ">>>>9" "|"
                    op.doc-num FORMAT "x(6)" "|"
                    dbacc FORMAT "x(20)" "|"
                    mDebName[1] FORMAT "x(50)" "|"
                    dbReg FORMAT "99.99.9999" "|"
                    dbMov FORMAT "99.99.9999" "|"
                    dbcur FORMAT "x(3)" "|"
                    dbamt FORMAT "->>>,>>>,>>>,>>9.99" "|"
                    mNam1 FORMAT "x(105)" "|" SKIP.
   PUT UNFORMATTED  "|     |      |"
                    cracc FORMAT "x(20)" "|"
                    mCreName[1] FORMAT "x(50)" "|"
                    crReg FORMAT "99.99.9999" "|"
                    crMov FORMAT "99.99.9999" "|"
                    crcur FORMAT "x(3)" "|"
                    cramt FORMAT "->>>,>>>,>>>,>>9.99" "|"
                    mNam2 FORMAT "x(105)" "|" SKIP.
   PUT UNFORMATTED  "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+" SKIP.
   num = num + 1.
END.

{signatur.i &user-only=yes}
{preview.i}
