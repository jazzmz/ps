{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ЗАО "Банковские информационные системы"
     Filename: WOP-PERR.P
      Comment: ОЭД. Печать списка документов с ошибками после создания
               транспортной формы.
   Parameters:
         Uses:
      Created: 27.06.2005 NIK
     Modified: 11.07.2006 MUTA 0064385 
*/
{globals.i}
{tmprecid.def}
{intrface.get strng}

DEFINE VAR hExch     AS HANDLE    NO-UNDO.
DEFINE VAR mErrCls   AS CHAR      NO-UNDO.
DEFINE VAR mErrLst   AS CHAR      NO-UNDO.
DEFINE VAR mErrStt   AS CHAR      NO-UNDO.
DEFINE VAR mErrFlag  AS CHAR      NO-UNDO.
DEFINE VAR mBankCode AS CHAR      NO-UNDO.
DEFINE VAR mAcctSnd  AS CHARACTER NO-UNDO.
DEFINE VAR mAcctRec  AS CHARACTER NO-UNDO.
DEFINE VAR mNameRec  AS CHARACTER NO-UNDO.
DEFINE VAR mDocType  AS CHARACTER NO-UNDO.
DEFINE VAR MHeader   AS CHAR      NO-UNDO.

DEFINE STREAM sRep.

{intrface.get exch}

FORM
   op.doc-num  
         COLUMN-LABEL "НОМЕР!ДОК."
   mErrFlag
         COLUMN-LABEL "ОШИБ."
         FORMAT "Да/ "        
   mDocType
         COLUMN-LABEL "ТИП !ДОК."
         FORMAT "x(4)"
   op.op-status
         COLUMN-LABEL "СТАТ."   
   mAcctSnd
         COLUMN-LABEL "ПЛАТЕЛЬЩИК"
         FORMAT "x(20)"
   mAcctRec
         COLUMN-LABEL "ПОЛУЧАТЕЛЬ"
         FORMAT "x(20)"
   op-entry.amt-rub
         COLUMN-LABEL "СУММА"
         FORMAT "->>>,>>>,>>>,>>9.99"
   mBankCode   
         column-label "БИК"
         format "x(9)"
   mNameRec 
         COLUMN-LABEL "НАИМЕНОВАНИЕ ПОЛУЧАТЕЛЯ"
         FORMAT "x(50)"
HEADER
   mHeader  FORMAT "x(80)"
   SKIP(1)
WITH FRAME frRep WIDTH 200.

/*============================================================================*/
IF auto THEN RETURN.

mHeader = PADC("СПИСОК ДОКУМЕНТОВ С ОШИБКАМИ И ПРЕДУПРЕЖДЕНИЯМИ",80).
hExch = ObjectValueHandle("ExchRKCDoc").

{setdest.i &stream="stream sRep" &filename='exp-err.log'}

PUT STREAM sRep UNFORMATTED dept.name FORMAT "x(50)" SKIP(1).

PRNT:
FOR EACH tmprecid,
   FIRST op-entry WHERE
   recid(op-entry) EQ tmprecid.id
         NO-LOCK,
   FIRST op OF op-entry
         NO-LOCK
    WITH FRAME frRep DOWN:

   hExch:find-first("where " + hExch:Name + ".op       EQ " + string(op-entry.op) +
                     " AND " + hExch:Name + ".op-entry EQ " + string(op-entry.op-entry)).
   IF NOT hExch:AVAILABLE THEN NEXT PRNT.

   ASSIGN
      mErrLst   = hExch:BUFFER-FIELD("ErrorList"):BUFFER-VALUE
      mErrCls   = hExch:BUFFER-FIELD("ErrorClass"):BUFFER-VALUE
      mErrStt   = hExch:BUFFER-FIELD("State"):BUFFER-VALUE
      mAcctSnd  = hExch:BUFFER-FIELD("acct-send"):BUFFER-VALUE
      mAcctRec  = hExch:BUFFER-FIELD("acct-rec"):BUFFER-VALUE
      mBankCode = hExch:BUFFER-FIELD("bank-code-rec"):BUFFER-VALUE
      mNameRec  = hExch:BUFFER-FIELD("name-rec"):BUFFER-VALUE
      mDocType  = hExch:BUFFER-FIELD("doc-type"):BUFFER-VALUE
   NO-ERROR.

IF mErrLst ne "" THEN DO:
/*  IF mErrStt EQ "ОШБК" THEN DO: */

      DISPLAY STREAM sRep 
           op.doc-num
           mDocType
           op.op-status
           mAcctSnd
           mAcctRec
           mBankCode
           op-entry.amt-rub
           mNameRec
      WITH FRAME frRep OVERLAY.
            
      RUN FillErrorTable (INPUT        mErrCls,
                          INPUT        mErrLst,
                          OUTPUT TABLE ttError).
   
      FOR EACH ttError:
         PUT STREAM sRep UNFORMATTED
            FILL(" ",7)
            string(ttError.Code,"x(12)") "      "
            string(ttError.Name,"x(50)") " "
            string(ttError.Type,"x(15)")  SKIP.
      END.
      {empty ttError}
    
   END.
END.

{signatur.i &STREAM = "stream sRep" &user-only=YES}
{preview.i  &STREAM = "stream sRep" &filename='exp-err.log'}

RETURN.
/******************************************************************************/
