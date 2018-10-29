{pirsavelog.p}
{globals.i}
{intrface.get xclass}

DEFINE INPUT PARAM pLoanRecID AS RECID.

/* pir_depoz_1_aft.p процедура выполняемая после запуска транзакции depoz_1
   заполнять ДР ВидКли значением НеБанк автоматически при открытии счетов 47426 клиентам,
   являющимися резидентами.
*/

FIND FIRST loan
  WHERE RECID(loan) = pLoanRecID
  NO-LOCK NO-ERROR.

IF AVAIL(loan) THEN DO:
  IF loan.cust-cat = "Ю" THEN DO:
    FIND FIRST cust-corp
      WHERE cust-corp.cust-id = loan.cust-id
      NO-LOCK NO-ERROR.
    IF AVAIL(cust-corp) THEN DO:
      IF UPPER(cust-corp.country-id) = "RUS" THEN DO: /* резидент */
  	FIND FIRST loan-acct
  	  OF loan
  	  WHERE loan-acct.acct-type = "ДепТ"
  	  NO-LOCK NO-ERROR.

  	IF AVAIL(loan-acct) THEN DO:
  	  FIND FIRST acct
  	    WHERE acct.acct = loan-acct.acct
  	    NO-LOCK NO-ERROR.
  	    UpdateSignsEx("acctb", acct.acct + ',' + acct.currency, "ВидКли", "НеБанк").
  	END. /* IF AVAIL(loan-acct) */
      END. /* резидент */
    END. /* IF AVAIL(cust-corp) THEN DO: */
  END. /* IF AVAIL(loan.cost-cat) = "Ю" THEN DO: */
END.
