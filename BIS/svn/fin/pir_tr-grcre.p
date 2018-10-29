/* 
pir_tr-grcre.p
создание графика погашения основной ссуды и процентов для КД типа ПК
*/

{pirsavelog.p}

{globals.i}

{svarloan.def new global}
{sh-defs.i}

{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /* Функции для работы с метасхемой */
{intrface.get strng}  /* Функции для работы со строками */

DEF VAR vColDaysInYeat AS INT NO-UNDO INIT 366. /* число дней в году */

{getdate.i}
/* end-date = gend-date.  !!! */

{setdest.i}

FOR EACH loan
  WHERE loan.contract  = "Кредит"
    AND loan.cont-code BEGINS "ПК"
/*    AND loan.cont-code = "ПК-027/06 70" */
    AND loan.end-date  >= end-date 	
    AND loan.end-date  <= end-date + 30
  NO-LOCK
  , FIRST loan-acct
      OF loan
      WHERE loan-acct.acct-type = "Кредит"
  NO-LOCK
  , FIRST loan-cond
      WHERE loan-cond.contract  = loan.contract
        AND loan-cond.cont-code = loan.cont-code
  NO-LOCK :
    RUN acct-pos IN h_base (loan-acct.acct, loan-acct.currency, end-date, end-date, "Ф").
    IF sh-bal > 0 THEN DO:
/*	DISP
	  loan.cont-code
	  loan.end-date
	.
*/
	RUN SolveProcAndCreateGraphics.
    END.
END.

{preview.i}

PROCEDURE SolveProcAndCreateGraphics.
  /* комиссия %Кредит */
  FIND FIRST comm-rate
    WHERE     comm-rate.kau        EQ loan.contract + "," + loan.cont-code 
          AND comm-rate.commission = "%Кред"
          AND comm-rate.since      >= loan-cond.since 
/*	  AND comm-rate.since    LT dat1))   */
      NO-LOCK NO-ERROR.

  /* сумма ОД */
  FIND LAST term-obl
    WHERE term-obl.contract  EQ loan-cond.contract
      AND term-obl.cont-code EQ loan-cond.cont-code
      AND term-obl.idnt      EQ 2
      AND term-obl.end-date  LE loan-cond.since
      NO-LOCK NO-ERROR.

  IF AVAIL term-obl AND AVAIL comm-rate AND comm-rate.rate-comm <> 0 THEN DO:
    RUN  CreateGraphicSsudaProc(3, loan.open-date, loan.end-date, term-obl.amt-rub, loan.cont-code). /* 3-ссуда */
    DEF VAR vAmtProc AS DEC NO-UNDO COLUMN-LABEL "ПРОЦЕНТЫ".
    vAmtProc = term-obl.amt-rub * comm-rate.rate-comm * (loan.end-date - loan.open-date) / (vColDaysInYeat * 100).
    DISP
	loan.cont-code
	loan.end-date
	term-obl.amt-rub
	comm-rate.rate-comm
	vAmtProc
    SKIP.
    RUN  CreateGraphicSsudaProc(1, loan.open-date, loan.end-date, vAmtProc, loan.cont-code). /* 1-проценты */
  END.
END. /* PROCEDURE SolveProcAndCreateGraphics. */

PROCEDURE CreateGraphicSsudaProc.
  DEF INPUT PARAM vidnt 	AS INT.  /* 3-ссуда  1-проценты */
  DEF INPUT PARAM vfop-date 	AS DATE. 
  DEF INPUT PARAM vend-date 	AS DATE. 
  DEF INPUT PARAM vamt-rub 	AS DEC.  
  DEF INPUT PARAM vcont-code 	AS CHAR.

/* создаем график погашения основного долга */
IF NOT CAN-FIND ( FIRST term-obl
		    WHERE   term-obl.cont-code 	= vcont-code
			AND term-obl.contract 	= "Кредит"
			AND term-obl.idnt    	= vidnt
) THEN DO:
  CREATE term-obl.
  ASSIGN
    term-obl.fop-date 	= vfop-date
    term-obl.nn 	= 0 
    term-obl.end-date 	= vend-date
    term-obl.sop 	= 0     
    term-obl.fop 	= 0

    term-obl.lnk-cont-code = "0"
    term-obl.fuser-id	= "BIS"
    term-obl.contract 	= "Кредит"
    term-obl.suser-id 	= "BIS"
    term-obl.amt-rub 	= vamt-rub 
  /* ? */
    term-obl.nn		= 1          
    term-obl.idnt    	= vidnt

    term-obl.bal-acct-cr = 0   
    term-obl.bal-acct-db = 0
    term-obl.cont-code 	= vcont-code
    term-obl.cont-type	= "ПК"
    term-obl.cor-acct	= ?
    term-obl.ratio	= 0.000000 
    term-obl.lnk-contract = "Назначение"
    term-obl.rate	  = 0.000000
    term-obl.int-amt	  = 0.00
    term-obl.class-code 	= IF vidnt = 3
				THEN "term-obl-debt"
				ELSE "term-obl-per"
    term-obl.price		= 0.00
    term-obl.amount-of-payment 	= 0.00 
    term-obl.dsc-beg-date 	= vend-date
    term-obl.amount-of-payment 	= 0.00
  .
  END.
END. /* PROCEDURE CreateGraphicSsudaProc. */


/* варианты от БИС - они интерактивны
DEF INPUT PARAM 
iRecLoan    AS RECID NO-UNDO. / *recid договора/
iRecCond    AS RECID NO-UNDO. /recid условия/
iSumm       AS DEC   NO-UNDO. / Сумма (term-obl.idnt = 2)/
iMode       AS INT64   NO-UNDO. / режим добавление/редактирование/
iChangeSumm AS LOG   NO-UNDO. / флаг того что изменили сумму в
                                               режиме редактирования/
iChangePr   AS LOG   NO-UNDO. / флаг того что изменили сумму
                                                или период погашения ссуды
                                                или дату погашения
                                                режиме редактирования/
iChangeDate AS LOG   NO-UNDO. / флаг того что изменили дату
                                                 окончания договора в
                                                 режиме редактирования/
iChangePer  AS LOG   NO-UNDO. / флаг того что надо переформировывать график
                                                 В частности- 
                                                 изменили дату погашения
                                                 изменили период погашения
                                                 изменился сдвиг/
*/
/*
      RUN mm-to.p(RecID(loan),
                  RecID(loan-cond),
                  4210.43 /* tt-term-amt.amt-rub */ ,
                  2 /* iMode */ ,
                  no,
                  no,
                  yes,
                  yes,
                  ?,
                  0) NO-ERROR.
      vRet = RETURN-VALUE. */

DEF VAR fl AS LOG NO-UNDO.
/*
         RUN pog-cr.p (recid(loan-cond),
                       recid(loan),
                       1,
                       loan-cond.since,
                       loan-cond.since + 1,
                       output fl).
*/
