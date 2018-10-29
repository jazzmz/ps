/***************************************************************
 *											     *
 *  Отчет по начисленным процентам по выделенным    *
 * договорам.									     *
 *											     *
 ***************************************************************
 *											     *
 * Автор: Маслов Д. А.							     *
 * Заявка: #647								     *
 * Дата создания: 9:23 03.03.2011				     *
 *											     *
 ***************************************************************/

{globals.i}
{t-otch.i new}
{tmprecid.def}
{intrface.get loan}
{ulib.i}
{pir-getsumbyoper.i}

DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */

DEF VAR oTable2 AS TTableFast.

	DEF VAR cAcct AS CHARACTER.
	DEF VAR oAcct AS TAcct.
DEF VAR dDate1 AS DATE.
DEF VAR dDate2 AS DATE.
DEF VAR cParamMask AS CHARACTER INITIAL "4".
DEF VAR clName AS CHARACTER.
DEF VAR firstLine AS LOGICAL.
DEF VAR i AS INTEGER INITIAL 1.

DEF VAR dSum10Rub AS DECIMAL.
DEF VAR dSum10Val AS DECIMAL INITIAL 0.

DEF VAR dSum65Rub AS DECIMAL INITIAL 0.

DEF VAR dSum98Rub AS DECIMAL INITIAL 0.
DEF VAR dSum98Val AS DECIMAL INITIAL 0.

DEF VAR kNU AS DECIMAL INITIAL 0.

DEF VAR dSumItog AS DECIMAL INITIAL 0.
DEF VAR dSumItog10Rub AS DECIMAL INITIAL 0.
DEF VAR dSumItog10Val AS DECIMAL INITIAL 0.
DEF VAR dSumItog98Val AS DECIMAL INITIAL 0.


{getdates.i}

dDate1=beg-date.
dDate2=end-date.

{tpl.create}

oTable2 = new TTableFast(13).

oTable2:addRow().
oTable2:addCell("Наименование клиента").
oTable2:addCell("Номер договора").
oTable2:addCell("Дата закл").
oTable2:addCell("Вал").
oTable2:addCell("Дата нач.").
oTable2:addCell("Дата окон.").
oTable2:addCell("Ставка").
oTable2:addCell("Остаток").
oTable2:addCell("Начисл. % (вал. дог.)").
oTable2:addCell("Просроченные").
oTable2:addCell("К факт опл. (вал)").
oTable2:addCell("К факт опл. (руб)").
oTable2:addCell("% к НУ (руб)").




  FOR EACH tmprecid,
     FIRST loan WHERE RECID(loan)=tmprecid.id NO-LOCK:
       {ch_dat_p.i}

dSum10Rub = getSumByOper(10,"",loan.cont-code,dDate1,dDate2) + getSumByOper(65,"",loan.cont-code,dDate1,dDate2).
dSum98Rub = getSumByOper(98,"",loan.cont-code,dDate1,dDate2).
dSum65Rub = getSumByOper(65,"",loan.cont-code,dDate1,dDate2).

IF loan.currency<>"" THEN DO:
dSum10Val = getSumByOper(10,loan.currency,loan.cont-code,dDate1,dDate2) + getSumByOper(65,loan.currency,loan.cont-code,dDate1,dDate2).
dSum98Val = getSumByOper(98,loan.currency,loan.cont-code,dDate1,dDate2).
END.

kNU = dSum10Rub.

 RUN name_cl.p (loan.cust-cat,
                  loan.cust-id,
                  INPUT-OUTPUT clName).
               run nach-pp.p(loan.contract,
                             loan.cont-code,
                             dDate1,
                             dDate2,
                             dat-per,
			     ?,
                             1).


	{empty otch1}


	RUN pint.p(loan.contract,loan.cont-code,dDate1,dDate2,"!704,*").
	firstLine = TRUE.

	FOR EACH otch1,
		FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
				     AND CAN-DO(cParamMask,STRING(loan-par.amt-id)) NO-LOCK:	
		 oTable2:addRow().

		IF firstLine THEN 
		 DO:

		   oTable2:addCell(clName).
		   oTable2:addCell(loan.cont-code).
		   oTable2:addCell(getMainLoanAttr(loan.contract,loan.cont-code,"%ДатаСогл")).
		   oTable2:addCell(IF loan.currency<>"" THEN loan.currency ELSE "810").
		END.
		ELSE
		   DO:
			   oTable2:addCell("").
			   oTable2:addCell("").
			   oTable2:addCell("").
			   oTable2:addCell("").
		   END.


		 oTable2:addCell(otch1.beg-date).
		 oTable2:addCell(otch1.end-date).
		 oTable2:addCell(otch1.rat1).
		 oTable2:addCell(otch1.bal-sum).


		 oTable2:addCell(otch1.summ_pr).

		 IF firstLine THEN DO:
 		        oTable2:addCell(dSum98Val).			
			oTable2:addCell(dSum10Val).
			oTable2:addCell(dSum10Rub).			
		        oTable2:addCell(kNU).
		 END. 
		 ELSE DO:
		        oTable2:addCell("").
		        oTable2:addCell("").
		        oTable2:addCell("").
		        oTable2:addCell("").
		      END.



		ACCUMULATE otch1.summ_pr (TOTAL).

	   firstLine = FALSE.

 i = i + 1.
	END.
	
	IF (ACCUM TOTAL otch1.summ_pr) > 0 THEN
          DO:
	       oTable2:addRow().
	       oTable2:addCell("ИТОГО ПО КЛНТ:").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell("").
	       oTable2:addCell(ACCUM TOTAL otch1.summ_pr).
	       oTable2:addCell(dSum98Val).
	       oTable2:addCell(dSum10Val).
	       oTable2:addCell(dSum10Rub).
	       oTable2:addCell(kNU).


	       dSumItog = dSumItog + (ACCUM TOTAL otch1.summ_pr).
	       dSumItog10Rub = dSumItog10Rub + kNU.
	       dSumItog10Val = dSumItog10Val + dSum10Val.
	       dSumItog98Val = dSumItog98Val + dSum98Val.
	       i = i + 1.
	  END.

/*******************************
 * Комментируем пока.
 * вполне возможно, что это еще
 * понадобится.
 *******************************/

/* 
	RUN ReqAcctByRole in h_loan (loan.contract,
							   loan.cont-code,
							   "КредТВ",
							   "o",
							   "PlAcct302",
							  TODAY,
							   FALSE,
							   OUTPUT cAcct).


	oAcct = new TAcct(cAcct).

/*	       oTable2:addRow().
	       oTable2:addCell("Учтено на внебалансе:").
	       
                IF cAcct <> ""  THEN oTable2:addCell(oAcct:calcOborot(dDate1,dDate2,CHR(251),810)).
			        ELSE oTable2:addCell(0).
	       oTable2:setColSpan(1,i + 1,8).
	       oTable2:setAlign(1,i + 1,"center").
*/
    DELETE OBJECT oAcct.
*/

   END. /* FOR EACH tmprecid */

oTable2:addRow().
oTable2:addCell("ИТОГО ПО ТАБЛ:").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell(dSumItog).
oTable2:addCell(dSumItog98Val).
oTable2:addCell(dSumItog10Val).
oTable2:addCell(dSumItog10Rub).
oTable2:addCell(dSumItog10Rub).


oTpl:addAnchorValue("ITOGNACH",dSumItog).
oTpl:addAnchorValue("ITOGVAL",dSumItog10Val).
oTpl:addAnchorValue("ITOG",dSumItog10Rub).
oTpl:addAnchorValue("TABLE2",oTable2).
oTpl:addAnchorValue("BEG-DATE",dDate1).
oTpl:addAnchorValue("END-DATE",dDate2).

{tpl.show}
/*
{setdest.i}
oTable2:show().
{preview.i}
*/

{tpl.delete}
