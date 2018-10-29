FUNCTION getAcct RETURNS CHAR (INPUT cAcct AS CHAR,INPUT cType AS CHAR):
   DEF VAR newAcct AS CHAR NO-UNDO.
   DEF VAR oSysClass AS TSysClass NO-UNDO.

   oSysClass = NEW TSysClass().

   SUBSTR(cAcct,9,1) = ".".

   CASE cType:
       WHEN "������" THEN DO:
          newAcct = oSysClass:buildAcctByMask(cAcct,"��������.XXXXXX4XXXX").

       END.
/* �� ���� */
       WHEN "��"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50721���.XXXXXXXXXXX").
       END.
       WHEN "��"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50720���.XXXXXXXXXXX").
       END.
/* �� �������� */
       WHEN "�����"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50221���.XXXXXXXXXXX").
       END.
       WHEN "�����"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"50220���.XXXXXXXXXXX").
       END.
       WHEN "������"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"��������.XXXXXX2XXXX").
       END.
       WHEN "������"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"��������.XXXXXX3XXXX").
       END.
       WHEN "�६��"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"��������.XXXXXX6XXXX").
       END.
       WHEN "��᪮��"      THEN DO: 
          newAcct = oSysClass:buildAcctByMask(cAcct,"��������.XXXXXX5XXXX").
       END.

   END CASE.
   DELETE OBJECT oSysClass.
 RETURN newAcct.
END FUNCTION.

 /**
  * ��楤�� ᮧ���� ��� ��������� ������ �� �������� ��᪥
  * �� ����� acctbc
  * @param CHAR  vCustCat ��⥣��� ������
  * @param INT64 vCustId  �������� ����� ������
  * @param CHAR  cMask    ��᪠ �� ���ன ᮧ������ ���
  * @param DATE  currDate ��� �� ������ ᮧ������ ���
  * @return BUFFER iAcct  ����� � ����� ������ ��⮬
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