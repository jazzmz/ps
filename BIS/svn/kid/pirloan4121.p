/*Распоряжение на погашения процентов по договору, для договоров с датой погашения в 10-м числе месяца
Автор: Красков А.С.
Заявка: #4121
*/

{globals.i}
{tmprecid.def}

{intrface.get date}

{t-otch.i new}

{pir-getsumbyoper.i}

{ulib.i}

DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */


DEF VAR orderDate as DATE NO-UNDO.
DEF VAR beg_date as DATE NO-UNDO.
DEF VAR end_date as DATE NO-UNDO.
DEF VAR Midldate as DATE NO-UNDO.

DEF VAR oTpl   AS TTpl   NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.


DEF VAR acct_conv AS CHAR NO-UNDO.

DEF VAR PrevMonth as DEC NO-UNDO.
DEF VAR NextMonth as DEC NO-UNDO.
DEF VAR BudDoh    as DEC NO-UNDO.
dEF VAR dVneseno  as DEC NO-UNDO.
def var PrevRanee as dec no-undo.
def var CurRanee as dec no-undo.
DEF VAR amtstr      AS CHARACTER EXTENT 2 NO-UNDO.
DEF VAR BtOk AS LOG NO-UNDO.
DEF VAR proc-name     AS CHARACTER NO-UNDO.
DEF VAR Clname     AS CHARACTER NO-UNDO.
def var ofunc as tfunc.

ofunc = new tfunc().




FOR EACH tmprecid NO-LOCK,
   FIRST loan where RECID(loan) = tmprecid.id NO-LOCK.
   PAUSE 0.
   UPDATE orderDate LABEL "Дата Операции" SKIP
          beg_date LABEL "Период расчета с" end_date LABEL "по" SKIP
          dVneseno LABEL "Сумма поступления" FORMAT "->>,>>>,>>>,>>9.99" 
           WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

      MESSAGE "Поступление с кор.счета?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 

      IF NOT BtOk or BtOk eq ? THEN 
        DO:
      DO TRANSACTION:
      message "Выбирите счет для списания" VIEW-AS ALERT-BOX.



      RUN browseld.p ("acct",    /* Класс объекта. */
                      "", /* Поля для предустановки. */
                      "",         /* Список значений полей. */
                      "",           /* Поля для блокировки. */
                      1).          /* Строка отображения фрейма. */

      IF keyfunc(lastkey) NE "end-error"
      THEN DO:
         ASSIGN
            acct_conv = ENTRY(1,pick-value).

      END.

      END.
     END.
     ELSE acct_conv = "30102810900000000491".

   Run x-amtstr.p(dVneseno,loan.currency,true,true,output amtstr[1], output amtstr[2]).

   oTpl = new TTpl("pirloan4121.tpl").
   oTable = new TTable(6).
   oTable:addRow().
   oTable:addCell("").
   oTable:addCell("С").
   oTable:addCell("По").
   oTable:addCell("").
   oTable:addCell("").
   oTable:addCell("").



  {empty otch1}

  {ch_dat_p.i}
   

  {get_meth.i 'NachProc' 'nach-pp'}

   

   Midldate = LastMonDate(beg_date).

   IF Midldate > end_date then MESSAGE "Начало и конец периода должны быть в разных месяцах!!!" VIEW-AS ALERT-BOX.

   run VALUE(proc-name + ".p") (loan.contract,
                 loan.cont-code,
                 beg_date,
                 Midldate,
                 dat-per,
	         ?,
                 1).


        FOR EACH otch1,
	 FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
		              AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK:
	       ACCUMULATE otch1.summ_pr (TOTAL).
               /**/

	END.
	                                                                                      
   PrevMonth = (ACCUM TOTAL otch1.summ_pr).

   /*Ранее погашено в предыдущем месяце*/
/*   PrevRanee = getSumByOperNum (loan.cont-code,9,beg_date,Midldate) + getSumByOperNum (loan.cont-code,79,beg_date,Midldate).*/
   PrevRanee = 0.
   PrevMonth = PrevMonth - PrevRanee.
   {empty otch1}

        run VALUE(proc-name + ".p") (loan.contract,
                 loan.cont-code,
                 beg_date,
                 end_date,
                 dat-per,
	         ?,
                 1).

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

   NextMonth = (ACCUM TOTAL otch1.summ_pr) - PrevMonth.

   CurRanee = getSumByOperNum (loan.cont-code,9,Midldate + 1,end_date).
   CurRanee = 0.
   NextMonth = NextMonth - CurRanee. 

/*ищем счета*/
IF MONTH(OrderDate) = MONTH(end_date) THEN 
DO:  
/*здесь воткнем финт для определения КК и возврата нужного счета*/
   if DEC(ENTRY(1,ofunc:getKRez(Loan.cont-code,orderDate))) >= 51 THEN 
      DO:
         oTpl:addAnchorValue("Account1",GetCredLoanAcct_ULL(Loan.cont-code,"КредПроц",orderDate, FALSE)).
      END.
      ELSE oTpl:addAnchorValue("Account1",GetCredLoanAcct_ULL(Loan.cont-code,"КредТ",orderDate, FALSE)).
      
   oTpl:addAnchorValue("Account2",GetCredLoanAcct_ULL(Loan.cont-code,"КредПроц",orderDate, FALSE)).
   oTpl:addAnchorValue("Account3",GetCredLoanAcct_ULL(Loan.cont-code,"КредБудПроц",orderDate, FALSE)).
END.
ELSE
DO:
   oTpl:addAnchorValue("Account1",GetCredLoanAcct_ULL(Loan.cont-code,"КредПроц",orderDate, FALSE)).
   oTpl:addAnchorValue("Account2",GetCredLoanAcct_ULL(Loan.cont-code,"КредБудПроц",orderDate, FALSE)).
   oTpl:addAnchorValue("Account3",GetCredLoanAcct_ULL(Loan.cont-code,"КредБудПроц",orderDate, FALSE)).
END.
/*нашли счета*/

clName = getPirClName(loan.cust-cat,loan.cust-id).

oTpl:addAnchorValue("DATE",orderDate).
oTpl:addAnchorValue("date1",beg_date).
oTpl:addAnchorValue("date2",end_date).
oTpl:addAnchorValue("dVneseno",TRIM(STRING(dVneseno,"->>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("summa_1",amtstr[1]).
oTpl:addAnchorValue("summa_2",amtstr[2]).
oTpl:addAnchorValue("summ1",TRIM(STRING(PrevMonth,"->>>,>>>,>>>,>>9.99"))).

oTpl:addAnchorValue("summ2",TRIM(STRING(NextMonth,"->>>,>>>,>>>,>>9.99"))).

oTpl:addAnchorValue("summ3",TRIM(STRING(dVneseno - NextMonth - PrevMonth,"->>>,>>>,>>>,>>9.99"))).

oTpl:addAnchorValue("D1",beg_date).
oTpl:addAnchorValue("D2",Midldate).
oTpl:addAnchorValue("D3",Midldate + 1).
oTpl:addAnchorValue("D4",end_date).
oTpl:addAnchorValue("clName",clName).
oTpl:addAnchorValue("PayAcct",acct_conv).
oTpl:addAnchorValue("loanNo",getMainLoanAttr(loan.contract,loan.cont-code,"%cont-code от %ДатаСогл")).
oTpl:addAnchorValue("loanCur",(IF loan.currency EQ "" THEN "810" ELSE loan.currency)).
oTpl:addAnchorValue("dNachProc",TRIM(STRING((ACCUM TOTAL otch1.summ_pr),"->>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("dOplProc",TRIM(STRING(CurRanee + PrevRanee,"->>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("dItog",TRIM(STRING(NextMonth + PrevMonth,"->>>,>>>,>>>,>>9.99"))).
oTpl:addAnchorValue("TABLE",oTable).


{setdest.i}
  oTpl:show(). 
{preview.i}


END.


DELETE OBJECT ofunc.
DELETE OBJECT oTable.
DELETE OBJECT oTpl.


{intrface.del}

