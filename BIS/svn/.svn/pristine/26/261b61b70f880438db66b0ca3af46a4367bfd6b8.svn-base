/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует сводную проверочную ведомость         *     
 *                                                           *
 *                                                           *
 *                                                           *
 *************************************************************
 *                                                           *
 * Автор: Красков А.С.                                       *
 * Дата создания: 20.06.2011                                 *
 * заявка №                                                  *
 *                                                           *
 *************************************************************/

using Progress.Lang.*.

{globals.i}
{tmprecid.def}
{getdate.i}
{sh-defs.i}     /* Необходимы для подсчета остатков на счете */
{lshpr.pro}
{ulib.i}
{loan_par.def
    &new = new} /* Параметры договора по которым рассчитываются проценты */

&GLOB   SUMM_ROUL   "СУММА ОСТАТКОВ ПО РОЛЯМ"

DEF VAR oTAcct AS TAcct.
DEF VAR oTable AS TTable.
DEF VAR str AS CHAR.
DEF VAR TempDec1 AS DEC INIT 0.
DEF VAR TempDecItog AS DEC INIT 0.

DEF VAR dItog AS DECIMAL INIT 0.
DEF VAR TEMP AS DECIMAL INIT 0.
DEF VAR dDate as date.
DEF BUFFER bLoan for loan.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */
DEF VAR iPar AS INTEGER.
DEF VAR cRole AS CHARACTER.
DEF var count_all AS Integer INIT 0.
DEF VAR count_err AS INTEGER INIT 0.
define var vNameSchet AS CHAR EXTENT 3 NO-UNDO. /* наименование счета */
DEF VAR bErr AS LOGICAL.

DEF VAR D1 AS INT.
DEF VAR d2 AS INT.

def buffer bfrloan for loan.


DEFINE VARIABLE vValLogPrt AS LOGICAL NO-UNDO. /*Переводить часть параметр 
                                                 в пол. область или нет*/
DEFINE VARIABLE vTmpStrPar AS CHARACTER  NO-UNDO.  /*Временная строка параметров*/

DEFINE VARIABLE ShowERR AS LOGICAL INIT TRUE.

/*****************************
 * Маслов Д. А. Maslov D. A. *
 * Перечень ошибок с кау     *
 ******************************/
DEF VAR key        AS CHARACTER 	     NO-UNDO.
DEF VAR val        AS CHARACTER 	     NO-UNDO.
DEF VAR listErrorKau AS TAArray NO-UNDO.
listErrorKau = new TAArray().

/***/

PROCEDURE COUNT_POS.

    define input  param ipAcctTypeChar as char    no-undo. /* Роль счета */
    define input  param ipContractChar as char    no-undo. /* Назначение договора */
    define input  param ipContCodeChar as char    no-undo. /* Номер договора */
    define input  param ipSinceDate    as date    no-undo. /* Дата состояния договора */    
    define output param opAcctRemDec   as decimal no-undo. /* Остаток на счете */
    define output param opIdTypeChar   as char    no-undo. /* Роль счета и номер */

    define var vAcctTypeChar as char no-undo. /* Роль счета */

    ASSIGN
        opIdTypeChar  = ipAcctTypeChar
        vAcctTypeChar = entry(1, entry (2, ipAcctTypeChar, "("), ")")
    .

    run RE_L_ACCT (ipContractChar,
                   ipContCodeChar,
                   vAcctTypeChar,
                   ipSinceDate,
                   buffer loan-acct).

    if avail loan-acct then
    do:
       RUN GetCustName in h_base (loan.cust-cat,
                                  loan.cust-id,
                                  ?,
                                  OUTPUT vNameSchet[1],
                                  OUTPUT vNameSchet[2],
                                  INPUT-OUTPUT vNameSchet[3]).  
       

    
       run acct-pos in h_base (loan-acct.acct,
                                loan-acct.currency,
                                ipSinceDate,
                                ipSinceDate,
                                gop-status).

        ASSIGN
            opIdTypeChar = opIdTypeChar + " " + loan-acct.acct +
                           if loan-acct.currency ne ""
                           then ("/" + loan-acct.currency)
                           else ""
            opAcctRemDec = if loan-acct.currency eq ""
                           then sh-bal
                           else sh-val
        .
    end.
    else ASSIGN
        opAcctRemDec = ?
        opIdTypeChar = "Счет по роли '" + vAcctTypeChar + "' не найден"
    .

    return.

END PROCEDURE.



PROCEDURE SLECT_COUNT_POS.

    define input  param ipAcctTypeChar as char    no-undo. /* Сумма ролей счета */
    define input  param ipContractChar as char    no-undo. /* Назначение договора */
    define input  param ipContCodeChar as char    no-undo. /* Номер договора */
    define input  param ipSinceDate    as date    no-undo. /* Дата состояния договора */
    define output param opAcctRemDec   as decimal no-undo. /* Остаток на счете */
    define output param opIdTypeChar   as char    no-undo. /* Роль счета и номер */

    define var vRoulCountInt as int     no-undo. /* Счетчик ролей в строке */
    define var vAcctRemDec   as decimal no-undo. /* Остаток по I-ому счету */
    /* Выбираем индивидуальные счета */
    do vRoulCountInt = 1 to num-entries (ipAcctTypeChar, "+"):

        /* Считаем сумму по I-ому счету */
        run COUNT_POS (entry(vRoulCountInt, ipAcctTypeChar, "+"),
                       ipContractChar,
                       ipContCodeChar,
                       ipSinceDate,
                       output vAcctRemDec,
                       output opIdTypeChar).

        /* Суммирую остатки по счетам */
        opAcctRemDec = opAcctRemDec + if vAcctRemDec eq ? then 
                                         (IF NUM-ENTRIES(ipAcctTypeChar, "+") > 1 THEN 
                                            0 
                                          ELSE ?)
                                      else 
                                         vAcctRemDec.
    end.

    if num-entries(ipAcctTypeChar, "+") ne 1
    then opIdTypeChar = {&SUMM_ROUL}.
    return.

END PROCEDURE.   


PROCEDURE GETRESULT:
DEFINE INPUT PARAMETER in_code  AS CHAR.
DEFINE INPUT PARAMETER in_role  AS CHAR.
DEFINE INPUT PARAMETER in_cont  AS CHAR.
DEFINE INPUT PARAMETER in_contract  AS CHAR.
DEFINE INPUT PARAMETER in_date  AS date.


def var dsummparT as DECIMAL INIT 0.
DEF VAR dSummPar AS DECIMAL INIT 0.
DEF VAR dSummAcct AS DECIMAL INIT 0.

          if in_code = "0" or in_code = "7" then 
          RUN GET_0_PARAMVALUE(in_code,in_cont,in_contract,in_Date,OUTPUT dSummPar).
          else
          RUN GETPARAMVALUE(in_code,in_cont,in_contract,in_Date,OUTPUT dSummPar).
          
          if in_code = "33" then do:
	     RUN GETPARAMVALUE("33",in_cont,in_contract,in_Date,OUTPUT dSummPar).
	     RUN GETPARAMVALUE("35",in_cont,in_contract,in_Date,OUTPUT dSummParT).	     
             dSummPar = dSummPar + dSummParT.
	  end.

	  RUN GETACCTVALUE(in_role,in_cont,in_contract,in_Date,OUTPUT dSummAcct). 
          if dSummPar <> 0 OR dSummAcct <> 0 THEN RUN RESULTOUT(dSummPar,dSummAcct,String(in_code),in_role).

          dSummPar = 0.
          dSummAcct = 0.        
       
     RETURN.

END PROCEDURE.


PROCEDURE COUNT_PARAMS.

    define input  param ipCountStrChar as char    no-undo. /* Алгоритм расчета */
    define input  param ipContractChar as char    no-undo. /* Назначение договора */
    define input  param ipContCodeChar as char    no-undo. /* Номер договора */
    define input  param ipSinceDate    as date    no-undo. /* Дата состояния договора */
    define output param opParamValDec  as decimal no-undo. /* Значение параметра */

    define var vParamDec  as decimal no-undo. /* Значение параметра */
    define var vDbOperDec as decimal no-undo. /* Обороты по дебеты на дату расчета */
    define var vCrOperDec as decimal no-undo. /* Обороты по кредиту на дату расчета */

    IF INDEX (ipCountStrChar, "+") ne 0 THEN do:

        run COUNT_PARAMS (
                substring(ipCountStrChar, index (ipCountStrChar, "+") + 1),
                ipContractChar,
                ipContCodeChar,
                ipSinceDate,
                output opParamValDec).

        ipCountStrChar = entry (1, ipCountStrChar, "+").
    END.
    IF ipCountStrChar BEGINS 'MOD' AND 
       SUBSTRING(ipCountStrChar,LENGTH(ipCountStrChar)) =')' THEN
     ASSIGN 
       vValLogPrt = YES
       vTmpStrPar = ENTRY(1,ENTRY (2,
                    SUBSTRING(ipCountStrChar,4),"("),")")           
     .
    ELSE ASSIGN 
      vValLogPrt = NO
      vTmpStrPar = ipCountStrChar.
    run STNDRT_PARAM (ipContractChar,
                      ipContCodeChar,
                      vTmpStrPar,
                      ipSinceDate,    /*  дату пересчета договора. */
                      output vParamDec,
                      output vDbOperDec,
                      output vCrOperDec).

    /* Производит учет процентов из состояния договра и
    ** суммирование параметров, если их несколько */
    ASSIGN
        vParamDec = vParamDec +
                    if lookup (vTmpStrPar, vLoanInterestChar) ne 0
                    then if lookup (vTmpStrPar, vLoanInterestChar) le 10
                         then loan.interest [lookup (vTmpStrPar, vLoanInterestChar)]
                         else LoadPar(lookup (vTmpStrPar, vLoanInterestChar),loan.contract + ',' + loan.cont-code) 
                    else 0
        opParamValDec = opParamValDec + (IF vValLogPrt THEN ABSOLUTE(vParamDec) ELSE vParamDec)                        
    .

    return.

END PROCEDURE.

PROCEDURE GET_0_PARAMVALUE:
  DEFINE INPUT PARAMETER in_code  AS CHAR.
  DEFINE INPUT PARAMETER in_cont  AS CHAR.
  DEFINE INPUT PARAMETER in_contract  AS CHAR.
  DEFINE INPUT PARAMETER in_date  AS date.
  DEFINE OUTPUT PARAMETER dSumm   AS DECIMAL.
  def var dTempp AS DEC.
  def var dSumm2 AS DEC.
        dSumm = 0.
         


   for each bloan where bloan.contract = in_contract and (bloan.cont-code begins in_cont) and (bloan.close-date = ? OR bloan.close-date > in_date ) NO-LOCK:

    RUN COUNT_PARAMS(in_code,in_contract,bloan.cont-code,in_date, output temp).
        dSumm = dSumm + temp.
        temp = 0.                                   
     end.
   if in_code = "0" then do:
   for each bloan where bloan.contract = in_contract and (bloan.cont-code begins in_cont) and (bloan.close-date = ? OR bloan.close-date > in_date ) NO-LOCK:

    RUN COUNT_PARAMS("2",in_contract,bloan.cont-code,in_date, output temp).
        dSumm2 = dSumm2 + temp.
        temp = 0.                                   
     end.                             
     dsumm = dsumm + dsumm2.
   end.                          
  RETURN.

END PROCEDURE.


PROCEDURE GETPARAMVALUE:
  DEFINE INPUT PARAMETER in_code  AS CHAR.
  DEFINE INPUT PARAMETER in_cont  AS CHAR.
  DEFINE INPUT PARAMETER in_contract  AS CHAR.
  DEFINE INPUT PARAMETER in_date  AS date.
  DEFINE OUTPUT PARAMETER dSumm   AS DECIMAL.
  def var dTempp AS Date.
        dSumm = 0.
         


    RUN COUNT_PARAMS(in_code,in_contract,in_cont,in_date, output temp).   
/*RUN GET_PARAM(in_contract,in_cont,in_code,in_date,output temp, output dTempp).*/

        dSumm = dSumm + temp.
        temp = 0.                                   

   RETURN.

END PROCEDURE.

PROCEDURE GETACCTVALUE:
  DEFINE INPUT PARAMETER in_code  AS CHAR.
  DEFINE INPUT PARAMETER in_cont  AS CHAR.
  DEFINE INPUT PARAMETER in_contract  AS CHAR.
  DEFINE INPUT PARAMETER in_date  AS date.
  DEFINE OUTPUT PARAMETER dSummAcct   AS DECIMAL.
       dSummAcct = 0.

    def var tempp as CHAR.
    def var prevacct as CHAR.
    def var dtempdd AS DEC.
/*for each loan-acct where loan-acct.cont-code begins in_cont no-lock.
    RUN SLECT_COUNT_POS(in_code,in_contract,loan-acct.cont-code,in_date,OUTPUT dtempdd, OUTPUT tempp).
        if dtempdd = ? then dtempdd = 0.
    dSummAcct = dSummAcct + dtempdd.
    dtempdd = 0.
end.*/

/*   message in_cont in_code dtempdd VIEW-AS ALERT-BOX.*/
/*        if dtempdd = ? then dtempdd = 0.
        dSummAcct = dtempdd.*/

          prevacct = "".
          for each loan-acct where loan-acct.cont-code = in_cont and loan-acct.acct-type = in_code and loan-acct.contract = in_contract  NO-LOCK.
           if prevacct <> loan-acct.acct then do:

/*           oTAcct = new TAcct(loan-acct.acct).*/

                run acct-pos in h_base (loan-acct.acct,
                                loan-acct.currency,
                                in_date,
                                in_date,
                                CHR(251)).
             dSummAcct = dSummAcct + if loan-acct.currency eq ""
                           then sh-bal
                           else sh-val.

/*		IF oTAcct:kau-id EQ ? THEN DO: 
		  listErrorKau:setH(oTAcct:acct,"не привязан к аналитике"). 
		END.*/

/*           	dSummAcct = dSummAcct + oTacct:getlastpos2date(dDate).
           DELETE OBJECT oTAcct.           */
          end.
	  prevacct = loan-acct.acct.
          end.                 

      RETURN.
END PROCEDURE.

PROCEDURE RESULTOUT:
  DEFINE INPUT PARAMETER dSummPar  AS DECIMAL.
  DEFINE INPUT PARAMETER dSummAcct  AS DECIMAL.
  DEFINE INPUT PARAMETER in_code  AS CHAR.
  DEFINE INPUT PARAMETER in_role  AS CHAR.

                   dItog = ABS(dSummPar) - ABS(dSummAcct).


          if ABS(dSummPar) <> ABS(dSummAcct) THEN
                DO:
                   oTable:AddRow().
                   oTable:AddCell(in_code + " и " + in_role).
                   oTable:AddCell(dSummPar).
                   oTable:AddCell(dSummAcct).
                   oTable:AddCell(dItog). 
                   oTable:AddCell("ОШИБКА"). 
                   bErr = true.
                END.
           ELSE
                DO:
                   if showerr = false then do:
  		   oTable:AddRow().
                   oTable:AddCell(in_code + " и " + in_role).
                   oTable:AddCell(dSummPar).
                   oTable:AddCell(dSummAcct).
                   oTable:AddCell(dItog). 
                   oTable:AddCell("ОК"). 
		   end.
                END.

        RETURN.

END PROCEDURE.



dDate = end-date.
d1 = Time.

if not can-find (first tmprecid)
then do:
    message "Нет ни одного выбранного договора!"
    view-as alert-box.
    return.
end.

{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id and (loan.class-code = "loan-transh" or loan.class-code = "l_agr_with_per" or loan.class-code = "loan_allocat") NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.
{setdest.i}

PUT UNFORMATTED               "Сводная проверочная ведомость по договорам"     SKIP(0).


FOR EACH tmprecid,
    first loan where RECID(loan) EQ tmprecid.id and (loan.class-code = "loan-transh" or loan.class-code = "l_agr_with_per" or loan.class-code = "loan_allocat") NO-LOCK.
oTable = new TTable(5).
         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
count_all = count_all + 1.
          berr = false.

         

/* Добавляем первую строку с заголовком строки*/

          oTable:AddRow().
          oTable:AddCell("Параметр").
          oTable:AddCell("Значение параметра").
          oTable:AddCell("Остаток на счете").
          oTable:AddCell("Разница").
          oTable:AddCell("Результат").

          for each comm-rate where comm-rate.commission = "%Рез" and comm-rate.kau begins loan.contract + "," + loan.cont-code + " " NO-LOCK,
		first bfrloan where bfrloan.contract = loan.contract and bfrloan.cont-code = entry(2,comm-rate.kau) and (bfrloan.close-date >= dDate or bfrloan.close-date = ?) NO-LOCK.

               oTable:AddRow().
               oTable:AddCell(entry(2,comm-rate.kau)).
               oTable:AddCell("").
               oTable:AddCell("").
               oTable:AddCell("").
               oTable:AddCell("Индивидульный коэф. рез.").
               bErr = true.
          end.

/* проверяем параметр 0 и счет с ролью "кредит" */
          RUN GETRESULT("0","Кредит",loan.cont-code,loan.contract,dDate).

         

/*проверяем параметр 7 и счет с ролью "КредПр" */
          RUN GETRESULT("7","КредПр",loan.cont-code,loan.contract,dDate).
   

/*!!!!проверяем параметр 0+7 = общая сумма задолженности по договору */

          TempDecItog = 0.
          RUN GETPARAMVALUE("0",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("7",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          oTable:AddRow().
          oTable:AddCell("Параметр 0+7").
          oTable:AddCell(TempDecItog).
          oTable:AddCell("  ").
          oTable:AddCell("  ").
          oTable:AddCell("  ").


/*проверяем параметр 4 и счет с ролью "КредПроц" */
/*          RUN GETRESULT("4","КредПроц",loan.cont-code,loan.contract,dDate).*/

/*проверяем параметр 33 и счет с ролью "КредТ" */
          RUN GETRESULT("33","КредТ",loan.cont-code,loan.contract,dDate).
        

/*проверяем параметр 48 и счет с ролью "КредТв" */
          RUN GETRESULT("29","КредТв",loan.cont-code,loan.contract,dDate).
        

/*проверяем параметр 10 и счет с ролью "КредПр%" */
          RUN GETRESULT("10","КредПр%",loan.cont-code,loan.contract,dDate).

          RUN GETRESULT("19","КредН",loan.cont-code,loan.contract,dDate).        

/*проверяем параметр 29 и счет с ролью "КредПр%Вб" */
          RUN GETRESULT("48","КредПр%В",loan.cont-code,loan.contract,dDate).
        

/*проверяем параметр 10+29 = просроченные проценты */

          TempDecItog = 0.
          RUN GETPARAMVALUE("10",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("29",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.

          oTable:AddRow().
          oTable:AddCell("Параметр 10+29").
          oTable:AddCell(TempDecItog).
          oTable:AddCell("  ").
          oTable:AddCell("  ").
          oTable:AddCell("  ").
        

/*проверяем параметр 4+33+48+10+29 = задолженность по процентам */

          TempDecItog = 0.
          RUN GETPARAMVALUE("4",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("33",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("48",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("10",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          RUN GETPARAMVALUE("29",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
	  TempDecItog = TempDecItog + TempDec1.
          oTable:AddRow().
          oTable:AddCell("Параметр 4+33+48+10+29").
          oTable:AddCell(TempDecItog).
          oTable:AddCell("  ").
          oTable:AddCell("  ").
          oTable:AddCell("  ").

/*проверяем параметр 21 и счет с ролью "Роль(КредРез)" */
          RUN GETRESULT("21","КредРез",loan.cont-code,loan.contract,dDate).

/*проверяем параметр 46 и счет с ролью "Роль(КредРез1)" */
          RUN GETRESULT("46","КредРез1",loan.cont-code,loan.contract,dDate).

/*проверяем параметр 88 и счет с ролью "Роль(КредРезВб)" */
/*          RUN GETRESULT("88","КредРезВб",loan.cont-code,loan.contract,dDate).*/

/*проверяем параметр 351 и счет с ролью "Роль(КредРезПр)" */
          RUN GETRESULT("351","КредРезПр",loan.cont-code,loan.contract,dDate).

/*проверяем наличие параметра 16  */
          
	  RUN GETPARAMVALUE("16",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
          if TempDec1 <> 0 then do:
          oTable:AddRow().
          oTable:AddCell("Параметр 16").
          oTable:AddCell(TempDec1).
          oTable:AddCell("  ").
          oTable:AddCell("  ").
          oTable:AddCell("ОШИБКА").
          end.

/*проверяем наличие параметра 34  */
          
	  RUN GETPARAMVALUE("34",loan.cont-code,loan.contract,dDate,OUTPUT TempDec1).
          if TempDec1 <> 0 then do:
          oTable:AddRow().
          oTable:AddCell("Параметр 34").
          oTable:AddCell(TempDec1).
          oTable:AddCell("  ").
          oTable:AddCell("  ").
          oTable:AddCell("ОШИБКА").
          end.



if berr = true then 
do:
count_err = count_err + 1.
PUT UNFORMATTED STRING(count_all) + ") " + loan.cont-code SKIP(0).
oTable:show().
end.
else
if showerr = false then do:
PUT UNFORMATTED STRING(count_all) + ") " + loan.cont-code SKIP(0).
PUT UNFORMATTED "Ошибок нет" SKIP(0).
END.

DELETE OBJECT oTable.
PUT UNFORMATTED SKIP(0).
           vLnCountInt = vLnCountInt + 1.
end.

PUT UNFORMATTED "Договоров с ошибкой: " + string(count_err) SKIP(0).

PUT UNFORMATTED "      *** ОШИБКИ ПРИВЯЗКИ СЧЕТОВ К АНАЛИТИКЕ ***   " SKIP.

{foreach listErrorKau key val}
  PUT UNFORMATTED key " - " val SKIP.
{endforeach listErrorKau}

DELETE OBJECT listErrorKau.

d2 = Time.

PUT UNFORMATTED "Выполнил: " + GetUserInfo_ULL(USERID, "fio", false) SKIP(0). 
PUT UNFORMATTED "Дата расчета: " + string(ddate) SKIP(0).
PUT UNFORMATTED "Дата выполнения: " + string(TODAY) + "  " + STRING(TIME,"HH:MM:SS") SKIP(0).
message (d2 - d1) VIEW-AS ALERT-BOX.



/*oTpl:show().*/

{preview.i}                              

