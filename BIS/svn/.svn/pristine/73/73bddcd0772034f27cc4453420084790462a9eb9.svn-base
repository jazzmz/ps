/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: DEPOPOS.P
      Comment: Процедура печати краткого баланса депо
   Parameters: 
         Uses:
      Used by:
      Created: 
     Modified: 07.12.01 Lera - причесали мордочку.
     Modified: 8/8/2002 Gunk
*/

{globals.i}
{sh-defs.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.


DEF VAR prn-tit  AS CHAR FORMAT "x(50)"  NO-UNDO.
DEF VAR prn-tit1 AS CHAR FORMAT "x(40)"  NO-UNDO.
DEF VAR prn-tit2 AS CHAR FORMAT "x(40)"  NO-UNDO.

DEFINE VARIABLE summ1 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE summ2 AS DECIMAL     NO-UNDO.

DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETURN:
   /*{getdate.i}*/

beg-date = TODAY - INTEGER(iParmStr).
end-date = TODAY - INTEGER(iParmStr).

{getdaydir.i}

cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/depopos.txt'.

   FIND FIRST op-date WHERE op-date.op-date EQ end-date NO-LOCK NO-ERROR.
   IF NOT AVAIL op-date THEN DO:
      MESSAGE "Этот день еще не открыт " . PAUSE .
      UNDO, RETRY.
   END.
END.
PAUSE 0.
{setdest.i &cols=85 &filename=cFileName
}
FIND FIRST dept NO-LOCK.
{justamin}

DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE WITH FRAME prn:
   {depopos.i &sec-cod = yes}
END.

{signatur.i}
