/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2009 ЗАО "Банковские информационные системы"
     Filename: pir-6nm.p
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

FUNCTION IS-INN RETURNS LOGICAL
   (INPUT inINN AS CHARACTER):

   DEFINE VARIABLE iMult   AS INTEGER EXTENT 11 INIT [3,7,2,4,10,3,5,9,4,6,8] NO-UNDO.
   DEFINE VARIABLE iI      AS INTEGER  NO-UNDO.
   DEFINE VARIABLE iSum    AS INTEGER  NO-UNDO.

   IF (inINN EQ ?)
   THEN RETURN NO.
   ELSE
      CASE LENGTH(inINN):
         WHEN 10 THEN DO:
            iSum = 0.
            DO iI = 1 TO 9:
               iSum = iSum + iMult[iI + 2] * INTEGER(SUBSTRING(inINN, iI, 1)).
            END.
            RETURN ((iSum MODULO 11) MODULO 10) EQ INTEGER(SUBSTRING(inINN, 10, 1)).
         END.
         WHEN 12 THEN DO:
            iSum = 0.
            DO iI = 1 TO 10:
               iSum = iSum + iMult[iI + 1] * INTEGER(SUBSTRING(inINN, iI, 1)).
            END.

            IF ((iSum MODULO 11) MODULO 10) NE INTEGER(SUBSTRING(inINN, 11, 1))
            THEN DO:
               RETURN NO.
            END.

            iSum = 0.
            DO iI = 1 TO 11:
               iSum = iSum + iMult[iI] * INTEGER(SUBSTRING(inINN, iI, 1)).
            END.
            RETURN ((iSum MODULO 11) MODULO 10) EQ INTEGER(SUBSTRING(inINN, 12, 1)).
         END.
         OTHERWISE RETURN NO.
      END CASE.


END FUNCTION.
/******************************************************************************/

oOk = YES.   /* Маркирование подозрительн. документа */
FIND FIRST op
   WHERE (op.op EQ iOp)
   NO-LOCK NO-ERROR.

IF NOT AVAILABLE op
THEN RETURN "".

IF (op.user-id EQ "PLASTIK")
THEN DO:
   oOk = NO.
   RETURN "".
END.

IF NOT {assigned op.name-ben }
THEN RETURN "".

vStr = REPLACE(op.name-ben, "//", CHR(1)).
IF     (NOT IS-INN(TRIM(op.inn)))
   AND (NUM-ENTRIES(vStr, CHR(1)) NE 3)
THEN RETURN "".

oOk = NO.
RETURN "".
/******************************************************************************/
