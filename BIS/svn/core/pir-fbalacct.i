
/*------------------------------------------------------------------------
    File        : pir-fbalacct.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : dmaslov
    Created     : Tue Jun 26 09:41:42 MSD 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
/**
 * ������ ���쏮���� �� ���. 
 **/
PROCEDURE ������쏮����:
   DEF INPUT  PARAMETER iRoleMask   AS CHAR  NO-UNDO.
   DEF OUTPUT PARAMETER out_Result  AS CHAR  NO-UNDO.

   DEF VAR oLoanParent AS TLoan NO-UNDO.
   DEF VAR oLoanChild  AS TLoan NO-UNDO.

   DEF VAR cAcct AS CHAR  NO-UNDO.
    /***
     * �� ��� #2068 ���뢠�� ���� ��砫�
     * �࠭�.
     ***/
    oLoanParent  = NEW TLoan("�।��",ENTRY(1,loan.cont-code," ")).
    oLoanChild   = NEW TLoan("�।��",loan.cont-code).

      cAcct = oLoanParent:getAcctByDateRole(iRoleMask,oLoanChild:open-date).

    DELETE OBJECT oLoanChild.
    DELETE OBJECT oLoanParent.
    out_Result = cAcct.
END PROCEDURE.

/*****************************************************************
 *                                                               *
 * ��楤�� ����砥� ����. ������� � ���                      *
 * XXX �� ���� �� ��� c �������� ஫�� (�                     *
 * �ਬ���, �।��) - acctMask.                                  *
 * ��⥬ � �⮩ ��᪥ �� ���� ������� �� . (���)            *
 * � ����砥� ��ப� ���᪠ - findMask.                          *
 * ��⠥��� ���� � ���� ��� �� ��᪥ findMask.                 *
 * �᫨ ⠪�� ��� ��室����, � ���६������                  *
 * ᨬ��� � �������� ����樨.                                    *
 *                                                               *
 * @param CHAR iMask  ஫� ��� � ���ண� �㤥� ���� ����    *
 * @param CHAR mask   ��᪠ �� ���ன �ந�������� ������       *
 * @param CHAR iPos   ������ � ���ன �㤥� ���६���஢���.  *
 * @return CHAR                                                  *
 *                                                               *
 ******************************************************************
 * ����         : ��᫮� �. �. Maslov D. A. *
 * ��� ᮧ����� : 30.10.12                  *
 * ���        : #1050                     *
 **********************************************/
PROCEDURE �����᪠�������:
   DEF INPUT  PARAMETER iRoleMask  AS CHAR NO-UNDO.
   DEF OUTPUT PARAMETER out_Result AS CHAR NO-UNDO.

   DEF VAR iRole        AS CHAR                    NO-UNDO.
   DEF VAR iMask        AS CHAR                    NO-UNDO.
   DEF VAR acct2        AS CHAR                    NO-UNDO.
   DEF VAR acctMask     AS CHAR INIT ""            NO-UNDO.
   DEF VAR findMask     AS CHAR INIT ""            NO-UNDO.
   DEF VAR baseAcct     AS CHAR                    NO-UNDO.
   DEF VAR i            AS INT                     NO-UNDO.
   DEF VAR upPos        AS INT                     NO-UNDO.
   DEF VAR checkList    AS CHAR INIT "�,�,�,�,X,�" NO-UNDO.
   DEF VAR waitCurrency AS CHAR                    NO-UNDO.

   DEF VAR oLoan        AS TLoan                   NO-UNDO.


   iRole = TRIM(ENTRY(1, iRoleMask), '"').
   iMask = TRIM(ENTRY(2, iRoleMask), '"').
   upPos = INT(TRIM(ENTRY(3, iRoleMask), '"')).

   RUN DecTable("DecisionTable,-1",OUTPUT acct2).


   oLoan = NEW TLoan("�।��",ENTRY(1,loan.cont-code," ")).
     baseAcct = oLoan:getAcctByDateRole(iRole,oLoan:open-date).
   DELETE OBJECT oLoan.

   /**
    * ��।��塞 ���� ��� ᮧ����� ���.
    * ��� �㤥� �����饭� � �࠭����� ᮧ�����
    * ��⮢.
    **/
   acctMask = iMask.


   acctMask = REPLACE(acctMask,"�����",acct2).


    DO i = 1 TO LENGTH(acctMask):
      SUBSTRING(acctMask,i,1) = (IF SUBSTRING(acctMask,i,1) = "�" OR SUBSTRING(acctMask,i,1) = "X" THEN
            SUBSTRING(baseAcct,i,1) ELSE SUBSTRING(acctMask,i,1)).
    END.
   


   /**
    * ��ନ�㥬 ���� ��� �஢�ન 䠪� ����⢮�����
    * ������ ���.
    **/
   findMask = acctMask.
   
   waitCurrency = IF tv-Currency = "" OR tv-Currency = ? THEN "810" ELSE tv-Currency.


   findMask = REPLACE(findMask,"���",waitCurrency).

   DO i = 1 TO LENGTH(findMask):
     IF INDEX(checkList,SUBSTRING(findMask,i,1)) > 0 THEN SUBSTRING(findMask,i,1) = ".".          
   END.



   /**
    * �஢��塞 ����稥 ��� � ��.
    * �᫨ ��� �������, � ���ਬ����㥬
    * ������. 
    **/
    DO i = 1 TO 9:
      SUBSTRING(findMask,upPos,1) = STRING(i).

      FIND FIRST acct WHERE CAN-DO(findMask,acct.acct) AND acct.currency = tv-Currency NO-LOCK NO-ERROR.

      IF NOT AVAILABLE(acct) THEN DO:
         SUBSTRING(acctMask,upPos,1) = STRING(i).
         LEAVE.
      END.
    END.

out_Result = acctMask.
END PROCEDURE.