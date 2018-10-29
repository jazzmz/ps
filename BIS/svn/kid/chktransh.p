{globals.i}
{intrface.get xclass}
{intrface.get i254}


{dtterm.i}

/*{intrface.get re}
{intrface.get rsrv}

{intrface.get refer}    /* Библиотека службы справочников. */
{intrface.get cust}     /* Библиотека для работы с клиентами. */

{loantran.pro}*/

DEFINE INPUT PARAMETER iRidTempl AS RECID NO-UNDO. /* recid - шаблона*/
DEFINE INPUT PARAMETER iRidLoan  AS RECID NO-UNDO. /* recid - договора */
DEFINE INPUT PARAMETER iOpDate   AS DATE  NO-UNDO. /* дата */

DEFINE NEW SHARED VARIABLE mask AS CHARACTER NO-UNDO INITIAL ?.
def var tv-Acct-type like loan-acct.acct-type NO-UNDO.


def var mResult as CHARACTER NO-UNDO.

   def var in-str  AS CHARACTER NO-UNDO.

   DEF VAR vTerm  AS CHAR INITIAL ""
                          NO-UNDO.
   DEF VAR DTType AS CHAR NO-UNDO.
   DEF VAR DTKind AS CHAR NO-UNDO.
   DEF VAR DTTerm AS CHAR NO-UNDO.
   DEF VAR DTCust AS CHAR NO-UNDO.

   DEF VAR l             AS INT64  NO-UNDO.
   DEF VAR mask-internal AS CHAR NO-UNDO.
   DEF VAR yy            AS INT64  NO-UNDO.
   DEF VAR dd            AS INT64  NO-UNDO.
   DEF VAR s             AS CHAR NO-UNDO.
   DEF VAR IS_ambiguous  AS LOG  NO-UNDO.
   DEF VAR vCodeValue    AS CHAR NO-UNDO.
   DEF VAR vFromDate     AS DATE NO-UNDO.



def var mBal-acct as CHAR NO-UNDO.
def var cparam as char NO-UNDO.

DEF BUFFER loan     FOR loan.
DEF BUFFER term-obl FOR term-obl.
DEF BUFFER bCode    FOR Code.

{dpsproc.def}

FIND FIRST loan WHERE
     RECID(loan) = iRidLoan
NO-LOCK NO-ERROR.

   tv-Acct-type =  Get_Param("acct-type",iRidTempl).
   cparam = Get_Param("flag-create",iRidTempl).
   in-str  = "DecisionTable".

   IF NUM-ENTRIES(in-str) > 1 THEN
      ASSIGN
          l      = INT64(ENTRY(2,in-str))
          in-str = ENTRY(1,in-str)
      NO-ERROR.

   ASSIGN
      mBal-acct    = ?
      vCodeValue = GetCode("",in-str)
      .

   IF vCodeValue <> ? THEN
   DO:
      ASSIGN
         pick-value = ?
         vFromDate = iOpDate.

      RUN GetDBITerm(vFromDate,
                     loan.end-date,
                     loan.contract,
                     loan.cust-cat,
                     OUTPUT vTerm).

      RUN DTCust(loan.cust-cat,loan.cust-id,?,OUTPUT DTcust).
             	
      ASSIGN
         DTType = GetXAttrValueEx("loan",
                                   loan.contract + "," + loan.cont-code,
                                   "DTType",
                                   GetXAttrInit(loan.class-code,"DTType"))
         DTKind = GetXAttrValueEx("loan",
                                   loan.contract + "," + loan.cont-code,
                                   "DTKind",
                                   GetXAttrInit(loan.class-code,"DTKind"))
         DTTerm = ENTRY(3,vTerm,"/")
         .


      IF DTType = ? OR DTType = "" THEN DTType = "*".
      IF DTKind = ? OR DTKind = "" THEN DTKind = "*".
      IF DTTerm = ? OR DTTerm = "" THEN DTTerm = "*".

      ASSIGN
         IS_ambiguous = DTType EQ "*" OR
                        DTKind EQ "*" OR
                        DTTerm EQ "*" OR
                        DTCust EQ "*"
         mask-internal = tv-Acct-type + CHR(1)
                             + DTType + CHR(1)
                             + DTCust + CHR(1)
                             + DTKind + CHR(1)
                             + DTTerm
          s = ""
          .

     FOR EACH code WHERE code.class  = "DTTerm"
                     AND code.parent = "DTTerm"
     NO-LOCK:
         IF IS-Term(vFromDate,
                    (IF loan.end-date = ? THEN
                        12/31/9999
                     ELSE
                        loan.end-date),
                     code.code,
                     NO,
                     0,
                     OUTPUT yy,
                     OUTPUT dd)
         THEN
            {additem.i s code.code}
      END.

      ASSIGN
         ENTRY(5,mask-internal,chr(1)) = s
         mask                          = mask-internal
         .

      RUN cbracct.p(in-str,in-str,"DecisionTable",l).

      IF pick-value NE ?  AND
         pick-value NE "" AND
         CAN-FIND(bal-acct WHERE
                  bal-acct.bal-acct EQ INT64(TRIM(pick-value)))
      THEN
         mBal-acct = pick-value.
   END.


/*нашли счет 2-го порядка который нам нужен, если*/




find first loan-acct where  loan-acct.acct-type = tv-Acct-type 
			and loan-acct.acct begins TRIM(mBal-acct)
		        and loan-acct.contract = loan.contract
			and loan-acct.cont-code begins ENTRY(1,loan.cont-code," ")
			and loan-acct.cont-code <> loan.cont-code
			NO-LOCK NO-ERROR.

if (not available loan-acct) and TRIM(cparam) <> "Создавать" then mResult = "NEXT".

if AVAILABLE (loan-acct) then 
   do:
      find first acct where acct.acct = loan-acct.acct and acct.currency = loan-acct.currency and acct.close-date = ? NO-LOCK NO-ERROR.

      if (available acct) and TRIM(cparam) = "Создавать" then mResult = "NEXT".
   end.
 
{intrface.del}

 
RETURN mResult.
