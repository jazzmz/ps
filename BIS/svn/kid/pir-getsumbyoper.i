/***************************************************
 *                                                                                                *
 * Инклюдник содержит одну функцию.
 * Функция возвращает сумму по операциям iOpNo
 * за предыдущий расчетный период.
 * Предназначается для отчета "Распоряжение на погашение
 * процентов"
 * Принцип действия следующий:
 *     1. Указываем операцию погашения;
 *     2. Указываем номер договора;
 *     3. Указываем искомую операцию (первоначально 10);
 *     4. Определяем конец предыдущего отчетно периода (от операции погашения);
 *     5. Находим все операции по аналитике от даты предыдущего периода до даты
 * операции погашения;
 *    6. Суммируем результат.
 **********************************************************
 * Автор: Маслов Д. А.
 * Дата создания: 16:33 31.08.2010
 * Заявка: #418
 **********************************************************/

FUNCTION getSumByOperInCurrPer RETURNS DECIMAL(INPUT iOp AS INTEGER,INPUT cLoanNo AS CHARACTER,INPUT iOpNo AS INTEGER,INPUT DateBeg AS Date,INPUT DateEnd AS Date):

DEF VAR dCurrDate  AS DATE NO-UNDO.
DEF VAR dBegPeriod AS DATE NO-UNDO.

DEF VAR dSum       AS DECIMAL INITIAL 0 NO-UNDO.

DEF BUFFER bOp FOR op.
DEF BUFFER bPrevOp FOR op.
DEF BUFFER bTermObl FOR term-obl.

FIND FIRST bOp WHERE bOp.op = iOp NO-LOCK.
dCurrDate = bOp.op-date.

/*********************************************
Находим конец последнего рассчетного периода.
**********************************************/
FIND LAST bTermObl WHERE bTermObl.cont-code EQ cLoanNo 
                                                    AND bTermObl.contract EQ 'Кредит' 
                                                    AND bTermObl.idnt EQ 1 AND bTermObl.end-date<dCurrDate 
                                                  NO-LOCK NO-ERROR.

IF NOT AVAILABLE(bTermObl) THEN
           DO:
                        /* Если на договоре заведено одно условие,
                            то дата его завершения будет больше чем исходная
                            дата. Поэтому в предыдущем проходе term-obl не будет найден
                            Для доп. информации см. #443
                        */
                        FIND LAST bTermObl WHERE bTermObl.cont-code EQ cLoanNo 
                                                                               AND bTermObl.contract EQ 'Кредит' 
                                                                               AND bTermObl.idnt EQ 1 NO-LOCK.
                        
           END.

/*dBegPeriod = bTermObl.end-date.                                      */
dBegPeriod = DateBeg.
/**/

/* Определяем критерий операции погашения % */
FIND FIRST chowhe WHERE chowhe.id-op = iOpNo NO-LOCK.

/* Находим все операции в периоде dBegPeriod - dCurrDate */

FOR EACH loan-int WHERE loan-int.cont-code EQ cLoanNo
                                                  AND loan-int.contract EQ 'Кредит' 
                                                 AND loan-int.id-d=chowhe.id-d 
                                                 AND loan-int.id-k=chowhe.id-k 
                                                 AND loan-int.op-date>dBegPeriod  AND loan-int.op-date<DateEnd AND loan-int.op<iOp NO-LOCK,
     FIRST bPrevOp WHERE bPrevOp.op=loan-int.op AND bPrevOp.op<iOp NO-LOCK:

     dSum = dSum + loan-int.amt-rub.

    END. /* Конец по всем операциям */
  RETURN dSum.
END FUNCTION.

FUNCTION getSumByOperSt RETURN DECIMAL(INPUT iOper AS INTEGER,INPUT lCurr AS CHARACTER,INPUT cDogNum AS CHARACTER,INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHARACTER):

  /*** По всем документам оплаты процентов ***/
  FOR EACH op WHERE op.op-date>=dDateBeg AND op.op-date<=dDateEnd AND op.op-status >= cStatus NO-LOCK,
    FIRST op-entry OF op WHERE CAN-DO("*" + cDogNum + "." + STRING(iOper),kau-cr) NO-LOCK: 
      ACCUMULATE op-entry.amt-rub (TOTAL).
      ACCUMULATE op-entry.amt-cur (TOTAL).
  END.

 IF lCurr <> "" THEN RETURN ACCUM TOTAL op-entry.amt-cur.
	           ELSE RETURN ACCUM TOTAL op-entry.amt-rub. 

END FUNCTION.
/***************
 * Возвращает 
 * оплату процентов за
 * период.
 ***************/
FUNCTION getSumByOper RETURN DECIMAL(INPUT iOper AS INTEGER,INPUT lCurr AS CHARACTER,INPUT cDogNum AS CHARACTER,INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):

DEF VAR dSumRub AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR dSumVal AS DECIMAL INITIAL 0 NO-UNDO.
FIND FIRST chowhe WHERE chowhe.id-op = iOper NO-LOCK NO-ERROR.
IF AVAILABLE(chowhe) THEN DO:

FOR EACH loan-int WHERE loan-int.cont-code EQ cDogNum
                        AND loan-int.contract EQ 'Кредит' 
                        AND loan-int.id-d=chowhe.id-d 
                        AND loan-int.id-k=chowhe.id-k 
                        AND loan-int.op-date>=dDateBeg AND loan-int.op-date<=dDateEnd NO-LOCK,
 FIRST op OF loan-int NO-LOCK,
  FIRST op-entry OF op NO-LOCK:

      ASSIGN
         dSumRub = dSumRub + op-entry.amt-rub
	 dSumVal = dSumVal + op-entry.amt-cur
	.

  END.

END.
 IF lCurr <> "" THEN RETURN dSumVal.
	        ELSE RETURN dSumRub.
END FUNCTION.

/*************************
 *
 * Функция возвращает
 * сумму по операциям.
 *
 **************************/
FUNCTION getSumByOperNum RETURNS DECIMAL(INPUT cLoanNo AS CHARACTER,INPUT oper-id AS INT64,INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):

DEF VAR dSum AS DECIMAL INITIAL 0 NO-UNDO.

/* Определяем критерий операции погашения % */
FIND FIRST chowhe WHERE chowhe.id-op = oper-id NO-LOCK.

/* Находим все операции в периоде dBegPeriod - dCurrDate */

FOR EACH loan-int WHERE loan-int.cont-code EQ cLoanNo
                        AND loan-int.contract EQ 'Кредит' 
                        AND loan-int.id-d=chowhe.id-d 
                        AND loan-int.id-k=chowhe.id-k 
                        AND loan-int.mdate>=dDateBeg AND loan-int.mdate<=dDateEnd NO-LOCK:
  ACCUMULATE amt-rub (TOTAL).
END.

dSum = (ACCUM TOTAL amt-rub).

 RETURN dSum.

END FUNCTION.
/*
Пример:

{tmprecid.def}
DEF VAR dRes AS DECIMAL NO-UNDO.

FOR EACH tmprecid, 
  FIRST op WHERE tmprecid.id = RECID(op):

dRes = getSumByOperInCurrPer(op.op,'55/09',10).

MESSAGE dRes VIEW-AS ALERT-BOX.

END.
*/