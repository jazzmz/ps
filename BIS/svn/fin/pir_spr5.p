/* 
Расчет ф.115 п.5 Требования по процентным доходам, учтенные на внебалансовых счетах  тыс. руб.
Никитина Ю.А.
18.11.2013
*/

{globals.i}
{norm.i}
{svarloan.def NEW}          /* Shared переменные модуля "Кредиты и депозиты". */
{intrface.get tmess}    /* Инструменты обработки сообщений. */
{intrface.get xclass} /* Загрузка инструментария метасхемы */
{intrface.get pogcr}

def output param oRes as dec init 0 no-undo.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iStr AS CHARACTER NO-UNDO.

def var mDProsOD  as date no-undo.
def var mDProsPr  as date no-undo.
def var mDPros    as date no-undo.
DEF VAR proc-name AS CHAR NO-UNDO.
def var mSumOst   as dec  no-undo.
def var mDOst     as date no-undo.
def var i         as int  no-undo.
def var id-d1     as int  no-undo.
def var id-k1     as int  no-undo.
def var id-d2     as int  no-undo.
def var id-k2     as int  no-undo.
def var tmpParam  as int  no-undo.
def var loan_ost  as dec  no-undo.
def var loan_cr   as dec  no-undo.
def var loan_db   as dec  no-undo.
def var mKD       as int  no-undo.

DEFINE NEW SHARED STREAM err.

def temp-table tmpLoan no-undo
   field tmpContCode as char
   field tmpContract as char
   field tmpCurrency as char
   field tmpDatePr   as date
   field tmpSumPrV   as dec
   field tmpParam    as int
.

def temp-table tmpGr no-undo
   field tmpContCode as char
   field tmpContract as char
   field tmpCurrency as char
   field tmpDNach    as date
   field tmpSumNach  as dec
   field tmpDSn      as date
   field tmpSumSn    as dec
   field tmpSumOst   as dec
.

def temp-table tmpLoan-int no-undo
   field tmpContCode as char
   field tmpContract as char
   field tmpCurrency as char
   field tmpmdate    as date
   field tmpid-d     as int
   field tmpid-k     as int
   field tmpamt-rub  as dec
.

def buffer mLoanInt for tmploan-int.

for each loan where loan.contract eq "Кредит" 
   and loan.open-date LE iEndDate
   and (loan.close-date eq ? or loan.close-date GT iEndDate)
   and can-do("!пк*,!но*,!MM*,*",loan.cont-code)
   no-lock:
   if loan.close-date eq ? then do:
      RUN SetSysConf IN h_base ("NoProtocol","YES").
      RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
      {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
      {get_meth.i  'Calc' 'loanclc'}
      RUN VALUE(proc-name + ".p") (loan.contract,
                                   loan.cont-code,
                                   ienddate).

      RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
      RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
   end.
   DO i = 1 to 3:
/*      message string(i) view-as alert-box.*/
      /* просрочка по ОД */
      if i eq 1 then do:
         id-d1 = 7. id-k1 = 0.  /* постановка на просрочку ОД */
         id-d2 = 5. id-k2 = 7.  /* оплата просрочки ОД*/
         tmpParam = 7.
      end.
      /* просрочка по процентам */
      if i eq 2 then do:
         id-d1 = 10. id-k1 = 33.  /*  */
         id-d2 = 5. id-k2 = 10.   /*  */
         tmpParam = 10.
      end.
      /* просрочка по процентам */
      if i eq 3 then do:
         id-d1 = 48. id-k1 = 30.  /* Вынес %% на просрочку. 308 */
         id-d2 = 30. id-k2 = 48.  /* Оплата просроченных %% на внеб. 309 */
         tmpParam = 48.
      end.

      find first tmpLoan where tmpLoan.tmpContCode eq entry(1,loan.cont-code," ") and tmpLoan.tmpContract eq loan.contract 
         and tmpLoan.tmpParam eq tmpParam
         no-lock no-error.
      if not avail tmpLoan then do:
         create tmpLoan.
         assign
            tmpLoan.tmpContCode = entry(1,loan.cont-code," ")
            tmpLoan.tmpContract = loan.contract
            tmpLoan.tmpCurrency = loan.currency
         .
         case i :
            when 1 then tmpLoan.tmpParam = tmpParam.
            when 2 then tmpLoan.tmpParam = tmpParam.
            when 3 then tmpLoan.tmpParam = tmpParam.
         end.
         for each loan-int where loan-int.cont-code begins tmploan.tmpcontcode 
            and loan-int.contract eq tmploan.tmpcontract
            and ((loan-int.id-d eq id-d1 and loan-int.id-k eq id-k1) or (loan-int.id-d eq id-d2 and loan-int.id-k eq id-k2))
            and loan-int.mdate LE iEndDate
            no-lock:
            /* составили таблицу платежей сквозную для все траншей и охвата*/
            find first tmpLoan-int where tmpLoan-int.tmpcontCode begins loan.cont-code
               and tmpLoan-int.tmpContract eq Loan-int.contract
               and tmpLoan-int.tmpCurrency eq Loan-int.currency 
               and tmpLoan-int.tmpmdate eq Loan-int.mdate
               and tmpLoan-int.tmpid-d eq Loan-int.id-d
               and tmpLoan-int.tmpid-k eq Loan-int.id-k
               no-lock no-error.
            if avail tmpLoan-int then do:
               tmpLoan-int.tmpamt-rub = tmpLoan-int.tmpamt-rub + Loan-int.amt-rub. 
            end.
            else do:
               create tmpLoan-int.
               ASSIGN
                  tmpLoan-int.tmpcontCode = entry(1,Loan-int.cont-code," ")
                  tmpLoan-int.tmpContract = Loan-int.contract
                  tmpLoan-int.tmpCurrency = Loan-int.currency
                  tmpLoan-int.tmpmdate = Loan-int.mdate
                  tmpLoan-int.tmpid-d = Loan-int.id-d
                  tmpLoan-int.tmpid-k = Loan-int.id-k
                  tmpLoan-int.tmpamt-rub = Loan-int.amt-rub
               .
            end.
            /* окончили создание таблицы платежей */
         end.
         mDOst = loan.open-date.
         mSumOst = 0.
         for each tmploan-int where tmploan-int.tmpcontcode eq tmploan.tmpcontcode 
            and tmploan-int.tmpcontract eq tmploan.tmpcontract
            and (tmploan-int.tmpid-d eq id-d1 and tmploan-int.tmpid-k eq id-k1)
            and tmploan-int.tmpmdate LE iEndDate
            no-lock by tmploan-int.tmpmdate:
            create tmpGR.
            ASSIGN
               tmpGr.tmpContCode = tmploan.tmpcontcode
               tmpGr.tmpContract = tmploan.tmpcontract
               tmpGr.tmpCurrency = tmploan.tmpcurrency
               tmpGr.tmpDNach = tmploan-int.tmpmdate
               tmpGr.tmpSumNach = tmploan-int.tmpamt-rub
               /*mSumOst = tmpGr.tmpSumOst*/
               tmpGr.tmpSumOst = tmploan-int.tmpamt-rub
            .
            tmpGr.tmpSumOst = tmpGr.tmpSumOst - abs(mSumOst).
            mSumOst = tmpGr.tmpSumOst.
            if tmpGr.tmpSumOst LE 0 then do:
               tmpGr.tmpDSn = mDOst.
            end. 
            else do:
               for each mloanint where mloanint.tmpcontcode eq tmploan.tmpcontcode 
                  and mloanint.tmpcontract eq tmploan.tmpcontract
                  and (mloanint.tmpid-d eq id-d2 and mloanint.tmpid-k eq id-k2)
                  and mloanint.tmpmdate LE iEndDate
                  and mloanint.tmpmdate GT mDOst 
                  and mloanint.tmpmdate GT tmploan-int.tmpmdate 
                  no-lock by mLoanInt.tmpmdate:
                  tmpGr.tmpSumOst = tmpGr.tmpSumOst - mLoanInt.tmpamt-rub.
      /*            message tmpGr.tmpSumOst tmpGr.tmpSumNach mLoanInt.amt-rub abs(mSumOst) mDOst mloanint.mdate view-as alert-box.*/
                  if tmpGr.tmpSumOst LE 0 then do:
                     ASSIGN
                        tmpGr.tmpDSn = mLoanInt.tmpmdate
                        tmpGr.tmpSumSn = tmpGr.tmpSumSn + mLoanInt.tmpamt-rub
                        mDOst = mLoanInt.tmpmdate
                        mSumOst = tmpGr.tmpSumOst.
                     .
                     LEAVE.
                  end.
               end.
            end.
         end.
      end.
   end.
end.

empty temp-table tmpLoan.

/* выберем максимальную дату просрочки по договору */
for each tmpGr where tmpGr.tmpDSn eq ? no-lock :
   find first tmpLoan where tmpLoan.tmpContCode eq tmpGr.tmpcontcode and tmpLoan.tmpContract eq tmpGr.tmpcontract 
      no-lock no-error.
   if not avail tmpLoan then do:
      create tmpLoan.
      assign
         tmpLoan.tmpContCode = tmpGr.tmpContCode
         tmpLoan.tmpContract = tmpGr.tmpcontract
         tmpLoan.tmpCurrency = tmpGr.tmpcurrency
         tmpLoan.tmpDatePr = tmpGr.tmpDNach
      .
   end.
   if tmpLoan.tmpDatePr GT tmpGr.tmpDNach then
      tmpLoan.tmpDatePr = tmpGr.tmpDNach.
/*   message tmpGr.tmpContCode tmpGr.tmpDNach string(tmpGr.tmpSumNach) tmpGr.tmpDSn string(tmpGr.tmpSumSn) string(tmpGr.tmpSumOst) view-as alert-box.*/
end.

/* если максимальная дата просрочки по договору больше 90 дней, то запишем сумму просрочки.*/
for each tmpLoan no-lock:
   mKD = iEndDate - tmpLoan.tmpDatePr.
   if mKD GT 90 then do:
      find first loan where loan.cont-code eq tmpLoan.tmpcontcode and loan.contract eq tmpLoan.tmpcontract no-lock no-error.
      if loan.close-date eq ? then do:
         RUN SetSysConf IN h_base ("NoProtocol","YES").
         RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
         {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
         {get_meth.i  'Calc' 'loanclc'}
         RUN VALUE(proc-name + ".p") (loan.contract,
                                      loan.cont-code,
                                      ienddate).

         RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
         RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
      end.
      RUN "STNDRT_PARAM" (tmploan.tmpcontract,
                          tmploan.tmpcontcode,
                          29,
                          ienddate,
                          OUTPUT loan_ost,
                          OUTPUT loan_cr,
                          OUTPUT loan_db).
      if tmpLoan.tmpcurrency ne "" then do:
         loan_ost = round(CurToCurWork("Учетный",tmpLoan.tmpcurrency,"",ienddate,loan_ost),2).
      end.
      tmpLoan.tmpSumPrV = tmpLoan.tmpSumPrV + loan_ost.
      RUN "STNDRT_PARAM" (tmploan.tmpcontract,
                          tmploan.tmpcontcode,
                          229,
                          ienddate,
                          OUTPUT loan_ost,
                          OUTPUT loan_cr,
                          OUTPUT loan_db).
      if tmpLoan.tmpcurrency ne "" then do:
         loan_ost = round(CurToCurWork("Учетный",tmpLoan.tmpcurrency,"",ienddate,loan_ost),2).
      end.
      tmpLoan.tmpSumPrV = tmpLoan.tmpSumPrV + loan_ost.
      RUN "STNDRT_PARAM" (tmploan.tmpcontract,
                          tmploan.tmpcontcode,
                          48,
                          ienddate,
                          OUTPUT loan_ost,
                          OUTPUT loan_cr,
                          OUTPUT loan_db).
      if tmpLoan.tmpcurrency ne "" then do:
         loan_ost = round(CurToCurWork("Учетный",tmpLoan.tmpcurrency,"",ienddate,loan_ost),2).
      end.
      tmpLoan.tmpSumPrV = tmpLoan.tmpSumPrV + loan_ost.
      oRes = oRes + tmpLoan.tmpSumPrV.
   end.
end.


