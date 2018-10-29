/*Процедура проверки соответствия сроков кредитного договора и счета второго порядка ссудного счета
автор: Красков А.С.
Заявка #1215 	*/
{globals.i}
{tmprecid.def}
/*{getdate.i}*/

{intrface.get xclass}

{dtterm.i}

DEFINE NEW SHARED VARIABLE mask AS CHARACTER NO-UNDO INITIAL ?.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var counter as integer INIT 0 no-undo.

def var tv-Acct-type like loan-acct.acct-type NO-UNDO.

def var oTable as TTable.

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

oTable = new TTable(4).

oTable:addRow().
oTable:addCell("").
oTable:addCell("Номер договора/транша").
oTable:addCell("Ссудный счет").
oTable:addCell("Счет 2-го порядка по сроку").

{init-bar.i "Обработка договоров"}
                                                            
for each tmprecid  NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.

FOR EACH tmprecid,
	first loan where RECID(loan) = tmprecid.id NO-LOCK.
        vLnTotalInt = vLnTotalInt + 1.
end.


FOR EACH tmprecid,
	first loan where RECID(loan) = tmprecid.id and CAN-DO ("!loan-transh,*",loan.class-code)NO-LOCK,
	last loan-acct where loan-acct.cont-code = loan.cont-code
			  and loan-acct.contract = loan.contract 
			  and loan-acct.acct-type = "Кредит" NO-LOCK,
	first acct of loan-acct NO-LOCK:


         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


/*здесь безумный кусок работы dectable, вынести в отдельную процедуру не получилось, ибо какая-то непредсказуемость*/



   tv-Acct-type =  loan-acct.acct-type.

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
         vFromDate = loan.open-date.

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

/*message mBal-acct VIEW-AS ALERT-BOX. */
/*получили mBal-acct */

if mBal-acct <> STRING(acct.bal-acct) then 
do:
counter = counter + 1.
oTable:addRow().
oTable:addCell(counter).
oTable:addCell(loan.cont-code).
oTable:addCell(acct.acct).
oTable:addCell(mBal-acct).
end.



 vLnCountInt = vLnCountInt + 1.


end.

{setdest.i}
 oTable:show().

{preview.i}

DELETE OBJECT oTable.
{intrface.del}
                 