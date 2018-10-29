{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 2005 ООО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir_kasssym.p
      Comment: 'Ведомость документов с указанием символов кассплана'
   Parameters:
         Uses: 
      Used by: YAKOVEN, ZEMTZOVA
      Created: 13.10.2005      ANISIMOV
*/


DEF VAR mName     AS CHAR NO-UNDO.
DEF VAR lastsym   AS CHAR NO-UNDO.
DEF VAR vStr      AS CHAR NO-UNDO.
DEF VAR amt       AS DEC  NO-UNDO.
{tmprecid.def}        /** Используем информацию из броузера */
{globals.i}
{get-bankname.i}
RUN getsymb.p("ВВЕДИТЕ СИМВОЛ",OUTPUT vStr).

{setdest.i &cols=130}
PUT 
   UNFORMATTED
   "Наименование банка " cBankName SKIP
.
amt = 0.
lastsym = "".

find _user where _user._userid eq userid("bisquit") no-lock no-error.

FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id
         NO-LOCK, 
    EACH op-entry OF op
         NO-LOCK
   BREAK BY op.op-date
         BY op-entry.symbol
         BY op.doc-num
:
   FORM 
      op.doc-num
      op-entry.acct-db  
      op-entry.acct-cr  
      op-entry.symbol
      op-entry.amt-rub  
      mName VIEW-AS EDITOR SIZE 40 BY 1 COLUMN-LABEL "СОДЕРЖАНИЕ ОПЕРАЦИИ"
   WITH WIDTH 220.

   IF FIRST-OF(op.op-date) THEN 
      PUT 
         UNFORMATTED
         "Ведомость документов по кассовым символам за " op.op-date SKIP
      .
   mName = TRIM(REPLACE(op.details,'\n',' ')).
   IF ((TRIM(vStr) NE "")  AND (vStr EQ op-entry.symbol)) OR ((TRIM(op-entry.symbol) NE "") AND (vStr EQ "")) THEN DO:
      IF (TRIM(lastsym) NE "") THEN
         IF (TRIM(lastsym) NE TRIM(op-entry.symbol)) THEN DO:
            PUT UNFORMATTED "----------------------------------------- ИТОГО ПО СИМВОЛУ " lastsym " " STRING(amt,"->>>,>>>,>>>,>>9.99") " ----------------------------------------" SKIP.
            amt = 0.
         end. 
      amt = amt + op-entry.amt-rub. 
      DISPLAY
         op.doc-num
         op-entry.acct-db  WHEN op-entry.acct-db  NE ?
         op-entry.acct-cr  WHEN op-entry.acct-cr  NE ?
         op-entry.symbol
         op-entry.amt-rub  WHEN op-entry.amt-rub  NE ?
         mName  WITH /*NO-BOX*/ USE-TEXT 
      .
      lastsym = op-entry.symbol.
   END.
END.
{signatur.i &user-only=yes}
{preview.i}
  
