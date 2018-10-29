{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: GETDATE.P
      Comment: Запрашивает у пользователя количество
   Parameters:
         Uses:
      Used by:
      Created: 18.10.2005 Anisimov
     Modified: 
*/


DEFINE INPUT  PARAMETER pTitle AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER opNum  AS INTEGER    NO-UNDO.

DEF VAR vOk   AS LOGICAL NO-UNDO.
DEF VAR vNum  AS INTEGER FORMAT ">>>>>>>>9" LABEL "Введите число" INIT 400 NO-UNDO.

pTitle = TRIM(pTitle, "[] ").

PAUSE 0.

UPDATE SKIP(1) vNum SKIP(1)
  WITH FRAME fMain OVERLAY ROW 10 CENTERED SIDE-LABELS TITLE "[ " + pTitle + " ]".

HIDE FRAME fMain.

opNum = vNum.
