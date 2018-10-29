
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
 * Аналог РольПоСогл от БИС. 
 **/
PROCEDURE ПИРРольПоСогл:
   DEF INPUT  PARAMETER iRoleMask   AS CHAR  NO-UNDO.
   DEF OUTPUT PARAMETER out_Result  AS CHAR  NO-UNDO.

   DEF VAR oLoanParent AS TLoan NO-UNDO.
   DEF VAR oLoanChild  AS TLoan NO-UNDO.

   DEF VAR cAcct AS CHAR  NO-UNDO.
    /***
     * По заявке #2068 учитываем дату начала
     * транша.
     ***/
    oLoanParent  = NEW TLoan("Кредит",ENTRY(1,loan.cont-code," ")).
    oLoanChild   = NEW TLoan("Кредит",loan.cont-code).

      cAcct = oLoanParent:getAcctByDateRole(iRoleMask,oLoanChild:open-date).

    DELETE OBJECT oLoanChild.
    DELETE OBJECT oLoanParent.
    out_Result = cAcct.
END PROCEDURE.

/*****************************************************************
 *                                                               *
 * Процедура получает маску. Заменяет в ней                      *
 * XXX на цифры из счета c заданной ролью (к                     *
 * примеру, Кредит) - acctMask.                                  *
 * Затем в этой маске все цифры заменяет на . (точку)            *
 * и получает строку поиска - findMask.                          *
 * Пытается найти в базе счет по маске findMask.                 *
 * Если такой счет находится, то инкрементирует                  *
 * символ в заданной позиции.                                    *
 *                                                               *
 * @param CHAR iMask  роль счета с которого будем брать цифры    *
 * @param CHAR mask   Маска по которой производится замена       *
 * @param CHAR iPos   позиция в которой будем инкрементировать.  *
 * @return CHAR                                                  *
 *                                                               *
 ******************************************************************
 * Автор         : Маслов Д. А. Maslov D. A. *
 * Дата создания : 30.10.12                  *
 * Заявка        : #1050                     *
 **********************************************/
PROCEDURE ПИРМаскаПКВверх:
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
   DEF VAR checkList    AS CHAR INIT "б,в,к,ф,X,х" NO-UNDO.
   DEF VAR waitCurrency AS CHAR                    NO-UNDO.

   DEF VAR oLoan        AS TLoan                   NO-UNDO.


   iRole = TRIM(ENTRY(1, iRoleMask), '"').
   iMask = TRIM(ENTRY(2, iRoleMask), '"').
   upPos = INT(TRIM(ENTRY(3, iRoleMask), '"')).

   RUN DecTable("DecisionTable,-1",OUTPUT acct2).


   oLoan = NEW TLoan("Кредит",ENTRY(1,loan.cont-code," ")).
     baseAcct = oLoan:getAcctByDateRole(iRole,oLoan:open-date).
   DELETE OBJECT oLoan.

   /**
    * Определяем маску для создания счета.
    * Она будет возвращена в транзакцию создания
    * счетов.
    **/
   acctMask = iMask.


   acctMask = REPLACE(acctMask,"ббббб",acct2).


    DO i = 1 TO LENGTH(acctMask):
      SUBSTRING(acctMask,i,1) = (IF SUBSTRING(acctMask,i,1) = "Х" OR SUBSTRING(acctMask,i,1) = "X" THEN
            SUBSTRING(baseAcct,i,1) ELSE SUBSTRING(acctMask,i,1)).
    END.
   


   /**
    * Формируем маску для проверки факта существования
    * нового счета.
    **/
   findMask = acctMask.
   
   waitCurrency = IF tv-Currency = "" OR tv-Currency = ? THEN "810" ELSE tv-Currency.


   findMask = REPLACE(findMask,"ввв",waitCurrency).

   DO i = 1 TO LENGTH(findMask):
     IF INDEX(checkList,SUBSTRING(findMask,i,1)) > 0 THEN SUBSTRING(findMask,i,1) = ".".          
   END.



   /**
    * Проверяем наличие счета в БД.
    * Если счет существует, то инкриментируем
    * позицию. 
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