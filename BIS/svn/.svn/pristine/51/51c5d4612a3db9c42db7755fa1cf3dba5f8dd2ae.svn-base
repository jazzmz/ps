FUNCTION getAcct RETURNS CHAR (INPUT cAcct AS CHAR,INPUT cType AS CHAR):
   DEF VAR newAcct AS CHAR NO-UNDO.
   DEF VAR oSysClass AS TSysClass NO-UNDO.

   oSysClass = NEW TSysClass().

   SUBSTR(cAcct,9,1) = ".".

   CASE cType:
       WHEN "затраты" THEN DO:
          newAcct = oSysClass:buildAcctByMask(cAcct,"бббббввв.XXXXXX4XXXX").

       END.
/* по акциям */
       WHEN "пп"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50721ввв.XXXXXXXXXXX").
       END.
       WHEN "по"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50720ввв.XXXXXXXXXXX").
       END.
/* по облигациям */
       WHEN "ппОбл"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50221ввв.XXXXXXXXXXX").
       END.
       WHEN "поОбл"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50220ввв.XXXXXXXXXXX").
       END.
       WHEN "ПКДНач"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"бббббввв.XXXXXX2XXXX").
       END.
       WHEN "ПКДУпл"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"бббббввв.XXXXXX3XXXX").
       END.
       WHEN "премия"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"бббббввв.XXXXXX6XXXX").
       END.
       WHEN "дисконт"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"бббббввв.XXXXXX5XXXX").
       END.

   END CASE.
   DELETE OBJECT oSysClass.
 RETURN newAcct.
END FUNCTION.

 /**
  * Процедура создает счет заданного клиент по заданной маске
  * на классе acctbc
  * @param CHAR  vCustCat Категория клиента
  * @param INT64 vCustId  Уникальный номер клиента
  * @param CHAR  cMask    Маска по которой создается счет
  * @param DATE  currDate Дата на которую создается счет
  * @return BUFFER iAcct  Буффер с вновь открытым счетом
  **/

 PROCEDURE createAcct:
    DEF INPUT  PARAM vCustCat AS CHAR  NO-UNDO.
    DEF INPUT  PARAM vCustId  AS INT64 NO-UNDO.
    DEF INPUT  PARAM cMask    AS CHAR  NO-UNDO.
    DEF INPUT  PARAM currDate AS DATE  NO-UNDO.
    DEF PARAM BUFFER iacct FOR acct .

    DEF VAR vDetails AS CHAR NO-UNDO.
    DEF VAR vAcct    AS CHAR NO-UNDO.
    DEF VAR bal      AS INT  NO-UNDO.

    bal = INT(SUBSTRING(cMask,1,5)).

    RUN Cm_acct_cr IN h_acct (
                            "acctbcb",              /* iClass                */
                             bal,                   /* iBal                  */
                            "",                     /* iCurr                 */
                            vCustCat,               /* iCustCat              */
                            vCustId,                /* iCustID               */
                            currDate,               /* iOpenDate             */
                            OUTPUT vAcct,           /* oAcct                 */
                            BUFFER iacct,           /* BUFFER iacct FOR acct */
                            cMask,                  /* iAcctMask             */
                            vDetails,               /* iDetails              */
                            ?,                      /* iKauId                */
                            ?,                      /* iContract             */
                             USERID('bisquit'),     /* iUserId               */
                            ?,                      /* iBranchId             */
                            FALSE                   /* iCopyBalXattr         */
                          ) NO-ERROR.



 END PROCEDURE.