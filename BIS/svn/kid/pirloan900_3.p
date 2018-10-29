/************************
 *
 * Распоряжение отнесение процентов на доходный счет
 * 
 ************************
 * ВНИМАНИЕ!!! 
 *
 * ПРИ РАССЧЕТЕ ПРОЦЕНТОВ СМОТРИТСЯ ФАКТИЧЕСКИЙ ОСТАТОК ПО ССУДНОМУ СЧЕТУ!!!!
 *
 *
 ************************
 *
 * Автор: Красков А.С.
 * Дата создания: 
 * Заявка: #900
 *
 *************************/

{globals.i}


{tmprecid.def}

{t-otch.i new}

{intrface.get loan}
{intrface.get cust}

{ulib.i}

{pir-getsumbyoper.i}

DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */

DEF VAR cDogNum AS CHARACTER  NO-UNDO.    /* Номер договора */
DEF VAR oDoc AS TDocument     NO-UNDO.    /* Документ */
DEF VAR clName AS CHARACTER   NO-UNDO.    /* Наименование заемщика */

DEF VAR dDate1 AS DATE NO-UNDO.
DEF VAR dDate2 AS DATE NO-UNDO.

DEF VAR oTpl   AS TTpl   NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.	  /* Храним рассчет резерва */

DEF VAR cLoanContract AS CHARACTER NO-UNDO.
DEF VAR cLoanNum      AS CHARACTER NO-UNDO.
DEF VAR proc-name     AS CHARACTER NO-UNDO.

/*** СУММЫ ИЗ ОТЧЕТА ***/
DEF VAR dVneseno    AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dOplProc    AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dPereplata  AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dNachProc   AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dPogProc    AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dItog       AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dZaPeriod   AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dVBudPeriod AS DECIMAL INITIAL 0  NO-UNDO.
def VAR prevPlat as DECIMAL INITIAL 0 NO-UNDO.

DEF VAR amtstr      AS CHARACTER EXTENT 2 NO-UNDO.
DEF VAR amtstr2      AS CHARACTER EXTENT 2 NO-UNDO.

{getdates.i}

dDate1=beg-date.
dDate2=end-date.

{setdest.i}


FOR EACH tmprecid:



oDoc = new TDocument(tmprecid.id). 
oTpl = new TTpl("pirloan900_3.tpl").
oTable = new TTable(6).
oTable:addRow().
oTable:addCell("").
oTable:addCell("С").
oTable:addCell("По").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").


/*******************************************
 * 1. Производим рассчет сумм              *
 *******************************************/

dPereplata = oDoc:doc-sum.
Run x-amtstr.p(dPereplata,oDoc:currency,true,true,output amtstr[1], output amtstr[2]).

oTpl:addAnchorValue("summa_1",amtstr[1]).
oTpl:addAnchorValue("summa_2",amtstr[2]).

/*******************************************
 * 2. Идем с конца и снача рассчитываем    *
 * начисленные проценты за отчетный период.*
 *******************************************/

 cLoanContract  = ENTRY(1,oDoc:getOpEntry4Order(1):kau-cr).
 cLoanNum       = ENTRY(2,oDoc:getOpEntry4Order(1):kau-cr).


  FIND FIRST loan WHERE     loan.contract  EQ cLoanContract
			AND loan.cont-code EQ cLoanNum NO-LOCK NO-ERROR.

  IF AVAILABLE(loan) THEN DO:

   {empty otch1}

   {ch_dat_p.i}
                                  	
/**************************
 *
 * Для рассчета процентов
 * необходимо использовать
 * метод с метасхемы.
 * Иначе будет ошибка.
 *
 **************************
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Заявка: #759
 *
 ***************************/
 
 {get_meth.i 'NachProc' 'nach-pp'}

   run VALUE(proc-name + ".p") (cLoanContract,
                 cLoanNum,
                 dDate1,
                 dDate2,
                 dat-per,
	         ?,
                 1).


   clName = getPirClName(loan.cust-cat,loan.cust-id).


/*********************
 * Закомментировал 
 * по заявке #759. 
 * Дате на одну копейку
 * больше.
 **********************/
/*
	{empty otch1}

	RUN pint.p(cLoanContract,cLoanNum,dDate1,dDate2,"!704,*").
*/



        FOR EACH otch1,
	 FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
		              AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK:

               oTable:addRow().
	       oTable:addCell(otch1.bal-sum).
	       oTable:addCell(otch1.beg-date).
	       oTable:addCell(otch1.end-date).
	       oTable:addCell(otch1.ndays).
	       oTable:addCell(STRING(otch1.rat1) + "%").
	       oTable:addCell(otch1.summ_pr).

	       ACCUMULATE otch1.summ_pr (TOTAL).
	END.

   dNachProc = (ACCUM TOTAL otch1.summ_pr).

/**********************************************
 * 3. Рассчитываем ранее оплаченные проценты .*
 * Они определяют как сумма 352 параметра и   *
 * сумма 10к в этом отчетном периоде.         *
 * ===
 * В текущий момент 10 будет задваиваться, на
 * текущей операции поэтому вычитаем ее.
 **********************************************
 * При этом возможен случай, когда списывают наращенные
 * % за предыдущий месяц. В этом случае вычитать проводку
 * не надо так как не учтется в 10.
 * На самом деле надо это перенести в getSumByOper, 
 * но делать пока этого не буду.
 **********************************************/

/********************************************
 * 10 операцией может быть                  *
 * оплачено много чего по процентам,        *
 * например, просроченные проценты.         *
 * Списание будет производится согласно     *
 * порядка приведенного в банке.            *
 * Поэтому ориентируемся на 10 и 9.         *
 * Наверное, можно вообще ориентироваться   *
 * на 9ку.                                  *
 ********************************************
 * Заявка: #727                             *
 * Автор: Маслов Д. А. Maslov D. A.         *
 ********************************************/

   dVneseno = ABS(GetCredLoanParamValue_ULL(loan.cont-code,352,oDoc:DocDate,FALSE)) + 
    getSumByOperNum(loan.cont-code,9,dDate1,dDate2).
   message GetCredLoanParamValue_ULL(loan.cont-code,352,oDoc:DocDate,FALSE) getSumByOperNum(loan.cont-code,9,dDate1,dDate2) VIEW-AS ALERT-BOX.
 Run x-amtstr.p(dVneseno,oDoc:currency,true,true,output amtstr2[1], output amtstr2[2]).

 /**********************************************
  * 4. ИТОГО к оплате			      *
  **********************************************/
  dItog = dNachProc.


   RUN pint.p(loan.contract,loan.cont-code,dDate1,dDate2,"!704,*").


 find last loan-acct where loan-acct.contract = cLoanContract
		       and loan-acct.cont-code = cLoanNum
		       and loan-acct.since <= oDoc:DocDate
		       and loan-acct.acct-type = "КредБудПроц"
		       NO-LOCK NO-ERROR.

if not available (loan-acct) then message "Не найден счет с ролью КредБудПроц!!!" VIEW-AS ALERT-BOX. 




oTpl:addAnchorValue("dVneseno",TRIM(STRING(dVneseno,">>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("dNachProc",dNachProc).
oTpl:addAnchorValue("dOplProc",TRIM(STRING(dOplProc,">>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("dItog",dItog).
oTpl:addAnchorValue("ACCT_DOH_BUD_PER",loan-acct.acct).
oTpl:addAnchorValue("dZaPeriod",STRING(dZaPeriod,">>>,>>>,>>>,>>9.99")).
oTpl:addAnchorValue("dVBudPeriod",STRING(dVBudPeriod,">>>,>>>,>>>,>>9.99")).


oTpl:addAnchorValue("summa_3",amtstr2[1]).
oTpl:addAnchorValue("summa_4",amtstr2[2]).  




oTpl:addAnchorValue("dPrevPlat",TRIM(STRING(dVBudPeriod,">>>,>>>,>>>,>>9.99"))).

oTpl:addAnchorValue("clName",clName).
oTpl:addAnchorValue("date1",dDate1).
oTpl:addAnchorValue("date2",dDate2).
oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("DATE",oDoc:DocDate).
oTpl:addAnchorValue("LoanCur",(IF loan.currency EQ "" THEN "810" ELSE loan.currency)).
oTpl:addAnchorValue("loanNo",getMainLoanAttr(cLoanContract,cLoanNum,"%cont-code от %ДатаСогл")).

oTpl:addAnchorValue("dPereplata",TRIM(STRING(dPereplata,">>>,>>>,>>>,>>9.99"))).


oTpl:show().
END. /* LOAN */

DELETE OBJECT oDoc.
DELETE OBJECT oTable.
DELETE OBJECT oTpl.

END. /* FOR EACH */

{preview.i}
