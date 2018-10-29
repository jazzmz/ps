/*в данном варианте для расчета берется параметр 8.
распоряжение нужно в случае если клиент платить просроченные проценты,
но при этом у кредитов с ним договоренность что просроченные проценты ему не начисляются (вот такая хитрость)
Модифицировал: Красков А.С.
Заказчик: Коноплева Е.В.*/


/************************
 *
 * Распоряжение на погашение
 * процентов.
 ************************
 * ВНИМАНИЕ!!! 
 *
 * ПРИ РАССЧЕТЕ ПРОЦЕНТОВ СМОТРИТСЯ ФАКТИЧЕСКИЙ ОСТАТОК ПО ССУДНОМУ СЧЕТУ!!!!
 *
 *
 ************************
 *
 * Автор: Маслов Д. А.
 * Дата создания: 
 * Заявка: #694
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
DEF VAR dNachProc   AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dPogProc    AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dItog       AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dZaPeriod   AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dVBudPeriod AS DECIMAL INITIAL 0  NO-UNDO.


DEF VAR amtstr      AS CHARACTER EXTENT 2 NO-UNDO.

{getdates.i}

dDate1=beg-date.
dDate2=end-date.

{setdest.i}


FOR EACH tmprecid:



oDoc = new TDocument(tmprecid.id). 
oTpl = new TTpl("pirln0041_1.tpl").
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

dVneseno = oDoc:doc-sum.
Run x-amtstr.p(dVneseno,oDoc:currency,true,true,output amtstr[1], output amtstr[2]).

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
		              AND CAN-DO("8",STRING(loan-par.amt-id)) NO-LOCK:

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

   dOplProc = GetCredLoanParamValue_ULL(loan.cont-code,352,oDoc:DocDate,FALSE) + 
     getSumByOperNum(loan.cont-code,280,dDate1,dDate2).



/* getSumByOperSt(10,loan.currency,loan.cont-code,dDate1 - 1,dDate2 + 1,"Ф") */

/*********************
 *
 * Из заявки #727 это потеряло
 * смысл, так как 9ка рождается, 
 * только при пересчете на следующий
 * день.
 * 
 *********************/
/******
  Это тоже теряет смысл 
  /* Корректировка на текущую операцию */
  IF oDoc:DocDate <= dDate2 THEN dOplProc = dOplProc - dVneseno.
 ******/
 
 /**********************************************
  * 4. ИТОГО к оплате			      *
  **********************************************/
  dItog = dNachProc - dOplProc.


  /*************************************************
   * 5. Сколько за период и в счет будущих доходов.
   *************************************************/
   IF dVneseno > dItog THEN DO:
	/*** Вносим больше чем необходимо ***/
	ASSIGN
	   dZaPeriod   = dItog
	   dVBudPeriod =  dVneseno - dItog
	.
   END.
   ELSE DO:
	/*** Внесли меньше или столько сколько нужно ***/
	ASSIGN
	  dZaPeriod   = dVneseno
	  dVBudPeriod = 0
        .
	.
   END.

   RUN pint.p(loan.contract,loan.cont-code,dDate1,dDate2,"!704,*").



oTpl:addAnchorValue("AccountStr",oDoc:acct-cr).
oTpl:addAnchorValue("PayAcct",oDoc:acct-db).
oTpl:addAnchorValue("cLoan","<НОМЕР_ДОГОВОРА>").
oTpl:addAnchorValue("val","<ВАЛЮТ>").
oTpl:addAnchorValue("oper_view","Погашение процентов за кредит").
oTpl:addAnchorValue("clName",clName).
oTpl:addAnchorValue("date1",dDate1).
oTpl:addAnchorValue("date2",dDate2).

oTpl:addAnchorValue("dVneseno",STRING(dVneseno,">>>,>>>,>>>,>>9.99")).
oTpl:addAnchorValue("dNachProc",dNachProc).
oTpl:addAnchorValue("dOplProc",TRIM(STRING(dOplProc,">>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("dItog",dItog).
oTpl:addAnchorValue("dZaPeriod",dZaPeriod).
oTpl:addAnchorValue("dVBudPeriod",dVBudPeriod).
oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("DATE",oDoc:DocDate).
oTpl:addAnchorValue("LoanCur",(IF loan.currency EQ "" THEN "810" ELSE loan.currency)).
oTpl:addAnchorValue("loanNo",getMainLoanAttr(cLoanContract,cLoanNum,"%cont-code от %ДатаСогл")).
oTpl:addAnchorValue("summa_1",amtstr[1]).
oTpl:addAnchorValue("summa_2",amtstr[2]).


oTpl:show().
END. /* LOAN */

DELETE OBJECT oDoc.
DELETE OBJECT oTable.
DELETE OBJECT oTpl.

END. /* FOR EACH */

{preview.i}
{preview.i}
