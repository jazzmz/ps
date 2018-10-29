{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 2006 КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pirchk501.p
      Comment: 'Проверка даты в отчете по ф.501 '
   Parameters:
         Uses: 
      Used by:
      Created: 05.12.2006 anisimov
*/

/******************************************************************************/
{globals.i}
{intrface.get instrum}
{g-defs.i}
{sh-defs.i}


DEF INPUT PARAM iData-Id LIKE DataBlock.Data-Id NO-UNDO.
DEF VAR cRepData    AS CHAR 		NO-UNDO.
DEF VAR cAccount    AS CHAR 		NO-UNDO.
DEF VAR cLastData   AS CHAR 		NO-UNDO.

{setdest.i &cols=130}


find DataBlock where DataBlock.Data-Id eq iData-Id no-lock no-error.
find first DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock.


for each DataLine of DataBlock no-lock,
    FIRST acct where acct.acct EQ DataLine.Sym4 no-lock,
    last acct-pos of acct no-lock :

/*    FIND last acct-pos where acct EQ DataLine.Sym4 no-lock no-error.
   FIND FIRST acct where acct EQ DataLine.Sym4 no-lock,
        last acct-pos of acct no-lock. */

/* Локальные значения по строкам и вывод */
   cAccount = DataLine.Sym4.

   cRepData = entry(6,DataLine.Txt,"~n").
   IF AVAIL acct-pos THEN cLastData = STRING(acct-pos.since,"99.99.9999").
   ELSE cLastData = cRepData.
   IF cLastData NE cRepData THEN DO:
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              cLastData,
                              cLastData,
                              CHR(251)).

      IF ( sh-val + sh-bal ) EQ 0 THEN 
         put unformatted "Расхождение дат по счету " cAccount " : дата в отчете " cRepData ", дата последнего движения " cLastData SKIP.
   END.
END.
/******************************************************************************/



{preview.i}

