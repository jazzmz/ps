{globals.i}
{getdate.i}

{tmprecid.def}

def var oTpl   as TTpl.
def var oTable as TTable.
def var oFunc  as tfunc.

DEF VAR months AS CHAR NO-UNDO 
        INITIAL "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь".

def var count  as INT INIT 0 NO-UNDO.
def var tempvar as char no-undo.
def var mPremia10 as dec no-undo.
def var mPremia30 as dec no-undo.
def Var dDateInstall as DATE NO-UNDO. /*Дата приходывания по документу прихода*/
dEF VAR dDateUpgrade as DATE NO-UNDO. /*Дата модернизации*/
def var dDatePremia  as date NO-UNDO. /*дата начисления премии*/

def var dPremia as DEC NO-UNDO.
DEF VAR dChange as dec no-undo.
DEF VAR dStartAmount as dec no-undo.
DEF VAR bIsPremia10 as LOGICAL NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */


{intrface.get umc}
{intrface.get date}
{intrface.get asset}    /* Инструмент услуг/ценностей */


FUNCTION GetStartAmount RETURNS DEC:
 def var dRes as dec no-undo.
  find first loan-acct where loan-acct.contract = loan.contract 
                         and loan-acct.cont-code = loan.cont-code
                         and loan-acct.acct-type = 'ОС-нал-учет'
                         NO-LOCK NO-ERROR.
  IF NOT AVAILABLE loan-acct THEN dRes = 0.
  ELSE 
  DO:
     FIND FIRST op-entry WHERE op-entry.acct-db = loan-acct.acct 
                           AND op-entry.op-date >= loan-acct.since 
                           NO-LOCK NO-ERROR.

     IF available op-entry THEN 
        DO:
           dDateInstall = op-entry.op-date.
           dRes = op-entry.amt-rub.
        END.

  END.
  RETURN dRes.

END FUNCTION.

FUNCTION GetChangeAmount RETURNS DEC (INPUT dDate as Date):         /*ищем изменение стоимости за месяц*/
  DEF VAR TotalChange AS DEC INIT 0 NO-UNDO.

  dDateUpgrade = ?.

  find first loan-acct where loan-acct.contract = loan.contract 
                         and loan-acct.cont-code = loan.cont-code
                         and loan-acct.acct-type = 'ОС-нал-учет'
                         NO-LOCK NO-ERROR.
  IF NOT AVAILABLE loan-acct THEN RETURN 0.

  for each op-entry where op-entry.acct-db = loan-acct.acct 
                        and op-entry.op-date >= dDateInstall
                        and op-entry.op-date >= FirstMonDate(dDate)
                        and op-entry.op-date <= LastMonDate(dDate)
                        NO-LOCK.

         if dDateUpgrade = ? then dDateUpgrade = op-entry.op-date.

         TotalChange = TotalChange + op-entry.amt-rub.

  end.

  RETURN TotalChange.
  

END FUNCTION.

FUNCTION GetPremiaSize RETURNS DEC:

 DEF VAR totalPremia AS DEC INIT 0 NO-UNDO.
 def var totalChange as dec init 0 no-undo.


  find first loan-acct where loan-acct.contract  = loan.contract 
                         and loan-acct.cont-code = loan.cont-code
                         and loan-acct.acct-type = 'ОС-нал-амор'
                         NO-LOCK NO-ERROR.
  IF NOT AVAILABLE loan-acct THEN RETURN 0.
  dDatePremia = ?.
  for each op-entry where op-entry.acct-db = loan-acct.acct 
                      and op-entry.op-date >= dDateInstall
                      and op-entry.op-date >= FirstMonDate(end-date)
                      and op-entry.op-date <= LastMonDate(end-date)
                      NO-LOCK,
		            FIRST op OF op-entry WHERE 
		               (op.op-kind begins '5002n0')
		            or (op.op-kind begins '5001b+')
		            or (op.op-kind begins '7012b2t')
		     NO-LOCK.

       totalPremia = totalPremia + op-entry.amt-rub.
       if dDatePremia = ? then dDatePremia = op-entry.op-date.
  END.
  

  if dChange <> 0 and totalPremia <> 0 then 
     DO:
        IF ABS(totalPremia - (dChange / 10)) < 1 THEN bIsPremia10 = true.
        IF ABS(totalPremia - (30 * dChange / 100)) < 1 THEN bIsPremia10 = false.        
     END.
  IF dChange = 0 and totalPremia <> 0 then            /*если премия */
     DO:
        totalChange = GetChangeAmount(FirstMonDate(end-date) - 1).
        IF ABS(totalPremia - (totalChange / 10)) < 1 THEN bIsPremia10 = true.
        IF ABS(totalPremia - (30 * totalChange / 100)) < 1 THEN bIsPremia10 = false.        

     END.

  RETURN TotalPremia.

END FUNCTION.




oTable = new TTable(8).

oTpl = new TTpl("pir-ved3823.tpl").

ofunc = new tfunc().

FOR EACH tmprecid:
    vLnTotalInt = vLnTotalInt + 1.
END.
                   	
FOR EACH tmprecid,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    FIRST asset of loan NO-LOCK.


         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }



        tempvar = ofunc:FindAmortPremia(loan.cont-code,loan.contract,end-date).
	mPremia10 = DEC(ENTRY(1,tempvar,";")).
	mPremia30 = dec(ENTRY(2,tempvar,";")).
   dStartAmount = GetStartAmount().
   dChange      = GetChangeAmount(end-date).
   dPremia      = GetPremiaSize().	
 
   if   (dDateInstall >= FirstMonDate(end-date) and dDateInstall <= LastMonDate(end-date))
     or (dDateUpgrade >= FirstMonDate(end-date) and dDateUpgrade <= LastMonDate(end-date))
     or (dDatePremia >= FirstMonDate(end-date) and dDatePremia <= LastMonDate(end-date))

     THEN
     DO:
        count = count + 1.
        oTable:addRow().
        oTable:addCell(count).
        oTable:addCell(loan.doc-ref + " " + asset.name).
        oTable:addCell(loan.open-date).
        oTable:addCell(dDateUpgrade).        /*Дата модернизации         */
        oTable:addCell(dStartAmount).      /*Первоначальная стоимость  */
        oTable:addCell(dChange).     /*Изменение стоимости       */
        oTable:addCell(IF bIsPremia10 THEN dPremia else 0).           /*Премия 10%                */
        oTable:addCell(IF bIsPremia10 THEN 0 else dPremia).           /*Премия 30%                */
     END.

    vLnCountInt = vLnCountInt + 1.

END.
oTpl:addAnchorValue("table",oTable).
oTpl:addAnchorValue("Month",ENTRY(MONTH(end-date),months)).

{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT ofunc.
{intrface.del}


