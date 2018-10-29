{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 2006 КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pirchk501.p
      Comment: 'Установка даты в отчете по ф.501 '
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


for each DataLine of DataBlock,
    FIRST acct where acct.acct EQ DataLine.Sym4 no-lock,
    last acct-pos of acct no-lock :

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
         DataLine.Txt   = (IF entry(1,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(1,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(2,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(2,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(3,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(3,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(4,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(4,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(5,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(5,DataLine.Txt,"~n"))  + "~n"
                        + cLastData + "~n"
                        + (IF entry(7,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(7,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(8,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(8,DataLine.Txt,"~n"))  + "~n"
                        + (IF entry(9,DataLine.Txt,"~n") = ? THEN "?" ELSE entry(9,DataLine.Txt,"~n"))  + "~n".
   END.
END.
/******************************************************************************/



{preview.i}

