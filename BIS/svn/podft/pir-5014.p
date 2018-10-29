/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2009 ЗАО "Банковские информационные системы"
     Filename: pir-5014.p
   Parameters:
         Uses:
      Used by:
      Created: 29.12.2009 10:32 admbav
*/
/******************************************************************************/
DEFINE INPUT  PARAMETER iOp LIKE op.op NO-UNDO.                   /* Документ */
DEFINE OUTPUT PARAMETER oOk AS LOGICAL NO-UNDO INIT NO.
/*
{globals.i}
{parsin.def}
*/
DEFINE VARIABLE vStr AS CHARACTER   NO-UNDO.

oOk  = YES.   /* Маркирование подозрительн. документа */
FIND FIRST op
   WHERE (op.op EQ iOp)
   NO-LOCK NO-ERROR.

IF NOT AVAILABLE op
THEN RETURN "".

IF CAN-DO("40812*,40504*", op.ben-acct)
THEN RETURN "".

oOk  = NO.
RETURN "".
/******************************************************************************/
